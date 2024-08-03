//
//  BRCPopUperExampleTestViewController.m
//  BRCPopUp_Example
//
//  Created by sunzhixiong on 2024/7/31.
//  Copyright © 2024 zhixiongsun. All rights reserved.
//

#import "BRCPopUperExampleTestViewController.h"
#import <BRCPopUp/UIView+BRCPopUp.h>
#import <BRCPopUp/BRCPopUper.h>
#import <Masonry/Masonry.h>
#import <YYKit/UIBarButtonItem+YYAdd.h>
#import <SDWebImage/SDWebImage.h>
#import <YYKit/UIControl+YYAdd.h>
#import <YYKit/YYKitMacro.h>
#import "BRCToast.h"
#import "BRCImageCollectionCell.h"
#import "NSString+Localizable.h"

@interface BRCPopUperExampleTestViewController ()
<
UICollectionViewDataSource,
UIScrollViewDelegate
>

@property (nonatomic, strong) BRCPopUper *gesturePopUp;
@property (nonatomic, strong) NSMutableArray<BRCPopUper *>  *popUpArray;
@property (nonatomic, strong) UIView *lastView;


@end

@implementation BRCPopUperExampleTestViewController

- (void)loadView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentInset = UIEdgeInsetsMake(0, 0,100, 0);
    scrollView.contentSize =  [UIScreen mainScreen].bounds.size;
    scrollView.delegate = self;
    [scrollView setAlwaysBounceVertical:YES];
    UIView *contentView = [UIView new];
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.height.equalTo(@([UIScreen mainScreen].bounds.size.height));
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
    }];
    self.view = scrollView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.popUpArray enumerateObjectsUsingBlock:^(BRCPopUper * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj hide];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationItem.titleView brc_popUpTip:[NSString localizableWithKey:@"key.popup.test.center.title.popup"] withDirection:BRCPopUpDirectionBottom hideAfterDuration:3.0];
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _popUpArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    [self setUpViews];
}

- (void)setUpPopUpWithItem:(UIBarButtonItem *)item
                      size:(CGSize)size
                 dropStyle:(void (^)(BRCPopUper *popUp))dropStyle
                    isLeft:(BOOL)isLeft{
    BRCPopUper *buttonpopUp = [[BRCPopUper alloc] initWithContentStyle:BRCPopUpContentStyleCustom];
    buttonpopUp.cornerRadius = 6;
    buttonpopUp.marginToAnchorView = 0;
    buttonpopUp.popUpDirection = BRCPopUpDirectionBottom;
    buttonpopUp.popUpAnimationType = BRCPopUpAnimationTypeFadeBounce;
    buttonpopUp.containerSize = size;
    buttonpopUp.autoFitContainerSize = NO;
    buttonpopUp.contentAlignment = isLeft ? BRCPopUpContentAlignmentLeft : BRCPopUpContentAlignmentRight;
    buttonpopUp.arrowAbsolutePosition = isLeft ? 12 : -12;
    dropStyle(buttonpopUp);
    [self.popUpArray addObject:buttonpopUp];
    @weakify(item);
    item.actionBlock = ^(id _Nonnull) {
        @strongify(item);
        buttonpopUp.anchorView = [item performSelector:@selector(view)];
        [buttonpopUp toggleDisplay];
    };
}

- (UIBarButtonItem *)setRightNavigationBarItem1WithImageName:(NSString *)imageName
                                     dropStyle:(void (^)(BRCPopUper *buttonpopUp))dropStyle
                                      dropSize:(CGSize)dropSize{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:imageName] menu:nil];
    item.tintColor = [UIColor blackColor];
    [self setUpPopUpWithItem:item size:CGSizeMake(dropSize.width, dropSize.height) dropStyle:dropStyle isLeft:NO];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
    return item;
}

- (UIBarButtonItem *)setRightNavigationBarItem2WithImageName:(NSString *)imageName
                                     dropStyle:(void (^)(BRCPopUper *buttonpopUp))dropStyle
                                      dropSize:(CGSize)dropSize{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:imageName] menu:nil];
    item.tintColor = [UIColor blackColor];
    [self setUpPopUpWithItem:item size:CGSizeMake(dropSize.width, dropSize.height) dropStyle:dropStyle isLeft:NO];
    return item;
}

- (void)setLeftNavigationBarItemWithImageName:(NSString *)imageName
                                     dropStyle:(void (^)(BRCPopUper *buttonpopUp))dropStyle
                                      dropSize:(CGSize)dropSize{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:imageName] menu:nil];
    item.tintColor = [UIColor blackColor];
    [self setUpPopUpWithItem:item size:CGSizeMake(dropSize.width, dropSize.height) dropStyle:dropStyle isLeft:YES];
    [self.navigationItem setLeftBarButtonItem:item animated:YES];
}

- (void)setNavigationBar {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"PopUp";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *rightItem2 = [self setRightNavigationBarItem2WithImageName:@"swift"
                                       dropStyle:^(BRCPopUper *buttonpopUp)  {
        buttonpopUp.contentStyle = BRCPopUpContentStyleText;
        [buttonpopUp.contentLabel setNumberOfLines:0];
        [buttonpopUp.contentLabel setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium]];
        [buttonpopUp setContentText:@"Swift is a powerful and intuitive programming language for all Apple platforms. It’s easy to get started using Swift, with a concise-yet-expressive syntax and modern features you’ll love. Swift code is safe by design and produces software that runs lightning-fast."];
    } dropSize:CGSizeMake(200, 200)];
    
    [self.navigationItem setRightBarButtonItems:@[rightItem2] animated:YES];
    
    [self setLeftNavigationBarItemWithImageName:@"photo.stack" dropStyle:^(BRCPopUper *buttonpopUp) {
        buttonpopUp.webImageLoadBlock = ^(UIImageView * _Nonnull imageView, NSURL * _Nonnull imageUrl) {
            [imageView sd_setImageWithURL:imageUrl];
        };
        buttonpopUp.contentStyle = BRCPopUpContentStyleImage;
        [(UIImageView *)buttonpopUp.contentView setContentMode:UIViewContentModeScaleAspectFit];
        [buttonpopUp setContentImageUrl:@"https://www.apple.com/v/home/bm/images/promos/iphone-15-pro/promo_iphone15pro__e48p7n5x3nsm_small_2x.jpg"];
    } dropSize:CGSizeMake(200, 200)];
}

- (void)setUpViews {
    [self addPopupTest1Button];
    [self addPopupTest2Button];
    [self addPopupTest3Button];
    [self addPopupTest4View];
    [self.lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.lessThanOrEqualTo(self.view);
    }];
}

#pragma mark - test1

- (NSArray *)topViewList {
    return @[
        @{
            @"image" : [UIImage systemImageNamed:@"doc.on.doc.fill"],
            @"text"  : @"添加",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"arrowshape.turn.up.right.fill"],
            @"text"  : @"转发",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"cube.fill"],
            @"text"  : @"收藏",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"trash.fill"],
            @"text"  : @"删除",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"mic"],
            @"text"  : @"麦克风",
        },
    ];
}

- (NSArray *)bottomViewList {
    return @[
        @{
            @"image" : [UIImage systemImageNamed:@"quote.bubble.fill"],
            @"text"  : @"引用",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"bell.fill"],
            @"text"  : @"提醒",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"line.3.crossed.swirl.circle.fill"],
            @"text"  : @"翻译",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"magnifyingglass.circle.fill"],
            @"text"  : @"搜一搜",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"sun.max.circle.fill"],
            @"text"  : @"手电",
        },
    ];
}

- (UIView *)test1ContentView {
    UIView *view = [UIView new];
    UIStackView *topView = [[UIStackView alloc] init];
    topView.axis = UILayoutConstraintAxisHorizontal;
    topView.alignment = UIStackViewAlignmentCenter;
    topView.distribution = UIStackViewDistributionFillEqually;
    [[self topViewList] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage  *image = obj[@"image"];
        NSString *text = obj[@"text"];
        void (^onTap)(void) = obj[@"onTap"];
        [self addButtonToStackView:topView image:image text:text onTap:^{
            if (onTap) {
                onTap();
            } else {
                [BRCToast show:[NSString localizableWithKey:@"key.popup.test.more.option.click.toast"]];
            }
        }];
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor systemGray5Color];
    
    UIStackView *bottomView = [[UIStackView alloc] init];
    bottomView.axis = UILayoutConstraintAxisHorizontal;
    bottomView.alignment = UIStackViewAlignmentCenter;
    bottomView.distribution = UIStackViewDistributionFillEqually;
    [[self bottomViewList] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage  *image = obj[@"image"];
        NSString *text = obj[@"text"];
        void (^onTap)(void) = obj[@"onTap"];
        [self addButtonToStackView:bottomView image:image text:text onTap:^{
            if (onTap) {
                onTap();
            } else {
                [BRCToast show:[NSString localizableWithKey:@"key.popup.test.more.option.click.toast"]];
            }
        }];
    }];
    
    [view addSubview:topView];
    [view addSubview:lineView];
    [view addSubview:bottomView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(5);
        make.leading.trailing.equalTo(view).inset(20);
        make.height.equalTo(@50);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.leading.trailing.equalTo(topView);
        make.height.equalTo(@1);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.leading.trailing.equalTo(topView);
        make.height.equalTo(@50);
        make.bottom.equalTo(view).offset(-5);
    }];
    return view;
}

- (void)addPopupTest1Button {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = [UIColor systemGreenColor];
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    button.layer.cornerCurve = kCACornerCurveContinuous;
    [button setTitle:[NSString localizableWithKey:@"key.popup.test.button.title1.style"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    BRCPopUper *popUp = [[BRCPopUper alloc] initWithContentStyle:BRCPopUpContentStyleCustom];
    popUp.anchorView = button;
    popUp.dismissMode = BRCPopUpDismissModeNone;
    popUp.contentAlignment = BRCPopUpContentAlignmentLeft;
    popUp.popUpDirection = BRCPopUpDirectionTop;
    popUp.popUpAnimationType = BRCPopUpAnimationTypeFadeBounce;
    popUp.containerSize = CGSizeMake(300, 150);
    [popUp setContentView:[self test1ContentView]];
    [self.popUpArray addObject:popUp];
    [button addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [popUp toggleDisplay];
    }] forControlEvents:UIControlEventTouchUpInside];
    [self addLabelWithText:@"key.popup.test.section.title1.style" withTopSpace:10];
    [self addButton:button withTopSpace:160 isRight:NO];
}

#pragma mark - test2

- (NSArray *)imageArray {
    return @[
        @"https://is1-ssl.mzstatic.com/image/thumb/Features/v4/b7/3a/0a/b73a0aa8-394c-a08d-4e25-88ee7612a41b/c9430441-b1be-43e4-bbba-f443c1422852.png/548x1186.jpg",
        @"https://is1-ssl.mzstatic.com/image/thumb/Features122/v4/ef/50/3f/ef503fb5-7ad5-ce94-76ae-5d211988b343/906ae116-b969-4f9e-a9f3-e3e6a5a492b2.png/548x1186.jpg",
        @"https://www.apple.com/v/home/bm/images/heroes/apple-vision-pro-enhanced/hero_apple_vision_pro_enhanced_endframe__b917czne63hy_small_2x.jpg",
        @"https://www.apple.com/v/home/bm/images/heroes/mothers-day-2024/hero_md24__e3yulubypvki_small_2x.jpg",
        @"https://www.apple.com/v/home/bm/images/heroes/apple-event-may/hero_1_apple_event_may__b3bo6rpkqhle_small_2x.jpg",
        @"https://www.apple.com/v/home/bm/images/promos/iphone-15-pro/promo_iphone15pro__e48p7n5x3nsm_small_2x.jpg"
    ];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self imageArray].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BRCImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row < [self imageArray].count) {
        NSString *imageUrl = [self imageArray][indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        cell.imageView.clipsToBounds = YES;
    }
    return cell;
}

- (UIView *)test2ContentView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(100, 100);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 10;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    collectionView.dataSource = self;
    [collectionView registerClass:[BRCImageCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    collectionView.backgroundColor = [UIColor systemGray6Color];
    return collectionView;
}

- (void)addPopupTest2Button {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = [UIColor systemGreenColor];
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    button.layer.cornerCurve = kCACornerCurveContinuous;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:[NSString localizableWithKey:@"key.popup.test.button.title2.style"] forState:UIControlStateNormal];
    BRCPopUper *popUp = [[BRCPopUper alloc] initWithContentStyle:BRCPopUpContentStyleCustom];
    
    popUp.contentAlignment = BRCPopUpContentAlignmentRight;
    popUp.popUpDirection = BRCPopUpDirectionTop;
    popUp.popUpAnimationType = BRCPopUpAnimationTypeFadeBounce;
    popUp.anchorView = button;
    popUp.containerSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3 / 4, 120);
    [popUp setContentView:[self test2ContentView]];
    [self.popUpArray addObject:popUp];
    [button addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [popUp toggleDisplay];
    }] forControlEvents:UIControlEventTouchUpInside];
    [self addLabelWithText:@"key.popup.test.section.title2.style" withTopSpace:10];
    [self addButton:button withTopSpace:130 isRight:YES];
}

#pragma mark - test3

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.gesturePopUp hide];
}

- (void)handlerLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    CGPoint gesturePoint = [gesture locationInView:[UIApplication sharedApplication].delegate.window];
    NSLog(@"%@",@(gesturePoint.x));
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.gesturePopUp.arrowAbsolutePosition = (gesturePoint.x - 20);
        [self.gesturePopUp setAnchorPoint:CGPointMake(20, gesturePoint.y)];
        [self.gesturePopUp show];
    }
}

- (void)addPopupTest3Button {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView setUserInteractionEnabled:YES];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://www.apple.com/v/home/bm/images/promos/iphone-15-pro/promo_iphone15pro__e48p7n5x3nsm_small_2x.jpg"]];
    imageView.layer.cornerRadius = 10;
    imageView.layer.cornerCurve = kCACornerCurveContinuous;
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlerLongPressGesture:)];
    longPressGesture.minimumPressDuration = 0.5;
    [imageView addGestureRecognizer:longPressGesture];
    [self addLabelWithText:@"key.popup.test.section.title3.style" withTopSpace:10];
    [self addSubView:imageView topSpace:10
               width:[UIScreen mainScreen].bounds.size.width/2 height:200 isCenter:NO isRight:NO];
}

- (void)addPopupTest4View {
    UIView *popUpTestView = [UIView new];
    
    UIButton *leftLabelView = [[UIButton alloc] init];
    leftLabelView.userInteractionEnabled = NO;
    [leftLabelView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftLabelView setTintColor:[UIColor blackColor]];
    [leftLabelView setTitle:@"UserName" forState:UIControlStateNormal];
    [leftLabelView setImage:[UIImage systemImageNamed:@"person"] forState:UIControlStateNormal];
    
    UILabel  *rightLabelView = [[UILabel alloc] init];
    [rightLabelView setText:@"JayChou"];
    
    UIButton *warnButton = [[UIButton alloc] init];
    [warnButton setImage:[UIImage systemImageNamed:@"exclamationmark.shield.fill"] forState:UIControlStateNormal];
    [warnButton setTintColor:[UIColor systemYellowColor]];
    
    NSString *allString = @"There may be an error in your name. Please modify it within 10 days.";
    NSString *highLightedString = @"10 days.";
    NSMutableAttributedString *warnString = [[NSAttributedString alloc] initWithString:allString attributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:14.0],
        NSForegroundColorAttributeName : [UIColor blackColor]
    }].mutableCopy;
    [warnString addAttributes:@{
        NSForegroundColorAttributeName : [UIColor systemPinkColor]
    } range:[allString rangeOfString:highLightedString]];
    warnButton.showPopUperImmediately = NO;
    [warnButton brc_popUpTip:warnString withDirection:BRCPopUpDirectionBottom withAnimationType:BRCPopUpAnimationTypeFadeBounce];
    BRCPopUper *popUper = warnButton.popUper;
    popUper.dismissMode = BRCPopUpDismissModeNone;
    popUper.contentAlignment = BRCPopUpContentAlignmentRight;
    popUper.backgroundColor = [UIColor systemGroupedBackgroundColor];
    popUper.shadowOffset = CGSizeMake(0, 5);
    popUper.shadowOpacity = 1;
    popUper.shadowRadius = 10.0;
    popUper.offsetToAnchorView = 10;
    popUper.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [warnButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [popUper toggleDisplay];
    }];
    
    [popUpTestView addSubview:leftLabelView];
    [popUpTestView addSubview:rightLabelView];
    [popUpTestView addSubview:warnButton];
    
    [leftLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(popUpTestView);
        make.top.bottom.equalTo(popUpTestView);
    }];
    
    [rightLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(warnButton.mas_leading).offset(-5);
        make.top.bottom.equalTo(popUpTestView);
    }];
    
    [warnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(popUpTestView);
        make.centerY.equalTo(popUpTestView);
    }];
    
    [self addLabelWithText:@"key.popup.test.section.title4.style" withTopSpace:10];
    [self addSubView:popUpTestView topSpace:10 width:[UIScreen mainScreen].bounds.size.width - 40 height:30 isCenter:NO isRight:NO];
}

- (void)addButtonToStackView:(UIStackView *)stackView
                       image:(UIImage *)image
                        text:(NSString *)text
                       onTap:(void (^)(void))onTap{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (onTap) onTap();
    }];
    [button setImage:image forState:UIControlStateNormal];
//    [button setTitle:text forState:UIControlStateNormal];
    [button setTintColor:[UIColor blackColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stackView addArrangedSubview:button];
}

- (void)addLabelWithText:(NSString *)text withTopSpace:(CGFloat)space {
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString localizableWithKey:text];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    [self addSubView:label topSpace:space width:[UIScreen mainScreen].bounds.size.width - 40 height:30 isCenter:NO isRight:NO];
}

- (void)addButton:(UIView *)button withTopSpace:(CGFloat)space isRight:(BOOL)isRight{
    [self addSubView:button topSpace:space width:[UIScreen mainScreen].bounds.size.width / 2 height:50 isCenter:NO isRight:isRight];
}

- (void)addSubView:(UIView *)view
          topSpace:(CGFloat)space
             width:(CGFloat)width
            height:(CGFloat)height
          isCenter:(BOOL)isCenter
           isRight:(BOOL)isRight{
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.lastView == nil) {
            make.top.equalTo(self.view).offset(0);
        } else {
            make.top.equalTo(self.lastView.mas_bottom).offset(space);
        }
        if (isCenter) {
            make.centerX.equalTo(self.view);
        } else if (isRight){
            make.trailing.equalTo(self.view).offset(-20);
        } else {
            make.leading.equalTo(self.view).offset(20);
        }
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
    }];
    self.lastView = view;
}

#pragma mark - props

- (BRCPopUper *)gesturePopUp {
    if (!_gesturePopUp) {
        _gesturePopUp = [[BRCPopUper alloc] initWithContentStyle:BRCPopUpContentStyleCustom];
        _gesturePopUp.arrowCenterAlignToAnchor = NO;
        _gesturePopUp.dismissMode = BRCPopUpDismissModeNone;
        _gesturePopUp.containerSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/2 + 40, 60);
        _gesturePopUp.contentAlignment = BRCPopUpContentAlignmentLeft;
        _gesturePopUp.popUpDirection = BRCPopUpDirectionTop;
        _gesturePopUp.contextStyle = BRCPopUpContextStyleWindow;
        _gesturePopUp.popUpAnimationType = BRCPopUpAnimationTypeFadeBounce;
        _gesturePopUp.marginToAnchorView = 0;
        [_gesturePopUp setContentStyle:BRCPopUpContentStyleText];
        [_gesturePopUp.contentLabel setText:[NSString localizableWithKey:@"key.popup.gesture.button.title"]];
        [self.popUpArray addObject:_gesturePopUp];
    }
    return _gesturePopUp;
}

@end

