//
//  BRCPopUp.m
//
//  Created by sunzhixiong on 2024/3/15.


#import "BRCPopUper.h"
#import "BRCBubbleLayer.h"
#import <objc/message.h>

@interface BRCPopUper ()

@property (nonatomic, assign) BOOL                      display;
@property (nonatomic, strong) UIControl                 *backgroundDismissView;
@property (nonatomic, strong) BRCBubbleContainerView    *containerView;
@property (nonatomic, strong) CADisplayLink             *displayLink;
@property (nonatomic, strong, readonly) UIView          *popUpContextView;
@property (nonatomic, assign, readonly) BOOL            isDirectionHorizontal;
@property (nonatomic, assign, readonly) CGFloat         sildeAnchorViewSize;
@property (nonatomic, assign, readonly) CGFloat         sildeContainerViewSize;

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
    if (self) {
        [self commonInit];
    }
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
    _autoCutoffRelief = NO;
    _arrowCenterAlignToAnchor = YES;
    
    _backgroundColor = [UIColor systemGray6Color];
    _shadowColor = [[UIColor grayColor] colorWithAlphaComponent:0];
    
    _containerSize = CGSizeZero;
    _shadowOffset = CGSizeZero;
    _shadowRadius = 0;
    
    _arrowSize = CGSizeMake(16, 8);
    _arrowAbsolutePosition = 12;
    _arrowRelativePosition = -1;
    _arrowRadius = 2;
    _bubbleAnchorPoint = CGPointZero;
    
    _contentInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _contextWindow = nil;
}

#pragma mark - view monitoring

- (void)dealloc {
    [self stopMonitoring];
}

- (void)startMonitoring {
    if ([self.popUpContextView isKindOfClass:[UIScrollView class]]) return;
    if (self.dismissMode != BRCPopUpDismissModeInteractive) {
        self.displayLink.paused = NO;
    }
}

- (void)stopMonitoring {
    self.displayLink.paused = YES;
}

- (void)checkFrame {
    if (!self.anchorView) return;
    self.containerView.frame = [self containerFrame];
}

#pragma mark - public method

#pragma mark - show

- (void)show {
    [self showAndHideAfterDelay:-1];
}

- (void)showAndHideAfterDelay:(NSTimeInterval)delay {
    [self showWithAnimationType:self.popUpAnimationType hideAfterDelay:delay];
}

- (void)showWithAnimationType:(BRCPopUpAnimationType)animationType {
    [self showWithAnimationType:animationType hideAfterDelay:-1];
}

- (void)showWithAnimationType:(BRCPopUpAnimationType)animationType hideAfterDelay:(NSTimeInterval)delay {
    self.popUpAnimationType = animationType;
    [self showWithAnimation:[self animationWithIsShow:YES] hideAfterDelay:delay];
}

- (void)showWithAnimation:(CAAnimation *)animation {
    [self showWithAnimation:animation hideAfterDelay:-1];
}

- (void)showWithAnchorView:(UIView *)anchorView {
    [self showWithAnchorView:anchorView hideAfterDelay:-1];
}

- (void)showWithAnchorView:(UIView *)anchorView hideAfterDelay:(NSTimeInterval)delay {
    [self showWithAnchorView:anchorView withAnimationType:self.popUpAnimationType hideAfterDelay:delay];
}

- (void)showWithAnchorView:(UIView *)anchorView withAnimationType:(BRCPopUpAnimationType)animationType {
    [self showWithAnchorView:anchorView withAnimationType:animationType hideAfterDelay:-1];
}

- (void)showWithAnchorView:(UIView *)anchorView withAnimationType:(BRCPopUpAnimationType)animationType hideAfterDelay:(NSTimeInterval)delay {
    self.popUpAnimationType = animationType;
    [self showWithAnchorView:anchorView withAnimation:[self animationWithIsShow:YES] hideAfterDelay:delay];
}

- (void)showWithAnchorView:(UIView *)anchorView withAnimation:(CAAnimation *)animation {
    [self showWithAnchorView:anchorView withAnimation:animation hideAfterDelay:-1];
}

- (void)showWithAnchorView:(UIView *)anchorView withAnimation:(CAAnimation *)animation hideAfterDelay:(NSTimeInterval)delay {
    self.anchorView = anchorView;
    [self showWithAnimation:animation hideAfterDelay:delay];
}

- (void)showWithAnchorFrame:(CGRect)anchorFrame {
    [self showWithAnchorFrame:anchorFrame hideAfterDelay:-1];
}

- (void)showWithAnchorFrame:(CGRect)anchorFrame hideAfterDelay:(NSTimeInterval)delay {
    [self showWithAnchorFrame:anchorFrame withAnimationType:self.popUpAnimationType hideAfterDelay:delay];
}

- (void)showWithAnchorFrame:(CGRect)anchorFrame withAnimationType:(BRCPopUpAnimationType)animationType {
    [self showWithAnchorFrame:anchorFrame withAnimationType:animationType hideAfterDelay:-1];
}

- (void)showWithAnchorFrame:(CGRect)anchorFrame withAnimationType:(BRCPopUpAnimationType)animationType hideAfterDelay:(NSTimeInterval)delay {
    self.popUpAnimationType = animationType;
    [self showWithAnchorFrame:anchorFrame withAnimation:[self animationWithIsShow:YES] hideAfterDelay:delay];
}

- (void)showWithAnchorFrame:(CGRect)anchorFrame withAnimation:(CAAnimation *)animation {
    [self showWithAnchorFrame:anchorFrame withAnimation:animation hideAfterDelay:-1];
}

- (void)showWithAnchorFrame:(CGRect)anchorFrame withAnimation:(CAAnimation *)animation hideAfterDelay:(NSTimeInterval)delay {
    self.anchorFrame = anchorFrame;
    [self showWithAnimation:animation hideAfterDelay:delay];
}

/// `CoreMethod`
- (void)showWithAnimation:(CAAnimation *)animation hideAfterDelay:(NSTimeInterval)delay {
    if ((![self.anchorView isKindOfClass:[UIView class]]) ||
        self.display) {
        return;
    }
    [self startMonitoring];
    CAAnimation *popUpAnimation = [animation isKindOfClass:[CAAnimation class]] ? animation : self.popUpAnimation;
    [self showContainerViewWithAnimation:popUpAnimation];
    if (delay > 0 || self.hideAfterDelayDuration > 0) {
        CGFloat hideDelay = delay > 0 ? delay : self.hideAfterDelayDuration;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hide];
        });
    }
}

#pragma mark - hide

- (void)hide {
    [self hideWithAnimated:YES];
}

- (void)hideWithAnimated:(BOOL)isAnimated {
    if ((![self.anchorView isKindOfClass:[UIView class]]) ||
        self.display == NO) {
        return;
    }
    [self stopMonitoring];
    [self dimissContainerView:isAnimated];
}


#pragma mark - toggle

- (void)toggleDisplay {
    if (self.display) {
        [self hide];
    } else {
        [self show];
    }
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
        UIView *superView = self.popUpContextView;
        if (self.dismissMode == BRCPopUpDismissModeInteractive) {
            [self.popUpContextView addSubview:self.backgroundDismissView];
            [self addEdgeConstraintsFromView:self.popUpContextView toView:self.backgroundDismissView needEdgeInsets:NO];
            superView = self.backgroundDismissView;
        }
        [superView addSubview:self.containerView];
        CGRect containerFrame = [self containerFrame];
        self.containerView.frame = containerFrame;
        if (![self.containerView.subviews containsObject:self.contentView] &&
            [self.contentView isKindOfClass:[UIView class]]) {
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

- (void)setContainerSize:(CGSize)containerSize {
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

- (UIEdgeInsets)contentInsets {
    CGFloat top = self.arrowDirection == BRCPopUpDirectionTop ? self.arrowSize.height : 0,
            left = self.arrowDirection == BRCPopUpDirectionRight ? self.arrowSize.width : 0,
            bottom = self.arrowDirection == BRCPopUpDirectionBottom ? self.arrowSize.height : 0,
            right = self.arrowDirection == BRCPopUpDirectionLeft ? self.arrowSize.width : 0;
    return UIEdgeInsetsMake(_contentInsets.top + top, _contentInsets.left + left, _contentInsets.bottom + bottom,_contentInsets.right + right);
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

- (CGRect)anchorViewFrame { return [self getFrameForView:self.anchorView inView:self.popUpContextView];}

- (CGRect)popUpContextViewFrame {
    UIView *popUpContextView = self.popUpContextView;
    if ([self.popUpContextView isKindOfClass:[UIScrollView class]]) {
        CGSize contentSize = [(UIScrollView *)self.popUpContextView contentSize];
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop
}

- (UIView *)popUpContextView {
    UIView *contextView = nil;
    if ([self.anchorView isKindOfClass:[UIView class]]) {
        if (self.contextStyle == BRCPopUpContextStyleAutoFind) {
            UIScrollView *nearestScrollView = [self findNearestAnchorSuperScrollView];
            if ([nearestScrollView isKindOfClass:[UIScrollView class]]) contextView = nearestScrollView;
        } else if (self.contextStyle == BRCPopUpContextStyleViewController) {
            UIViewController *anchorVC = [self findViewControllerForView:self.anchorView];
            if ([anchorVC isKindOfClass:[UIViewController class]])  contextView = anchorVC.view;
        } else if (self.contextStyle == BRCPopUpContextStyleSuperView){
            if ([self.anchorView.superview isKindOfClass:[UIView class]]) contextView = self.anchorView.superview;
        } else if (self.contextStyle == BRCPopUpContextStyleWindow) {
            contextView = self.contextWindow;
        }
    }
    // 如果都没有找到的话 那么就给一个兜底的取Window
    if (![contextView isKindOfClass:[UIView class]]) contextView = self.contextWindow;
    return contextView;
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
    }
    return _containerView;
}

- (UIControl *)backgroundDismissView {
    if (!_backgroundDismissView) {
        _backgroundDismissView = [[UIControl alloc] init];
        _backgroundDismissView.backgroundColor = [UIColor clearColor];
        _backgroundDismissView.userInteractionEnabled = YES;
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

- (void)setContentText:(id)contentText {
    if (![self.contentLabel isKindOfClass:[UILabel class]]) return;
    if ([contentText isKindOfClass:[NSString class]]) {
        [self.contentLabel setText:contentText];
    } else if ([contentText isKindOfClass:[NSAttributedString class]]) {
        [self.contentLabel setAttributedText:contentText];
    }
}

- (void)setContentImage:(UIImage *)image {
    if (![self.contentImageView isKindOfClass:[UIImageView class]]) return;
    [self.contentImageView setImage:image];
}

- (void)setContentImageUrl:(NSString *)imageUrl {
    if (![self.contentImageView isKindOfClass:[UIImageView class]]) return;
    if (self.webImageLoadBlock) self.webImageLoadBlock(self.contentImageView, [NSURL URLWithString:imageUrl]);
}

#pragma mark - props

- (UIView *)contentView {
    if (!_contentView) {
        if (self.contentStyle == BRCPopUpContentStyleText) {
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            _contentView = label;
        } else if (self.contentStyle == BRCPopUpContentStyleImage) {
            UIImageView *imageView = [[UIImageView alloc] init];
            _contentView = imageView;
        }
    }
    return _contentView;
}

@end

