//
//  BRCPopUp.h
//
//  Created by sunzhixiong on 2024/3/15.
//

#import <UIKit/UIKit.h>
#import "BRCPopUpConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRCPopUper : NSObject<BRCBubbleStyle>

@property (nonatomic, strong, readonly, nullable) UIImageView  *contentImageView;
@property (nonatomic, strong, readonly, nullable) UILabel      *contentLabel;
@property (nonatomic, strong, nullable) UIView                 *anchorView;
@property (nonatomic, strong) UIView                   *contentView;
@property (nonatomic, strong) UIColor                  *backgroundColor;
@property (nonatomic, strong) UIColor                  *shadowColor;
@property (nonatomic, strong) UIColor                  *cancelTintColor;
@property (nonatomic, strong) UIImage                  *cancelImage;
@property (nonatomic, assign) CGSize                   cancelButtonSize;
@property (nonatomic, assign) CGRect                   cancelButtonFrame;
@property (nonatomic, assign) CGRect                   anchorFrame;
@property (nonatomic, assign) CGFloat                  cornerRadius;
@property (nonatomic, assign) CGSize                   containerSize;
@property (nonatomic, assign) CGFloat                  containerHeight;
@property (nonatomic, assign) CGFloat                  containerWidth;
@property (nonatomic, assign) CGSize                   shadowOffset;
@property (nonatomic, assign) CGFloat                  shadowRadius;
@property (nonatomic, assign) CGFloat                  shadowOpacity;
@property (nonatomic, assign) BOOL                     showCancelButton;
@property (nonatomic, copy)   void (^webImageLoadBlock)(UIImageView *imageView, NSURL *imageUrl);

#pragma mark - Text

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont   *textFont;
@property (nonatomic, strong) UIColor  *textColor;
@property (nonatomic, assign) NSTextAlignment    textAlignment;
@property (nonatomic, strong) NSAttributedString *attribuedText;

#pragma mark - Image

@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIColor  *tintColor;

#pragma mark - private

/**
 * The RootView For PopUper / 弹出框的根视图
 * @discussion - Used In SwiftUI
 */
@property (nonatomic, strong, readonly) UIView *rootView;

#pragma mark - context

/**
 * The SuperView For PopUper / 弹出框的父视图
 */
@property (nonatomic, strong, nullable) UIView *popUpSuperView;

/**
 * The ContextStyle for PopUper / 弹出框的父视图
 * default is `BRCPopUpContextStyleViewController`
 * @attention 该属性建议由本框架内部自行判断控制，大部分的情况不需要使用者去
 * 关注这个属性。
 *
 * @attention This attribute is recommended to be controlled by
 * the framework itself. In most cases, users do not need to do it.
 */
@property (nonatomic, assign) BRCPopUpContextStyle contextStyle;

/**
 * The Window for PopUper / 弹出框的所在Window
 * default is `[UIApplication sharedApplication].keyWindow`
 * @discussion 当你将 `contextType` 设置为 `window` 之后
 * 当你想要自定义弹出框弹出在某个window中时，可以设置该属性
 *
 * @discussion After you set `contextType` to `window`
 * When you want a custom pop-up box to pop up in a window,
 * you can set this attribute
 */
@property (nonatomic, strong) UIWindow *contextWindow;


#pragma mark - inside

/**
 * The EdgeInsets for contentView / 内边距
 * default is `UIEdgeInsetsMake(5, 5, 5, 5)`
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/**
 * The Style for contentView / 内容的样式
 * default is `BRCPopUpContentStyleCustom`
 *
 * @discussion 如果你设置了 `contentStyle` 为 `BRCPopUpContentStyleText`
 * 可以使用属性`contentLabel` 去设置你的文本 或者 使用`-setContentText:`方法
 * `BRCPopUpContentStyleText` 同理
 *
 * @discussion if you set `contentStyle` to `BRCPopUpContentStyleText`
 * You can use the attribute `contentLabel` to set your text or use the
 * `-setContentText:` method
 * `BRCPopUpContentStyleText` the same way
 */
@property (nonatomic, assign) BRCPopUpContentStyle contentStyle;

/**
 * The RelativePosition For Cancel Button / 关闭按钮的相对位置
 * default is `(0,0)`
 */
@property (nonatomic, assign) CGPoint cancelButtonRelativePosition;

/**
 * The RelativePosition For Cancel Button / 关闭按钮的绝对位置
 * default is `(0,0)`
 */
@property (nonatomic, assign) CGPoint cancelButtonAbsoultePosition;

/**
 * Whether to cut off the part beyond the view / 是否切除超过视图以外的部分
 * default `NO`
 */
@property (nonatomic, assign) BOOL autoCutoffRelief;

/**
 * Whether to adapt the size of the container view / 是否要自适应容器视图的大小
 * default `YES`
 * @discussion
 * 当弹出方向是 Top/Bottom，那么 `ContainerSize = (AnchorViewWidth,AnchorViewWidth)`
 * 当弹出方向是 Left/Right，那么 `ContainerSize = (AnchorViewHeight,AnchorViewHeight)`
 *
 * @discussion
 * When the pop-up direction is Top/Bottom, then `ContainerSize = (AnchorViewWidth,AnchorViewWidth)`
 * When the pop-up direction is Left/Right, then `ContainerSize = (AnchorViewHeight,AnchorViewHeight)`
 */
@property (nonatomic, assign) BOOL autoFitContainerSize;

/**
 * Whether to keep the arrow always in the center of the anchored view (if possible) / 是否保持箭头始终在锚定视图的中心（如果可以）
 * default `YES`
 */
@property (nonatomic, assign) BOOL arrowCenterAlignToAnchor;

/**
 * Anchor point for bubble background / 气泡背景的锚点
 * @discussion 当你有自定义弹出动画的需求时，你可以使用
 * 该属性来帮助你完成你的动画效果
 *
 * @discussion When you need to customize pop-up animation,
 * you can use this attribute to help you complete your animation effect.
 */
@property (nonatomic, assign) CGPoint bubbleAnchorPoint;

#pragma mark - outside

/**
 * The Alignment for contentView / 内容对齐方式
 * default is `BRCPopUpContentAlignmentCenter`
 * @discussion: align to `anchorView`
 */
@property (nonatomic, assign) BRCPopUpContentAlignment contentAlignment;

/**
 * Relative vertical spacing between popup view and anchor view / 弹出视图和锚定视图相对垂直的间距
 * default is `5.0`
 */
@property (nonatomic, assign) CGFloat marginToAnchorView;

/**
 * The relative horizontal spacing between pop-up views and anchor views / 弹出视图和锚定视图相对水平方向的间距
 * default `0.0`
 * @discussion 该属性支持负数，负数将会向另外一个方向偏移
 *
 * @discussion This property supports negative numbers,
 * which will shift in the other direction.
 */
@property (nonatomic, assign) CGFloat offsetToAnchorView;


#pragma mark - popup custom

/**
 * The Direction of PopUper / 弹出的方向
 * default is `BRCPopUpDirectionBottom`
 */
@property (nonatomic, assign) BRCPopUpDirection popUpDirection;

/**
 * The DismissMode for PopUper / 弹出框的消失方式
 * default is `BRCPopUpDismissModeInteractive`
 * @discussion 该属性被设置为 `BRCPopUpDismissModeInteractive` 意味着当用户触碰屏幕时，
 * 就会自动解散改弹出框，设置为 `BRCPopUpDismissModeNone` 则需要开发者代码自行控制解散弹出框的时机
 *
 * @discussion This property is set to `BRCPopUpDismissModeInteractive` which means that when the user touches the screen,
 * will automatically dismiss the pop-up box. If set to `BRCPopUpDismissModeNone`, the developer code needs to control the timing of dismissing the pop-up box.
 */
@property (nonatomic, assign) BRCPopUpDismissMode dismissMode;

/**
 * The Animation For PopUp / 弹出自定义动画
 * @discussion 当你有自定义弹出动画的需求时，你可以使用
 * 该属性帮助你完成你的动画效果，该动画将被添加到弹出框的
 * layer中去
 *
 * @discussion When you need to customize the pop-up animation,
 * you can use This attribute helps you complete your animation effect,
 * which will be added to the popUp box layer
 *
 * @attention 该动画的 Delegate将会被重写，你可以设置
 * `delegate` 属性，来观察相关的回调
 *
 * @attention The animation's Delegate will be rewritten, you can set
 * `delegate` attribute to observe related callbacks
 */
@property (nonatomic, strong) CAAnimation *popUpAnimation;

/**
 * The Animation Type for PopUp / 弹出动画样式
 * default is `BRCPopUpAnimationTypeFadeBounce`
 */
@property (nonatomic, assign) BRCPopUpAnimationType popUpAnimationType;

/**
 * The duration for popUp Animation / 弹出动画的时长
 * default is `0.2`
 */
@property (nonatomic, assign) NSTimeInterval popUpAnimationDuration;

/**
 * The delegate for PopUper / 弹出框的代理
 * @discussion 你可以通过设置代理的方式，来监听
 * PopUper 的展示、消失、点击等事件
 *
 * @discussion You can listen by setting up a proxy
 * PopUper’s display, disappearance, click and other events
 * 
 */
@property (nonatomic, weak)   id<BRCPopUperDelegate>   delegate;

/**
 * Hide popUper after duration / 弹出框自动消失的时间
 * default is `-1`
 */
@property (nonatomic, assign) CGFloat hideAfterDelayDuration;

#pragma mark - init

- (instancetype)initWithContentView:(UIView *)contentView;
- (instancetype)initWithContentStyle:(BRCPopUpContentStyle)contentStyle;

#pragma mark - show

/**
 * Show PopUper / 显示弹出框
 * @discussion 你需要先设置 `AnchorView` 或 `AnchorFrame`
 * You Need Set `AnchorView` or `AnchorFrame` before show
 */
- (void)show;
- (void)showAndHideAfter:(NSTimeInterval)duration NS_SWIFT_NAME(showAndHideAfter(duration:));
- (void)showWithAnimation:(CAAnimation *)animation NS_SWIFT_NAME(showWithAnimation(animation:));
- (void)showWithAnimation:(CAAnimation *)animation hideAfter:(NSTimeInterval)duration NS_SWIFT_NAME(showWithAnimation(animation:hideAfter:));
- (void)showWithAnimationType:(BRCPopUpAnimationType)animationType NS_SWIFT_NAME(showWithAnimationType(type:));
- (void)showWithAnimationType:(BRCPopUpAnimationType)animationType hideAfter:(NSTimeInterval)duration NS_SWIFT_NAME(showWithAnimationType(type:hideAfter:));

- (void)showWithAnchorView:(UIView *)anchorView NS_SWIFT_NAME(showWithAnchorView(view:));
- (void)showWithAnchorView:(UIView *)anchorView hideAfter:(NSTimeInterval)duration  NS_SWIFT_NAME(showWithAnchorView(view:hideAfter:));
- (void)showWithAnchorView:(UIView *)anchorView withAnimationType:(BRCPopUpAnimationType)animationType NS_SWIFT_NAME(showWithAnchorView(view:animationType:));
- (void)showWithAnchorView:(UIView *)anchorView withAnimationType:(BRCPopUpAnimationType)animationType hideAfter:(NSTimeInterval)duration NS_SWIFT_NAME(showWithAnchorView(view:animationType:hideAfter:));
- (void)showWithAnchorView:(UIView *)anchorView withAnimation:(CAAnimation *)animation NS_SWIFT_NAME(showWithAnchorView(view:animation:));
- (void)showWithAnchorView:(UIView *)anchorView withAnimation:(CAAnimation *)animation hideAfter:(NSTimeInterval)duration NS_SWIFT_NAME(showWithAnchorView(view:animation:hideAfter:));

- (void)showWithAnchorFrame:(CGRect)anchorFrame NS_SWIFT_NAME(showWithAnchorFrame(frame:));
- (void)showWithAnchorFrame:(CGRect)anchorFrame hideAfter:(NSTimeInterval)duration NS_SWIFT_NAME(showWithAnchorFrame(frame:hideAfter:));
- (void)showWithAnchorFrame:(CGRect)anchorFrame withAnimationType:(BRCPopUpAnimationType)animationType NS_SWIFT_NAME(showWithAnchorFrame(frame:animationType:));
- (void)showWithAnchorFrame:(CGRect)anchorFrame withAnimationType:(BRCPopUpAnimationType)animationType hideAfter:(NSTimeInterval)duration NS_SWIFT_NAME(showWithAnchorFrame(frame:animationType:hideAfter:));
- (void)showWithAnchorFrame:(CGRect)anchorFrame withAnimation:(CAAnimation *)animation NS_SWIFT_NAME(showWithAnchorFrame(frame:animation:));
- (void)showWithAnchorFrame:(CGRect)anchorFrame withAnimation:(CAAnimation *)animation hideAfter:(NSTimeInterval)duration NS_SWIFT_NAME(showWithAnchorFrame(frame:animation:hideAfter:));

#pragma mark - hide

- (void)hide;
- (void)hideWithAnimated:(BOOL)isAnimated;

#pragma mark - toggle

- (void)toggleDisplay;

#pragma mark - fit

/**
 * 调用该方法来自适应大小-主要适用于文本
 * Call this method to adapt to size - mainly applicable to text
 */
- (void)sizeThatFits:(CGSize)size;

@end


NS_ASSUME_NONNULL_END
