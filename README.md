# 当前维护版：Objective-C 工具栏适配

发布版本 `6.5.11-adaptation.1`，最低 iOS 15.0。请先阅读 [INTEGRATION.md](INTEGRATION.md)，使用其中的远端 Pod 声明及迁移步骤。

以下保留原仓库说明；其 Swift 产品、原仓库地址和其它版本信息不代表当前维护版。

---

<p align="center">
  <img src="https://raw.githubusercontent.com/hackiftekhar/IQKeyboardManagerObjC/master/Screenshot/Social.png" alt="Icon"/>
</p>

[![LICENSE.md](https://img.shields.io/github/license/hackiftekhar/IQKeyboardManagerObjC.svg)](https://github.com/hackiftekhar/IQKeyboardManagerObjC/blob/master/LICENSE.md)
[![Build Status](https://travis-ci.org/hackiftekhar/IQKeyboardManagerObjC.svg)](https://travis-ci.org/hackiftekhar/IQKeyboardManagerObjC)
![Platform iOS](https://img.shields.io/badge/Platform-iOS-blue.svg?style=fla)
[![CocoaPods](https://img.shields.io/cocoapods/v/IQKeyboardManagerObjC.svg)](http://cocoadocs.org/docsets/IQKeyboardManagerObjC)
[![Github tag](https://img.shields.io/github/tag/hackiftekhar/IQKeyboardManagerObjC.svg)](https://github.com/hackiftekhar/IQKeyboardManagerObjC/tags)

## IQKeyboardManager Objective-C version is less likely to maintain. Please use the Swift version for your upcoming projects https://github.com/hackiftekhar/IQKeyboardManager

## Introduction
While developing iOS apps, we often run into issues where the iPhone keyboard slides up and covers the `UITextField/UITextView`. `IQKeyboardManagerObjC` allows you to prevent this issue of keyboard sliding up and covering `UITextField/UITextView` without needing you to write any code or make any additional setup. To use `IQKeyboardManagerObjC` you simply need to add source files to your project.


## Key Features

1) `One Lines of Code`

2) `Works Automatically`

3) `No More UIScrollView`

4) `No More Subclasses`

5) `No More Manual Work`

6) `No More #imports`

`IQKeyboardManagerObjC` works on all orientations, and with the toolbar. It also has nice optional features allowing you to customize the distance from the text field, behavior of previous, next and done buttons in the keyboard toolbar, play sound when the user navigates through the form and more.


## Screenshot
[![Screenshot 1](https://raw.githubusercontent.com/hackiftekhar/IQKeyboardManagerObjC/master/Screenshot/README_Screenshot1.png)](http://youtu.be/6nhLw6hju2A)
[![Screenshot 2](https://raw.githubusercontent.com/hackiftekhar/IQKeyboardManagerObjC/master/Screenshot/README_Screenshot2.png)](http://youtu.be/6nhLw6hju2A)
[![Screenshot 3](https://raw.githubusercontent.com/hackiftekhar/IQKeyboardManagerObjC/master/Screenshot/README_Screenshot3.png)](http://youtu.be/6nhLw6hju2A)
[![Screenshot 4](https://raw.githubusercontent.com/hackiftekhar/IQKeyboardManagerObjC/master/Screenshot/README_Screenshot4.png)](http://youtu.be/6nhLw6hju2A)
[![Screenshot 5](https://raw.githubusercontent.com/hackiftekhar/IQKeyboardManagerObjC/master/Screenshot/README_Screenshot5.png)](http://youtu.be/6nhLw6hju2A)

## GIF animation
[![IQKeyboardManagerObjC](https://raw.githubusercontent.com/hackiftekhar/IQKeyboardManagerObjC/v3.3.0/Screenshot/IQKeyboardManagerObjC.gif)](http://youtu.be/6nhLw6hju2A)

## Video

<a href="http://youtu.be/WAYc2Qj-OQg" target="_blank"><img src="http://img.youtube.com/vi/WAYc2Qj-OQg/0.jpg"
alt="IQKeyboardManagerObjC Demo Video" width="480" height="360" border="10" /></a>

## Tutorial video by @rebeloper ([#1135](https://github.com/hackiftekhar/IQKeyboardManager/issues/1135))

@rebeloper demonstrated two videos on how to implement **IQKeyboardManagerObjC** at it's core:

<a href="https://www.youtube.com/playlist?list=PL_csAAO9PQ8aTL87XnueOXi3RpWE2m_8v" target="_blank"><img src="https://raw.githubusercontent.com/hackiftekhar/IQKeyboardManagerObjC/master/Screenshot/ThirdPartyYoutubeTutorial.jpg"
alt="Youtube Tutorial Playlist"/></a>

https://www.youtube.com/playlist?list=PL_csAAO9PQ8aTL87XnueOXi3RpWE2m_8v

## Warning

- **If you're planning to build SDK/library/framework and want to handle UITextField/UITextView with IQKeyboardManagerObjC then you're totally going the wrong way.** I would never suggest to add **IQKeyboardManagerObjC** as **dependency/adding/shipping** with any third-party library. Instead of adding **IQKeyboardManagerObjC** you should implement your own solution to achieve same kind of results. **IQKeyboardManagerObjC** is totally designed for projects to help developers for their convenience, it's not designed for **adding/dependency/shipping** with any **third-party library**, because **doing this could block adoption by other developers for their projects as well (who are not using IQKeyboardManagerObjC and have implemented their custom solution to handle UITextField/UITextView in the project).**
- If **IQKeyboardManagerObjC** conflicts with other **third-party library**, then it's **developer responsibility** to **enable/disable IQKeyboardManagerObjC** when **presenting/dismissing** third-party library UI. Third-party libraries are not responsible to handle IQKeyboardManagerObjC.

## Requirements

|                        | Minimum iOS Target | Minimum Xcode Version |
|------------------------|--------------------|-----------------------|
| IQKeyboardManagerObjC  | iOS 13.0           | Xcode 13             |
| Demo Project           |                    | Xcode 15             |

Installation
==========================

#### CocoaPods

***IQKeyboardManagerObjC:*** To install it, simply add the following line to your Podfile:

```ruby
pod 'IQKeyboardManagerObjC' #iOS13 and later
```

#### Carthage

To integrate `IQKeyboardManagerObjC` into your Xcode project using Carthage, add the following line to your `Cartfile`:

```ogdl
github "hackiftekhar/IQKeyboardManagerObjC"
```

Run `carthage update --use-xcframeworks` to build the frameworks and drag `IQKeyboardManagerObjC.xcframework` into your Xcode project based on your need. Make sure to add only one framework, not both.

#### Source Code

***IQKeyboardManagerObjC:*** Just ***drag and drop*** `IQKeyboardManagerObjC` directory from demo project to your project. That's it.

#### Basic Usage

In `AppDelegate..m`, just `#import <IQKeyboardManagerObjC/IQKeyboardManager.h>` framework and enable IQKeyboardManager.

```objc
#import "AppDelegate.h"
#import <IQKeyboardManagerObjC/IQKeyboardManager.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    return YES;
}

@end
```


Migration Guide
==========================
- [IQKeyboardManagerObjC 8.0.0 Migration Guide](https://github.com/hackiftekhar/IQKeyboardManagerObjC/blob/master/Documentation/MIGRATION%20GUIDE%207.0%20TO%208.0.md)

Other Links
==========================

- [Known Issues](https://github.com/hackiftekhar/IQKeyboardManagerObjC/wiki/Known-Issues)
- [Manual Management Tweaks](https://github.com/hackiftekhar/IQKeyboardManagerObjC/wiki/Manual-Management)
- [Properties and functions usage](https://github.com/hackiftekhar/IQKeyboardManagerObjC/wiki/Properties-&-Functions)

LICENSE
---
Distributed under the MIT License.

Contributions
---
Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

Author
---
If you wish to contact me, email at: hack.iftekhar@gmail.com
