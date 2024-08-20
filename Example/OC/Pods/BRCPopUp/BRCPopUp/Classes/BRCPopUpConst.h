//
//  BRCPopUpConst.h
//  BRCDropDown
//
//  Created by sunzhixiong on 2024/7/30.
//

#ifndef BRCPopUpConst_h
#define BRCPopUpConst_h

#define kBRCScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kBRCScreenHeight  [UIScreen mainScreen].bounds.size.height

/// DO NOT CHANGE THIS！
/// 不要修改该枚举的值
typedef NS_ENUM(NSInteger, BRCPopUpDirection) {
    BRCPopUpDirectionTop    = 3,    // Popup displays at the top
    BRCPopUpDirectionBottom = 1,     // Popup displays at the bottom
    BRCPopUpDirectionLeft   = 2,       // Popup displays to the left
    BRCPopUpDirectionRight  = 0       // Popup displays to the right
};

typedef NS_ENUM(NSInteger, BRCPopUpAnimationType) {
    BRCPopUpAnimationTypeNone = 0,               // No animation
    BRCPopUpAnimationTypeFade,                   // Fade animation
    BRCPopUpAnimationTypeScale,                  // Scale animation
    BRCPopUpAnimationTypeBounce,                 // Bounce animation
    BRCPopUpAnimationTypeFadeScale,              // Fade and Scale animation
    BRCPopUpAnimationTypeFadeBounce,             // Fade and Bounce animation
    BRCPopUpAnimationTypeFadeHeightExpansion,    // Fade and Height Expansion animation
    BRCPopUpAnimationTypeHeightExpansion         // Height Expansion animation
};

typedef NS_ENUM(NSInteger, BRCPopUpContentStyle) {
    BRCPopUpContentStyleText,         // Content style as text
    BRCPopUpContentStyleImage,        // Content style as image
    BRCPopUpContentStyleCustom        // Custom content style
};

typedef NS_ENUM(NSInteger, BRCPopUpContentAlignment) {
    BRCPopUpContentAlignmentLeft = 0,     // Left alignment
    BRCPopUpContentAlignmentCenter,       // Center alignment
    BRCPopUpContentAlignmentRight         // Right alignment
};

typedef NS_ENUM(NSInteger, BRCPopUpContextStyle) {
    BRCPopUpContextStyleViewController = 0,        // Context as view controller
    BRCPopUpContextStyleWindow,           // Context as window
    BRCPopUpContextStyleSuperView,            // Context as superview
    BRCPopUpContextStyleAutoFind    // Will Find The Nearest ScrollView
};

typedef NS_ENUM(NSInteger, BRCPopUpDismissMode) {
    BRCPopUpDismissModeNone = 0,          // No dismiss mode
    BRCPopUpDismissModeInteractive,    // Dismiss on tapping content
};

typedef NS_ENUM(NSInteger, BRCPopUpArrowStyle) {
    BRCPopUpArrowStyleNone = 0,              // No arrow
    BRCPopUpArrowStyleRightangle,            // Right-angle arrow
    BRCPopUpArrowStyleEquilateral,           // Equilateral triangle arrow
    BRCPopUpArrowStyleRoundEquilateral       // Round-edged equilateral triangle arrow
};

@class BRCPopUper;

@protocol BRCPopUperDelegate <NSObject>

@optional
- (void)willShowPopUper:(BRCPopUper *)popUper withAchorView:(UIView *)anchorView NS_SWIFT_NAME(willShowPopUper(popUper:anchorView:));
- (void)didShowPopUper:(BRCPopUper *)popUper withAchorView:(UIView *)anchorView NS_SWIFT_NAME(didShowPopUper(popUper:anchorView:));
- (void)willHidePopUper:(BRCPopUper *)popUper withAchorView:(UIView *)anchorView NS_SWIFT_NAME(willHidePopUper(popUper:anchorView:));
- (void)didHidePopUper:(BRCPopUper *)popUper withAchorView:(UIView *)anchorView NS_SWIFT_NAME(didHidePopUper(popUper:anchorView:));
- (void)didUserDismissPopUper:(BRCPopUper *)popUper withAchorView:(UIView *)anchorView NS_SWIFT_NAME(didUserDismissPopUper(popUper:anchorView:));

@end

@protocol BRCBubbleStyle <NSObject>

/**
 * 箭头位置的圆角半径
 * The corner radius of the arrow position
 * default `4`
 */
@property (nonatomic, assign) CGFloat arrowRadius;

/**
 * 箭头的大小
 * size of arrow
 * default `CGSizeMake(16, 8)`
 */
@property (nonatomic, assign) CGSize  arrowSize;

/**
 * 箭头方向
 * Arrow direction
 * default `BRCPopUpDirectionTop`
 */
@property (nonatomic, assign) BRCPopUpDirection arrowDirection;

/**
 * 箭头的相对位置
 * relative position of arrow
 * default `-1`
 */
@property (nonatomic, assign) CGFloat arrowRelativePosition;

/**
 * 箭头的绝对位置
 * The absolute position of the arrow
 *
 * default `12`
 * @discussion 设置了 arrowRelativePosition 之后，该参数就不再生效
 * 箭头向上或者向下 那么就是箭头中心到容器左侧的距离
 * 箭头向左或者向右 那么就是箭头中心到容器上侧的距离
 * 同时该参数支持为`负数`，例如在箭头向上或者向下
 * arrowAbsolutePosition = 12，代表着箭头中心到容器左侧的距离为 12
 * arrowAbsolutePosition = -12，代表箭头中心到容器右侧的距离为 12
 *
 * @discussion After setting arrowRelativePosition, this parameter will no longer take effect.
 * If the arrow is up or down, it is the distance from the center of the arrow to the left side of the container
 * If the arrow points to the left or right, it is the distance from the center of the arrow to the upper side of the container
 * At the same time, this parameter supports `negative numbers`, such as arrows up or down
 * arrowAbsolutePosition = 12, which means the distance from the center of the arrow to the left side of the container is 12
 * arrowAbsolutePosition = -12, which means the distance from the center of the arrow to the right side of the container is 12
 */
@property (nonatomic, assign) CGFloat arrowAbsolutePosition;

@end


#endif /* BRCPopUpConst_h */
