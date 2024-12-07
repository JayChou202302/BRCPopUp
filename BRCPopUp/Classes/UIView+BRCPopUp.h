//
//  UIView+BRCPopUp.h
//  BRCPopUp
//
//  Created by sunzhixiong on 2024/7/30.
//

#import <UIKit/UIKit.h>
#import "BRCPopUpConst.h"

NS_ASSUME_NONNULL_BEGIN

@class BRCPopUper;

@interface UIView (BRCPopUp)
/**
 * PopUper for Anchoring Views / 锚定视图的PopUper
 */
@property (nonatomic, strong, readonly, nullable) BRCPopUper *popUper;

///=============================================================================
/// @name Create PopUp Tip / 创建文本弹出框
/// @param tip NSString / NSAttributedString
///=============================================================================

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
NS_SWIFT_NAME(brc_popUpTip(_:direction:));

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
NS_SWIFT_NAME(brc_popUpTip(_:fitSize:direction:));

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
           hideAfter:(NSTimeInterval)duration
NS_SWIFT_NAME(brc_popUpTip(_:direction:hideAfter:));

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
           hideAfter:(NSTimeInterval)duration
NS_SWIFT_NAME(brc_popUpTip(_:fitSize:direction:hideAfter:));

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
   withAnimationType:(BRCPopUpAnimationType)animationType
NS_SWIFT_NAME(brc_popUpTip(_:direction:animationType:));

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
   withAnimationType:(BRCPopUpAnimationType)animationType
NS_SWIFT_NAME(brc_popUpTip(_:fitSize:direction:animationType:));

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
   withAnimationType:(BRCPopUpAnimationType)animationType
           hideAfter:(NSTimeInterval)duration
NS_SWIFT_NAME(brc_popUpTip(_:direction:animationType:hideAfter:));

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
   withAnimationType:(BRCPopUpAnimationType)animationType
           hideAfter:(NSTimeInterval)duration
NS_SWIFT_NAME(brc_popUpTip(_:fitSize:direction:animationType:hideAfter:));

///=============================================================================
/// @name Create PopUp CustomView / 创建自定义内容弹出框
/// @param view 自定义弹出视图
/// @param size 自定义弹出视图的大小
///=============================================================================

- (void)brc_popUpView:(UIView *)view
        containerSize:(CGSize)size
        withDirection:(BRCPopUpDirection)direction
NS_SWIFT_NAME(brc_popUpView(_:containerSize:direction:));

- (void)brc_popUpView:(UIView *)view
        containerSize:(CGSize)size
        withDirection:(BRCPopUpDirection)direction
            hideAfter:(NSTimeInterval)duration
NS_SWIFT_NAME(brc_popUpView(_:containerSize:direction:hideAfter:));

- (void)brc_popUpView:(UIView *)view
        containerSize:(CGSize)size
        withDirection:(BRCPopUpDirection)direction
    withAnimationType:(BRCPopUpAnimationType)animationType
NS_SWIFT_NAME(brc_popUpView(_:containerSize:direction:animationType:));

- (void)brc_popUpView:(UIView *)view
        containerSize:(CGSize)size
        withDirection:(BRCPopUpDirection)direction
    withAnimationType:(BRCPopUpAnimationType)animationType
            hideAfter:(NSTimeInterval)duration
NS_SWIFT_NAME(brc_popUpView(_:containerSize:direction:animationType:hideAfter:));


#pragma mark - display

/**
 * Show PopUp(if popUper not nil) / 展示弹出框 - popUper 不为空
 *
 */
- (void)brc_showPopUp;

/**
 * Hide PopUp(if popUper not nil) / 隐藏弹出框 - popUper 不为空
 */
- (void)brc_hidePopUp;


@end

NS_ASSUME_NONNULL_END
