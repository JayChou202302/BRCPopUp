//
//  BRCPopUperInputTestViewController.m
//  BRCPopUp_Example
//
//  Created by sunzhixiong on 2024/7/31.
//  Copyright © 2024 zhixiongsun. All rights reserved.
//

#import "BRCPopUperInputTestViewController.h"
#import <BRCPopUp/BRCPopUper.h>
#import <Masonry/Masonry.h>
#import <YYKit/YYKitMacro.h>
#import <YYKit/UIBarButtonItem+YYAdd.h>
#import <YYKit/NSString+YYAdd.h>
#import <BRCPopUp/BRCPopUpConst.h>
#import <YYKit/UIScrollView+YYAdd.h>
#import "NSString+Localizable.h"

#define kSafeAreaBottomSpcing [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom
 
#define kStatusAndNavigationBarHeight 100

@interface BRCPopUperInputTestViewController ()
<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView       *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView       *containerView;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UITextField *inputTextField1;
@property (nonatomic, strong) BRCPopUper *textFieldPopUp;
@property (nonatomic, strong) NSMutableArray<BRCPopUper *> *PopUpManager;

@property (nonatomic, assign) CGFloat currentKeyboardY;

@end

@implementation BRCPopUperInputTestViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.inputTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.inputTextField resignFirstResponder];
    [self.PopUpManager enumerateObjectsUsingBlock:^(BRCPopUper * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj hide];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    self.title = @"DropDown";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"sun.min"] menu:nil];
    item.tintColor = [UIColor blackColor];
    item.actionBlock = ^(id _Nonnull obj) {
        BRCPopUperInputTestViewController *vc = [BRCPopUperInputTestViewController new];
        [self presentViewController:vc animated:YES completion:nil];
    };
    [self.navigationItem setRightBarButtonItem:item animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setUpViews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    [self.contentView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.containerView addSubview:self.inputTextField];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(20);
        make.leading.trailing.equalTo(self.containerView).inset(20);
        make.height.equalTo(@40);
    }];
    [self.containerView addSubview:self.inputTextField1];
    [self.inputTextField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextField.mas_bottom).offset(300);
        make.leading.trailing.equalTo(self.containerView).inset(20);
        make.height.equalTo(@40);
    }];
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.inputTextField1).offset(self.textFieldPopUp.containerHeight);
    }];
}

#pragma mark - keyboard

- (void)handleKeyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSValue *keyboardFrameEndValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardY = [keyboardFrameEndValue CGRectValue].origin.y;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat backScrollViewNeedHeight;
    CGFloat bottomSpace = kSafeAreaBottomSpcing;
    CGFloat containerBottomHeight = 20;
    CGFloat otherHeight = kSafeAreaBottomSpcing + containerBottomHeight;
    BOOL isTryScroll = NO;
  
    if (keyboardY < kBRCScreenHeight - 1) {  // show
        backScrollViewNeedHeight = keyboardY -  otherHeight;
        bottomSpace = [keyboardFrameEndValue CGRectValue].size.height + 10;
        // 设置scrollView偏移
        if (self.currentKeyboardY != keyboardY) {
            // 有时候键盘起来的时候，输入框输入文本，键盘仍会回调，此时不去偏移
            isTryScroll = YES;
        }
    } else {
        bottomSpace = kSafeAreaBottomSpcing;
        backScrollViewNeedHeight = kBRCScreenHeight - bottomSpace;
    }
    
    self.currentKeyboardY = keyboardY;
    
    if (duration == 0) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(backScrollViewNeedHeight);
        }];
        if (isTryScroll) {
            [self.scrollView scrollToBottomAnimated:YES];
        }
        [self.view updateConstraintsIfNeeded];
        [self.view layoutIfNeeded];
    } else {
        UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        [UIView animateWithDuration:duration delay:0 options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(backScrollViewNeedHeight);
            }];
            [self.view updateConstraintsIfNeeded];
            [self.view layoutIfNeeded];
            
            if (isTryScroll) {
                [self.scrollView scrollToBottomAnimated:YES];
            }
        } completion:nil];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.textFieldPopUp showWithAnchorView:textField];
    [self.tableView reloadData];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self.textFieldPopUp hide];
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    [self.textFieldPopUp showWithAnchorView:textField];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.textFieldPopUp hide];
    if (indexPath.row < [self dataSource].count) {
        NSString *value = [self dataSource][indexPath.row];
        if ([self.inputTextField isFirstResponder]) {
            self.inputTextField.text = value;
        }
        if ([self.inputTextField1 isFirstResponder]) {
            self.inputTextField1.text = value;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self dataSource].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.row < [self dataSource].count) {
        cell.textLabel.text = [self dataSource][indexPath.row];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

#pragma mark - props

- (NSMutableArray<BRCPopUper *> *)PopUpManager {
    if (!_PopUpManager) {
        _PopUpManager = [NSMutableArray array];
    }
    return _PopUpManager;
}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.delegate = self;
        _inputTextField.placeholder = [NSString localizableWithKey:@"key.dropdown.input.placeholder"];
        _inputTextField.borderStyle = UITextBorderStyleRoundedRect;
        _inputTextField.backgroundColor = [UIColor whiteColor];
    }
    return _inputTextField;
}

- (UITextField *)inputTextField1 {
    if (!_inputTextField1) {
        _inputTextField1 = [[UITextField alloc] init];
        _inputTextField1.delegate = self;
        _inputTextField1.placeholder = [NSString localizableWithKey:@"key.dropdown.input.placeholder"];
        _inputTextField1.borderStyle = UITextBorderStyleRoundedRect;
        _inputTextField1.backgroundColor = [UIColor whiteColor];
    }
    return _inputTextField1;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = UIView.new;
    }
    return _contentView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = UIView.new;
    }
    return _containerView;
}

- (BRCPopUper *)textFieldPopUp {
    if (!_textFieldPopUp) {
        _textFieldPopUp = [[BRCPopUper alloc] initWithContentView:self.tableView];
        _textFieldPopUp.dismissMode = BRCPopUpDismissModeNone;
        _textFieldPopUp.arrowSize = CGSizeMake(0, 0);
        _textFieldPopUp.popUpDirection = BRCPopUpDirectionBottom;
        _textFieldPopUp.popUpAnimationType = BRCPopUpAnimationTypeFadeHeightExpansion;
        _textFieldPopUp.containerHeight = 200;
        [self.PopUpManager addObject:_textFieldPopUp];
    }
    return _textFieldPopUp;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)originDataSource {
    return @[
        @"周杰伦",
        @"Jaychou",
        @"最伟大的作品",
        @"十二新作",
        @"十一月的肖邦",
        @"等你下课",
        @"2004无与伦比演唱会",
        @"青花瓷",
        @"周杰伦的床边故事",
        @"说好不哭",
        @"莫名其妙爱上你",
        @"跨时代",
        @"霍元甲",
        @"稻香",
        @"三年二班",
        @"地表最强演唱会",
        @"魔杰座",
        @"惊叹号",
        @"手写的从前",
        @"阳光宅男",
        @"一路向北",
        @"不能说的秘密",
        @"头文字D",
        @"彩虹",
        @"给我一首歌的时间",
        @"龙战骑士",
        @"发如雪",
        @"晴天",
        @"千里之外",
        @"本草纲目",
        @"九州天空城"
    ];
}

- (NSArray *)dataSource {
    NSArray *origin = [self originDataSource];
    UITextField *view = nil;
    if ([self.inputTextField isFirstResponder]) {
        view = self.inputTextField;
    }
    if ([self.inputTextField1 isFirstResponder]) {
        view = self.inputTextField1;
    }
    if (![view.text isNotBlank]) {
        return origin;
    }
    return [origin filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *_Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([evaluatedObject containsString:view.text]) {
            return YES;
        }
        return NO;
    }]];
}

@end
