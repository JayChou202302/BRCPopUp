//
//  BRCBaseTestViewController.h
//  BRCFastTest
//
//  Created by sunzhixiong on 2024/8/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRCBaseTestViewController : UIViewController
<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isNavigationBarChangeAlphaWhenScrolled;
@property (nonatomic, assign) BOOL isAutoHandlerKeyBoard;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) UIView       *lastView;

- (void)setUpViews;
- (void)scrollToFirstResponder;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

#pragma mark - test control

- (void)addEnumControlWithItems:(NSArray *)items
                      withTitle:(NSString *)title
                     chageBlock:(void (^)(UISegmentedControl *control))chageBlock;

- (void)addBoolControlWithTitle:(NSString *)title
                     chageBlock:(void (^)(BOOL newValue))chageBlock
                   defaultValue:(BOOL)defaultValue;

- (void)addSliderControlWithTitle:(NSString *)title
                             desc:(NSString *)desc
                       valueArray:(NSArray *)valueArray
                       chageBlock:(void (^)(UISlider *control))chageBlock;

#pragma mark - view

- (void)addSubView:(UIView *)view;
- (void)addTestView:(UIView *)testView withTitle:(NSString *)title height:(CGFloat)height isFitWidth:(BOOL)isFitWidth;
- (void)addTestView:(UIView *)testView withTitle:(NSString *)title height:(CGFloat)height
              width:(CGFloat)width space:(CGFloat)space ;
- (void)addTestView:(UIView *)testView withTitle:(NSString *)title height:(CGFloat)height
         isFitWidth:(BOOL)isFitWidth space:(CGFloat)space;
- (void)addSubView:(UIView *)view space:(CGFloat)space height:(CGFloat)height;
- (void)addSubView:(UIView *)view space:(CGFloat)space height:(CGFloat)height width:(CGFloat)width;
- (void)addSubView:(UIView *)view space:(CGFloat)space height:(CGFloat)height
        isFitWidth:(BOOL)isFitWidth;
- (void)addSubView:(UIView *)view topSpace:(CGFloat)space width:(CGFloat)width height:(CGFloat)height
          isCenter:(BOOL)isCenter isRight:(BOOL)isRight;
- (void)addLabelWithText:(NSString *)text withTopSpace:(CGFloat)space;

#pragma mark - debug

- (NSString *)componentTitle;
- (NSString *)componentDescription;
- (NSArray *)componentFunctions;
- (CGFloat)leftPadding;
- (CGFloat)keyBoardBottomSpace;

@end

NS_ASSUME_NONNULL_END
