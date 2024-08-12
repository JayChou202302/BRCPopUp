//
//  BRCPopUp.m
//
//  Created by sunzhixiong on 2024/3/15.


#import "BRCPopUper.h"
#import "BRCBubbleLayer.h"

@interface BRCPopUper ()

@property (nonatomic, strong) UIControl                 *backgroundDismissView;
@property (nonatomic, strong) BRCBubbleContainerView    *containerView;
@property (nonatomic, strong) CADisplayLink             *displayLink;
@property (nonatomic, strong, readonly) UIView          *popUpContextView;
@property (nonatomic, assign) BOOL                      display;
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
    _offsetToAnchorView = 0;
    _contentStyle = BRCPopUpContentStyleCustom;
    _popUpDirection = BRCPopUpDirectionBottom;
    _cornerRadius = 4;
    
    _webImageLoadBlock = nil;
    _cornerRadius = 10;
    _marginToAnchorView = 5;
    _shadowRadius = 8;
    _shadowOpacity = 1.0;
    _popUpAnimationDuration = 0.2;
    _offsetToAnchorView = 0;
    
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
    
    _popUpAnimation = nil;
}

#pragma mark - view monitoring

- (void)dealloc {
    [self stopMonitoring];
}

- (void)startMonitoring {
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

- (void)showWithAnchorView:(UIView *)anchorView {
    [self showWithAnchorView:anchorView hideAfterDelay:-1];
}

- (void)showWithAnchorView:(UIView *)anchorView hideAfterDelay:(NSTimeInterval)delay {
    self.anchorView = anchorView;
    [self showAndHideAfterDelay:delay];
}

- (void)showAtAnchorPoint:(CGPoint)anchorPoint {
    [self showAtAnchorPoint:anchorPoint hideAfterDelay:-1];
}

- (void)showAtAnchorPoint:(CGPoint)anchorPoint hideAfterDelay:(NSTimeInterval)delay {
    [self setAnchorPoint:anchorPoint];
    [self showWithAnchorView:self.anchorView hideAfterDelay:delay];
}

- (void)hide {
    if ((![self.anchorView isKindOfClass:[UIView class]]) ||
        self.display == NO) {
        return;
    }
    [self stopMonitoring];
    [self dimissContainerViewAnimated];
}

- (void)toggleDisplay {
    if (self.display) {
        [self hide];
    } else {
        [self show];
    }
}

- (void)show {
    [self showAndHideAfterDelay:-1];
}

- (void)showAndHideAfterDelay:(NSTimeInterval)delay {
    if ((![self.anchorView isKindOfClass:[UIView class]]) ||
        self.display) {
        return;
    }
    [self startMonitoring];
    [self showContainerViewAnimated];
    if (delay > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hide];
        });
    }
}

- (void)sizeThatFits:(CGSize)size {
    [self _sizeThatFits:size isFromInside:NO];
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

#pragma mark - private

- (void)dismissView {
    [self stopMonitoring];
    [self dimissContainerViewAnimated];
    [self sendDelegateEventWithSEL:@selector(didUserDismissPopUper:withAchorView:)];
}

- (void)addEdgeConstraintsFromView:(UIView *)fromView toView:(UIView *)toView needEdgeInsets:(BOOL)needEdgeInsets {
    UIEdgeInsets insests = needEdgeInsets ? self.contentInsets : UIEdgeInsetsZero;
    [toView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [toView.leadingAnchor constraintEqualToAnchor:fromView.leadingAnchor constant:insests.left],
        [toView.trailingAnchor constraintEqualToAnchor:fromView.trailingAnchor constant:-insests.right],
        [toView.topAnchor constraintEqualToAnchor:fromView.topAnchor constant:insests.top],
        [toView.bottomAnchor constraintEqualToAnchor:fromView.bottomAnchor constant:-insests.bottom]
    ]];
}

- (void)showContainerViewAnimated {
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
        [self.containerView showWithAnimation:self.popUpAnimation completionBlock:^(BOOL finished) {
            self.display = YES;
            [self sendDelegateEventWithSEL:@selector(didShowPopUper:withAchorView:)];
            if (finished) {
                if ([self isHeightAnimationType]) {
                    self.contentView.alpha = 1;
                }
            }
        }];
    }
}

- (void)dimissContainerViewAnimated {
    [self sendDelegateEventWithSEL:@selector(willHidePopUper:withAchorView:)];
    [self updateBubbleLayerAnchorPoint];
    CAAnimation *animation = [self animationWithDuration:self.popUpAnimationDuration isShow:NO];
    [self.containerView hideWithAnimation:animation completionBlock:nil];
    if (self.popUpAnimationType == BRCPopUpAnimationTypeNone) {
        [self.backgroundDismissView removeFromSuperview];
        self.display = NO;
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.popUpAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.backgroundDismissView removeFromSuperview];
            self.display = NO;
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
        if (containerWidth == 0) {
            containerWidth = self.sildeAnchorViewSize;
        }
        if (containerHeight == 0) {
            containerHeight = self.sildeAnchorViewSize;
        }
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

- (void)setAnchorPoint:(CGPoint)anchorPoint {
    _anchorPoint = anchorPoint;
    self.anchorView = [UIView new];
    self.anchorView.frame = CGRectMake(anchorPoint.x, anchorPoint.y, 0, 0);
}

#pragma mark - getter

- (CGFloat)containerHeight {
    return _containerSize.height;
}

- (CGFloat)containerWidth {
    return _containerSize.width;
}

- (BOOL)isHeightAnimationType {
    return self.popUpAnimationType == BRCPopUpAnimationTypeHeightExpansion ||
    self.popUpAnimationType == BRCPopUpAnimationTypeFadeHeightExpansion;
}

- (BRCPopUpDirection)arrowDirection {
    switch (_popUpDirection) {
        case BRCPopUpDirectionTop:
            return BRCPopUpDirectionBottom;
        case BRCPopUpDirectionBottom:
            return BRCPopUpDirectionTop;
        case BRCPopUpDirectionLeft:
            return BRCPopUpDirectionRight;
        case BRCPopUpDirectionRight:
            return BRCPopUpDirectionLeft;
    }
}

- (UIEdgeInsets)contentInsets {
    switch (self.arrowDirection) {
        case BRCPopUpDirectionTop:
            return UIEdgeInsetsMake(_contentInsets.top + self.arrowSize.height, _contentInsets.left,
                                              _contentInsets.bottom, _contentInsets.right);
        case BRCPopUpDirectionBottom:
            return UIEdgeInsetsMake(_contentInsets.top, _contentInsets.left,
                                              _contentInsets.bottom + self.arrowSize.height, _contentInsets.right);
        case BRCPopUpDirectionLeft:
            return UIEdgeInsetsMake(_contentInsets.top, _contentInsets.left,
                                              _contentInsets.bottom, _contentInsets.right + self.arrowSize.width);
        case BRCPopUpDirectionRight:
            return UIEdgeInsetsMake(_contentInsets.top, _contentInsets.left + self.arrowSize.width,
                                              _contentInsets.bottom, _contentInsets.right);
    }
}

- (UIImageView *)contentImageView {
    if ([self.contentView isKindOfClass:[UIImageView class]]) {
        return (UIImageView *)self.contentView;
    }
    return nil;
}

- (UILabel *)contentLabel {
    if ([self.contentView isKindOfClass:[UILabel class]]) {
        return (UILabel *)self.contentView;
    }
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

- (CGFloat)anchorViewLeft {
    return CGRectGetMinX(self.anchorViewFrame);
}

- (CGFloat)anchorViewRight {
    return CGRectGetMaxX(self.anchorViewFrame);
}

- (CGFloat)anchorViewTop {
    return CGRectGetMinY(self.anchorViewFrame);
}

- (CGFloat)anchorViewBottom {
    return CGRectGetMaxY(self.anchorViewFrame);
}

- (CGFloat)anchorViewCenterX {
    return CGRectGetMidX(self.anchorViewFrame);
}

- (CGFloat)anchorViewCenterY {
    return CGRectGetMidY(self.anchorViewFrame);
}

- (CGRect)anchorViewFrame {
    UIView *contextView = self.popUpContextView;
    return [self getFrameForView:self.anchorView inView:contextView];
}

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
    if (CGSizeEqualToSize(self.containerSize, CGSizeZero)) {
        return YES;
    }
    return _autoFitContainerSize;
}

- (BOOL)isAnchorViewInTabBarOrNavigationBar {
    if (![self.anchorView isKindOfClass:[UIView class]]) {
        return NO;
    }
    if ([self.anchorView isKindOfClass:NSClassFromString(@"_UIButtonBarButton")]) {
        return YES;
    }
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

- (CAAnimation *)popUpAnimation {
    if ([_popUpAnimation isKindOfClass:[CAAnimation class]]) {
        return _popUpAnimation;
    }
    return [self animationWithDuration:self.popUpAnimationDuration isShow:YES];
}

- (CGFloat)sildeAnchorViewSize {
    return [self getSildeViewSizeWithView:self.anchorView];
}

- (CGFloat)sildeContainerViewSize {
    return [self getSildeViewSizeWithView:self.containerView];
}

- (CGFloat)getSildeViewSizeWithView:(UIView *)view {
    if ([view isKindOfClass:[UIView class]]) {
        if (self.isDirectionHorizontal) {
            return view.frame.size.width;
        } else {
            return view.frame.size.height;
        }
    }
    return 0;
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
    if (isShow == NO) {
        return @[@1,@0];
    }
    return @[@0,@1];
}

- (CAAnimation *)animationWithDuration:(CGFloat)duration isShow:(BOOL)isShow{
    if (self.popUpAnimationType == BRCPopUpAnimationTypeNone) {
        return nil;
    }
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
        groupAnimation.duration = duration;
        return groupAnimation;
    }
    CAKeyframeAnimation *animation = [self createKeyFrameAnimationWithKeyPath:[self animationKeyPath] duration:duration];
    animation.values = [self animationValuesWithIsShow:isShow];
    return animation;
}

#pragma mark - utils

- (CGRect)getFrameForView:(UIView *)view inView:(UIView *)inView {
    return [view convertRect:view.bounds toView:inView];
}

- (UIView *)popUpContextView {
    if ([self.anchorView isKindOfClass:[UIView class]]) {
        if (self.contextStyle == BRCPopUpContextStyleViewController) {
            UIViewController *anchorVC = [self findViewControllerForView:self.anchorView];
            if ([anchorVC isKindOfClass:[UIViewController class]]) {
                return anchorVC.view;
            }
        } else if (self.contextStyle == BRCPopUpContextStyleSuperView){
            if ([self.anchorView.superview isKindOfClass:[UIView class]]) {
                return self.anchorView.superview;
            }
        } else if (self.contextStyle == BRCPopUpContextStyleWindow) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
                return [UIApplication sharedApplication].keyWindow;
            #pragma clang diagnostic pop
        }
    }
    return nil;
}

- (UIViewController *)findViewControllerForView:(UIView *)originView {
    for (UIView *view = originView; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
   return nil;
}

- (BOOL)isInClassViewWithClassName:(NSString *)className withView:(UIView *)view {
    if (![className isKindOfClass:[NSString class]]) {
        return NO;
    }
    UIView *currentView = view;
    while (currentView) {
        if ([currentView isKindOfClass:NSClassFromString(className)]) {
            return YES;
        }
        currentView = currentView.superview;
    }
    return NO;
}

- (void)sendDelegateEventWithSEL:(SEL)selector {
    if (self.delegate &&
        [self.delegate respondsToSelector:selector]) {
        [self.delegate performSelector:selector withObject:self withObject:self.anchorView];
    }
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
    if (![self.contentLabel isKindOfClass:[UILabel class]]) {
        return;
    }
    if ([contentText isKindOfClass:[NSString class]]) {
        [self.contentLabel setText:contentText];
    } else if ([contentText isKindOfClass:[NSAttributedString class]]) {
        [self.contentLabel setAttributedText:contentText];
    }
}

- (void)setContentImage:(UIImage *)image {
    if (![self.contentImageView isKindOfClass:[UIImageView class]]) {
        return;
    }
    [self.contentImageView setImage:image];
}

- (void)setContentImageUrl:(NSString *)imageUrl {
    if (![self.contentImageView isKindOfClass:[UIImageView class]]) {
        return;
    }
    if (self.webImageLoadBlock) {
        self.webImageLoadBlock(self.contentImageView, [NSURL URLWithString:imageUrl]);
    }
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

