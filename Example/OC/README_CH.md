# BRCPopUp

![](https://img.shields.io/github/v/tag/jaychou202302/BRCPopUp?label=Version)
[![Cocoapods Compatible](https://img.shields.io/badge/cocoapods-Compatible-brightgreen.svg)](https://cocoapods.org/pods/BRCPopUp)
[![Version](https://img.shields.io/cocoapods/v/BRCPopUp.svg?style=flat)](https://cocoapods.org/pods/BRCPopUp)
[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/cocoapods/p/BRCPopUp.svg?style=flat)](https://cocoapods.org/pods/BRCPopUp)

`BRCPopUp` 是一个强大的弹出框管理工具，具有高自定义性和丰富的动画效果，可以轻松满足各种复杂场景下的弹出需求

## 特点

- **高度自定义**：支持自定义内容视图、背景颜色、阴影效果、圆角等。
- **丰富的动画效果**：内置多种动画效果，并支持自定义动画。
- **多样的内容支持**：支持文本和图片内容，且提供便捷的方法进行设置。
- **灵活的弹出和消失方式**：支持锚定视图和锚点位置弹出，支持自动消失和手动控制消失。
- **完善的代理回调**：提供多种代理回调方法，方便监听弹出框的各种事件。


## 快速使用

```objective-c
#import <BRCPopUp/UIView+BRCPopUp.h>

[self.navigationItem.titleView 
    brc_popUpTip:@"你好,我是一个功能完善,高度定制化的DropDown/PopUp组件,很高兴认识你!" 
    withDirection:BRCPopUpDirectionBottom 
    hideAfterDuration:3.0
];
```

```swift
import BRCPopUp

DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
    self.navigationItem.titleView?.brc_popUpTip("你好,我是一个功能完善,高度定制化的DropDown/PopUp组件,很高兴认识你!", with: .bottom,hideAfterDuration: 1.0);
};
```

## 使用

```objective-c
BRCPopUper *popUper = [[BRCPopUper alloc] initWithContentStyle:BRCPopUpContentStyleCustom];
[popUper showWithAnchorView:anchorView hideAfterDelay:3.0]
```

```swift
let popUper = BRCPopUper.init(contentStyle: .text);
popUper.show(withAnchorView:anchorView , hideAfterDelay: 3.0);
```

## Requirements
-  iOS 13.0
-  Xcode 12+

## Installation

BRCPopUp is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BRCPopUp'
```

## Author

zhixiongsun, jaychou202302@gmail.com

## License

BRCPopUp is available under the MIT license. See the LICENSE file for more info.
