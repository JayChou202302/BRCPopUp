# BRCPopUp

<a href="./README.md">英文文档</a>

![](https://img.shields.io/github/v/tag/jaychou202302/BRCPopUp?label=Version)
[![Cocoapods Compatible](https://img.shields.io/badge/cocoapods-Compatible-brightgreen.svg)](https://cocoapods.org/pods/BRCPopUp)
[![Version](https://img.shields.io/cocoapods/v/BRCPopUp.svg?style=flat)](https://cocoapods.org/pods/BRCPopUp)
[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/cocoapods/p/BRCPopUp.svg?style=flat)](https://cocoapods.org/pods/BRCPopUp)

`BRCPopUp` 是一个强大的弹出框管理工具，具有高自定义性和丰富的动画效果，可以轻松满足各种复杂场景下的弹出需求

## 特点
- **多框架支持**：支持 SwiftUI、UIKit 两种框架，同时支持OC以及Swift两种语言
- **高度自定义**：支持自定义内容视图、背景颜色、阴影效果、圆角等。
- **丰富的动画效果**：内置多种动画效果，并支持自定义动画。
- **多样的内容支持**：支持文本和图片内容，且提供便捷的方法进行设置。
- **灵活的弹出和消失方式**：支持锚定视图和锚点位置弹出，支持自动消失和手动控制消失。
- **完善的代理回调**：提供多种代理回调方法，方便监听弹出框的各种事件。


## 快速使用

`1.Objective-c`
```objective-c
#import <BRCPopUp/UIView+BRCPopUp.h>

[self.navigationItem.titleView 
    brc_popUpTip:@"你好,我是一个功能完善,高度定制化的DropDown/PopUp组件,很高兴认识你!" 
    withDirection:BRCPopUpDirectionBottom 
    hideAfterDuration:3.0
];
```

`2.Swift`
```swift
import BRCPopUp

DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
    self.navigationItem.titleView?.brc_popUpTip("你好,我是一个功能完善,高度定制化的DropDown/PopUp组件,很高兴认识你!", with: .bottom,hideAfterDuration: 1.0);
};
```

`3.SwiftUI`
```swift
import BRCPopUp

struct PopUpView : View {
    @State var isTest1Present : Bool = false;
    var body : some View {
        Vstack {
            Text("Hello world")
            .brc_popUpTip(isPresented: $isTest1Present, tipText: "") {
               $0
                .contentInsets(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                .shadowOffset(.init(width: 0, height: 3))
                .shadowRadius(10.0)
                .shadowColor(.brtest_black.withAlphaComponent(0.2))
                .backgroundColor(.brtest_contentWhite)
                .textFont(.boldSystemFont(ofSize: 16.0))
                .textColor(.brtest_orange)
                .fitSize(.init(width: kBRCScreenWidth / 2, height: .infinity))
            }
        }
    }
}
```

## 使用

`1.Objective-c`
```objective-c
BRCPopUper *popUper = [[BRCPopUper alloc] initWithContentStyle:BRCPopUpContentStyleCustom];
[popUper showWithAnchorView:anchorView hideAfterDelay:3.0]
```

`2.Swift`
```swift
let popUper = BRCPopUper.init(contentStyle: .text);
popUper.showWithAnimation(view:anchorView, hideAfterDelay: 3.0);
```

`3.SwiftUI`
```swift
 View()
    .brc_popUpView(isPresented: $isTest3Present) {
        CustomerView()
    } customize: {
       $0
        .containerSize(.init(width: 100, height: 150))
        .didUserDismissPopUper { popUp, view in
            BRCToast.show("didUserDismissPopUper");
            print("didUserDismissPopUper");
        }
        .didHidePopUper { popUp, view in
            BRCToast.show("didHidePopUper");
            print("didHidePopUper");
        }
        .didShowPopUper { popUp, view in
            BRCToast.show("didShowPopUper");
            print("didShowPopUper");
        }
        .willHidePopUper { popUp, view in
            print("willHidePopUper");
        }
        .willShowPopUper { popUp, view in
            print("willShowPopUper");
        }
    }
    .onTapGesture {
        isTest3Present.toggle()
    }
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
