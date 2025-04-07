//
//  BRCBubbleContainerView.m
//  BRCPopUp
//
//  Created by sunzhixiong on 2025/4/6.
//

#import "BRCBubbleContainerView.h"
#import "BRCBubbleLayer.h"

@interface BRCBubbleContainerView ()

@property (nonatomic, strong) UIImageView    *cancelButton;
@property (nonatomic, strong) UIColor        *backgroundBubbleColor;
@property (nonatomic, strong) BRCBubbleLayer *bubbleLayer;
@property (nonatomic, assign) BOOL            isAnimating;

@end

@implementation BRCBubbleContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isAnimating = NO;
        [self.layer addSublayer:self.bubbleLayer];
        [self addSubview:self.cancelButton];
    }
    return self;
}

#pragma mark - display

- (void)show {
    self.bubbleLayer.frame = self.bounds;
    self.isAnimating = NO;
    self.hidden = NO;
}

- (void)hide {
    self.isAnimating = NO;
    self.hidden = YES;
}

- (void)showWithAnimation:(CAAnimation *)animation
          completionBlock:(void (^)(BOOL))completionBlock {
    [self startAnimation:animation isShow:YES completion:completionBlock];
}

- (void)hideWithAnimation:(CAAnimation *)animation
          completionBlock:(void (^)(BOOL))completionBlock {
    [self startAnimation:animation isShow:NO completion:completionBlock];
}

- (void)startAnimation:(CAAnimation *)animation
                isShow:(BOOL)isShow
            completion:(void (^)(BOOL))completion {
    self.bubbleLayer.frame = self.bounds;
    if ([animation isKindOfClass:[CAAnimation class]]) {
        if (self.isAnimating) return;
        self.animationFinishBlock = completion;
        [self.layer removeAllAnimations];
        animation.delegate = self;
        [self.layer addAnimation:animation forKey:@"animations"];
    } else {
        if (isShow) [self show];
        else [self hide];
        if (completion) completion(YES);
    }
}

- (void)setAnchorPointWithAnimationType:(BRCPopUpAnimationType)type {
    CGPoint anchorPoint = CGPointMake(0.5, 0.5);
    CGFloat arrowPosition = [self.bubbleLayer getArrowTopPointPosition:self.bounds.size];
    if (type == BRCPopUpAnimationTypeScale ||
        type == BRCPopUpAnimationTypeFadeScale ||
        type == BRCPopUpAnimationTypeFadeBounce ||
        type == BRCPopUpAnimationTypeBounce) {
        if (self.bubbleLayer.arrowDirection == BRCPopUpDirectionBottom) {
            anchorPoint = CGPointMake((arrowPosition / self.frame.size.width), 1);
        } else if (self.bubbleLayer.arrowDirection == BRCPopUpDirectionTop) {
            anchorPoint = CGPointMake((arrowPosition / self.frame.size.width), 0);
        } else if (self.bubbleLayer.arrowDirection == BRCPopUpDirectionLeft) {
            anchorPoint = CGPointMake(0, (arrowPosition / self.frame.size.height));
        } else if (self.bubbleLayer.arrowDirection == BRCPopUpDirectionRight) {
            anchorPoint = CGPointMake(1, (arrowPosition / self.frame.size.height));
        }
    } else if (type == BRCPopUpAnimationTypeHeightExpansion ||
               type == BRCPopUpAnimationTypeFadeHeightExpansion){
        anchorPoint = CGPointMake(0.5, 0);
    }
    if (anchorPoint.x >= 0 && anchorPoint.x <= 1 &&
        anchorPoint.y >= 0 && anchorPoint.y <= 1) {
        [self setLayerAnchorPoint:anchorPoint];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    self.backgroundBubbleColor = backgroundColor;
    self.bubbleLayer.backgroundColor = self.backgroundBubbleColor.CGColor;
}

- (void)handleClickCancelButton { if (self.onClickCancelButton) self.onClickCancelButton(); }

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    self.isAnimating = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.isAnimating = NO;
    if (self.animationFinishBlock) self.animationFinishBlock(flag);
    self.animationFinishBlock = nil;
}

#pragma mark - theme

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    self.bubbleLayer.backgroundColor = self.backgroundBubbleColor.CGColor;
    self.bubbleLayer.shadowColor = self.shadowColor.CGColor;
}

#pragma mark - props

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    self.layer.shadowColor = shadowColor.CGColor;
}

- (void)setLayerAnchorPoint:(CGPoint)anchorPoint {
    CGRect oldFrame = self.frame;
    [self.layer setAnchorPoint:anchorPoint];
    self.frame = oldFrame;
}

- (BRCBubbleLayer *)bubbleLayer {
    if (!_bubbleLayer) { _bubbleLayer = [[BRCBubbleLayer alloc] init]; }
    return _bubbleLayer;
}

- (UIImageView *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIImageView alloc] init];
        _cancelButton.image = [UIImage systemImageNamed:@"xmark"];
        _cancelButton.tintColor = [UIColor blackColor];
        _cancelButton.userInteractionEnabled = YES;
        _cancelButton.hidden = YES;
        _cancelButton.layer.zPosition = HUGE;
        [_cancelButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClickCancelButton)]];
    }
    return _cancelButton;
}

@end

