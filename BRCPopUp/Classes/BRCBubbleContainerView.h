//
//  BRCBubbleContainerView.h
//  BRCPopUp
//
//  Created by sunzhixiong on 2025/4/6.
//

#import <UIKit/UIKit.h>
#import "BRCBubbleLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRCBubbleContainerView : UIView <CAAnimationDelegate>

@property (nonatomic, strong, readonly) UIImageView    *cancelButton;
@property (nonatomic, assign, readonly) BOOL isAnimating;
@property (nonatomic, strong, readonly) BRCBubbleLayer *bubbleLayer;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, copy) void(^ __nullable animationFinishBlock)(BOOL);
@property (nonatomic, copy) void(^ __nullable onClickCancelButton)(void);

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
