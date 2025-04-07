//
//  BRCBubbleLayer.m
//  BRCPopUp
//
//  Created by sunzhixiong on 2025/4/6.
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

- (void)updateLayer { [self setMask:nil]; }

- (CGFloat)getArrowTopPointPosition:(CGSize)size {
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
