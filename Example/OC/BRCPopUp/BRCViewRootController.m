//
//  BRCViewController.m
//  BRCPopUp
//
//  Created by zhixiongsun on 07/30/2021.
//  Copyright (c) 2021 zhixiongsun. All rights reserved.
//

#import "BRCViewRootController.h"
#import <BRCFastTest/NSString+BRCTestLocalizable.h>
#import <BRCPopUp/UIView+BRCPopUp.h>
#import <BRCPopUp/BRCPopUper.h>
#import <BRCFastTest/Masonry.h>
#import <BRCFastTest/UIControl+YYAdd.h>
#import <BRCFastTest/YYKitMacro.h>
#import <BRCFastTest/UIBarButtonItem+YYAdd.h>

@interface BRCViewRootController ()
<UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray<BRCPopUper *>   *popUpArray;

@end

@implementation BRCViewRootController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.popUpArray enumerateObjectsUsingBlock:^(BRCPopUper * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj hide];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popUpArray = [NSMutableArray array];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *targetView = (UIView *)[obj performSelector:@selector(view)];
        BRCPopUper *popUp = [[BRCPopUper alloc] initWithContentStyle:BRCPopUpContentStyleText];
        popUp.anchorView = targetView;
        popUp.popUpDirection = BRCPopUpDirectionTop;
        popUp.cornerRadius = 10;
        popUp.contentAlignment = BRCPopUpContentAlignmentCenter;
        popUp.arrowRelativePosition = 0.5;
        [popUp.contentLabel setTextAlignment:NSTextAlignmentCenter];
        [popUp setContentText:[NSString brctest_localizationStringWithFormat:@"key.main.tab.selectTab",@(idx),nil]];
        [self.popUpArray addObject:popUp];
    }];
}

#pragma mark - UITabBarDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSInteger index = self.selectedIndex;
    [self.popUpArray enumerateObjectsUsingBlock:^(BRCPopUper * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            [obj showAndHideAfter:1.5];
        } else {
            [obj hide];
        }
    }];
}

#pragma mark - debug

- (NSArray *)tabImageArray {
    return @[@"house",@"chevron.up",@"chevron.down"];
}

- (NSArray *)tabTitleKeyArray {
    return @[@"key.main.tab.test",
             @"key.main.tab.popup",
             @"key.main.tab.down"];
}

- (NSArray *)controllerClassArray {
    return @[
        @"BRCPopUpMainTestViewController",
        @"BRCPopUperExampleTestViewController",
        @"BRCPopUperInputTestViewController",
    ];
}

@end

