//
//  BRCPopUpMainTestViewController.m
//  BRCPopUp_Example
//
//  Created by sunzhixiong on 2024/8/1.
//  Copyright © 2024 zhixiongsun. All rights reserved.
//

#import "BRCPopUpMainTestViewController.h"
#import "BRCToast.h"
#import <BRCFastTest/NSString+BRCTestLocalizable.h>
#import <BRCPopUp/BRCPopUper.h>
#import <BRCFastTest/Masonry.h>
#import <BRCFastTest/NSString+YYAdd.h>
#import <BRCPopUp/BRCPopUpConst.h>
#import <BRCFastTest/YYKitMacro.h>
#import <FLEX/FLEXMacros.h>
#import <BRCFastTest/UIControl+YYAdd.h>
#import <BRCFastTest/UIColor+BRCFastTest.h>

@interface BRCPopUpMainTestViewController ()
<BRCPopUperDelegate>

@property (nonatomic, assign) BRCPopUpContentAlignment alignmentStyle;
@property (nonatomic, assign) BRCPopUpAnimationType    animationStyle;
@property (nonatomic, assign) BRCPopUpDirection        popUpDirection;
@property (nonatomic, assign) BRCPopUpContextStyle     contextStyle;
@property (nonatomic, assign) BRCPopUpDismissMode      dismissMode;
@property (nonatomic, assign) BOOL     autoCutoffRelief;
@property (nonatomic, assign) BOOL     autoFitContainerSize;
@property (nonatomic, assign) BOOL     arrowCenterAlignToContainer;
@property (nonatomic, assign) CGFloat  offsetToAnchorView;
@property (nonatomic, assign) CGFloat  marginToAnchorView;
@property (nonatomic, assign) CGFloat  cornerRadius;
@property (nonatomic, assign) CGFloat  arrowRadius;
@property (nonatomic, assign) CGFloat  arrowWidth;
@property (nonatomic, assign) CGFloat  arrowHeight;
@property (nonatomic, assign) CGFloat  containerWidth;
@property (nonatomic, assign) CGFloat  containerHeight;
@property (nonatomic, assign) CGFloat  arrowRelativePosition;
@property (nonatomic, assign) CGFloat  arrowAbsolutePosition;

@end

@implementation BRCPopUpMainTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNavigationBarChangeAlphaWhenScrolled = YES;
    self.title = [self componentTitle];
    [self.navigationController setNavigationBarHidden:YES];
    self.autoCutoffRelief = NO;
    self.autoFitContainerSize = NO;
    self.arrowCenterAlignToContainer = YES;
    self.offsetToAnchorView = 0;
    self.marginToAnchorView = 5;
    self.cornerRadius = 4;
    self.arrowRadius = 2;
    self.arrowWidth = 16;
    self.arrowHeight = 8;
    self.containerWidth = 100;
    self.containerHeight = 100;
    self.arrowAbsolutePosition = 12;
    self.arrowRelativePosition = -1;
}

- (void)setUpViews {
    [super setUpViews];
    self.popUpDirection = BRCPopUpDirectionLeft;
    weakify(self)
    [self addEnumControlWithItems:@[
        @"Left",
        @"Right",
        @"Top",
        @"Bottom"
    ] withTitle:@"key.main.test.section.title.direction" chageBlock:^(UISegmentedControl *control) {
        strongify(self)
        switch (control.selectedSegmentIndex) {
            case 0:
                self.popUpDirection = BRCPopUpDirectionLeft;
                break;
            case 1:
                self.popUpDirection = BRCPopUpDirectionRight;
                break;
            case 2:
                self.popUpDirection = BRCPopUpDirectionTop;
                break;
            case 3:
                self.popUpDirection = BRCPopUpDirectionBottom;
                break;
            default:
                break;
        }
    }];

    [self addEnumControlWithItems:@[
        @"None",
        @"Fade",
        @"Scale",
        @"Bounce",
        @"FadeScale",
        @"FadeBounce"
    ] withTitle:@"key.main.test.section.title.animation" chageBlock:^(UISegmentedControl *control) {
        strongify(self)
        self.animationStyle = control.selectedSegmentIndex;
    }];
    
    [self addEnumControlWithItems:@[
        @"Left",
        @"Center",
        @"Right"
    ] withTitle:@"key.main.test.section.title.alignment" chageBlock:^(UISegmentedControl *control) {
        strongify(self)
        self.alignmentStyle = control.selectedSegmentIndex;
    }];
    
    [self addEnumControlWithItems:@[
        @"ViewController",
        @"Window",
        @"View"
    ] withTitle:@"key.main.test.section.title.context" chageBlock:^(UISegmentedControl *control) {
        strongify(self)
        self.contextStyle = control.selectedSegmentIndex;
    }];
    
    [self addEnumControlWithItems:@[
        @"None",
        @"Interactive"
    ] withTitle:@"key.main.test.section.title.dismissmode" chageBlock:^(UISegmentedControl *control) {
        strongify(self)
        self.dismissMode = control.selectedSegmentIndex;
    }];
    
    [self addEnumControlWithItems:@[
        @"NO",
        @"YES"
    ] withTitle:@"key.main.test.section.title.cutoff" chageBlock:^(UISegmentedControl *control) {
        strongify(self)
        self.autoCutoffRelief = [@(control.selectedSegmentIndex) boolValue];
    }];
    
    [self addEnumControlWithItems:@[
        @"NO",
        @"YES"
    ] withTitle:@"key.main.test.section.title.autofitsize" chageBlock:^(UISegmentedControl *control) {
        strongify(self)
        self.autoFitContainerSize = [@(control.selectedSegmentIndex) boolValue];
    }];
    
    [self addEnumControlWithItems:@[
        @"YES",
        @"NO"
    ] withTitle:@"key.main.test.section.title.arrowcenter" chageBlock:^(UISegmentedControl *control) {
        strongify(self)
        self.arrowCenterAlignToContainer = [@(1 - control.selectedSegmentIndex) boolValue];
    }];
    
    [self addSliderControlWithTitle:@"offsetToAnchorView" desc:@"key.main.test.section.title.hoffset" valueArray:@[@(-20),@(40)] chageBlock:^(UISlider *control) {
        strongify(self)
        self.offsetToAnchorView = control.value;
    }];
    
    [self addSliderControlWithTitle:@"marginToAnchorView" desc:@"key.main.test.section.title.voffset" valueArray:@[@0,@20] chageBlock:^(UISlider *control) {
        strongify(self)
        self.marginToAnchorView = control.value;
    }];
    
    [self addSliderControlWithTitle:@"cornerRadius" desc:@"key.main.test.section.title.cornerradius" valueArray:@[@0,@30] chageBlock:^(UISlider *control) {
        strongify(self)
        self.cornerRadius = control.value;
    }];
    
    [self addSliderControlWithTitle:@"arrowRadius" desc:@"key.main.test.section.title.arrowradius" valueArray:@[@0,@30] chageBlock:^(UISlider *control) {
        strongify(self)
        self.arrowRadius = control.value;
    }];
    
    [self addSliderControlWithTitle:@"arrowWidth" desc:@"key.main.test.section.title.arrowW" valueArray:@[@0,@(30)] chageBlock:^(UISlider *control) {
        strongify(self)
        self.arrowWidth = control.value;
    }];
    
    [self addSliderControlWithTitle:@"arrowHeight" desc:@"key.main.test.section.title.arrowH" valueArray:@[@0,@30] chageBlock:^(UISlider *control) {
        strongify(self)
        self.arrowHeight = control.value;
    }];
    
    [self addSliderControlWithTitle:@"containerWidth" desc:@"key.main.test.section.title.containerW" valueArray:@[@0,@(kBRCScreenWidth)] chageBlock:^(UISlider *control) {
        strongify(self)
        self.containerWidth = control.value;
    }];
    
    [self addSliderControlWithTitle:@"containerHeight" desc:@"key.main.test.section.title.containerH" valueArray:@[@0,@(kBRCScreenHeight)] chageBlock:^(UISlider *control) {
        strongify(self)
        self.containerHeight = control.value;
    }];
    
    [self addSliderControlWithTitle:@"arrowRelativePosition" desc:@"key.main.test.section.title.arrowRP" valueArray:@[@0,@1] chageBlock:^(UISlider *control) {
        strongify(self)
        self.arrowRelativePosition = control.value;
    }];
    
    [self addSliderControlWithTitle:@"arrowAbsolutePosition" desc:@"key.main.test.section.title.arrowAP" valueArray:@[@(-40),@(80)] chageBlock:^(UISlider *control) {
        strongify(self)
        self.arrowAbsolutePosition = control.value;
    }];
    
    [self createButtonWithTitle:@"key.main.test.button.title" popUpStyle:^(BRCPopUper *popUp) {
        
    }];
}

- (void)createButtonWithTitle:(NSString *)title
                popUpStyle:(void (^)(BRCPopUper * popUp))popUpStyle{
    UIButton *button = [[UIButton alloc] init];
    NSString *buttonText = [NSString brctest_localizableWithKey:title];
    [button setTitle:buttonText forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor brtest_red]];
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    BRCPopUper *buttonpopUp = [[BRCPopUper alloc] initWithContentStyle:BRCPopUpContentStyleCustom];
    buttonpopUp.anchorView = button;
    buttonpopUp.delegate = self;
    popUpStyle(buttonpopUp);
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        buttonpopUp.cornerRadius = self.cornerRadius;
        buttonpopUp.offsetToAnchorView = self.offsetToAnchorView;
        buttonpopUp.marginToAnchorView = self.marginToAnchorView;
        buttonpopUp.arrowRadius = self.arrowRadius;
        buttonpopUp.arrowSize = CGSizeMake(self.arrowWidth, self.arrowHeight);
        buttonpopUp.containerHeight = self.containerHeight;
        buttonpopUp.containerWidth = self.containerWidth;
        buttonpopUp.arrowRelativePosition = self.arrowRelativePosition;
        buttonpopUp.arrowAbsolutePosition = self.arrowAbsolutePosition;
        buttonpopUp.autoCutoffRelief = self.autoCutoffRelief;
        buttonpopUp.autoFitContainerSize = self.autoFitContainerSize;
        buttonpopUp.arrowCenterAlignToAnchor = self.arrowCenterAlignToContainer;
        buttonpopUp.dismissMode = self.dismissMode;
        buttonpopUp.popUpDirection = self.popUpDirection;
        buttonpopUp.popUpAnimationType = self.animationStyle;
        buttonpopUp.contextStyle = self.contextStyle;
        buttonpopUp.contentAlignment = self.alignmentStyle;
        [buttonpopUp toggleDisplay];
    }];
    [self addTestView:button withTitle:buttonText height:50 width:kBRCScreenWidth/2 space:20];
}

#pragma mark - BRCPopUperDelegate

- (void)willHidePopUper:(BRCPopUper *)popUper withAchorView:(UIView *)anchorView {
    [BRCToast show:@"willHidePopUper"];
}

- (void)willShowPopUper:(BRCPopUper *)popUper withAchorView:(UIView *)anchorView {
    [BRCToast show:@"willShowPopUper"];
}

- (void)didShowPopUper:(BRCPopUper *)popUper withAchorView:(UIView *)anchorView {
    [BRCToast show:@"didShowPopUper"];
}

- (void)didHidePopUper:(BRCPopUper *)popUper withAchorView:(UIView *)anchorView {
    [BRCToast show:@"didHidePopUper"];
}

- (void)didUserDismissPopUper:(BRCPopUper *)popUper withAchorView:(UIView *)anchorView {
    [BRCToast show:@"didUserDismissPopUper"];
}

#pragma mark - debug

- (NSString *)componentTitle {
    return @"BRCPopUp";
}

- (NSString *)componentDescription {
    return [NSString brctest_localizableWithKey:@"key.main.test.main.title"];
}

- (CGFloat)leftPadding {
    return 15;
}

@end


