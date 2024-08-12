//
//  BRCBubbleLayer.m
//  BRCDropDown
//
//  Created by sunzhixiong on 2024/7/30.
//

#import "BRCBubbleLayer.h"

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

- (void)updateLayer {
    [self setMask:nil];
}

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
    if (size.width == 0 || size.height == 0) {
        return nil;
    }
    
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
    if (!CGRectEqualToRect(frame, CGRectZero)) {
        [self setMask:nil];
    }
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
    if (_arrowRelativePosition > 0) {
        return _arrowRelativePosition;
    }
    CGFloat boundSize = 0;
    if (self.arrowDirection == BRCPopUpDirectionTop ||
        self.arrowDirection == BRCPopUpDirectionBottom) {
        boundSize = size.width;
    } else {
        boundSize = size.height;
    }
    if (_arrowAbsolutePosition > 0) {
        return _arrowAbsolutePosition / boundSize;
    } else {
        return (boundSize + _arrowAbsolutePosition) / boundSize;
    }
}

@end


@interface BRCBubbleContainerView ()

@property (nonatomic, strong) UIColor *backgroundBubbleColor;
@property (nonatomic, strong) BRCBubbleLayer *bubbleLayer;
@property (nonatomic, copy) void(^ __nullable animationFinishBlock)(BOOL);
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation BRCBubbleContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isAnimating = NO;
        [self.layer addSublayer:self.bubbleLayer];
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
        if (isShow) {
            [self show];
        } else {
            [self hide];
        }
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
    self.bubbleLayer.shadowColor = shadowColor.CGColor;
}

- (void)setLayerAnchorPoint:(CGPoint)anchorPoint {
    CGRect oldFrame = self.frame;
    [self.layer setAnchorPoint:anchorPoint];
    self.frame = oldFrame;
}

- (BRCBubbleLayer *)bubbleLayer {
    if (!_bubbleLayer) {
        _bubbleLayer = [[BRCBubbleLayer alloc] init];
    }
    return _bubbleLayer;
}

@end
