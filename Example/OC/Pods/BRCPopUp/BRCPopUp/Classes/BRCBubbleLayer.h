//
//  BRCBubbleLayer.h
//  BRCDropDown
//
//  Created by sunzhixiong on 2024/7/30.
//

#import <QuartzCore/QuartzCore.h>
#import "BRCPopUpConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRCBubbleLayer : CALayer <BRCBubbleStyle>

/// 设置了 `BubbleStyle` 之后,可使用该方法立刻更新
/// After setting `BubbleStyle`, you can use this method to update immediately
- (void)updateLayer;

@end

@interface BRCBubbleContainerView : UIView <CAAnimationDelegate>

@property (nonatomic, assign, readonly) BOOL isAnimating;
@property (nonatomic, strong, readonly) BRCBubbleLayer *bubbleLayer;
@property (nonatomic, strong) UIColor *shadowColor;
- (void)setAnchorPointWithAnimationType:(BRCPopUpAnimationType)type;

#pragma mark - display

- (void)show;
- (void)showWithAnimation:(nullable CAAnimation *)animation
          completionBlock:(void (^__nullable)(BOOL))completionBlock;

- (void)hide;
- (void)hideWithAnimation:(nullable CAAnimation *)animation
          completionBlock:(void (^__nullable)(BOOL))completionBlock;

@end


NS_ASSUME_NONNULL_END
