#import <UIKit/UIKit.h>
#import "IQKeyboardManager.h"

static void After(NSTimeInterval delay, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay*NSEC_PER_SEC), dispatch_get_main_queue(), block);
}
@interface IQToolbarCheck : UIResponder <UIApplicationDelegate, UIWindowSceneDelegate>
@property UIWindow *window;
@property UITextField *first;
@property UITextField *second;
@property NSMutableArray<NSString *> *failures;
@end
@implementation IQToolbarCheck
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options { return YES; }
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)options {
    self.failures=[NSMutableArray array];
    IQKeyboardManager *manager=IQKeyboardManager.sharedManager;
    manager.enable=YES;manager.enableAutoToolbar=YES;manager.toolbarDoneBarButtonItemText=@"完成";
    self.window=[[UIWindow alloc] initWithWindowScene:(id)scene];
    self.window.overrideUserInterfaceStyle=UIUserInterfaceStyleLight;
    UIViewController *vc=[UIViewController new];vc.view.backgroundColor=UIColor.systemBackgroundColor;
    self.window.rootViewController=vc;[self.window makeKeyAndVisible];
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(20,100,300,35)];title.text=@"IQ 工具栏适配验证";title.font=[UIFont boldSystemFontOfSize:20];[vc.view addSubview:title];
    self.first=[[UITextField alloc] initWithFrame:CGRectMake(20,160,260,44)];
    self.second=[[UITextField alloc] initWithFrame:CGRectMake(20,220,260,44)];
    self.first.placeholder=@"第一项";self.second.placeholder=@"第二项";
    for(UITextField *field in @[self.first,self.second]){field.keyboardType=UIKeyboardTypeNumberPad;field.borderStyle=UITextBorderStyleRoundedRect;[vc.view addSubview:field];}
    [self.first becomeFirstResponder];After(2,^{[self checkAppearanceAndNext];});
}
- (IQToolbar *)toolbarFor:(UITextField *)field {
    UIView *accessory=field.inputAccessoryView;
    if(![accessory isKindOfClass:IQToolbar.class]){[self.failures addObject:@"missing toolbar"];return nil;}
    return (IQToolbar *)accessory;
}
- (void)checkAppearanceAndNext {
    IQToolbar *bar=[self toolbarFor:self.first];
    if(fabs(bar.bounds.size.height-44)>.1)[self.failures addObject:@"44pt height"];
    if(![bar.doneBarButton.title isEqualToString:@"完成"])[self.failures addObject:@"Chinese done"];
    if(@available(iOS 26.0,*)) {
        UIView *flat=[bar valueForKey:@"jm_flatBackgroundView"];
        [bar layoutIfNeeded];
        if(!flat || flat.userInteractionEnabled || !flat.clipsToBounds || !flat.cornerConfiguration)[self.failures addObject:@"capsule background ownership"];
        UIEdgeInsets safe=bar.safeAreaInsets;
        CGRect expected=CGRectMake(safe.left,0,MAX(0,bar.bounds.size.width-safe.left-safe.right),bar.bounds.size.height);
        if(!CGRectEqualToRect(flat.frame,expected))[self.failures addObject:@"background safe width"];
        if(bar.translucent || bar.standardAppearance.backgroundEffect || bar.scrollEdgeAppearance.backgroundEffect)[self.failures addObject:@"flat toolbar appearance"];
        for(UIBarButtonItem *item in bar.items)if(!item.hidesSharedBackground)[self.failures addObject:@"shared glass background"];
        if(![flat.backgroundColor isEqual:UIColor.secondarySystemBackgroundColor])[self.failures addObject:@"default background color"];
        bar.barTintColor=UIColor.systemOrangeColor;[bar layoutIfNeeded];
        if(![flat.backgroundColor isEqual:UIColor.systemOrangeColor])[self.failures addObject:@"custom background color"];
        bar.barTintColor=nil;bar.barStyle=UIBarStyleBlack;[bar layoutIfNeeded];
        if(![flat.backgroundColor isEqual:[UIColor colorWithWhite:.12 alpha:1]])[self.failures addObject:@"black bar style"];
        bar.barStyle=UIBarStyleDefault;[bar layoutIfNeeded];
    }
    [UIApplication.sharedApplication sendAction:bar.nextBarButton.action to:bar.nextBarButton.target from:bar.nextBarButton forEvent:nil];
    After(.35,^{
        if(!self.second.isFirstResponder)[self.failures addObject:@"next action"];
        IQToolbar *secondBar=[self toolbarFor:self.second];
        [UIApplication.sharedApplication sendAction:secondBar.previousBarButton.action to:secondBar.previousBarButton.target from:secondBar.previousBarButton forEvent:nil];
        After(.35,^{
            if(!self.first.isFirstResponder)[self.failures addObject:@"previous action"];
            IQToolbar *firstBar=[self toolbarFor:self.first];
            [UIApplication.sharedApplication sendAction:firstBar.doneBarButton.action to:firstBar.doneBarButton.target from:firstBar.doneBarButton forEvent:nil];
            After(.35,^{
                if(self.first.isFirstResponder || self.second.isFirstResponder)[self.failures addObject:@"done action"];
                [self.first becomeFirstResponder];After(1,^{[self finish];});
            });
        });
    });
}
- (void)finish {
    NSString *result=self.failures.count?[@"FAIL: " stringByAppendingString:[self.failures componentsJoinedByString:@"; "]]:@"PASS: actual IQ toolbar; 44pt height; Chinese done; solid capsule background; safe-area width; default/custom/black colors; no shared glass; previous/next/done actions; keyboard reopen";
    [result writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/result.txt"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
@end
int main(int argc,char **argv){@autoreleasepool{return UIApplicationMain(argc,argv,nil,NSStringFromClass(IQToolbarCheck.class));}}
