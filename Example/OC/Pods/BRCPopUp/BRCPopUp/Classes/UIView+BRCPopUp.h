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
 * 锚定视图的PopUper
 * PopUper for Anchoring Views
 *
 * @discussion:当你调用 `brc_popUpTip` 方法之后，该属性才有值
 * 适用场景：用来自定义展示 Tip 样式的时候
 *
 * This property only has a value after you call the 'brc_popUpTip' method
 * Applicable scenario: Used for customizing the display of Tip styles
 */
@property (nonatomic, strong, readonly, nullable) BRCPopUper *popUper;

/**
 * 是否立刻展示PopUper
 * Whether to redisplay PopUper
 *
 * @discussion:当你调用 `brc_popUpTip` 方法，当该属性为 true 时，
 * PopUper 会立刻显示，否则则需要手动调用方法才会显示
 *
 * @discussion: When you call the `brc_popUpTip` method,
 * when this attribute is true, PopUper will be displayed immediately,
 * otherwise you need to manually call the method to display it
 */
@property (nonatomic, assign) BOOL showPopUperImmediately;

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction;

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction;

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
   hideAfterDuration:(NSTimeInterval)hideAfterDuration;

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
   hideAfterDuration:(NSTimeInterval)hideAfterDuration;

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
   withAnimationType:(BRCPopUpAnimationType)animationType;

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
   withAnimationType:(BRCPopUpAnimationType)animationType;

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
   withAnimationType:(BRCPopUpAnimationType)animationType
   hideAfterDuration:(NSTimeInterval)hideAfterDuration;

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
   withAnimationType:(BRCPopUpAnimationType)animationType
   hideAfterDuration:(NSTimeInterval)hideAfterDuration;

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
 cutomPopUpAnimation:(CAAnimation *)animation;

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
 cutomPopUpAnimation:(CAAnimation *)animation;

- (void)brc_popUpTip:(id)tip
       withDirection:(BRCPopUpDirection)direction
 cutomPopUpAnimation:(CAAnimation *)animation
   hideAfterDuration:(NSTimeInterval)hideAfterDuration;

- (void)brc_popUpTip:(id)tip
             fitSize:(CGSize)fitSize
       withDirection:(BRCPopUpDirection)direction
 cutomPopUpAnimation:(CAAnimation *)animation
   hideAfterDuration:(NSTimeInterval)hideAfterDuration;


@end

NS_ASSUME_NONNULL_END
