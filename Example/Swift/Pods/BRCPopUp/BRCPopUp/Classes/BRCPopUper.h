//
//  BRCPopUp.h
//
//  Created by sunzhixiong on 2024/3/15.
//

#import <UIKit/UIKit.h>
#import "BRCPopUpConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRCPopUper : NSObject<BRCBubbleStyle>

@property (nonatomic, strong, readonly, nullable) UIImageView *contentImageView;
@property (nonatomic, strong, readonly, nullable) UILabel     *contentLabel;
@property (nonatomic, strong) UIView                   *contentView;
@property (nonatomic, strong) UIView                   *anchorView;
@property (nonatomic, assign) CGPoint                  anchorPoint;
@property (nonatomic, strong) UIColor                  *backgroundColor;
@property (nonatomic, assign) CGFloat                  cornerRadius;
@property (nonatomic, assign) CGSize                   containerSize;
@property (nonatomic, assign) CGFloat                  containerHeight;
@property (nonatomic, assign) CGFloat                  containerWidth;
@property (nonatomic, strong) UIColor                  *shadowColor;
@property (nonatomic, assign) CGSize                   shadowOffset;
@property (nonatomic, assign) CGFloat                  shadowRadius;
@property (nonatomic, assign) CGFloat                  shadowOpacity;
@property (nonatomic, copy)   void (^webImageLoadBlock)(UIImageView *imageView, NSURL *imageUrl);
/**
 * 内容对齐方式
 * The Alignment for contentView
 * default is `BRCPopUpContentAlignmentCenter`
 */
@property (nonatomic, assign) BRCPopUpContentAlignment contentAlignment;

/**
 * 内容的样式
 * The Style for contentView
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
 *
 */
@property (nonatomic, assign) BRCPopUpContentStyle     contentStyle;

/**
 * 内边距
 * The EdgeInsets for contentView
 * default is `UIEdgeInsetsMake(5, 5, 5, 5)`
 */
@property (nonatomic, assign) UIEdgeInsets             contentInsets;

/**
 * 弹出的方向
 * The Directio of PopUper
 * default is `BRCPopUpDirectionBottom`
 */
@property (nonatomic, assign) BRCPopUpDirection        popUpDirection;

/**
 * 弹出框的消失方式
 * The DismissMode for PopUper
 * default is `BRCPopUpDismissModeInteractive`
 * @discussion 该属性被设置为 `BRCPopUpDismissModeInteractive` 意味着当用户触碰屏幕时，
 * 就会自动解散改弹出框，设置为 `BRCPopUpDismissModeNone` 则需要开发者代码自行控制解散弹出框的时机
 *
 * @discussion This property is set to `BRCPopUpDismissModeInteractive` which means that when the user touches the screen,
 * will automatically dismiss the pop-up box. If set to `BRCPopUpDismissModeNone`, the developer code needs to control the timing of dismissing the pop-up box.
 */
@property (nonatomic, assign) BRCPopUpDismissMode      dismissMode;

/**
 * 弹出框的父视图
 * The ContextStyle for PopUper
 * default is `BRCPopUpContextStyleViewController`
 * @attention 该属性建议由本框架内部自行判断控制，大部分的情况不需要使用者去
 * 关注这个属性。
 *
 * @attention This attribute is recommended to be controlled by
 * the framework itself. In most cases, users do not need to do it.
 */
@property (nonatomic, assign) BRCPopUpContextStyle     contextStyle;

/**
 * 弹出视图和锚定视图相对垂直的间距
 * Relative vertical spacing between popup view and anchor view
 * default is `5.0`
 */
@property (nonatomic, assign) CGFloat                  marginToAnchorView;

/**
 * 弹出视图和锚定视图相对水平方向的间距
 * The relative horizontal spacing between pop-up views and anchor views
 * default `0.0`
 * @discussion 该属性支持负数，负数将会向另外一个方向偏移
 *
 * @discussion This property supports negative numbers, 
 * which will shift in the other direction.
 */
@property (nonatomic, assign) CGFloat                  offsetToAnchorView;

/**
 * 是否切除超过视图以外的部分
 * Whether to cut off the part beyond the view
 * default `NO`
 */
@property (nonatomic, assign) BOOL                     autoCutoffRelief;

/**
 * 是否要自适应容器视图的大小
 * Whether to adapt the size of the container view
 * default `YES`
 * @discussion
 * 当弹出方向是 Top/Bottom，那么 `ContainerSize = (AnchorViewWidth,AnchorViewWidth)`
 * 当弹出方向是 Left/Right，那么 `ContainerSize = (AnchorViewHeight,AnchorViewHeight)`
 *
 * @discussion
 * When the pop-up direction is Top/Bottom, then `ContainerSize = (AnchorViewWidth,AnchorViewWidth)`
 * When the pop-up direction is Left/Right, then `ContainerSize = (AnchorViewHeight,AnchorViewHeight)`
 */
@property (nonatomic, assign) BOOL                     autoFitContainerSize;

/**
 * 是否保持箭头始终在锚定视图的中心（如果可以）
 * Whether to keep the arrow always in the center of the anchored view (if possible)
 * default `YES`
 */
@property (nonatomic, assign) BOOL                     arrowCenterAlignToAnchor;

/**
 * 气泡背景的锚点
 * Anchor point for bubble background
 * @discussion 当你有自定义弹出动画的需求时，你可以使用
 * 该属性来帮助你完成你的动画效果
 *
 * @discussion When you need to customize pop-up animation,
 * you can use this attribute to help you complete your animation effect.
 */
@property (nonatomic, assign) CGPoint                  bubbleAnchorPoint;

/**
 * 弹出自定义动画
 * The Animation For PopUp
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
@property (nonatomic, strong) CAAnimation              *popUpAnimation;

/**
 * 弹出动画样式
 * The Animation Type for PopUp
 * default is `BRCPopUpAnimationTypeFadeBounce`
 */
@property (nonatomic, assign) BRCPopUpAnimationType    popUpAnimationType;

/**
 * 弹出动画的时长
 * The duration for popUp Animation
 * default is `0.2`
 */
@property (nonatomic, assign) NSTimeInterval           popUpAnimationDuration;

/**
 * 弹出框的代理
 * The delegate for PopUper
 * @discussion 你可以通过设置代理的方式，来监听
 * PopUper 的展示、消失、点击等事件
 *
 * @discussion You can listen by setting up a proxy
 * PopUper’s display, disappearance, click and other events
 * 
 */
@property (nonatomic, weak)   id<BRCPopUperDelegate>   delegate;

#pragma mark - init

- (instancetype)initWithContentView:(UIView *)contentView;
- (instancetype)initWithContentStyle:(BRCPopUpContentStyle)contentStyle;

#pragma mark - display

/**
 * 显示弹出框
 * Show PopUper
 * @discussion 你需要先设置 `AnchorView` 或 `AnchorPoint`
 * You Need Set `AnchorView` or `AnchorPoint` before show
 */
- (void)show;
- (void)showAndHideAfterDelay:(NSTimeInterval)delay;

- (void)showWithAnchorView:(UIView *)anchorView;
- (void)showWithAnchorView:(UIView *)anchorView hideAfterDelay:(NSTimeInterval)delay;

- (void)showAtAnchorPoint:(CGPoint)anchorPoint;
- (void)showAtAnchorPoint:(CGPoint)anchorPoint hideAfterDelay:(NSTimeInterval)delay;

- (void)hide;

- (void)toggleDisplay;

#pragma mark - fit

/**
 * 调用该方法来自适应大小-主要适用于文本
 * Call this method to adapt to size - mainly applicable to text
 */
- (void)sizeThatFits:(CGSize)size;

@end

/**
 * Extension for managing popUp content like text, and images.
 */
@interface BRCPopUper (popUpContent)

#pragma mark - Text

/**
 * Sets the popUp's content text.
 *
 * @param contentText The text to be displayed in the popUp.
 */
- (void)setContentText:(id)contentText;

#pragma mark - Image

/**
 * Sets the popUp's content image.
 *
 * @param image The image to be displayed in the popUp.
 */
- (void)setContentImage:(UIImage *)image;

/**
 * Sets the popUp's content image using a URL.
 *
 * @param imageUrl The URL of the image to be displayed in the popUp.
 */
- (void)setContentImageUrl:(NSString *)imageUrl;

@end


NS_ASSUME_NONNULL_END
