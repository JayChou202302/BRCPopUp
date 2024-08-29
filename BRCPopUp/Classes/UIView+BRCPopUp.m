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
static const void *const kBRCShowPopUperCustomAnimationKey = &kBRCShowPopUperCustomAnimationKey;

@implementation UIView (BRCPopUp)

#pragma mark - getter

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

#pragma mark - setter

- (void)setShowPopUperImmediately:(BOOL)showPopUperImmediately {
    objc_setAssociatedObject(self, kBRCShowPopUperImmediatelyKey, @(showPopUperImmediately), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - text display

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction {
    [self brc_popUpTip:tip fitSize:CGSizeMake(kBRCScreenWidth - 40, HUGE) withDirection:BRCPopUpDirectionBottom];
}

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction {
    [self brc_popUpTip:tip fitSize:fitSize withDirection:direction hideAfter:-1];
}

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
           hideAfter:(NSTimeInterval)duration {
    [self brc_popUpTip:tip fitSize:CGSizeMake(kBRCScreenWidth - 40, HUGE) withDirection:direction hideAfter:duration];
}

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
           hideAfter:(NSTimeInterval)duration {
    [self brc_popUpTip:tip fitSize:fitSize withDirection:direction withAnimationType:BRCPopUpAnimationTypeFadeBounce hideAfter:duration];
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
    [self brc_popUpTip:tip fitSize:fitSize withDirection:direction withAnimationType:animationType hideAfter:-1];
}

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
   withAnimationType:(BRCPopUpAnimationType)animationType
           hideAfter:(NSTimeInterval)duration {
    [self brc_popUpTip:tip fitSize:CGSizeMake(kBRCScreenWidth - 40, HUGE) withDirection:direction withAnimationType:animationType hideAfter:duration];
}

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
   withAnimationType:(BRCPopUpAnimationType)animationType
           hideAfter:(NSTimeInterval)duration {
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
        [popUper showAndHideAfter:duration];
    }
}

#pragma mark - menu display

- (void)brc_popUpMenu:(NSArray<BRCPopUpMenuAction *> *)menuActions withDirection:(BRCPopUpDirection)direction {
    [self brc_popUpMenu:menuActions withDirection:direction hideAfter:-1];
}

- (void)brc_popUpMenu:(NSArray<BRCPopUpMenuAction *> *)menuActions
        withDirection:(BRCPopUpDirection)direction
            hideAfter:(NSTimeInterval)duration {
    [self brc_popUpMenu:menuActions withDirection:direction withAnimationType:BRCPopUpAnimationTypeFadeBounce hideAfter:duration];
}

- (void)brc_popUpMenu:(NSArray<BRCPopUpMenuAction *> *)menuActions
        withDirection:(BRCPopUpDirection)direction
    withAnimationType:(BRCPopUpAnimationType)animationType {
    [self brc_popUpMenu:menuActions withDirection:direction withAnimationType:animationType hideAfter:-1];
}

- (void)brc_popUpMenu:(NSArray<BRCPopUpMenuAction *> *)menuActions
        withDirection:(BRCPopUpDirection)direction
    withAnimationType:(BRCPopUpAnimationType)animationType
            hideAfter:(NSTimeInterval)duration {
    BRCPopUpMenu *menu = [BRCPopUpMenu menuWithActions:menuActions];
    [self brc_popUpView:menu containerSize:CGSizeZero withDirection:direction withAnimationType:animationType hideAfter:duration];
}

#pragma mark - custom display

- (void)brc_popUpView:(UIView *)view
        containerSize:(CGSize)size
        withDirection:(BRCPopUpDirection)direction {
    [self brc_popUpView:view containerSize:size withDirection:direction hideAfter:-1];
}

- (void)brc_popUpView:(UIView *)view
        containerSize:(CGSize)size
        withDirection:(BRCPopUpDirection)direction
            hideAfter:(NSTimeInterval)duration {
    [self brc_popUpView:view containerSize:size withDirection:direction withAnimationType:BRCPopUpAnimationTypeFadeBounce hideAfter:duration];
}

- (void)brc_popUpView:(UIView *)view
        containerSize:(CGSize)size
        withDirection:(BRCPopUpDirection)direction
    withAnimationType:(BRCPopUpAnimationType)animationType {
    [self brc_popUpView:view containerSize:size withDirection:direction withAnimationType:animationType hideAfter:-1];
}

- (void)brc_popUpView:(UIView *)view
        containerSize:(CGSize)size
        withDirection:(BRCPopUpDirection)direction
    withAnimationType:(BRCPopUpAnimationType)animationType
            hideAfter:(NSTimeInterval)duration {
    BRCPopUper *popUper = self.popUper;
    if (![self.popUper isKindOfClass:[BRCPopUper class]]) {
        popUper = [[BRCPopUper alloc] initWithContentView:view];;
        if ([popUper isKindOfClass:[BRCPopUper class]]) {
            popUper.popUpDirection = direction;
            popUper.containerSize = size;
            popUper.popUpAnimationType = animationType;
            popUper.anchorView = self;
            objc_setAssociatedObject(self, kBRCPopUperKey, popUper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    if (self.showPopUperImmediately) {
        [popUper showAndHideAfter:duration];
    }
}

#pragma mark - display

- (void)brc_showPopUp {
    if ([self.popUper isKindOfClass:[BRCPopUper class]]) {
        [self.popUper show];
    }
}

- (void)brc_hidePopUp {
    if ([self.popUper isKindOfClass:[BRCPopUper class]]) {
        [self.popUper hide];
    }
}

@end
