//
//  BRCTestRootTabBarViewController.m
//  BRCFastTest
//
//  Created by sunzhixiong on 2024/8/8.
//

#import "BRCTestRootTabBarViewController.h"
#import "UIColor+BRCFastTest.h"
#import "NSString+BRCTestLocalizable.h"

@interface BRCTestRootTabBarViewController ()

@end

@implementation BRCTestRootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brtest_contentWhite];
    NSArray *tabArray = [self tabImageArray];
    NSArray *tabTitleArray = [self tabTitleKeyArray];
    NSArray *vcArray = [self controllerClassArray];
    NSMutableArray *array = [NSMutableArray array];
    [tabArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __kindof UIViewController *vc;
        vc = [NSClassFromString(vcArray[idx]) new];
        vc.tabBarItem.image = [UIImage systemImageNamed:obj];
        vc.tabBarItem.title = [NSString brctest_localizableWithKey:tabTitleArray[idx]];
        [array addObject:[[UINavigationController alloc] initWithRootViewController:vc]];
    }];
    self.viewControllers = [array copy];
    self.delegate = self;
}

- (NSArray *)tabImageArray {
    return @[];
}

- (NSArray *)tabTitleKeyArray {
    return @[];
}

- (NSArray *)controllerClassArray {
    return @[];
}

@end
