# BRCPopUp

<a href="./README.md">英文文档</a>

![](https://img.shields.io/github/v/tag/jaychou202302/BRCPopUp?label=Version)
[![Cocoapods Compatible](https://img.shields.io/badge/cocoapods-Compatible-brightgreen.svg)](https://cocoapods.org/pods/BRCPopUp)
[![Version](https://img.shields.io/cocoapods/v/BRCPopUp.svg?style=flat)](https://cocoapods.org/pods/BRCPopUp)
[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/cocoapods/p/BRCPopUp.svg?style=flat)](https://cocoapods.org/pods/BRCPopUp)

`BRCPopUp` 是一个强大的弹出框管理工具，具有高自定义性和丰富的动画效果，可以轻松满足各种复杂场景下的弹出需求

## 特点
- **多框架支持**：支持 `SwiftUI、UIKit` 两种框架，同时支持`OC`以及`Swift`两种语言
- **高度自定义**：支持自定义内容视图、背景颜色、阴影效果、圆角等。
- **丰富的动画效果**：内置多种动画效果，并支持自定义动画。
- **多样的内容支持**：支持文本和图片内容，且提供便捷的方法进行设置。
- **灵活的弹出和消失方式**：支持锚定视图和锚点位置弹出，支持自动消失和手动控制消失。
- **完善的代理回调**：提供多种代理回调方法，方便监听弹出框的各种事件。


## 快速使用

### 1.弹出一段文本

`1.Objective-c`
```objective-c
#import <BRCPopUp/UIView+BRCPopUp.h>

[self.navigationItem.titleView 
    brc_popUpTip:@"你好,我是一个功能完善,高度定制化的DropDown/PopUp组件,很高兴认识你!" 
    withDirection:BRCPopUpDirectionBottom 
    hideAfter:3.0
];
```

`2.Swift`
```swift
import BRCPopUp

DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
   self.navigationItem.titleView?.brc_popUpTip("你好,我是一个功能完善,高度定制化的DropDown/PopUp组件,很高兴认识你!", direction: .bottom,hideAfter: 2.0);
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
            .brc_popUpTip(isPresented: $isTest1Present, tipText: "你好,我是一个功能完善,高度定制化的DropDown/PopUp组件,很高兴认识你!") {
               $0
                .contentInsets(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                .textFont(.boldSystemFont(ofSize: 16.0))
                .fitSize(.init(width: kBRCScreenWidth / 2, height: .infinity))
            }
        }
    }
}
```

### 2.弹出一个菜单

> [!Note]
> 1.3.0 以上版本支持

`1.Objective-c`
```objective-c
#import <BRCPopUp/UIView+BRCPopUp.h>
[self.navigationItem.titleView brc_popUpMenu:@[
    [BRCPopUpMenuAction actionWithTitle:@"你好" image:nil handler:^(BRCPopUpMenuAction * _Nonnull action) {
        // TODO: 
    }]
] withDirection:BRCPopUpDirectionBottom hideAfter:3.0];
```

`2.Swift`
```swift
import BRCPopUp

DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
    self.navigationItem.titleView?.brc_popUpMenu([
        BRCPopUpMenuAction(title: "你好", image: nil, handler: { action in
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

### 3.弹出一个自定义视图

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
                 // TOOD: 自定义视图 CustomView()
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

## 使用说明

### 1.参数说明

> [!Note]
> BRCPopUp 提供了诸多自定义参数，学习正确使用这些参数，将会帮助你更好的使用该组件

**Q:** 我想要自定义弹出框的箭头样式，如何设置参数呢？<p>
**A:** <p>
1）**基础属性**：`arrowRadius`,`arrowSize`,`arrowDirection`,`arrowRelativePosition`,`arrowAbsolutePosition`，需要注意的是当你设置了弹出框的 `popUpDirection` 属性后`arrowRelativePosition ` 这个属性将会跟随 `popUpDirection` 自适应设置。<p>
2）**高级属性**：<p>
`arrowCenterAlignToAnchor` 让箭头始终指向锚定视图的中心（除了少数情况下，设置的偏移过大，无法指向），建议打开<p>

**Q:** 我想要自定义弹出框的外部布局，如何设置参数呢？<p>
**A:**<p>
1）**基础属性**：`containerSize`,`containerHeight`,`containerWidth`，这些属性你可以配合下面的高级属性来自定义其外部布局。<p>
2）**高级属性**： <p>
`marginToAnchorView`:弹出框视图到锚定视图的外部间距<p>

<div style="display: flex; justify-content: center; align-items: center; height: 500px;background-color:clear;border-radius:4px;">
 <img style="width:400px" src="https://jaychou202302.github.io/media/BRCPopUp/md1.png"/>
</div>

<br>

`contentAlignment`:弹出框视图和锚定视图之间的对齐方式


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
                <img src="https://jaychou202302.github.io/media/BRCPopUp/md3.png"/>
            </td>
            <td>
               <img src="https://jaychou202302.github.io/media/BRCPopUp/md2.png"/>
            </td>
                 <td>
                 <img src="https://jaychou202302.github.io/media/BRCPopUp/md4.png"/>
            </td>
        </tr>
    </tbody>
</table>


`offsetToAnchorView`:弹出框视图和锚定视图之间的相对偏移，设置此参数前，你需要注意设置 `contentAlignment` 参数，因为该偏移是基于对齐之后的进行偏移的。

<center>
     <img style="width:320px" src="https://jaychou202302.github.io/media/BRCPopUp/md5.png"/>
</center>

`autoFitContainerSize`:根据锚定视图自适应调整弹出框容器大小，需要注意的是，当你主动设置了 `containerSize`之后，该属性将不会再生效。 
 > [!Note]
 > * 当弹出方向是 **top / bottom**，那么 ContainerSize = (AnchorViewWidth,AnchorViewWidth)
 > * 当弹出方向是 **left / right**，那么 ContainerSize = (AnchorViewHeight,AnchorViewHeight)

`autoCutoffRelief`:是否切除超出弹出框父视图的部分，当你设置了锚定视图和弹出框容器大小之后，组件内部会根据弹出方向对弹出框视图的 `Frame` 计算，当计算后得到的弹出框的位置超出了其父视图的范围，那么此时会自适应的裁剪宽度和高度。

**Q:** 我想要自定义弹出框的父视图，应该如何设置参数？<p>
**A:**<p>
1）**基础参数**:<p>
`popUpSuperView`: 指定弹出框的父视图<p>
2）**高级参数**:<p>
`contextStyle`: 指定弹出框父视图的样式,分别为 `SuperView / ViewController / Window / SuperScrollView` <p>
> [!Note]
> * SuperView: 指定弹出框的父视图为锚定视图的 superview
> * ViewController: 指定弹出框的父视图为锚定视图的 controller.view
> * Window: 指定弹出框父视图为当前 Window
> * SuperScrollView: 指定弹出框的父视图为锚定视图最近的SuperScrollView

`contextWindow`:当你设置 `contextStyle` 为 `Window` 的时候，你可以自定义弹出框弹出的
父视图具体为哪个Window，默认是App的`KeyWindow`

**Q:** 我想要自定义弹出框的弹出样式，应该如何设置参数？<p>
**A:**<p>
1）**基础参数**：<p>
`popUpDirection`,`hideAfterDelayDuration`:分别可以帮助你自定义弹出的方向和自动解散弹出<p>
视图的时间<p>
2）**高级参数**：<p>
`dismissMode`:该参数决定弹出框的解散模式，支持用户触碰弹出框背景视图，自动解散弹出框。你可以在 `delegate` 中获取到该事件的回调<p>

**Q:** 我想要自定义弹出框的动画样式，应该如何设置参数？<p>
**A:**<p>
1）**基础参数**：<p>
`popUpAnimationType`,`popUpAnimationDuration`:分别可以帮助你自定义弹出框的弹出动画样式和时长，内部以及自带有 **7** 种常用的弹出动画样式<p>
2）**高级参数**:<p>
`popUpAnimation`:自定义的 `CAAnimation` 弹出动画，该动画将会被添加到弹出框根视图layer上<p>
`bubbleAnchorPoint`: 当你自定义了 `popUpAnimation` 参数后，你或许需要通过自定义 `anchorPoint` 来辅助你完善弹出动画的效果。<p>

### 2.SwiftUI 支持
> [!Note]
> BRCPopUp 在 **v1.2.0** 之后对 SwiftUI 进行了拓展与支持，如果你需要在 SwiftUI 中使用该组件，请升级到 **> v1.2.0** 的版本

**1.支持程度**

目前 `SwiftUI` 已经支持 `Menu / Text / Image / CustomView` 四种弹出框类型，你只需要引入`BRCPopUp`，而后就可以在所有符合 `View` 协议的视图上调用API来弹出内容。

目前暂不支持的API: `popUpAnimation`, `bubbleAnchorPoint`


**2.高级使用**

由于 `SwiftUI` 中不支持像 `UIKit` 直接访问视图树，因此针对下面场景：
> * 在`ScrollView`中弹出一个视图，希望视图可以跟随其滑动
> * 想要指定弹出框的父视图

我们推出了 `BRCPopUpWrapper` 工具类，你需要升级到 v1.3.0 之后的版本。

**Q:** 如何使用 `BRCPopUpWrapper` 工具类? <p>
**A:** 你需要让这个工具类去包裹你想要指定弹出框的父视图，而后该工具类会给到一个回调，在回调中你会拿到其转化的`UIView`，然后作为参数传递到`BRCPopUp`中，示例将在后文中提供

### 3.使用示例

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

## 使用

BRCPopUp is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BRCPopUp'
```

## 作者

zhixiongsun, jaychou202302@gmail.com

BRCPopUp is available under the MIT license. See the LICENSE file for more info.
