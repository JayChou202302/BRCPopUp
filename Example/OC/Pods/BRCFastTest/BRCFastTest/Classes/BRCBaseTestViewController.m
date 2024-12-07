//
//  BRCBaseTestViewController.m
//  BRCFastTest
//
//  Created by sunzhixiong on 2024/8/8.
//

#import "BRCBaseTestViewController.h"
#import "UIColor+BRCFastTest.h"
#import "NSString+BRCTestLocalizable.h"
#import "NSString+YYAdd.h"
#import "YYKitMacro.h"
#import "UIControl+YYAdd.h"
#import "UIView+YYAdd.h"
#import "Masonry.h"
#import "BRCFlexTagBoxView.h"

#define kSafeAreaBottomSpcing [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom
 
#define kStatusAndNavigationBarHeight 100

@interface BRCBaseTestViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MASConstraint *bottomConstraint;
@property (nonatomic, assign) CGFloat currentKeyboardY;
@property (nonatomic, strong, readonly) NSArray *componentTagColors;


@end

@implementation BRCBaseTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brtest_contentWhite];
    [self setUpViews];
    if ([self.lastView isKindOfClass:[UIView class]]) {
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.lastView);
        }];
    }
    if ([self isAutoHandlerKeyBoard]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)dealloc
{
    if ([self isAutoHandlerKeyBoard]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillChangeFrameNotification];
    }
}

- (void)setUpViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom + 44);
        make.leading.trailing.equalTo(self.view);
        self.bottomConstraint = make.bottom.equalTo(self.view);
    }];
    if ([self.componentTitle isNotBlank]) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 1;
        titleLabel.text = [NSString brctest_localizableWithKey:self.componentTitle];
        titleLabel.textColor = [UIColor brtest_black];
        titleLabel.font = [UIFont systemFontOfSize:25.0 weight:UIFontWeightBold];
        [self addSubView:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView);
            make.leading.equalTo(self.scrollView);
        }];
        self.lastView = titleLabel;
    }
    if ([self.componentTags isKindOfClass:[NSArray class]] &&
        self.componentTags.count > 0) {
        BRCFlexTagBoxView *flexTagView = [[BRCFlexTagBoxView alloc] init];
        flexTagView.backgroundColor = [UIColor brtest_contentWhite];
        NSMutableArray *tags = [NSMutableArray array];
        NSMutableArray *componentTagColors = self.componentTagColors.mutableCopy;
        [self.componentTags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isNotBlank]) {
                BRCFlexTagModel *tagModel = [[BRCFlexTagModel alloc] init];
                tagModel.text = [NSString brctest_localizableWithKey:obj];
                tagModel.style.tagTextColor = [UIColor whiteColor];
                tagModel.style.tagTextFont = [UIFont boldSystemFontOfSize:13.0];
                tagModel.style.tagBorderWidth = 1.0;
                tagModel.style.tagBorderColor = [UIColor brtest_fifthGray];
                tagModel.style.tagCornerRadius = 5.0;
                tagModel.style.tagContentInsets = UIEdgeInsetsMake(5, 5, 5, 5);
                tagModel.style.tagTextAlignment = NSTextAlignmentLeft;
                
                if (idx < componentTagColors.count) {
                    NSString *color = componentTagColors[idx];
                    tagModel.style.tagBackgroundColor = [UIColor colorWithHexString:color];
                    [componentTagColors removeObject:color];
                } else {
                    tagModel.style.tagBackgroundColor = [UIColor colorWithHexString:componentTagColors.lastObject];
                    [componentTagColors removeLastObject];
                }
                [tags addObject:tagModel];
            }
        }];
        [flexTagView setTagList:tags];
        [self addSubView:flexTagView];
        [flexTagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastView.mas_bottom).offset(10);
            make.leading.equalTo(self.scrollView);
            make.trailing.equalTo(self.scrollView);
        }];
        self.lastView = flexTagView;
    }
    if ([self.componentDescription isNotBlank]) {
        UILabel *descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.textAlignment = NSTextAlignmentLeft;
        descriptionLabel.text = [NSString brctest_localizableWithKey:self.componentDescription];
        descriptionLabel.textColor = [UIColor brtest_secondaryBlack];
        descriptionLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
        [self addSubView:descriptionLabel];
        [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastView.mas_bottom).offset(10);
            make.leading.equalTo(self.scrollView);
            make.trailing.equalTo(self.scrollView);
            make.width.equalTo(@(UIScreen.mainScreen.bounds.size.width - self.leftPadding * 2));
        }];
        self.lastView = descriptionLabel;
    }
    
    if ([self.componentFunctions count] > 0) {
        [self.componentFunctions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isNotBlank]) {
                UILabel *label = [self createFunctionLabel:[NSString stringWithFormat:@"%ld.%@",idx+1,[NSString brctest_localizableWithKey:obj]]];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.lastView.mas_bottom).offset(5);
                    make.leading.equalTo(self.scrollView);
                    make.height.equalTo(@20);
                }];
                self.lastView = label;
            }
        }];
    }
}

- (void)addEnumControlWithItems:(NSArray *)items
                      withTitle:(NSString *)title
                     chageBlock:(void (^)(UISegmentedControl *control))chageBlock{
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:items];
    [control setSelectedSegmentIndex:0];
    @weakify(control)
    [control addBlockForControlEvents:UIControlEventValueChanged block:^(id  _Nonnull sender) {
        @strongify(control)
        if (chageBlock) chageBlock(control);
    }];
    [self addTestView:control withTitle:title height:0 isFitWidth:NO space:10];
}

- (void)addBoolControlWithTitle:(NSString *)title
                     chageBlock:(void (^)(BOOL newValue))chageBlock
                   defaultValue:(BOOL)defaultValue{
    [self addEnumControlWithItems:defaultValue ? @[@"YES",@"NO"] : @[@"NO",@"YES"] withTitle:title chageBlock:^(UISegmentedControl * _Nonnull control) {
        if (chageBlock) chageBlock(defaultValue ? (1-control.selectedSegmentIndex) : control.selectedSegmentIndex);
    }];
}

- (void)addSliderControlWithTitle:(NSString *)title
                             desc:(NSString *)desc
                       valueArray:(NSArray *)valueArray
                       chageBlock:(void (^)(UISlider *control))chageBlock{
    NSNumber *defaultNSValue = [self valueForKey:title];
    CGFloat defaultValue = [defaultNSValue floatValue];
    
    UIView *containerView = [UIView new];
    UISlider *control = [[UISlider alloc] init];
    [control setTintColor:[UIColor brtest_red]];
    control.value = defaultValue;
    control.minimumValue = [valueArray[0] floatValue];
    control.maximumValue = [valueArray[1] floatValue];
    [containerView addSubview:control];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = [UIColor brtest_black];
    label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    [containerView addSubview:label];
    
    UILabel *desclabel = [[UILabel alloc] init];
    desclabel.text = [NSString brctest_localizableWithKey:desc];
    desclabel.numberOfLines = 0;
    desclabel.textColor = [UIColor brtest_secondaryBlack];
    desclabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
    [containerView addSubview:desclabel];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = [NSString stringWithFormat:@"%.1f",[@(defaultValue) doubleValue]];
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.textColor = [UIColor brtest_red];
    valueLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [containerView addSubview:valueLabel];
    
    @weakify(control)
    [control addBlockForControlEvents:UIControlEventValueChanged block:^(id  _Nonnull sender) {
        @strongify(control)
        if (chageBlock) chageBlock(control);
        valueLabel.text = [NSString stringWithFormat:@"%.1f",[@(control.value) doubleValue]];
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(containerView);
        make.top.equalTo(containerView);
        make.trailing.equalTo(valueLabel.mas_leading).offset(-5);
    }];
    
    [desclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(containerView);
        make.top.equalTo(label.mas_bottom).offset(5);
        make.trailing.equalTo(label);
    }];
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(containerView);
        make.top.equalTo(containerView);
    }];
    
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(containerView);
        make.trailing.equalTo(containerView);
        make.top.equalTo(desclabel.mas_bottom).offset(5);
        make.bottom.equalTo(containerView);
    }];
    
    [self addSubView:containerView space:10 height:0 isFitWidth:NO];
}


- (UILabel *)createFunctionLabel:(NSString *)text {
    UILabel *functionLabel = [[UILabel alloc] init];
    functionLabel.numberOfLines = 1;
    functionLabel.text = text;
    functionLabel.textColor = [UIColor brtest_tertiaryBlack];
    functionLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubView:functionLabel];
    return functionLabel;
}

- (void)addTestView:(UIView *)testView
          withTitle:(NSString *)title
             height:(CGFloat)height
         isFitWidth:(BOOL)isFitWidth{
    [self addTestView:testView withTitle:title height:height isFitWidth:isFitWidth space:10];
}

- (void)addTestView:(UIView *)testView
          withTitle:(NSString *)title
             height:(CGFloat)height
              width:(CGFloat)width
              space:(CGFloat)space {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = [UIColor brtest_black];
    label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    [self addSubView:label space:space height:0];
    [self addSubView:testView space:10 height:height width:width];
}

- (void)addTestView:(UIView *)testView
          withTitle:(NSString *)title
             height:(CGFloat)height
         isFitWidth:(BOOL)isFitWidth
              space:(CGFloat)space {
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString brctest_localizableWithKey:title];
    label.textColor = [UIColor brtest_black];
    label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    [self addSubView:label space:space height:0];
    if (testView) {
        [self addSubView:testView space:10 height:height isFitWidth:isFitWidth];
    }
}

- (void)addSubView:(UIView *)view space:(CGFloat)space height:(CGFloat)height {
    [self addSubView:view space:space height:height isFitWidth:NO];
}

- (void)addSubView:(UIView *)view
             space:(CGFloat)space
            height:(CGFloat)height
             width:(CGFloat)width {
    [self addSubView:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.lastView) {
            make.top.equalTo(self.lastView.mas_bottom).offset(space);
        } else {
            make.top.equalTo(self.scrollView).offset(space);
        }
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(width));
        if (height != 0) {
            make.height.equalTo(@(height));
        }
    }];
    self.lastView = view;
}

- (void)addSubView:(UIView *)view
             space:(CGFloat)space
            height:(CGFloat)height
        isFitWidth:(BOOL)isFitWidth{
    [self addSubView:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.lastView) {
            make.top.equalTo(self.lastView.mas_bottom).offset(space);
        } else {
            make.top.equalTo(self.scrollView).offset(space);
        }
        make.leading.equalTo(self.scrollView);
        if (!isFitWidth) {
            make.trailing.equalTo(self.scrollView);
        }
        if (height != 0) {
            make.height.equalTo(@(height));
        }
    }];
    self.lastView = view;
}

- (void)addSubView:(UIView *)view
          topSpace:(CGFloat)space
             width:(CGFloat)width
            height:(CGFloat)height
          isCenter:(BOOL)isCenter
           isRight:(BOOL)isRight{
    [self addSubView:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.lastView == nil) {
            make.top.equalTo(self.scrollView).offset(0);
        } else {
            make.top.equalTo(self.lastView.mas_bottom).offset(space);
        }
        if (isCenter) {
            make.centerX.equalTo(self.scrollView);
        } else if (isRight){
            make.trailing.equalTo(self.view).offset(-[self leftPadding]);
        } else {
            make.leading.equalTo(self.scrollView);
        }
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
    }];
    self.lastView = view;
}

- (void)addLabelWithText:(NSString *)text withTopSpace:(CGFloat)space {
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString brctest_localizableWithKey:text];
    label.textColor = [UIColor brtest_black];
    label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    [self addSubView:label topSpace:space width:[UIScreen mainScreen].bounds.size.width - 40 height:30 isCenter:NO isRight:NO];
}

- (void)addSubView:(UIView *)view {
    [self.scrollView addSubview:view];
}

#pragma mark - keyBoard

- (void)handleKeyBoardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSValue *keyboardFrameEndValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardY = [keyboardFrameEndValue CGRectValue].origin.y;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat backScrollViewNeedHeight;
    CGFloat bottomSpace = kSafeAreaBottomSpcing;
    CGFloat containerBottomHeight = 20;
    CGFloat otherHeight = kSafeAreaBottomSpcing + containerBottomHeight;
    BOOL isTryScroll = NO;
  
    if (keyboardY < UIScreen.mainScreen.bounds.size.height - 1) {  // show
        backScrollViewNeedHeight = keyboardY -  otherHeight;
        bottomSpace = [keyboardFrameEndValue CGRectValue].size.height + [self keyBoardBottomSpace];
        // 设置scrollView偏移
        if (self.currentKeyboardY != keyboardY) {
            // 有时候键盘起来的时候，输入框输入文本，键盘仍会回调，此时不去偏移
            isTryScroll = YES;
        }
    } else {
        backScrollViewNeedHeight = UIScreen.mainScreen.bounds.size.height;
    }
    
    self.currentKeyboardY = keyboardY;
    
    if (duration == 0) {
        self.bottomConstraint.offset = -bottomSpace;
        if (isTryScroll) {
            [self scrollToFirstResponder];
        }
        [self.view updateConstraintsIfNeeded];
        [self.view layoutIfNeeded];
    } else {
        UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        [UIView animateWithDuration:duration delay:0 options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
            self.bottomConstraint.offset = -bottomSpace;
            [self.view updateConstraintsIfNeeded];
            [self.view layoutIfNeeded];
            
            if (isTryScroll) {
                [self scrollToFirstResponder];
            }
        } completion:nil];
    }
}

- (void)scrollToFirstResponder {
    UIView *firstResponder = [self findFirstResponderForView:self.view];
    
    if (![firstResponder isKindOfClass:[UIView class]]) return;
    
    [self.view layoutIfNeeded];
    
    CGRect rect = [self.scrollView convertRect:firstResponder.frame fromView:firstResponder.superview];
    CGFloat top = rect.origin.y;
    top -= 16;  // 上部给一个16的距离
    top = MAX(top, 0);
    
    CGFloat bottom = rect.origin.y + rect.size.height;
    bottom += 16; // 下部给一个16的距离
    bottom = MIN(bottom, MAX(self.scrollView.height, self.scrollView.contentSize.height));
    
    CGFloat backScrollViewHeight = self.scrollView.height;
    
    // 当前屏幕展示的视图对应的原始frame的[topY, bottomY]区域
    CGFloat currentShowTop = self.scrollView.contentOffset.y;
    CGFloat currentShowBottom = currentShowTop + backScrollViewHeight;
    
    if (top >= currentShowTop && bottom <= currentShowBottom) return;
    
    CGPoint offset = self.scrollView.contentOffset;
    
    if (bottom > currentShowBottom) {
        // 尾部定位到底部
        [self.scrollView setContentOffset:CGPointMake(offset.x, bottom - backScrollViewHeight) animated:YES];
    } else if (top < currentShowTop) {
        // 头部定位到头部
        [self.scrollView setContentOffset:CGPointMake(offset.x, top) animated:YES];
    }
}

- (UIView *)findFirstResponderForView:(UIView *)originView {
    if ([originView isFirstResponder]) {
        return originView;
    }

    for (UIView *subview in originView.subviews) {
        UIView *firstResponder = [self findFirstResponderForView:subview];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }

    return nil;
}

#pragma mark - debug

- (NSString *)componentTitle {
    return @"";
}

- (NSString *)componentDescription {
    return @"";
}

- (NSArray *)componentTags {
    return @[];
}

- (NSArray *)componentFunctions {
    return @[];
}

- (CGFloat)leftPadding {
    return 15;
}

- (CGFloat)keyBoardBottomSpace {
    return 10;
}

- (NSArray *)componentTagColors {
    return [UIColor componentTagColors];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isNavigationBarChangeAlphaWhenScrolled) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat alpha =  MIN(offsetY / 44, 1);
        if (offsetY > 0) {
            self.navigationController.navigationBar.alpha = alpha;
        } else if (alpha < 1) {
            self.navigationController.navigationBar.alpha = 0;
        }
    }
}

#pragma mark - props

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor brtest_contentWhite];
        _scrollView.contentInset = UIEdgeInsetsMake(0, self.leftPadding,80, -self.leftPadding);
        [_scrollView setAlwaysBounceVertical:YES];
        _scrollView.delegate = self;
    }
    return _scrollView;
}


@end
