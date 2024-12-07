//
//  BRCPopUp.m
//
//  Created by sunzhixiong on 2024/3/15.


#import "BRCPopUper.h"
#import <objc/message.h>

@interface BRCBubbleLayer : CALayer <BRCBubbleStyle>
- (void)updateLayer;
@end

@implementation BRCBubbleLayer

@synthesize arrowSize = _arrowSize;
@synthesize arrowAbsolutePosition = _arrowAbsolutePosition;
@synthesize arrowDirection = _arrowDirection;
@synthesize arrowRelativePosition = _arrowRelativePosition;
@synthesize arrowRadius = _arrowRadius;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cornerRadius = 4;
        _arrowSize = CGSizeMake(16, 8);
        _arrowAbsolutePosition = 12;
        _arrowRelativePosition = -1;
        _arrowRadius = 2;
        _arrowDirection = BRCPopUpDirectionTop;
    }
    return self;
}

#pragma mark - public

- (void)updateLayer { [self setMask:nil]; }

- (CGFloat)getArrowTopPointPosition:(CGSize)size{
    CGFloat arrowRelativePosition = [self getArrowRelativePositionWithSize:size];
    if (self.arrowDirection == BRCPopUpDirectionRight ||
        self.arrowDirection == BRCPopUpDirectionLeft) {
        return size.height * arrowRelativePosition;
    }
    return size.width * arrowRelativePosition;
}

#pragma mark - drawBubble

- (NSMutableArray *)bubblePointsWithSize:(CGSize)size {
    NSMutableArray *points = [NSMutableArray array];
    CGPoint beginPoint, topPoint, endPoint;
    CGFloat x = 0, y = 0;
    CGFloat width = size.width, height = size.height;
    CGFloat arrowHeight = self.arrowSize.height;
    CGFloat arrowWidth = self.arrowSize.width;
    CGFloat topPointPoisition = [self getArrowTopPointPosition:size];
    
    if (self.arrowDirection == BRCPopUpDirectionRight) {
        topPoint = CGPointMake(size.width , topPointPoisition);
        beginPoint = CGPointMake(topPoint.x - arrowHeight, topPoint.y - arrowWidth/2);
        endPoint = CGPointMake(beginPoint.x, beginPoint.y + arrowWidth);
    } else if (self.arrowDirection == BRCPopUpDirectionLeft) {
        topPoint = CGPointMake(0, topPointPoisition);
        beginPoint = CGPointMake(topPoint.x + arrowHeight, topPoint.y + arrowWidth/2);
        endPoint = CGPointMake(beginPoint.x, beginPoint.y - arrowWidth);
        x = arrowHeight;
    } else if (self.arrowDirection == BRCPopUpDirectionBottom) {
        topPoint = CGPointMake(topPointPoisition, size.height);
        beginPoint = CGPointMake(topPoint.x + arrowWidth/2, topPoint.y - arrowHeight);
        endPoint = CGPointMake(beginPoint.x - arrowWidth, beginPoint.y);
    } else {
        topPoint = CGPointMake(topPointPoisition, 0);
        beginPoint = CGPointMake(topPoint.x - arrowWidth/2, topPoint.y + arrowHeight);
        endPoint = CGPointMake(beginPoint.x + arrowWidth, beginPoint.y);
        y = arrowHeight;
    }
    
    if (self.arrowDirection == BRCPopUpDirectionRight ||
        self.arrowDirection == BRCPopUpDirectionLeft) {
        width -= arrowHeight;
    } else {
        height -= arrowHeight;
    }
    
    points = @[
        [NSValue valueWithCGPoint:beginPoint],
        [NSValue valueWithCGPoint:topPoint],
        [NSValue valueWithCGPoint:endPoint]
    ].mutableCopy;
    
    NSMutableArray *rectPoints = @[
        [NSValue valueWithCGPoint:CGPointMake(x + width, y + height)],
        [NSValue valueWithCGPoint:CGPointMake(x, y + height)],
        [NSValue valueWithCGPoint:CGPointMake(x, y)],
        [NSValue valueWithCGPoint:CGPointMake(x + width, y)]
    ].mutableCopy;
    
    int rectPointIndex = (int)self.arrowDirection;
    for(NSInteger i = 0; i < 4; i++) {
        [points addObject:[rectPoints objectAtIndex:rectPointIndex]];
        rectPointIndex = (rectPointIndex+1) % 4;
    }
    return points;
}

- (CGPathRef)bubblePathWithSize:(CGSize)size {
    if (size.width == 0 || size.height == 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSMutableArray *points = [self bubblePointsWithSize:size];
    CGPoint currentPoint = [[points objectAtIndex:6] CGPointValue];
    CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
    CGPoint pointA, pointB;
    CGFloat radius;
    int count = 0;
    while(count < 7) {
        radius = count < 3 ?  self.arrowRadius : self.cornerRadius;
        pointA = [[points objectAtIndex:count] CGPointValue];
        pointB = [[points objectAtIndex:(count+1) % 7] CGPointValue];
        CGContextAddArcToPoint(context, pointA.x, pointA.y, pointB.x, pointB.y, radius);
        count = count + 1;
    }
    CGContextClosePath(context);
    CGPathRef path = CGContextCopyPath(context);
    UIGraphicsEndImageContext();
    return path;
}

#pragma mark - setter

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (!CGRectEqualToRect(frame, CGRectZero)) [self setMask:nil];
}

- (void)setMask:(__kindof CALayer *)mask {
    CAShapeLayer *bubbleLayer = [CAShapeLayer layer];
    bubbleLayer.path = [self bubblePathWithSize:self.bounds.size];
    [super setMask:bubbleLayer];
}

#pragma mark - getter

- (CGFloat)arrowRelativePosition {
    return [self getArrowRelativePositionWithSize:self.bounds.size];
}

- (CGFloat)getArrowRelativePositionWithSize:(CGSize)size {
    if (_arrowRelativePosition > 0) return _arrowRelativePosition;
    CGFloat boundSize = 0;
    if (self.arrowDirection == BRCPopUpDirectionTop ||
        self.arrowDirection == BRCPopUpDirectionBottom) {
        boundSize = size.width;
    } else {
        boundSize = size.height;
    }
    if (_arrowAbsolutePosition > 0) return _arrowAbsolutePosition / boundSize;
    return (boundSize + _arrowAbsolutePosition) / boundSize;
}

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

@interface BRCBubbleContainerView ()

@property (nonatomic, strong) UIImageView    *cancelButton;
@property (nonatomic, strong) UIColor        *backgroundBubbleColor;
@property (nonatomic, strong) BRCBubbleLayer *bubbleLayer;
@property (nonatomic, assign) BOOL            isAnimating;
@property (nonatomic, copy) void(^ __nullable animationFinishBlock)(BOOL);
@property (nonatomic, copy) void(^ __nullable onClickCancelButton)(void);


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


@interface BRCPopUper ()

@property (nonatomic, assign) BOOL                      display;
@property (nonatomic, strong) UIControl                 *backgroundDismissView;
@property (nonatomic, strong) BRCBubbleContainerView    *containerView;
@property (nonatomic, strong) CADisplayLink             *displayLink;
@property (nonatomic, strong) UIView                    *superView;
@property (nonatomic, assign, readonly) BOOL            isDirectionHorizontal;
@property (nonatomic, assign, readonly) CGFloat         sildeAnchorViewSize;
@property (nonatomic, assign, readonly) CGFloat         sildeContainerViewSize;
@property (nonatomic, assign, readonly) UIEdgeInsets    bubbleContentInsets;

@end

@implementation BRCPopUper

@synthesize arrowSize = _arrowSize;
@synthesize arrowAbsolutePosition = _arrowAbsolutePosition;
@synthesize arrowDirection = _arrowDirection;
@synthesize arrowRelativePosition = _arrowRelativePosition;
@synthesize arrowRadius = _arrowRadius;

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) { [self commonInit]; }
    return self;
}

- (instancetype)initWithContentStyle:(BRCPopUpContentStyle)contentStyle {
    self = [super init];
    if (self) {
        [self commonInit];
        _contentStyle = contentStyle;
    }
    return self;
}

- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super init];
    if (self) {
        [self commonInit];
        _contentStyle = BRCPopUpContentStyleCustom;
        _contentView = contentView;
    }
    return self;
}

- (void)commonInit {
    _hideAfterDelayDuration = -1;
    _offsetToAnchorView = 0;
    _contentStyle = BRCPopUpContentStyleCustom;
    _popUpDirection = BRCPopUpDirectionBottom;
    _cornerRadius = 4;
    
    _webImageLoadBlock = nil;
    _marginToAnchorView = 5;
    _shadowOpacity = 1.0;
    _popUpAnimationDuration = 0.2;
    
    _dismissMode = BRCPopUpDismissModeInteractive;
    _contextStyle = BRCPopUpContextStyleViewController;
    _popUpAnimationType = BRCPopUpAnimationTypeFadeBounce;
    _contentAlignment = BRCPopUpContentAlignmentCenter;
    
    _autoFitContainerSize = YES;
    _arrowCenterAlignToAnchor = YES;
    
    _backgroundColor = [UIColor systemGray6Color];
    _shadowColor = [[UIColor grayColor] colorWithAlphaComponent:0];
    
    _containerSize = CGSizeZero;
    _shadowOffset = CGSizeZero;
    _shadowRadius = 0;
    
    _cancelButtonRelativePosition = CGPointZero;
    _cancelButtonAbsoultePosition = CGPointZero;
    _cancelButtonFrame = CGRectZero;
    _arrowSize = CGSizeMake(16, 8);
    _arrowAbsolutePosition = 12;
    _arrowRelativePosition = -1;
    _arrowRadius = 2;
    _bubbleAnchorPoint = CGPointZero;
    
    _contentInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _contextWindow = nil;
}

#pragma mark - view monitoring

- (void)dealloc { [self stopMonitoring]; }

- (void)stopMonitoring { self.displayLink.paused = YES; }

- (void)startMonitoring {
    if ([self.popUpSuperView isKindOfClass:[UIScrollView class]]) return;
    if (self.dismissMode != BRCPopUpDismissModeInteractive) self.displayLink.paused = NO;
}

- (void)checkFrame {
    if (!self.anchorView) return;
    self.containerView.frame = [self containerFrame];
}

#pragma mark - public method

#pragma mark - show

- (void)show {
    [self showAndHideAfter:-1];
}

- (void)showAndHideAfter:(NSTimeInterval)duration {
    [self showWithAnimationType:self.popUpAnimationType hideAfter:duration];
}

- (void)showWithAnimationType:(BRCPopUpAnimationType)animationType {
    [self showWithAnimationType:animationType hideAfter:-1];
}

- (void)showWithAnimationType:(BRCPopUpAnimationType)animationType hideAfter:(NSTimeInterval)duration {
    self.popUpAnimationType = animationType;
    [self showWithAnimation:[self animationWithIsShow:YES] hideAfter:duration];
}

- (void)showWithAnimation:(CAAnimation *)animation {
    [self showWithAnimation:animation hideAfter:-1];
}

- (void)showWithAnchorView:(UIView *)anchorView {
    [self showWithAnchorView:anchorView hideAfter:-1];
}

- (void)showWithAnchorView:(UIView *)anchorView hideAfter:(NSTimeInterval)duration {
    [self showWithAnchorView:anchorView withAnimationType:self.popUpAnimationType hideAfter:duration];
}

- (void)showWithAnchorView:(UIView *)anchorView withAnimationType:(BRCPopUpAnimationType)animationType {
    [self showWithAnchorView:anchorView withAnimationType:animationType hideAfter:-1];
}

- (void)showWithAnchorView:(UIView *)anchorView withAnimationType:(BRCPopUpAnimationType)animationType hideAfter:(NSTimeInterval)duration {
    self.popUpAnimationType = animationType;
    [self showWithAnchorView:anchorView withAnimation:[self animationWithIsShow:YES] hideAfter:duration];
}

- (void)showWithAnchorView:(UIView *)anchorView withAnimation:(CAAnimation *)animation {
    [self showWithAnchorView:anchorView withAnimation:animation hideAfter:-1];
}

- (void)showWithAnchorView:(UIView *)anchorView withAnimation:(CAAnimation *)animation hideAfter:(NSTimeInterval)duration {
    self.anchorView = anchorView;
    [self showWithAnimation:animation hideAfter:duration];
}

- (void)showWithAnchorFrame:(CGRect)anchorFrame {
    [self showWithAnchorFrame:anchorFrame hideAfter:-1];
}

- (void)showWithAnchorFrame:(CGRect)anchorFrame hideAfter:(NSTimeInterval)duration {
    [self showWithAnchorFrame:anchorFrame withAnimationType:self.popUpAnimationType hideAfter:duration];
}

- (void)showWithAnchorFrame:(CGRect)anchorFrame withAnimationType:(BRCPopUpAnimationType)animationType {
    [self showWithAnchorFrame:anchorFrame withAnimationType:animationType hideAfter:-1];
}

- (void)showWithAnchorFrame:(CGRect)anchorFrame withAnimationType:(BRCPopUpAnimationType)animationType hideAfter:(NSTimeInterval)duration {
    self.popUpAnimationType = animationType;
    [self showWithAnchorFrame:anchorFrame withAnimation:[self animationWithIsShow:YES] hideAfter:duration];
}

- (void)showWithAnchorFrame:(CGRect)anchorFrame withAnimation:(CAAnimation *)animation {
    [self showWithAnchorFrame:anchorFrame withAnimation:animation hideAfter:-1];
}

- (void)showWithAnchorFrame:(CGRect)anchorFrame withAnimation:(CAAnimation *)animation hideAfter:(NSTimeInterval)duration {
    self.anchorFrame = anchorFrame;
    [self showWithAnimation:animation hideAfter:duration];
}

/// `CoreMethod`
- (void)showWithAnimation:(CAAnimation *)animation hideAfter:(NSTimeInterval)duration {
    if ((![self.anchorView isKindOfClass:[UIView class]]) ||
        self.display) {
        return;
    }
    [self startMonitoring];
    CAAnimation *popUpAnimation = [animation isKindOfClass:[CAAnimation class]] ? animation : self.popUpAnimation;
    [self showContainerViewWithAnimation:popUpAnimation];
    if (duration > 0 || self.hideAfterDelayDuration > 0) {
        CGFloat hideDelay = duration > 0 ? duration : self.hideAfterDelayDuration;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hide];
        });
    }
}

#pragma mark - hide

- (void)hide { [self hideWithAnimated:YES]; }

- (void)hideWithAnimated:(BOOL)isAnimated {
    if (self.display == NO) {
        self.anchorView = nil;
        return;
    }
    [self stopMonitoring];
    [self dimissContainerView:isAnimated];
}

#pragma mark - toggle

- (void)toggleDisplay {
    if (self.display) [self hide];
    else [self show];
}

#pragma mark - fit

- (void)sizeThatFits:(CGSize)size {
    [self _sizeThatFits:size isFromInside:NO];
}

#pragma mark - private

- (void)dismissView {
    [self stopMonitoring];
    [self dimissContainerView:YES];
    [self sendDelegateEventWithSEL:@selector(didUserDismissPopUper:withAchorView:)];
}

- (void)showContainerViewWithAnimation:(CAAnimation *)animation{
    if ([self.anchorView isKindOfClass:[UIView class]]) {
        [self sendDelegateEventWithSEL:@selector(willShowPopUper:withAchorView:)];
        [self updateContainerViewWithPopupFrame];
        UIView *superView = self.popUpSuperView;
        if (self.dismissMode == BRCPopUpDismissModeInteractive) {
            UIView *fullScreenView = [self findNearestFullScreenView];
            if ([self canAddSubView:self.backgroundDismissView toView:fullScreenView]) {
                [fullScreenView insertSubview:self.backgroundDismissView aboveSubview:self.popUpSuperView];
                superView = self.backgroundDismissView;
            }
        }
        [superView addSubview:self.containerView];
        self.containerView.frame = [self containerFrame];
        [self updateCancelButtonFrame];
        if ([self canAddSubView:self.contentView toView:self.containerView]) {
            [self.containerView addSubview:self.contentView];
            [self addEdgeConstraintsFromView:self.containerView toView:self.contentView needEdgeInsets:YES];
        }
        [self updateStyleBeforeShow];
        [self.containerView showWithAnimation:animation completionBlock:^(BOOL finished) {
            self.display = YES;
            [self sendDelegateEventWithSEL:@selector(didShowPopUper:withAchorView:)];
            if ([self isHeightAnimationType]) {
                self.contentView.alpha = 1;
            }
        }];
    }
}

- (void)finishDismissContainerView {
    [self sendDelegateEventWithSEL:@selector(didHidePopUper:withAchorView:)];
    [self.rootView removeFromSuperview];
    self.display = NO;
    self.anchorView = nil; // 防止强持有导致的内存泄漏
}

- (void)dimissContainerView:(BOOL)isAnimated {
    [self sendDelegateEventWithSEL:@selector(willHidePopUper:withAchorView:)];
    [self updateBubbleLayerAnchorPoint];
    CAAnimation *animation = [self animationWithIsShow:NO];
    [self.containerView hideWithAnimation:animation completionBlock:nil];
    if (self.popUpAnimationType == BRCPopUpAnimationTypeNone || isAnimated == NO) {
        [self finishDismissContainerView];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.popUpAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self finishDismissContainerView];
        });
    }
}

- (void)updateStyleBeforeShow {
    self.containerView.backgroundColor = self.backgroundColor;
    self.containerView.shadowColor = self.shadowColor;
    self.containerView.layer.shadowOffset = self.shadowOffset;
    self.containerView.layer.shadowRadius = self.shadowRadius;
    self.containerView.layer.shadowOpacity = self.shadowOpacity;
    self.containerView.bubbleLayer.cornerRadius = self.cornerRadius;
    self.containerView.bubbleLayer.arrowDirection = self.arrowDirection;
    self.containerView.bubbleLayer.arrowSize = self.arrowSize;
    self.containerView.bubbleLayer.arrowRadius = self.arrowRadius;
    self.containerView.bubbleLayer.arrowAbsolutePosition = self.arrowAbsolutePosition;
    self.containerView.bubbleLayer.arrowRelativePosition = self.arrowRelativePosition;
    [self updateBubbleLayerAnchorPoint];
    if ([self isHeightAnimationType]) {
        self.contentView.alpha = 0;
    }
}

- (void)updateBubbleLayerAnchorPoint {
    if (!CGPointEqualToPoint(self.bubbleAnchorPoint, CGPointZero)) {
        [self.containerView.layer setAnchorPoint:self.bubbleAnchorPoint];
    } else {
        [self.containerView setAnchorPointWithAnimationType:self.popUpAnimationType];
    }
    [self.containerView.bubbleLayer updateLayer];
}

- (void)updateCancelButtonFrame {
    if (!self.showCancelButton) return;
    if (!CGRectEqualToRect(self.cancelButtonFrame, CGRectZero)) {
        self.containerView.cancelButton.frame = self.cancelButtonFrame;
        return;
    }
    UIEdgeInsets bubbleContentInsets = self.bubbleContentInsets;
    CGFloat min_x = bubbleContentInsets.left,min_y = bubbleContentInsets.top,button_x = min_x,button_y = min_y,button_w = self.cancelButtonSize.width,button_h = self.cancelButtonSize.height;
    CGFloat max_width = self.containerView.frame.size.width - bubbleContentInsets.left - bubbleContentInsets.right ,max_height = self.containerView.frame.size.height - bubbleContentInsets.top - bubbleContentInsets.bottom;
    if (!CGPointEqualToPoint(self.cancelButtonAbsoultePosition, CGPointZero)) {
        CGFloat absoultePosition_x = self.cancelButtonAbsoultePosition.x;
        CGFloat absoultePosition_y = self.cancelButtonAbsoultePosition.y;
        if (absoultePosition_x < 0) { absoultePosition_x =  max_width + absoultePosition_x; button_x -= button_w; }
        if (absoultePosition_y < 0) { absoultePosition_y =  max_height + absoultePosition_y; button_y -= button_h; }
        button_x += absoultePosition_x;
        button_y += absoultePosition_y;
    } else {
        CGFloat relativePosition_x = self.cancelButtonRelativePosition.x;
        CGFloat relativePosition_y = self.cancelButtonRelativePosition.y;
        if (relativePosition_x < 0) { relativePosition_x = 1 + relativePosition_x; button_x -= (button_w); } else { button_x -= (button_w) / 2;  }
        if (relativePosition_y < 0) { relativePosition_y = 1 + relativePosition_y; button_y -= (button_h); } else { button_y -= (button_h / 2);  }
        button_x += relativePosition_x * max_width;
        button_y += relativePosition_y * max_height;
    }
    self.containerView.cancelButton.frame = CGRectMake(button_x, button_y, button_w, button_h);
}

- (void)_sizeThatFits:(CGSize)size isFromInside:(BOOL)isFromInside{
    if ([self.contentLabel isKindOfClass:[UILabel class]]) {
        CGSize labelFitSize = [self.contentLabel sizeThatFits:size];
        CGFloat containerWidth = labelFitSize.width + self.contentInsets.left + self.contentInsets.right;
        CGFloat containerHeight = labelFitSize.height + self.contentInsets.top + self.contentInsets.bottom;
        if ([self isDirectionHorizontal]) {
            containerHeight += self.arrowSize.height;
        } else {
            containerWidth += self.arrowSize.width;
        }
        if (isFromInside) {
            _containerSize = CGSizeMake(containerWidth, containerHeight);
        } else {
            self.containerSize = CGSizeMake(containerWidth, containerHeight);
        }
    } else if ([self.contentView respondsToSelector:@selector(sizeThatFits:)]) {
        [self.contentView sizeThatFits:size];
    }
}

#pragma mark - setter & getter

- (CGRect)getHorizontalDirectionFrame {
    CGRect popUpContextViewFrame = [self popUpContextViewFrame];
    CGFloat frameX = self.anchorViewLeft,frameY = 0,containerHeight = self.containerHeight,containerWidth = self.containerWidth;
    BOOL isDirectionTop = self.popUpDirection == BRCPopUpDirectionTop;
    if (isDirectionTop) {
        frameY = self.anchorViewTop - self.containerHeight - self.marginToAnchorView;
    } else {
        frameY = self.anchorViewBottom + self.marginToAnchorView;
    }
    if (self.autoCutoffRelief) {
        if (isDirectionTop) {
            if (frameY < CGRectGetMinY(popUpContextViewFrame)) {
                frameY = CGRectGetMinY(popUpContextViewFrame);
                containerHeight = self.anchorViewTop - CGRectGetMinY(popUpContextViewFrame);
            }
        } else {
            if (frameY + containerHeight > CGRectGetMaxY(popUpContextViewFrame)) {
                containerHeight = CGRectGetMaxY(popUpContextViewFrame) - frameY;
            }
        }
        if (self.contentAlignment == BRCPopUpContentAlignmentLeft) {
            if (frameX + containerWidth > CGRectGetMaxX(popUpContextViewFrame)) {
                containerWidth = CGRectGetMaxX(popUpContextViewFrame) - frameX;
            }
        } else if (self.contentAlignment == BRCPopUpContentAlignmentRight){
            frameX = self.anchorViewRight;
            if (frameX - containerWidth < CGRectGetMinX(popUpContextViewFrame)) {
                containerWidth = frameX - CGRectGetMinX(popUpContextViewFrame);
            }
        }
    }
    return CGRectMake(frameX, frameY, containerWidth, containerHeight);
}

- (CGRect)getVerticalDirectionFrame {
    CGRect popUpContextViewFrame = [self popUpContextViewFrame];
    CGFloat frameX = 0,frameY = self.anchorViewTop,containerHeight = self.containerHeight,containerWidth = self.containerWidth;
    BOOL isDirectionLeft = self.popUpDirection == BRCPopUpDirectionLeft;
    if (isDirectionLeft) {
        frameX = self.anchorViewLeft - containerWidth - self.marginToAnchorView;
    } else {
        frameX = self.anchorViewRight + self.marginToAnchorView;
    }
    if (self.autoCutoffRelief) {
        if (isDirectionLeft) {
            if (frameX < CGRectGetMinX(popUpContextViewFrame)) {
                frameX = CGRectGetMinX(popUpContextViewFrame);
                containerWidth = self.anchorViewLeft - CGRectGetMinX(popUpContextViewFrame) - self.marginToAnchorView;
            }
        } else {
            if (frameX + containerWidth > CGRectGetMaxX(popUpContextViewFrame)) {
                containerWidth = CGRectGetMaxX(popUpContextViewFrame) - frameX;
            }
        }
        
        if (self.contentAlignment == BRCPopUpContentAlignmentLeft) {
            if (frameY + containerHeight > CGRectGetMaxY(popUpContextViewFrame)) {
                containerHeight = CGRectGetMaxY(popUpContextViewFrame) - frameY;
            }
        } else if (self.contentAlignment == BRCPopUpContentAlignmentRight){
            frameY = self.anchorViewBottom;
            if (frameY - containerHeight < CGRectGetMinY(popUpContextViewFrame)) {
                containerHeight = frameY - CGRectGetMinY(popUpContextViewFrame);
            }
        }
    }
    return CGRectMake(frameX, frameY, containerWidth, containerHeight);
}

- (CGRect)containerFrame {
    CGRect frame = self.isDirectionHorizontal ?  [self getHorizontalDirectionFrame] : [self getVerticalDirectionFrame];
    CGPoint origin = frame.origin;
    if (self.contentAlignment == BRCPopUpContentAlignmentCenter) {
        CGPoint centerPoint = CGPointMake([self anchorViewCenterX], [self anchorViewCenterY]);
        if (self.isDirectionHorizontal) {
            origin.x = centerPoint.x - (frame.size.width / 2);
        } else {
            origin.y = centerPoint.y - (frame.size.height / 2);
        }
    } else if (self.contentAlignment == BRCPopUpContentAlignmentRight) {
        if (self.isDirectionHorizontal) {
            origin.x = self.anchorViewRight - frame.size.width;
        } else {
            origin.y = self.anchorViewBottom - frame.size.height;
        }
    }
    frame = CGRectMake(origin.x, origin.y, frame.size.width, frame.size.height);
    if (self.isDirectionHorizontal) {
        frame = CGRectOffset(frame, self.offsetToAnchorView, 0);
    } else {
        frame = CGRectOffset(frame, 0, self.offsetToAnchorView);
    }
    return frame;
}

- (void)updateContainerViewWithPopupFrame {
    CGFloat containerWidth = self.containerSize.width;
    CGFloat containerHeight = self.containerSize.height;
    if (self.autoFitContainerSize) {
        _containerSize = CGSizeMake(self.sildeAnchorViewSize, self.sildeAnchorViewSize);
        CGSize fitSize = self.isDirectionHorizontal ? CGSizeMake(self.sildeAnchorViewSize, HUGE) : CGSizeMake(HUGE, self.sildeAnchorViewSize);
        [self _sizeThatFits:fitSize isFromInside:YES];
    } else {
        if (containerWidth == 0) { containerWidth = self.sildeAnchorViewSize; }
        if (containerHeight == 0) { containerHeight = self.sildeAnchorViewSize; }
        _containerSize = CGSizeMake(containerWidth, containerHeight);
    }
}

#pragma mark - setter

- (void)setCancelImage:(UIImage *)cancelImage {
    _cancelImage = cancelImage;
    self.containerView.cancelButton.image = cancelImage;
}

- (void)setCancelTintColor:(UIColor *)cancelTintColor {
    _cancelTintColor = cancelTintColor;
    self.containerView.cancelButton.tintColor = cancelTintColor;
}

- (void)setShowCancelButton:(BOOL)isShowCancelImage {
    _showCancelButton = isShowCancelImage;
    self.containerView.cancelButton.hidden = !isShowCancelImage;
}

- (void)setContainerSize:(CGSize)containerSize {
    _containerSize = containerSize;
    self.containerHeight = containerSize.height;
    self.containerWidth = containerSize.width;
    if (!CGSizeEqualToSize(containerSize, CGSizeZero)) {
        self.autoFitContainerSize = NO;
    }
}

- (void)setContainerHeight:(CGFloat)containerHeight {
    CGSize originSize = self.containerSize;
    _containerSize = CGSizeMake(originSize.width, containerHeight);
}

- (void)setContainerWidth:(CGFloat)containerWidth {
    CGSize originSize = self.containerSize;
    _containerSize = CGSizeMake(containerWidth, originSize.height);
}

- (void)setAnchorFrame:(CGRect)anchorFrame {
    _anchorFrame = anchorFrame;
    if (![self.anchorView isKindOfClass:[UIView class]]) self.anchorView = [UIView new];
    self.anchorView.frame = anchorFrame;
}

- (void)setPopUpSuperView:(UIView *)popUpSuperView {
    if (![popUpSuperView isKindOfClass:[UIView class]]) return;
    _superView = popUpSuperView;
    self.contextStyle = BRCPopUpContextStyleCustom;
}

#pragma mark - getter


- (CGFloat)containerHeight { return _containerSize.height; }

- (CGFloat)containerWidth { return _containerSize.width; }

- (BOOL)isHeightAnimationType {
    return self.popUpAnimationType == BRCPopUpAnimationTypeHeightExpansion ||
    self.popUpAnimationType == BRCPopUpAnimationTypeFadeHeightExpansion;
}

- (BRCPopUpDirection)arrowDirection {
    if (self.popUpDirection == BRCPopUpDirectionTop) {
        return BRCPopUpDirectionBottom;
    } else if (self.popUpDirection == BRCPopUpDirectionBottom) {
        return BRCPopUpDirectionTop;
    } else if (self.popUpDirection == BRCPopUpDirectionRight) {
        return BRCPopUpDirectionLeft;
    } else {
        return BRCPopUpDirectionRight;
    }
}

- (UIEdgeInsets)bubbleContentInsets {
    CGFloat top = self.arrowDirection == BRCPopUpDirectionTop ? self.arrowSize.height : 0,
    left = self.arrowDirection == BRCPopUpDirectionRight ? self.arrowSize.width : 0,
    bottom = self.arrowDirection == BRCPopUpDirectionBottom ? self.arrowSize.height : 0,
    right = self.arrowDirection == BRCPopUpDirectionLeft ? self.arrowSize.width : 0;
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (UIEdgeInsets)contentInsets {
    return UIEdgeInsetsMake(_contentInsets.top + self.bubbleContentInsets.top, _contentInsets.left + self.bubbleContentInsets.left, _contentInsets.bottom + self.bubbleContentInsets.bottom,_contentInsets.right + self.bubbleContentInsets.right);
}

- (UIImageView *)contentImageView {
    if ([self.contentView isKindOfClass:[UIImageView class]]) return (UIImageView *)self.contentView;
    return nil;
}

- (UILabel *)contentLabel {
    if ([self.contentView isKindOfClass:[UILabel class]]) return (UILabel *)self.contentView;
    return nil;
}

- (CGFloat)arrowAbsolutePosition {
    CGFloat position = _arrowAbsolutePosition;
    if (self.arrowCenterAlignToAnchor) {
        CGFloat anchorSize = self.sildeAnchorViewSize;
        CGFloat containerSize = self.sildeContainerViewSize;
        position = anchorSize / 2;
        if (self.contentAlignment == BRCPopUpContentAlignmentRight){
            position = -position - self.offsetToAnchorView;
        } else if (self.contentAlignment == BRCPopUpContentAlignmentLeft){
            position = position - self.offsetToAnchorView;
        }
        if (position > containerSize) {
            position = containerSize / 2;
        }
        if (fabs(position - 0) < 5) {
            position = 5;
        }
    }
    return position;
}

- (CGFloat)arrowRelativePosition {
    if (self.contentAlignment == BRCPopUpContentAlignmentCenter &&
        self.arrowCenterAlignToAnchor) {
        return 0.5;
    }
    return _arrowRelativePosition;
}

- (CGFloat)anchorViewLeft { return CGRectGetMinX(self.anchorViewFrame);}

- (CGFloat)anchorViewRight { return CGRectGetMaxX(self.anchorViewFrame);}

- (CGFloat)anchorViewTop { return CGRectGetMinY(self.anchorViewFrame);}

- (CGFloat)anchorViewBottom { return CGRectGetMaxY(self.anchorViewFrame); }

- (CGFloat)anchorViewCenterX { return CGRectGetMidX(self.anchorViewFrame); }

- (CGFloat)anchorViewCenterY { return CGRectGetMidY(self.anchorViewFrame);}

- (CGRect)anchorViewFrame { return [self getFrameForView:self.anchorView inView:self.dismissMode == BRCPopUpDismissModeNone ? self.popUpSuperView : self.backgroundDismissView];}

- (CGRect)popUpContextViewFrame {
    UIView *popUpContextView = self.popUpSuperView;
    if ([self.popUpSuperView isKindOfClass:[UIScrollView class]]) {
        CGSize contentSize = [(UIScrollView *)self.popUpSuperView contentSize];
        return CGRectMake(popUpContextView.frame.origin.x, popUpContextView.frame.origin.y,
                          MAX(popUpContextView.frame.size.width, contentSize.width),
                          MAX(popUpContextView.frame.size.height, contentSize.height));
    }
    return popUpContextView.frame;
}

- (BOOL)autoFitContainerSize {
    if (CGSizeEqualToSize(self.containerSize, CGSizeZero))  return YES;
    return _autoFitContainerSize;
}

- (BOOL)isAnchorViewInTabBarOrNavigationBar {
    if (![self.anchorView isKindOfClass:[UIView class]]) return NO;
    if ([self.anchorView isKindOfClass:NSClassFromString(@"_UIButtonBarButton")]) return YES;
    if ([self isInClassViewWithClassName:@"UINavigationBar" withView:self.anchorView] ||
        [self isInClassViewWithClassName:@"UITabBar" withView:self.anchorView]) {
        return YES;
    }
    return NO;
}

- (BOOL)isDirectionHorizontal {
    return
    self.popUpDirection == BRCPopUpDirectionTop ||
    self.popUpDirection == BRCPopUpDirectionBottom;
}

- (CGFloat)sildeAnchorViewSize {
    return [self getSildeViewSizeWithView:self.anchorView];
}

- (CGFloat)sildeContainerViewSize {
    return [self getSildeViewSizeWithView:self.containerView];
}

- (CGFloat)getSildeViewSizeWithView:(UIView *)view {
    if ([view isKindOfClass:[UIView class]]) {
        return self.isDirectionHorizontal ? view.frame.size.width : view.frame.size.height;
    }
    return 0;
}

- (UIView *)rootView {
    return self.dismissMode == BRCPopUpDismissModeInteractive ? self.backgroundDismissView : self.containerView;
}

- (UIWindow *)contextWindow {
    if ([_contextWindow isKindOfClass:[UIWindow class]]) return _contextWindow;
    return [UIApplication sharedApplication].delegate.window;
}

- (UIView *)popUpSuperView {
    UIView *finalSuperView = nil;
    if (self.contextStyle == BRCPopUpContextStyleCustom) {
        finalSuperView = self.superView;
    } else if ([self.anchorView isKindOfClass:[UIView class]]) {
        if (self.contextStyle == BRCPopUpContextStyleSuperScrollView) {
            UIScrollView *scrollView = [self findNearestAnchorSuperScrollView];
            if ([scrollView isKindOfClass:[UIScrollView class]]) finalSuperView = scrollView;
        } else if (self.contextStyle == BRCPopUpContextStyleViewController) {
            UIViewController *anchorVC = [self findViewControllerForView:self.anchorView];
            if ([anchorVC isKindOfClass:[UIViewController class]])  finalSuperView = anchorVC.view;
        } else if (self.contextStyle == BRCPopUpContextStyleSuperView){
            if ([self.anchorView.superview isKindOfClass:[UIView class]]) finalSuperView = self.anchorView.superview;
        } else if (self.contextStyle == BRCPopUpContextStyleWindow) {
            finalSuperView = self.contextWindow;
        }
    }
    if (![finalSuperView isKindOfClass:[UIView class]]) finalSuperView = self.contextWindow;
    return finalSuperView;
}

#pragma mark - animations

- (CAKeyframeAnimation *)createKeyFrameAnimationWithKeyPath:(NSString *)keyPath
                                                   duration:(CGFloat)duration{
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    if (duration != -1) {
        keyFrameAnimation.duration = duration;
        keyFrameAnimation.removedOnCompletion = NO;
        keyFrameAnimation.fillMode = kCAFillModeForwards;
    }
    return keyFrameAnimation;
}

- (NSString *)animationKeyPath {
    switch (self.popUpAnimationType) {
        case BRCPopUpAnimationTypeFade:
            return @"opacity";
        case BRCPopUpAnimationTypeScale:
        case BRCPopUpAnimationTypeFadeScale:
            return @"transform.scale";
        case BRCPopUpAnimationTypeBounce:
        case BRCPopUpAnimationTypeFadeBounce:
            return @"transform.scale";
        case BRCPopUpAnimationTypeFadeHeightExpansion:
        case BRCPopUpAnimationTypeHeightExpansion:
            return @"transform.scale.y";
        default:
            return nil;
    }
}

- (NSArray *)animationValuesWithIsShow:(BOOL)isShow{
    return isShow == 0 ? @[@1,@0] : @[@0,@1];
}

- (CAAnimation *)animationWithIsShow:(BOOL)isShow{
    if (self.popUpAnimationType == BRCPopUpAnimationTypeNone) return nil;
    if (self.popUpAnimationType == BRCPopUpAnimationTypeFadeScale ||
        self.popUpAnimationType == BRCPopUpAnimationTypeFadeBounce ||
        self.popUpAnimationType == BRCPopUpAnimationTypeFadeHeightExpansion) {
        CAKeyframeAnimation *fadeAnimation = [self createKeyFrameAnimationWithKeyPath:@"opacity" duration:-1];
        fadeAnimation.values = [self animationValuesWithIsShow:isShow];
        CAKeyframeAnimation *otherAnimation = [self createKeyFrameAnimationWithKeyPath:[self animationKeyPath] duration:-1];
        if (self.popUpAnimationType == BRCPopUpAnimationTypeFadeBounce && isShow) {
            otherAnimation.values =  @[@0.6,@1.1,@1.0];
        } else {
            otherAnimation.values = [self animationValuesWithIsShow:isShow];
        }
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.animations = @[fadeAnimation,otherAnimation];
        groupAnimation.fillMode = kCAFillModeForwards;
        groupAnimation.removedOnCompletion = NO;
        groupAnimation.duration = self.popUpAnimationDuration;
        return groupAnimation;
    }
    CAKeyframeAnimation *animation = [self createKeyFrameAnimationWithKeyPath:[self animationKeyPath] duration:self.popUpAnimationDuration];
    animation.values = [self animationValuesWithIsShow:isShow];
    return animation;
}

#pragma mark - utils

- (CGRect)getFrameForView:(UIView *)view inView:(UIView *)inView {
    return [view convertRect:view.bounds toView:inView];
}

- (BOOL)canAddSubView:(UIView *)subView toView:(UIView *)superView {
    if ([subView isKindOfClass:[UIView class]] &&
        [superView isKindOfClass:[UIView class]] &&
        ![superView.subviews containsObject:subView]) {
        return YES;
    }
    return NO;
}

- (UIView *)findNearestFullScreenView {
    for (UIView *view = self.popUpSuperView.superview; view; view = view.superview) {
        if (CGSizeEqualToSize(view.frame.size, UIScreen.mainScreen.bounds.size))  return view;
    }
    return self.popUpSuperView;
}

- (UIScrollView *)findNearestAnchorSuperScrollView {
    for (UIView *view = self.anchorView.superview; view; view = view.superview) {
        if ([view isKindOfClass:[UIScrollView class]]) return (UIScrollView *)view;
    }
    return nil;
}

- (UIViewController *)findViewControllerForView:(UIView *)originView {
    for (UIView *view = originView; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) return (UIViewController *)nextResponder;
    }
    return nil;
}

- (BOOL)isInClassViewWithClassName:(NSString *)className withView:(UIView *)view {
    if (![className isKindOfClass:[NSString class]]) return NO;
    UIView *currentView = view;
    while (currentView) {
        if ([currentView isKindOfClass:NSClassFromString(className)]) return YES;
        currentView = currentView.superview;
    }
    return NO;
}

- (void)sendDelegateEventWithSEL:(SEL)selector {
    if (self.delegate && [self.delegate respondsToSelector:selector]) {
        void(*func)(id, SEL, id, id) = (void*)objc_msgSend;
        func(self.delegate, selector, self, self.anchorView);
    }
}

- (void)addEdgeConstraintsFromView:(UIView *)fromView toView:(UIView *)toView needEdgeInsets:(BOOL)needEdgeInsets {
    if (![fromView isKindOfClass:[UIView class]] || ![toView isKindOfClass:[UIView class]]) return;
    UIEdgeInsets insests = needEdgeInsets ? self.contentInsets : UIEdgeInsetsZero;
    [toView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [toView.leadingAnchor constraintEqualToAnchor:fromView.leadingAnchor constant:insests.left],
        [toView.trailingAnchor constraintEqualToAnchor:fromView.trailingAnchor constant:-insests.right],
        [toView.topAnchor constraintEqualToAnchor:fromView.topAnchor constant:insests.top],
        [toView.bottomAnchor constraintEqualToAnchor:fromView.bottomAnchor constant:-insests.bottom]
    ]];
}

#pragma mark - props

- (BRCBubbleContainerView *)containerView {
    if (!_containerView) {
        _containerView =  [[BRCBubbleContainerView alloc] init];
        _containerView.backgroundColor = self.backgroundColor;
        _containerView.layer.zPosition = FLT_MAX;
        __weak typeof(self) weakSelf = self;
        _containerView.onClickCancelButton = ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf hide];
            [strongSelf sendDelegateEventWithSEL:@selector(didClickCloseButton:withAchorView:)];
        };
    }
    return _containerView;
}

- (UIControl *)backgroundDismissView {
    if (!_backgroundDismissView) {
        _backgroundDismissView = [[UIControl alloc] init];
        _backgroundDismissView.backgroundColor = [UIColor clearColor];
        _backgroundDismissView.userInteractionEnabled = YES;
        _backgroundDismissView.frame = CGRectMake(0, 0, kBRCScreenWidth, kBRCScreenHeight);
        [_backgroundDismissView addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundDismissView;
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(checkFrame)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink setPaused:YES];
    }
    return _displayLink;
}

@end

@implementation BRCPopUper (popUpContent)

#pragma mark - public

- (void)setText:(NSString *)text {
    _text = text;
    if (![self.contentLabel isKindOfClass:[UILabel class]]) return;
    [self.contentLabel setText:text];
}

- (void)setAttribuedText:(NSAttributedString *)attribuedText {
    _attribuedText = attribuedText;
    if (![self.contentLabel isKindOfClass:[UILabel class]]) return;
    [self.contentLabel setAttributedText:attribuedText];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    if (![self.contentLabel isKindOfClass:[UILabel class]]) return;
    [self.contentLabel setFont:textFont];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    if (![self.contentLabel isKindOfClass:[UILabel class]]) return;
    [self.contentLabel setTextColor:textColor];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    if (![self.contentLabel isKindOfClass:[UILabel class]]) return;
    [self.contentLabel setTextAlignment:textAlignment];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    if (![self.contentImageView isKindOfClass:[UIImageView class]]) return;
    [self.contentImageView setTintColor:tintColor];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if (![self.contentImageView isKindOfClass:[UIImageView class]]) return;
    [self.contentImageView setImage:image];
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    if (![self.contentImageView isKindOfClass:[UIImageView class]]) return;
    if (self.webImageLoadBlock) self.webImageLoadBlock(self.contentImageView, [NSURL URLWithString:imageUrl]);
}


#pragma mark - props

- (UIView *)contentView {
    if (!_contentView) {
        if (self.contentStyle == BRCPopUpContentStyleText) {
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.textColor = self.textColor;
            label.font = self.textFont;
            label.textAlignment = self.textAlignment;
            _contentView = label;
        } else if (self.contentStyle == BRCPopUpContentStyleImage) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tintColor = self.tintColor;
            _contentView = imageView;
        }
    }
    return _contentView;
}

@end

