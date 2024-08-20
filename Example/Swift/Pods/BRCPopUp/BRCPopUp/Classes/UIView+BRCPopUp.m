//
//  UIView+BRCPopUp.m
//  BRCPopUp
//
//  Created by sunzhixiong on 2024/7/30.
//

#import "UIView+BRCPopUp.h"
#import "BRCPopUper.h"
#import <objc/runtime.h>

static const void *const kBRCPopUperKey = &kBRCPopUperKey;
static const void *const kBRCShowPopUperImmediatelyKey = &kBRCShowPopUperImmediatelyKey;

@implementation UIView (BRCPopUp)

- (BRCPopUper *)popUper {
    return objc_getAssociatedObject(self, kBRCPopUperKey);
}

- (BOOL)showPopUperImmediately {
    id object = objc_getAssociatedObject(self, kBRCShowPopUperImmediatelyKey);
    if ([object isKindOfClass:[NSNumber class]]) {
        return [objc_getAssociatedObject(self, kBRCShowPopUperImmediatelyKey) boolValue];
    }
    return YES;
}

- (void)setShowPopUperImmediately:(BOOL)showPopUperImmediately {
    objc_setAssociatedObject(self, kBRCShowPopUperImmediatelyKey, @(showPopUperImmediately), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction {
    [self brc_popUpTip:tip fitSize:CGSizeMake(kBRCScreenWidth - 40, HUGE) withDirection:BRCPopUpDirectionBottom];
}

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction {
    [self brc_popUpTip:tip fitSize:fitSize withDirection:direction hideAfterDuration:-1];
}

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
   hideAfterDuration:(NSTimeInterval)hideAfterDuration {
    [self brc_popUpTip:tip fitSize:CGSizeMake(kBRCScreenWidth - 40, HUGE) withDirection:direction hideAfterDuration:hideAfterDuration];
}

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
   hideAfterDuration:(NSTimeInterval)hideAfterDuration {
    [self brc_popUpTip:tip fitSize:fitSize withDirection:direction withAnimationType:BRCPopUpAnimationTypeFadeBounce hideAfterDuration:hideAfterDuration];
}

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
   withAnimationType:(BRCPopUpAnimationType)animationType {
    [self brc_popUpTip:tip fitSize:CGSizeMake(kBRCScreenWidth - 40, HUGE) withDirection:direction withAnimationType:animationType];
}

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
   withAnimationType:(BRCPopUpAnimationType)animationType {
    [self brc_popUpTip:tip fitSize:fitSize withDirection:direction withAnimationType:animationType hideAfterDuration:-1];
}

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
   withAnimationType:(BRCPopUpAnimationType)animationType
   hideAfterDuration:(NSTimeInterval)hideAfterDuration {
    [self brc_popUpTip:tip fitSize:CGSizeMake(kBRCScreenWidth - 40, HUGE) withDirection:direction withAnimationType:animationType hideAfterDuration:hideAfterDuration];
}

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
 cutomPopUpAnimation:(CAAnimation *)animation {
    [self brc_popUpTip:tip fitSize:CGSizeMake(kBRCScreenWidth - 40, HUGE) withDirection:direction cutomPopUpAnimation:animation];
}

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
 cutomPopUpAnimation:(CAAnimation *)animation {
    [self brc_popUpTip:tip fitSize:fitSize withDirection:direction cutomPopUpAnimation:animation hideAfterDuration:-1];
}

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
 cutomPopUpAnimation:(CAAnimation *)animation
   hideAfterDuration:(NSTimeInterval)hideAfterDuration {
    [self brc_popUpTip:tip fitSize:CGSizeMake(kBRCScreenWidth - 40, HUGE) withDirection:direction cutomPopUpAnimation:animation hideAfterDuration:hideAfterDuration];
}

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
 cutomPopUpAnimation:(CAAnimation *)animation
   hideAfterDuration:(NSTimeInterval)hideAfterDuration {
    BRCPopUper *popUper = self.popUper;
    if (![self.popUper isKindOfClass:[BRCPopUper class]]) {
        popUper = [[BRCPopUper alloc] initWithContentStyle:BRCPopUpContentStyleText];;
        if ([popUper isKindOfClass:[BRCPopUper class]]) {
            [popUper setContentText:tip];
            [popUper sizeThatFits:fitSize];
            popUper.popUpDirection = direction;
            popUper.popUpAnimation = animation;
            popUper.anchorView = self;
            objc_setAssociatedObject(self, kBRCPopUperKey, popUper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    if (self.showPopUperImmediately) {
        [popUper showAndHideAfterDelay:hideAfterDuration];
    }
}

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
   withAnimationType:(BRCPopUpAnimationType)animationType
   hideAfterDuration:(NSTimeInterval)hideAfterDuration {
    BRCPopUper *popUper = self.popUper;
    if (![self.popUper isKindOfClass:[BRCPopUper class]]) {
        popUper = [[BRCPopUper alloc] initWithContentStyle:BRCPopUpContentStyleText];;
        if ([popUper isKindOfClass:[BRCPopUper class]]) {
            [popUper setContentText:tip];
            [popUper sizeThatFits:fitSize];
            popUper.popUpDirection = direction;
            popUper.popUpAnimationType = animationType;
            popUper.anchorView = self;
            objc_setAssociatedObject(self, kBRCPopUperKey, popUper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    if (self.showPopUperImmediately) {
        [popUper showAndHideAfterDelay:hideAfterDuration];
    }
}

@end
