//
//  BRCViewController.m
//  BRCPopUp
//
//  Created by zhixiongsun on 07/30/2021.
//  Copyright (c) 2021 zhixiongsun. All rights reserved.
//

#import "BRCViewRootController.h"
#import "NSString+Localizable.h"
#import <BRCPopUp/UIView+BRCPopUp.h>
#import <BRCPopUp/BRCPopUper.h>
#import <Masonry/Masonry.h>
#import <YYKit/UIControl+YYAdd.h>
#import <YYKit/YYKitMacro.h>
#import <YYKit/UIBarButtonItem+YYAdd.h>

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
    NSArray *tabArray = @[@"house",@"chevron.up",@"chevron.down"];
    NSArray *tabTitleArray = @[@"key.main.tab.test",
                               @"key.main.tab.popup",
                               @"key.main.tab.down"];
    NSArray *vcArray = @[
        @"BRCPopUpMainTestViewController",
        @"BRCPopUperExampleTestViewController",
        @"BRCPopUperInputTestViewController",
    ];
    NSMutableArray *array = [NSMutableArray array];
    self.popUpArray = [NSMutableArray array];
    [tabArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __kindof UIViewController *vc;
        vc = [NSClassFromString(vcArray[idx]) new];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.tabBarItem.image = [UIImage systemImageNamed:obj];
        vc.tabBarItem.title = [NSString localizableWithKey:tabTitleArray[idx]];
        [array addObject:[[UINavigationController alloc] initWithRootViewController:vc]];
    }];
    self.viewControllers = [array copy];
    self.delegate = self;
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *targetView = (UIView *)[obj performSelector:@selector(view)];
        BRCPopUper *popUp = [[BRCPopUper alloc] initWithContentStyle:BRCPopUpContentStyleText];
        popUp.anchorView = targetView;
        popUp.popUpDirection = BRCPopUpDirectionTop;
        popUp.cornerRadius = 10;
        popUp.contentAlignment = BRCPopUpContentAlignmentCenter;
        popUp.arrowRelativePosition = 0.5;
        [popUp.contentLabel setTextAlignment:NSTextAlignmentCenter];
        [popUp setContentText:[NSString localizationStringWithFormat:@"key.main.tab.selectTab",@(idx),nil]];
        [self.popUpArray addObject:popUp];
    }];
}

#pragma mark - UITabBarDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSInteger index = self.selectedIndex;
    [self.popUpArray enumerateObjectsUsingBlock:^(BRCPopUper * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            [obj showAndHideAfterDelay:1.5];
        } else {
            [obj hide];
        }
    }];
}

@end

