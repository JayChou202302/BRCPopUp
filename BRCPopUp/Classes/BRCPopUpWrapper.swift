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
    
    public init(_ viewType : BRCPopUpContextType? = .topView,
                @ViewBuilder content: () -> Content,
                onFindContextUIView: @escaping (UIView) -> Void) {
        self.viewType = viewType ?? .topView;
        self.content = content()
        self.onFindContextUIView = onFindContextUIView
    }
    
    public var body: some View {
        content
            .brc_findTopUIView { contextView in
                guard let contextView = contextView else { return }
                guard let findSubView = contextView.brc_findFirstSubview(ofType: viewType == .topView ? UIView.self : UIScrollView.self) else {
                    onFindContextUIView(contextView)
                    return
                }
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
        isPresented   : Binding<Bool>,
        contentStyle  : BRCPopUpContentStyle? = .text,
        contentView   : (() -> PopupContent)? = nil,
        contentUIView : UIView? = nil,
        parameters    : BRCPopUpParameters?   = nil
    ) {
        self.anchorViewFrame = .zero;
        self._isPresented = isPresented
        self.contentView = contentView
        if (contentUIView != nil) {
            self.popUper = BRCPopUper(contentView: contentUIView!);
        } else if (contentView != nil) {
            self.popUper = BRCPopUper(contentView: contentView!().brc_convertToUIView());
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
            self.popUper.autoFitContainerStyle = parameters!.autoFitContainerStyle;
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
            self.popUper.showCancelButton = parameters!.showCancelButton;
            self.popUper.cancelButtonSize = parameters!.cancelButtonSize;
            self.popUper.cancelButtonRelativePosition = parameters!.cancelButtonRelPosition;
            self.popUper.cancelButtonFrame = parameters!.cancelButtonFrame;
            self.popUper.cancelButtonAbsoultePosition = parameters!.cancelButtonAbsPosition;
            if (parameters!.cancelImage != nil) {
                self.popUper.cancelImage = parameters!.cancelImage!;
            }
            if (parameters!.cancelTintColor != nil) {
                self.popUper.cancelTintColor = parameters!.cancelTintColor!;
            }
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
            .brc_frameGetter($anchorViewFrame)
            .brc_valueChanged(value: anchorViewFrame, onChange: { newValue in
                if (self.popUper.dismissMode == .none) { self.popUper.anchorFrame = anchorViewFrame; }
            })
            .brc_valueChanged(value: isPresented) { newValue in
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
    func didClickCloseButton(popUper: BRCPopUper!, anchorView: UIView!) {
        if (self.paramers!.didClickCloseButton != nil) {
            self.paramers!.didClickCloseButton!(popUper,anchorView);
        }
    }
}

internal extension View {
    func brc_convertToUIView() -> UIView {
        return UIHostingController(rootView: self).view;
    }
    
    @ViewBuilder
    func brc_valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
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
    var autoFitContainerStyle    : BRCPopUpAutoFitContainerStyle = .none;
    var autoCutoffRelief         : Bool = false;
    var arrowCenterAlignToAnchor : Bool = true;
    var showCancelButton         : Bool = false;
    var isShowMenuSepLine        : Bool = true;
    var menuSepLineColor         : UIColor = .systemGray5;
    var backgroundColor          : UIColor = .systemGray6;
    var shadowColor              : UIColor = .gray.withAlphaComponent(0);
    var arrowSize                : CGSize = .init(width: 16, height: 8);
    var contentInsets            : EdgeInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5);
    var containerSize            : CGSize = .init(width: 100, height: 100)
    var fitSize                  : CGSize = .zero
    var bubbleAnchorPoint        : CGPoint = .zero;
    var cancelButtonRelPosition  : CGPoint = .zero;
    var cancelButtonAbsPosition  : CGPoint = .zero;
    var shadowOffset             : CGSize = .zero;
    var cancelButtonSize         : CGSize = .zero;
    var cancelButtonFrame        : CGRect = .zero;
    var cancelImage              : UIImage?;
    var cancelTintColor          : UIColor?;
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
    var didClickCloseButton      : ((BRCPopUper,UIView) -> ())?
    
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
    
    public func didClickCloseButton(_ block : @escaping (BRCPopUper,UIView) -> () = { _,_ in }) -> BRCPopUpParameters {
        return updateParams { params in
            params.didClickCloseButton = block;
        };
    }
    
    /// Set the container size of the popup box / 设置弹出框的容器大小
    /// default is `(100,100)`
    public func containerSize(_ size: CGSize) -> BRCPopUpParameters {
        return updateParams { params in
            params.containerSize = size;
        };
    }
    
    /// Set the adaptive size of the pop-up box text / 设置弹出框文本的自适应大小
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
    
    /// The relative horizontal spacing between pop-up views and anchor views / 弹出视图和锚定视图相对水平方向的间距
    /// default is `0.0`
    /// 该属性支持负数，负数将会向另外一个方向偏移
    /// This property supports negative numbers,which will shift in the other direction.
    public func offsetToAnchorView(_ offset : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.offsetToAnchorView = offset;
        };
    }
    
    /// The Direction of PopUper / 弹出的方向
    /// default is `BRCPopUpDirectionBottom`
    public func popUpDirection(_  direction : BRCPopUpDirection) -> BRCPopUpParameters {
        return updateParams { params in
            params.popUpDirection = direction;
        };
    }
    
    /// Relative vertical spacing between popup view and anchor view / 弹出视图和锚定视图相对垂直的间距
    /// default is `5.0`
    public func marginToAnchorView(_  margin : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.marginToAnchorView = margin;
        };
    }
    
    /// The duration for popUp Animation / 弹出动画的时长
    /// default is `0.2`
    public func popUpAnimationDuration(_  duration : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.popUpAnimationDuration = duration;
        };
    }
    
    /// The DismissMode for PopUper / 弹出框的消失方式
    /// default is `BRCPopUpDismissModeInteractive`
    /// @discussion 该属性被设置为 `BRCPopUpDismissModeInteractive` 意味着当用户触碰屏幕时，
    /// 就会自动解散改弹出框，设置为 `BRCPopUpDismissModeNone` 则需要开发者代码自行控制解散弹出框的时机
    /// This property is set to `BRCPopUpDismissModeInteractive` which means that when the user touches the screen,will automatically dismiss the pop-up box. If set to `BRCPopUpDismissModeNone`, the developer code needs to control the timing of dismissing the pop-up box.
    public func dismissMode(_  mode : BRCPopUpDismissMode) -> BRCPopUpParameters {
        return updateParams { params in
            params.dismissMode = mode;
        };
    }
    
    /// The Animation Type for PopUp / 弹出动画样式
    /// default is `BRCPopUpAnimationTypeFadeBounce`
    public func animationType(_  type : BRCPopUpAnimationType) -> BRCPopUpParameters {
        return updateParams { params in
            params.animationType = type;
        };
    }
    
    /// The Alignment for contentView / 内容对齐方式
    /// default is `BRCPopUpContentAlignmentCenter`
    public func contentAlignment(_  alignment : BRCPopUpContentAlignment) -> BRCPopUpParameters {
        return updateParams { params in
            params.contentAlignment = alignment;
        };
    }
    
    /// Whether to adapt the size of the container view / 是否要自适应容器视图的大小
    /// default `YES`
    /// 当弹出方向是 Top/Bottom，那么 `ContainerSize = (AnchorViewWidth,AnchorViewWidth)`
    /// 当弹出方向是 Left/Right，那么 `ContainerSize = (AnchorViewHeight,AnchorViewHeight)`
    /// When the pop-up direction is Top/Bottom, then `ContainerSize = (AnchorViewWidth,AnchorViewWidth)`
    /// When the pop-up direction is Left/Right, then `ContainerSize = (AnchorViewHeight,AnchorViewHeight)`
    public func autoFitContainerStyle(_  autoFitContainerStyle : BRCPopUpAutoFitContainerStyle) -> BRCPopUpParameters {
        return updateParams { params in
            params.autoFitContainerStyle = autoFitContainerStyle;
        };
    }
    
    /// Whether to cut off the part beyond the view / 是否切除超过视图以外的部分
    /// default `NO`
    public func autoCutoffRelief(_  autoCut : Bool) -> BRCPopUpParameters {
        return updateParams { params in
            params.autoCutoffRelief = autoCut;
        };
    }
    
    /// Whether to keep the arrow always in the center of the anchored view (if possible) / 是否保持箭头始终在锚定视图的中心（如果可以）
    /// default `YES`
    public func arrowCenterAlignToAnchor(_  alignToAnchor : Bool) -> BRCPopUpParameters {
        return updateParams { params in
            params.arrowCenterAlignToAnchor = alignToAnchor;
        };
    }
    
    /// Size of arrow / 箭头的大小
    ///
    /// default `CGSizeMake(16, 8)`
    public func arrowSize(_ size : CGSize) -> BRCPopUpParameters {
        return updateParams { params in
            params.arrowSize = size;
        };
    }
    
    /// The absolute position of the arrow / 箭头的绝对位置
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
    
    /// Relative position of arrow / 箭头的相对位置
    /// default `-1`
    public func arrowRelativePosition(_ position : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.arrowRelativePosition = position;
        };
    }
    
    /// The corner radius of the arrow position / 箭头位置的圆角半径
    /// default `4`
    public func arrowRadius(_ radius : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.arrowRadius = radius;
        };
    }
    
    /// Anchor point for bubble background / 气泡背景的锚点
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
    
    /// The EdgeInsets for contentView / 内边距
    /// default is `UIEdgeInsetsMake(5, 5, 5, 5)`
    public func contentInsets(_ insets : EdgeInsets) -> BRCPopUpParameters {
        return updateParams { params in
            params.contentInsets = insets;
        };
    }
    
    /// The Window for PopUper / 弹出框的所在Window
    /// default is `[UIApplication sharedApplication].keyWindow`
    public func contextWindow(_ window : UIWindow?) -> BRCPopUpParameters {
        return updateParams { params in
            params.contextWindow = window;
        };
    }
    
    /// The Font For PopUper Text / 弹出框的文本字体
    public func textFont(_ font : UIFont) -> BRCPopUpParameters {
        return updateParams { params in
            params.textFont = font;
        };
    }
    
    /// The Font For PopUper TextColor / 弹出框的文本颜色
    /// default is `Black`
    public func textColor(_ color : UIColor) -> BRCPopUpParameters {
        return updateParams { params in
            params.textColor = color;
        };
    }
    
    /// Hide PopUper after delay time / 设置弹出框的自动消失时间
    /// default is `-1`
    public func hideAfterDelay(_ delay : CGFloat) -> BRCPopUpParameters {
        return updateParams { params in
            params.hideAfterDelayDuration = delay;
        };
    }
    
    /// Set SuperView For PopUp / 设置弹出框的父视图
    /// default is `window`
    public func popUpContext(_ context : UIView) -> BRCPopUpParameters {
        return updateParams { params in
            params.popUpContextStyle = .custom;
            params.popUpSuperView = context;
        }
    }
    
    /// Show Cancel-Button / 显示取消按钮
    /// - Parameters:
    ///   - relativePosition: The relativePosition for button / 按钮的相对位置 (-1,-1) <-> (1,1)
    public func showCancelButton(withSize size : CGSize, absoultePosition : CGPoint = .zero ,relativePosition : CGPoint = .zero,image : UIImage? = nil,color : UIColor? = nil) -> BRCPopUpParameters {
        return updateParams { params in
            params.showCancelButton = true;
            params.cancelButtonRelPosition = relativePosition;
            params.cancelButtonAbsPosition = absoultePosition;
            params.cancelButtonSize = size;
            params.cancelImage = image;
            params.cancelTintColor = color;
        }
    }
    
    /// Show Cancel-Button / 显示取消按钮
    /// - Parameters:
    ///    - frame: The Frame for button / 按钮的位置
    public func showCancelButton(withFrame frame : CGRect,image : UIImage? = nil,color : UIColor? = nil) -> BRCPopUpParameters {
        return updateParams { params in
            params.showCancelButton = true;
            params.cancelButtonFrame = frame;
            params.cancelImage = image;
            params.cancelTintColor = color;
        }
    }
    
    /// Menu SeparatorColor / 菜单分割线颜色
    public func menuSeparatorColor(_ color : UIColor)  -> BRCPopUpParameters {
        return updateParams { params in
            params.menuSepLineColor = color;
        }
    }
    
    /// Show MenuSeparator / 显示菜单分割线
    public func showMenuSeparator(_ isShow : Bool)  -> BRCPopUpParameters {
        return updateParams { params in
            params.isShowMenuSepLine = isShow;
        }
    }
    
}

extension View {
    
    /// Pop up a rich text / 弹出一段富文本
    public func brc_popUpTip (
        isPresented    : Binding<Bool>,
        attributedText : NSAttributedString
    ) -> some View {
        let wrapper = BRCPopUpViewModifier<AnyView>(isPresented: isPresented)
        wrapper.popUper.attribuedText = attributedText;
        return self.modifier(wrapper)
    }
    
    /// Pop up a rich text / 弹出一段富文本
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
        wrapper.popUper.attribuedText = attributedText;
        return self.modifier(wrapper)
    }
    
    /// Pop up a text / 弹出一段文本
    public func brc_popUpTip (
        isPresented  : Binding<Bool>,
        tipText      : String
    ) -> some View {
        let wrapper = BRCPopUpViewModifier<AnyView>(isPresented: isPresented)
        wrapper.popUper.text = tipText;
        return self.modifier(wrapper)
    }
    
    /// Pop up a text / 弹出一段文本
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
        wrapper.popUper.text = tipText;
        return self.modifier(wrapper)
    }
    
    /// Pop up a webImage / 弹出一张网络图片
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
        wrapper.popUper.imageUrl = imageUrl;
        return self.modifier(wrapper)
    }
    
    /// Pop up a image / 弹出一张图片
    public func brc_popUpImage (
        isPresented  : Binding<Bool>,
        image        : UIImage,
        customize    : @escaping (BRCPopUpParameters) -> (BRCPopUpParameters)
    ) -> some View {
        let wrapper = BRCPopUpViewModifier<AnyView>(isPresented: isPresented,contentStyle: .image,parameters:customize(BRCPopUpParameters()))
        wrapper.popUper.image = image;
        return self.modifier(wrapper)
    }
    
    /// Pop up a custom view / 弹出一个自定义视图
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

