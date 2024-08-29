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
            <th>DropDown</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <img src="https://jaychou202302.github.io/media/BRCPopUp/main-en.png"/>
            </td>
            <td>
                <img src="https://jaychou202302.github.io/media/BRCPopUp/popup-en.png"/>
            </td>
                 <td>
                <img src="https://jaychou202302.github.io/media/BRCPopUp/dropdown-en.png"/>
            </td>
        </tr>
    </tbody>
</table>

## Features
- **Multiple framework support**: Supports two frameworks, `SwiftUI and UIKit`, and supports both `OC` and `Swift` languages.
- **Highly Customizable**: Supports custom content views, background colors, shadow effects, rounded corners, etc.
- **Rich animation effects**: Built-in multiple animation effects and supports custom animations.
- **Diverse content support**: Supports text and image content, and provides convenient methods for settings.
- **Flexible pop-up and disappearance methods**: supports pop-up at a certain view and a certain point position, supports automatic disappearance and manual control of disappearance.
- **Complete proxy callback**: Provides a variety of proxy callback methods to facilitate monitoring of various events in pop-up boxes.


## Fast Usage

### 1.Pop up a piece of text

`1.Objective-c`
```objective-c
#import <BRCPopUp/UIView+BRCPopUp.h>

[self.navigationItem.titleView 
    brc_popUpTip:@"Hello, I am a fully functional and highly customized DropDown/PopUp component. Nice to meet you!" 
    withDirection:BRCPopUpDirectionBottom 
    hideAfter:3.0
];
```

`2.Swift`
```swift
import BRCPopUp

DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
   self.navigationItem.titleView?.brc_popUpTip("Hello, I am a fully functional and highly customized DropDown/PopUp component. Nice to meet you!", direction: .bottom,hideAfter: 2.0);
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
            .brc_popUpTip(isPresented: $isTest1Present, tipText: "Hello, I am a fully functional and highly customized DropDown/PopUp component. Nice to meet you!") {
               $0
                .contentInsets(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                .textFont(.boldSystemFont(ofSize: 16.0))
                .fitSize(.init(width: kBRCScreenWidth / 2, height: .infinity))
            }
        }
    }
}
```

### 2.Pop up a menu

> [!Note]
> Supported by version 1.3.0 or above

`1.Objective-c`
```objective-c
#import <BRCPopUp/UIView+BRCPopUp.h>
[self.navigationItem.titleView brc_popUpMenu:@[
    [BRCPopUpMenuAction actionWithTitle:@"Hello" image:nil handler:^(BRCPopUpMenuAction * _Nonnull action) {
        // TODO: 
    }]
] withDirection:BRCPopUpDirectionBottom hideAfter:3.0];
```

`2.Swift`
```swift
import BRCPopUp

DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
    self.navigationItem.titleView?.brc_popUpMenu([
        BRCPopUpMenuAction(title: "Hello", image: nil, handler: { action in
            // TODO: 
        })
    ], direction: .bottom,hideAfter: 2.0)
};
```

`3.SwiftUI`
```swift
import BRCPopUp

struct PopUpView : View {
    @State var isTest3Present : Bool = false;
    var body : some View {
        Vstack {
            Text("Hello world")
            .brc_popUpMenu(isPresented: $isTest3Present
             menuActions: [
                BRCPopUpMenuAction(title: String.brctest_localizableWithKey("key.test.menu.01"), image: nil, handler: { action in
                                    isTest3Present.toggle()
                                    }),
                BRCPopUpMenuAction(title: String.brctest_localizableWithKey("key.test.menu.02"), image: nil, handler: { action in
                                    isTest3Present.toggle()
                                }),
                BRCPopUpMenuAction(title: String.brctest_localizableWithKey("key.test.menu.03"), image: nil, handler: { action in
                                    isTest3Present.toggle()
                                })
            ]) {
               $0
                .contentInsets(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                .textFont(.boldSystemFont(ofSize: 16.0))
                .fitSize(.init(width: kBRCScreenWidth / 2, height: .infinity))
            }
        }
    }
}
```

### 3.Pop up a custom view

`1.Objective-c`
```objective-c
#import <BRCPopUp/UIView+BRCPopUp.h>

[self.navigationItem.titleView brc_popUpView:[UIView new] containerSize:CGSizeMake(200, 200) withDirection:BRCPopUpDirectionBottom];
```

`2.Swift`
```swift
import BRCPopUp

self.navigationItem.titleView?.brc_popUpView(UIView(), containerSize: .init(width: 200, height: 200), direction: .bottom)
```

`3.SwiftUI`
```swift
import BRCPopUp

struct PopUpView : View {
    @State var isTest4Present : Bool = false;
    var body : some View {
        Vstack {
            Text("Hello world")
              .brc_popUpView(isPresented: $isTest4Present,view: {
                 // TOOD: CustomView()
              },customize: {
                    $0
                    .containerSize(.init(width: kBRCScreenWidth / 2, height: 200))

             })
            .onTapGesture {
                isTest4Present.toggle()
            }
        }
    }
}
```

## Instructions for use

### 1. Parameter description

> [!Note]
> BRCPopUp provides many custom parameters. Learning to use these parameters correctly will help you use this component better.

**Q:** I want to customize the arrow style of the pop-up box. How to set the parameters? <p>
**A:** <p>
1) **Basic attributes**: `arrowRadius`, `arrowSize`, `arrowDirection`, `arrowRelativePosition`, `arrowAbsolutePosition`. It should be noted that when you set the `popUpDirection` attribute of the pop-up box, the `arrowRelativePosition` attribute Will follow the `popUpDirection` adaptive setting. <p>
2) **Advanced properties**: <p>
`arrowCenterAlignToAnchor` makes the arrow always point to the center of the anchored view (except in a few cases, the offset set is too large to point), it is recommended to turn on <p>

<br>

**Q:** I want to customize the external layout of the pop-up box. How to set the parameters? <p>
**A:**<p>
1) **Basic properties**: `containerSize`, `containerHeight`, `containerWidth`. You can use these properties with the following advanced properties to customize its external layout. <p>
2) **Advanced properties**: <p>
`marginToAnchorView`: External spacing from popup view to anchor view<p>

<p align="center">
 <img style="width:400px" src="https://jaychou202302.github.io/media/BRCPopUp/md1-en.png"/>
</p>

<br>


`contentAlignment`:Alignment between popover view and anchor view


<table>
    <thead>
        <tr>
            <th>Left</th>
            <th>Center</th>
            <th>Right</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <img src="https://jaychou202302.github.io/media/BRCPopUp/md3-en.png"/>
            </td>
            <td>
               <img src="https://jaychou202302.github.io/media/BRCPopUp/md2-en.png"/>
            </td>
                 <td>
                 <img src="https://jaychou202302.github.io/media/BRCPopUp/md4-en.png"/>
            </td>
        </tr>
    </tbody>
</table>

`offsetToAnchorView`: The relative offset between the pop-up box view and the anchor view. Before setting this parameter, you need to pay attention to setting the `contentAlignment` parameter, because the offset is based on the alignment.
<p align="center">
     <img style="width:320px" src="https://jaychou202302.github.io/media/BRCPopUp/md5-en.png"/>
</p>

`autoFitContainerSize`: Adaptively adjust the size of the pop-up box container according to the anchor view. It should be noted that after you actively set `containerSize`, this property will no longer take effect. 
 > [!Note]
 > * When the pop-up direction is **top / bottom**, then ContainerSize = (AnchorViewWidth,AnchorViewWidth)
 > * When the pop-up direction is **left / right**, then ContainerSize = (AnchorViewHeight,AnchorViewHeight)

 `autoCutoffRelief`: Whether to cut off the part beyond the pop-up box's parent view. After you set the anchor view and pop-up box container size, the component will internally calculate the `Frame` of the pop-up box view based on the pop-up direction. When the calculated pop-up box is calculated, the `Frame` of the pop-up box view will be calculated. If the position of the box exceeds the scope of its parent view, the width and height will be adaptively cropped.

**Q:** I want to customize the parent view of the pop-up box. How should I set the parameters? <p>
**A:**<p>
1) **Basic parameters**:<p>
`popUpSuperView`: Specifies the parent view of the pop-up box<p>
2) **Advanced parameters**:<p>
`contextStyle`: Specify the style of the pop-up box parent view, which are `SuperView / ViewController / Window / SuperScrollView` <p>
> [!Note]
> * SuperView: Specifies that the parent view of the pop-up box is the superview of the anchored view.
> * ViewController: Specify the pop-up box's parent view as the anchor view's controller.view
> * Window: Specify the pop-up box parent view as the current Window
> * SuperScrollView: Specify the parent view of the pop-up box as the SuperScrollView closest to the anchor view

`contextWindow`: When you set `contextStyle` to `Window`, you can customize the pop-up box that pops up
Which Window is the parent view? The default is App's `KeyWindow`

<br>

**Q:** I want to customize the pop-up style of the pop-up box. How should I set the parameters? <p>
**A:**<p>
1) **Basic parameters**: <p>
`popUpDirection`, `hideAfterDelayDuration`: can help you customize the direction of the pop-up and automatically dismiss the pop-up<p>
View time<p>
2) **Advanced parameters**: <p>
`dismissMode`: This parameter determines the dismissal mode of the pop-up box. It supports the user to touch the pop-up box background view to automatically dismiss the pop-up box. You can get the callback of this event in `delegate`<p>

<br>

**Q:** I want to customize the animation style of the pop-up box. How should I set the parameters? <p>
**A:**<p>
1) **Basic parameters**: <p>
`popUpAnimationType`, `popUpAnimationDuration`: can help you customize the pop-up animation style and duration of the pop-up box respectively. There are **7** commonly used pop-up animation styles inside and out<p>
2) **Advanced parameters**:<p>
`popUpAnimation`: Customized `CAAnimation` pop-up animation, which will be added to the pop-up box root view layer<p>
`bubbleAnchorPoint`: After you customize the `popUpAnimation` parameter, you may need to customize the `anchorPoint` to help you improve the effect of the pop-up animation. <p>

### 2.SwiftUI support
> [!Note]
> BRCPopUp has expanded and supported SwiftUI after **v1.2.0**. If you need to use this component in SwiftUI, please upgrade to the version **> v1.2.0**

**1. Level of support**

Currently, `SwiftUI` already supports four pop-up box types: `Menu / Text / Image / CustomView`. You only need to introduce `BRCPopUp`, and then you can call the API on all views that comply with the `View` protocol to pop up content.

APIs currently not supported: `popUpAnimation`, `bubbleAnchorPoint`


**2.Advanced use**

Since `SwiftUI` does not support direct access to the view tree like `UIKit`, the following scenario is targeted:
> * Pop up a view in `ScrollView` and hope that the view can slide with it
> * Want to specify the parent view of the pop-up box

We have launched the `BRCPopUpWrapper` tool class, you need to upgrade to a version after v1.3.0.

**Q:** How to use the `BRCPopUpWrapper` utility class? <p>
**A:** You need to let this tool class wrap the parent view of the pop-up box you want to specify, and then the tool class will give a callback. In the callback, you will get the `UIView` it converted, and then use it as Parameters are passed to `BRCPopUp`, examples will be provided later.


### 3.Usage

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
 struct TestView : View {
    @State var isTest3Present : Bool = false;
    @State var context : UIView = UIView();
    var body : some View {
        VStack {
            Text("Hello World");
            
            BRCPopUpWrapper(.nearestScrollView) {
                ScrollView {
                    Button {
                        isTest3Present.toggle()
                    } label: {
                        Text("Click Me")
                            .frame(width: 100, height: 40)
                            .background(.red)
                            .cornerRadius(4)
                            .clipped()
                            .foregroundColor(.white)
                    }
                    .brc_popUpView(isPresented: $isTest3Present) {
                        MenuButton(menuArray: [
                            String.brctest_localizableWithKey("key.test.menu.01"),
                            String.brctest_localizableWithKey("key.test.menu.02"),
                            String.brctest_localizableWithKey("key.test.menu.03"),
                            String.brctest_localizableWithKey("key.test.menu.04")
                        ])
                        .background(.clear)
                    } customize: {
                        $0
                            .dismissMode(.none)
                            .popUpContext(self.context)
                            .containerSize(.init(width: 100, height: 150))
                    }
                }
            } onFindContextUIView: { view in
                context = view;
            }
            
        }
    }
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
