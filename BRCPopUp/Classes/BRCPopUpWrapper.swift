//
//  BRCPopUpViewModifier.swift
//  BRCPopUp
//
//  Created by sunzhixiong on 2024/8/14.
//

import SwiftUI
import Combine

public enum BRCPopUpContextType {
    case topView /// will auto find the topest `UIView`
    case nearestScrollView /// will auto find the nearest `UIScrollView`
}


/// A Wrapper will help you find a suitable context for popUp
/// 使用本结构体包裹你的视图，可帮助你给弹出框找到合适的父视图
///
///      BRCPopUpWrapper(.topView) {
///           Text("Hello World")
///      } onFindContextUIView { context in
///
///      }
///
public struct BRCPopUpWrapper<Content: View> : View {
    var content : Content
    var viewType : BRCPopUpContextType
    var onFindContextUIView: (UIView) -> Void
    
    public init(_ viewType : BRCPopUpContextType? = .topView,@ViewBuilder content: () -> Content, onFindContextUIView: @escaping (UIView) -> Void) {
        self.viewType = viewType ?? .topView;
        self.content = content()
        self.onFindContextUIView = onFindContextUIView
    }
    
    
    public var body: some View {
        content
            .brc_findTopUIView { contextView in
                guard let contextView = contextView else { return }
                guard let findSubView = contextView.findFirstSubview(ofType: viewType == .topView ? UIView.self : UIScrollView.self) else {
                    onFindContextUIView(contextView)
                    return
                }
                print(findSubView);
                onFindContextUIView(findSubView);
            }
    }
}

struct BRCPopUpViewModifier<PopupContent : View> : ViewModifier {
    var popUper : BRCPopUper
    var paramers : BRCPopUpParameters?
    var fitSize  : CGSize?
    var popUpDelegate : BRCPopUpDelegateObject;
    @Binding var isPresented : Bool
    @State private var anchorViewFrame: CGRect
    private var contentView : (() -> PopupContent)?
    init(
        isPresented  : Binding<Bool>,
        contentStyle : BRCPopUpContentStyle? = .text,
        contentView  : (() -> PopupContent)? = nil,
        parameters   : BRCPopUpParameters?   = nil
    ) {
        self.anchorViewFrame = .zero;
        self._isPresented = isPresented
        self.contentView = contentView
        if (contentView != nil) {
            self.popUper = BRCPopUper(contentView: contentView!().convertToUIView());
        } else if (contentStyle != nil) {
            self.popUper = BRCPopUper(contentStyle: contentStyle!);
        } else {
            self.popUper = BRCPopUper(contentStyle: .text);
        }
        self.popUpDelegate = BRCPopUpDelegateObject(paramers: parameters);
        self.paramers = parameters;
        self.popUper.contextStyle = .window;
        if (self.paramers != nil && parameters != nil) {
            self.fitSize = parameters!.fitSize;
            self.popUper.contextStyle = parameters!.popUpContextStyle;
            self.popUper.popUpSuperView = parameters!.popUpSuperView;
            self.popUper.containerSize = parameters!.containerSize;
            self.popUper.offsetToAnchorView = parameters!.offsetToAnchorView;
            self.popUper.popUpDirection = parameters!.popUpDirection;
            self.popUper.cornerRadius = parameters!.cornerRadius;
            self.popUper.marginToAnchorView = parameters!.marginToAnchorView;
            self.popUper.shadowOpacity = parameters!.shadowOpacity;
            self.popUper.popUpAnimationDuration = parameters!.popUpAnimationDuration;
            self.popUper.dismissMode = parameters!.dismissMode;
            self.popUper.popUpAnimationType = parameters!.animationType;
            self.popUper.contentAlignment = parameters!.contentAlignment;
            self.popUper.autoFitContainerSize = parameters!.autoFitContainerSize;
            self.popUper.autoCutoffRelief = parameters!.autoCutoffRelief;
            self.popUper.arrowCenterAlignToAnchor = parameters!.arrowCenterAlignToAnchor;
            self.popUper.backgroundColor = parameters!.backgroundColor;
            self.popUper.shadowColor = parameters!.shadowColor;
            self.popUper.shadowOffset = parameters!.shadowOffset;
            self.popUper.shadowRadius = parameters!.shadowRadius;
            self.popUper.arrowSize = parameters!.arrowSize;
            self.popUper.arrowAbsolutePosition = parameters!.arrowAbsolutePosition;
            self.popUper.arrowRelativePosition = parameters!.arrowRelativePosition;
            self.popUper.arrowRadius = parameters!.arrowRadius;
            self.popUper.bubbleAnchorPoint = parameters!.bubbleAnchorPoint;
            self.popUper.hideAfterDelayDuration = parameters!.hideAfterDelayDuration;
            if (parameters!.webImageLoadBlock != nil){
                self.popUper.webImageLoadBlock = parameters!.webImageLoadBlock!;
            }
            self.popUper.contentInsets = UIEdgeInsets(top: parameters!.contentInsets.top, left: parameters!.contentInsets.leading, bottom: parameters!.contentInsets.bottom, right: parameters!.contentInsets.trailing);
    
            if (parameters!.contextWindow != nil) {
                self.popUper.contextWindow = parameters!.contextWindow!;
            }
            self.popUper.delegate = self.popUpDelegate;
        }
    }
    
    func body(content: Content) -> some View {
        content
            .tag(0x1232)
            .frameGetter($anchorViewFrame)
            .valueChanged(value: anchorViewFrame, onChange: { newValue in
                if (self.popUper.dismissMode == .none) { self.popUper.anchorFrame = anchorViewFrame; }
            })
            .valueChanged(value: isPresented) { newValue in
                var popUperFitSize : CGSize? = self.fitSize;
                if (self.fitSize == nil || self.fitSize!.equalTo(.zero)) {
                    popUperFitSize = .init(width: anchorViewFrame.width, height:CGFloat(MAXFLOAT));
                }
                if (self.popUper.contentLabel != nil && self.paramers != nil) {
                    if (self.paramers!.textColor != nil) {
                        self.popUper.contentLabel!.textColor = self.paramers!.textColor!;
                    }
                    if (self.paramers!.textColor != nil) {
                        self.popUper.contentLabel!.font = self.paramers!.textFont!;
                    }
                }
                self.popUper.sizeThatFits(popUperFitSize!);
                self.popUper.anchorFrame = anchorViewFrame;
                self.popUper.toggleDisplay();
            }
    }
}

class BRCPopUpDelegateObject : NSObject {
    var paramers : BRCPopUpParameters?
    init(paramers: BRCPopUpParameters? = nil) {
        self.paramers = paramers
    }
}

extension BRCPopUpDelegateObject : BRCPopUperDelegate {
    func willShowPopUper(popUper: BRCPopUper!, anchorView: UIView!) {
        if (self.paramers!.willShowPopUper != nil) {
            self.paramers!.willShowPopUper!(popUper,anchorView);
        }
    }
    
    func willHidePopUper(popUper: BRCPopUper!, anchorView: UIView!) {
        if (self.paramers!.willHidePopUper != nil) {
            self.paramers!.willHidePopUper!(popUper,anchorView);
        }
    }
    
    func didHidePopUper(popUper: BRCPopUper!, anchorView: UIView!) {
        if (self.paramers!.didHidePopUper != nil) {
            self.paramers!.didHidePopUper!(popUper,anchorView);
        }
    }
    
    func didShowPopUper(popUper: BRCPopUper!, anchorView: UIView!) {
        if (self.paramers!.didShowPopUper != nil) {
            self.paramers!.didShowPopUper!(popUper,anchorView);
        }
    }
    
    func didUserDismissPopUper(popUper: BRCPopUper!, anchorView: UIView!) {
        if (self.paramers!.didUserDismissPopUper != nil) {
            self.paramers!.didUserDismissPopUper!(popUper,anchorView);
        }
    }
}

extension View {
    internal func convertToUIView() -> UIView {
        return UIHostingController(rootView: self).view;
    }
    
    @ViewBuilder
    internal func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, tvOS 14.0, macOS 11.0, watchOS 7.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { value in
                onChange(value)
            }
        }
    }
}

public struct BRCPopUpParameters {
    var offsetToAnchorView       : CGFloat = 0;
    var cornerRadius             : CGFloat = 4;
    var marginToAnchorView       : CGFloat = 5;
    var shadowOpacity            : CGFloat = 1.0;
    var popUpAnimationDuration   : CGFloat = 0.2;
    var hideAfterDelayDuration   : CGFloat = -1;
    var shadowRadius             : CGFloat = 0;
    var arrowAbsolutePosition    : CGFloat = 12;
    var arrowRelativePosition    : CGFloat = -1;
    var arrowRadius              : CGFloat = 2;
    var autoFitContainerSize     : Bool = false;
    var autoCutoffRelief         : Bool = false;
    var arrowCenterAlignToAnchor : Bool = true;
    var backgroundColor          : UIColor = .systemGray6;
    var shadowColor              : UIColor = .gray.withAlphaComponent(0);
    var arrowSize                : CGSize = .init(width: 16, height: 8);
    var contentInsets            : EdgeInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5);
    var containerSize            : CGSize = .init(width: 100, height: 100)
    var fitSize                  : CGSize = .zero
    var bubbleAnchorPoint        : CGPoint = .zero;
    var shadowOffset             : CGSize = .zero;
    var popUpSuperView           : UIView?;
    var contextWindow            : UIWindow?;
    var textFont                 : UIFont?;
    var textColor                : UIColor?;
    
    var popUpContextStyle        : BRCPopUpContextStyle = .window;
    var popUpDirection           : BRCPopUpDirection = .bottom;
    var dismissMode              : BRCPopUpDismissMode = .interactive;
    var animationType            : BRCPopUpAnimationType = .fadeBounce;
    var contentAlignment         : BRCPopUpContentAlignment = .center;
    
    var webImageLoadBlock        : ((UIImageView,URL)   -> ())?
    var willShowPopUper          : ((BRCPopUper,UIView) -> ())?
    var didShowPopUper           : ((BRCPopUper,UIView) -> ())?
    var willHidePopUper          : ((BRCPopUper,UIView) -> ())?
    var didHidePopUper           : ((BRCPopUper,UIView) -> ())?
    var didUserDismissPopUper    : ((BRCPopUper,UIView) -> ())?
    
    private func updateParams(_ block : ((inout BRCPopUpParameters) -> Void)) -> BRCPopUpParameters {
        var params = self;
        block(&params);
        return params;
    }
    
    public func cornerRadius(_  radius : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.cornerRadius = radius;
        };
    }
    
    public func shadowOpacity(_  opacity : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.shadowOpacity = opacity;
        };
    }
    
    public func backgroundColor(_  color : UIColor) -> BRCPopUpParameters {
        return updateParams { params in
            params.backgroundColor = color;
        };
    }
    
    public func shadowColor(_  color : UIColor) -> BRCPopUpParameters {
        return updateParams { params in
            params.shadowColor = color;
        };
    }
    
    public func shadowOffset(_  offset : CGSize) -> BRCPopUpParameters {
        return updateParams { params in
            params.shadowOffset = offset;
        };
    }
    
    public func shadowRadius(_ radius : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.shadowRadius = radius;
        };
    }
    
    public func willShowPopUper(_ block : @escaping (BRCPopUper,UIView) -> () = { _,_ in }) -> BRCPopUpParameters {
        return updateParams { params in
            params.willShowPopUper = block;
        };
    }
    
    public func didShowPopUper(_ block : @escaping (BRCPopUper,UIView) -> () = { _,_ in }) -> BRCPopUpParameters {
        return updateParams { params in
            params.didShowPopUper = block;
        };
    }
    
    public func willHidePopUper(_ block : @escaping (BRCPopUper,UIView) -> () = { _,_ in }) -> BRCPopUpParameters {
        return updateParams { params in
            params.willHidePopUper = block;
        };
    }
    
    public func didHidePopUper(_ block : @escaping (BRCPopUper,UIView) -> () = { _,_ in }) -> BRCPopUpParameters {
        return updateParams { params in
            params.didHidePopUper = block;
        };
    }
    
    public func didUserDismissPopUper(_ block : @escaping (BRCPopUper,UIView) -> () = { _,_ in }) -> BRCPopUpParameters {
        return updateParams { params in
            params.didUserDismissPopUper = block;
        };
    }
    
    public func webImageLoadBlock(_ block : @escaping (UIImageView,URL) -> () = { _,_ in}) -> BRCPopUpParameters {
        return updateParams { params in
            params.webImageLoadBlock = block;
        };
    }
    
    /// 设置弹出框的容器大小
    /// Set the container size of the popup box
    /// default is `(100,100)`
    public func containerSize(_ size: CGSize) -> BRCPopUpParameters {
        return updateParams { params in
            params.containerSize = size;
        };
    }
    
    /// 设置弹出框文本的自适应大小
    /// Set the adaptive size of the pop-up box text
    /// default is `.zero`
    /// 当你设置了一段文本作为你的弹出框容器内容,如果你需要自适应容器大小,
    /// 你需要设置本属性来告诉弹出框你的理想大小,它将会根据该属性自适应文本大小
    /// When you set a piece of text as the content of your pop-up box container, if you need to adapt the container size,
    /// You need to set this attribute to tell the pop-up box your ideal size, and it will adapt to the text size based on this attribute.
    public func fitSize(_ size : CGSize) -> BRCPopUpParameters {
        return updateParams { params in
            params.fitSize = size;
        };
    }
    
    /// 弹出视图和锚定视图相对水平方向的间距
    /// The relative horizontal spacing between pop-up views and anchor views
    /// default is `0.0`
    /// 该属性支持负数，负数将会向另外一个方向偏移
    /// This property supports negative numbers,which will shift in the other direction.
    public func offsetToAnchorView(_ offset : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.offsetToAnchorView = offset;
        };
    }
    
    /// 弹出的方向
    /// The Direction of PopUper
    /// default is `BRCPopUpDirectionBottom`
    public func popUpDirection(_  direction : BRCPopUpDirection) -> BRCPopUpParameters {
        return updateParams { params in
            params.popUpDirection = direction;
        };
    }
    
    /// 弹出视图和锚定视图相对垂直的间距
    /// Relative vertical spacing between popup view and anchor view
    /// default is `5.0`
    public func marginToAnchorView(_  margin : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.marginToAnchorView = margin;
        };
    }
    
    /// 弹出动画的时长
    /// The duration for popUp Animation
    /// default is `0.2`
    public func popUpAnimationDuration(_  duration : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.popUpAnimationDuration = duration;
        };
    }
    
    /// 弹出框的消失方式
    /// The DismissMode for PopUper
    /// default is `BRCPopUpDismissModeInteractive`
    /// @discussion 该属性被设置为 `BRCPopUpDismissModeInteractive` 意味着当用户触碰屏幕时，
    /// 就会自动解散改弹出框，设置为 `BRCPopUpDismissModeNone` 则需要开发者代码自行控制解散弹出框的时机
    /// This property is set to `BRCPopUpDismissModeInteractive` which means that when the user touches the screen,will automatically dismiss the pop-up box. If set to `BRCPopUpDismissModeNone`, the developer code needs to control the timing of dismissing the pop-up box.
    public func dismissMode(_  mode : BRCPopUpDismissMode) -> BRCPopUpParameters {
        return updateParams { params in
            params.dismissMode = mode;
        };
    }
    
    /// 弹出动画样式
    /// The Animation Type for PopUp
    /// default is `BRCPopUpAnimationTypeFadeBounce`
    public func animationType(_  type : BRCPopUpAnimationType) -> BRCPopUpParameters {
        return updateParams { params in
            params.animationType = type;
        };
    }
    
    /// 内容对齐方式
    ///  The Alignment for contentView
    ///  default is `BRCPopUpContentAlignmentCenter`
    public func contentAlignment(_  alignment : BRCPopUpContentAlignment) -> BRCPopUpParameters {
        return updateParams { params in
            params.contentAlignment = alignment;
        };
    }
    
    /// 是否要自适应容器视图的大小
    /// Whether to adapt the size of the container view
    /// default `YES`
    /// 当弹出方向是 Top/Bottom，那么 `ContainerSize = (AnchorViewWidth,AnchorViewWidth)`
    /// 当弹出方向是 Left/Right，那么 `ContainerSize = (AnchorViewHeight,AnchorViewHeight)`
    /// When the pop-up direction is Top/Bottom, then `ContainerSize = (AnchorViewWidth,AnchorViewWidth)`
    /// When the pop-up direction is Left/Right, then `ContainerSize = (AnchorViewHeight,AnchorViewHeight)`
    public func autoFitContainerSize(_  autoFit : Bool) -> BRCPopUpParameters {
        return updateParams { params in
            params.autoFitContainerSize = autoFit;
        };
    }
    
    /// 是否切除超过视图以外的部分
    /// Whether to cut off the part beyond the view
    /// default `NO`
    public func autoCutoffRelief(_  autoCut : Bool) -> BRCPopUpParameters {
        return updateParams { params in
            params.autoCutoffRelief = autoCut;
        };
    }
    
    /// 是否保持箭头始终在锚定视图的中心（如果可以）
    /// Whether to keep the arrow always in the center of the anchored view (if possible)
    /// default `YES`
    public func arrowCenterAlignToAnchor(_  alignToAnchor : Bool) -> BRCPopUpParameters {
        return updateParams { params in
            params.arrowCenterAlignToAnchor = alignToAnchor;
        };
    }
    
    /// 箭头的大小
    /// size of arrow
    /// default `CGSizeMake(16, 8)`
    public func arrowSize(_ size : CGSize) -> BRCPopUpParameters {
        return updateParams { params in
            params.arrowSize = size;
        };
    }
    
    /// 箭头的绝对位置
    /// The absolute position of the arrow
    /// default `12`
    /// 设置了 arrowRelativePosition 之后，该参数就不再生效
    /// 箭头向上或者向下 那么就是箭头中心到容器左侧的距离
    /// 箭头向左或者向右 那么就是箭头中心到容器上侧的距离
    /// 同时该参数支持为`负数`，例如在箭头向上或者向下
    /// arrowAbsolutePosition = 12，代表着箭头中心到容器左侧的距离为 12
    /// arrowAbsolutePosition = -12，代表箭头中心到容器右侧的距离为 12
    ///
    /// After setting arrowRelativePosition, this parameter will no longer take effect.
    /// If the arrow is up or down, it is the distance from the center of the arrow to the left side of the container
    /// If the arrow points to the left or right, it is the distance from the center of the arrow to the upper side of the container
    /// At the same time, this parameter supports `negative numbers`, such as arrows up or down
    /// arrowAbsolutePosition = 12, which means the distance from the center of the arrow to the left side of the container is 12
    /// arrowAbsolutePosition = -12, which means the distance from the center of the arrow to the right side of the container is 12
    public func arrowAbsolutePosition(_ position : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.arrowAbsolutePosition = position;
        };
    }
    
    /// 箭头的相对位置
    /// relative position of arrow
    /// default `-1`
    public func arrowRelativePosition(_ position : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.arrowRelativePosition = position;
        };
    }
    
    /// 箭头位置的圆角半径
    /// The corner radius of the arrow position
    /// default `4`
    public func arrowRadius(_ radius : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.arrowRadius = radius;
        };
    }
    
    /// 气泡背景的锚点
    /// Anchor point for bubble background
    /// 当你有自定义弹出动画的需求时，你可以使用
    /// 该属性来帮助你完成你的动画效果
    ///
    /// When you need to customize pop-up animation,
    /// you can use this attribute to help you complete your animation effect.
    public func bubbleAnchorPoint(_ point : CGPoint) -> BRCPopUpParameters {
        return updateParams { params in
            params.bubbleAnchorPoint = point;
        };
    }
    
    /// 内边距
    /// The EdgeInsets for contentView
    /// default is `UIEdgeInsetsMake(5, 5, 5, 5)`
    public func contentInsets(_ insets : EdgeInsets) -> BRCPopUpParameters {
        return updateParams { params in
            params.contentInsets = insets;
        };
    }
    
    /// 弹出框的所在Window
    /// The Window for PopUper
    /// default is `[UIApplication sharedApplication].keyWindow`
    public func contextWindow(_ window : UIWindow?) -> BRCPopUpParameters {
        return updateParams { params in
            params.contextWindow = window;
        };
    }
    
    /// 弹出框的文本字体
    /// The Font For PopUper Text
    public func textFont(_ font : UIFont) -> BRCPopUpParameters {
        return updateParams { params in
            params.textFont = font;
        };
    }
    
    /// 弹出框的文本颜色
    /// The Font For PopUper TextColor
    /// default is `Black`
    public func textColor(_ color : UIColor) -> BRCPopUpParameters {
        return updateParams { params in
            params.textColor = color;
        };
    }
    
    /// 设置弹出框的自动消失时间
    /// Hide PopUper after delay time
    /// default is `-1`
    public func hideAfterDelay(_ delay : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.hideAfterDelayDuration = delay;
        };
    }
    
    /// 设置弹出框的父视图
    /// Set SuperView For PopUp
    /// default is `window`
    public func popUpContext(_ context : UIView) -> BRCPopUpParameters {
        return updateParams { params in
            params.popUpContextStyle = .custom;
            params.popUpSuperView = context;
        }
    }
}

extension View {
    
    /// 弹出一段富文本
    /// Pop up a rich text
    public func brc_popUpTip (
        isPresented    : Binding<Bool>,
        attributedText : NSAttributedString
    ) -> some View {
        let wrapper = BRCPopUpViewModifier<AnyView>(isPresented: isPresented)
        wrapper.popUper.setContentText(attributedText);
        return self.modifier(wrapper)
    }
    
    /// 弹出一段富文本
    /// Pop up a rich text
    /// - Parameters:
    ///   - customize: 
    ///   你可以用该属性来完成你对弹出框的自定义
    ///   You can use this attribute to complete your customization of the pop-up box
    public func brc_popUpTip (
        isPresented    : Binding<Bool>,
        attributedText : NSAttributedString,
        customize      : @escaping (BRCPopUpParameters) -> (BRCPopUpParameters)
    ) -> some View {
        let wrapper = BRCPopUpViewModifier<AnyView>(isPresented: isPresented,parameters:customize(BRCPopUpParameters()))
        wrapper.popUper.setContentText(attributedText);
        return self.modifier(wrapper)
    }
    
    /// 弹出一段文本
    /// Pop up a text
    public func brc_popUpTip (
        isPresented  : Binding<Bool>,
        tipText      : String
    ) -> some View {
        let wrapper = BRCPopUpViewModifier<AnyView>(isPresented: isPresented)
        wrapper.popUper.setContentText(tipText);
        return self.modifier(wrapper)
    }
    
    /// 弹出一段文本
    /// Pop up a text
    /// - Parameters:
    ///   - customize: 
    ///   你可以用该属性来完成你对弹出框的自定义
    ///   You can use this attribute to complete your customization of the pop-up box
    public func brc_popUpTip (
        isPresented  : Binding<Bool>,
        tipText      : String,
        customize    : @escaping (BRCPopUpParameters) -> (BRCPopUpParameters)
    ) -> some View {
        let wrapper = BRCPopUpViewModifier<AnyView>(isPresented: isPresented,parameters:customize(BRCPopUpParameters()))
        wrapper.popUper.setContentText(tipText);
        return self.modifier(wrapper)
    }
    
    /// 弹出一张网络图片
    /// Pop up a webImage
    /// - Parameters:
    ///   - customize: 
    ///   你可以用该属性来完成你对弹出框的自定义
    ///   You can use this attribute to complete your customization of the pop-up box
    ///
    ///   - discusssion:
    ///   你需要在 customize 中设置 `BRCPopUpParameters.webImageLoadBlock`属性，否则网络图片
    ///   将不会展示出来
    ///   You need to set the `BRCPopUpParameters.webImageLoadBlock` property in customize, otherwise the network image will not be displayed
    public func brc_popUpImage (
        isPresented  : Binding<Bool>,
        imageUrl     : String,
        customize    : @escaping (BRCPopUpParameters) -> (BRCPopUpParameters)
    ) -> some View {
        let wrapper = BRCPopUpViewModifier<AnyView>(isPresented: isPresented,contentStyle: .image,parameters:customize(BRCPopUpParameters()))
        wrapper.popUper.setContentImageUrl(imageUrl);
        return self.modifier(wrapper)
    }
    
    /// 弹出一张图片
    /// Pop up a image
    public func brc_popUpImage (
        isPresented  : Binding<Bool>,
        image        : UIImage,
        customize    : @escaping (BRCPopUpParameters) -> (BRCPopUpParameters)
    ) -> some View {
        let wrapper = BRCPopUpViewModifier<AnyView>(isPresented: isPresented,contentStyle: .image,parameters:customize(BRCPopUpParameters()))
        wrapper.popUper.setContentImage(image);
        return self.modifier(wrapper)
    }
    
    /// 弹出一个自定义视图
    /// Pop up a custom view
    /// - Parameters:
    ///   - customize:
    ///   你可以用该属性来完成你对弹出框的自定义
    ///   You can use this attribute to complete your customization of the pop-up box
    public func brc_popUpView<PopupContent: View> (
        isPresented       : Binding<Bool>,
        @ViewBuilder view : @escaping () -> PopupContent,
        customize         : @escaping (BRCPopUpParameters) -> (BRCPopUpParameters)
    ) -> some View  {
        return self.modifier(
            BRCPopUpViewModifier(isPresented: isPresented,contentView: view,parameters:customize(BRCPopUpParameters()))
        )
    }
    
}

