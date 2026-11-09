# 适配版接入

此发布基于现有业务项目验证过的 IQKeyboardManager 6.5.11，并直接纳入 IQToolbar 适配。发布版本为 `6.5.11-adaptation.1`，最低 iOS 15.0。这里没有升级为仓库原 podspec 声明的其它版本。

## 远端源码引用

```ruby
pod 'IQKeyboardManagerObjC',
    :git => 'https://github.com/ccchzxj/IQKeyboardManagerObjC.git',
    :tag => '6.5.11-adaptation.1'
```

删除旧的 `pod 'IQKeyboardManager'` 声明；不要同时安装两者。类名和原有属性不变。

```objc
#import <IQKeyboardManagerObjC/IQKeyboardManager.h>
IQKeyboardManager.sharedManager.enableAutoToolbar = YES;
IQKeyboardManager.sharedManager.toolbarDoneBarButtonItemText = @"完成";
```

“完成”文案由业务项目配置，不在库内强制中文。保留各项目原有的键盘距离、自动工具栏和点击收起等设置。

## 适配内容

- 保留原生 IQToolbar 的按钮、响应链和 44pt 高度。
- 在适用系统上禁用工具栏按钮共享玻璃背景，提供实色背景视图。
- 根据安全区布置背景，并使用胶囊圆角，不向系统键盘边缘外绘制背景。
- 支持默认、自定义颜色和深色样式。

安装时不再需要用 post_install 覆盖 IQToolbar.m。迁移时一并移除该源码补丁；若项目手动写入 `-lIQKeyboardManager`，移除旧链接项并使用 CocoaPods 生成的新链接配置。保留与最低系统版本等其它 Pod 有关的配置。

## 源码与维护

`IQKeyboardManagerObjC/` 是唯一发布源码目录。原仓库历史、根 LICENSE.md 和隐私清单保留；6.5.11 源码许可证同时保存在 LICENSE.6.5.11.md。

本发布验证的是 CocoaPods 接入。原仓库 Package.swift 对应另一个 Swift 目录，不作为本 Objective-C 版本的接入方式。

后续修改此仓库源码并发布新标签，再显式更新业务 Podfile 和 Podfile.lock。不要修改已经发布的标签。

回归测试与使用方法见 Tests/README.md。
