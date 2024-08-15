# BRCPopUp
<a href="./README_CH.md">中文文档</a>

![](https://img.shields.io/github/v/tag/jaychou202302/BRCPopUp?label=Version)
[![Cocoapods Compatible](https://img.shields.io/badge/cocoapods-Compatible-brightgreen.svg)](https://cocoapods.org/pods/BRCPopUp)
[![Version](https://img.shields.io/cocoapods/v/BRCPopUp.svg?style=flat)](https://cocoapods.org/pods/BRCPopUp)
[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/cocoapods/p/BRCPopUp.svg?style=flat)](https://cocoapods.org/pods/BRCPopUp)

`BRCPopUper` is a powerful pop-up management tool that offers high customization and rich animation effects, easily meeting the needs of various complex scenarios.

<table>
    <thead>
        <tr>
            <th>MainTest</th>
            <th>PopUpTest</th>
            <th>DropDownTest</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <img src="https://jaychou202302.github.io/media/BRCPopUp/main.png"/>
            </td>
            <td>
                <img src="https://jaychou202302.github.io/media/BRCPopUp/popup.png"/>
            </td>
                 <td>
                <img src="https://jaychou202302.github.io/media/BRCPopUp/dropdown.png"/>
            </td>
        </tr>
    </tbody>
</table>

## Features
- **Multi Framework Support**: Supports SwiftUI and UIKit frameworks, as well as OC and Swift languages
- **Highly Customizable**: Supports custom content views, background colors, shadow effects, rounded corners, etc.
- **Rich Animation Effects**: Built-in multiple animation effects and supports custom animations.
- **Diverse Content Support**: Supports both text and image content, providing convenient methods for setting them.
- **Flexible Pop-up and Dismiss Methods**: Supports pop-ups anchored to views or points, with both automatic and manual dismiss controls.
- **Comprehensive Delegate Callbacks**: Provides various delegate callback methods to monitor pop-up events like display, dismissal, and clicks.


## Fast Usage
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

## Usage

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
