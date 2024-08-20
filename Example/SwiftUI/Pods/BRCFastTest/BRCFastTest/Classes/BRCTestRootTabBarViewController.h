//
//  BRCTestRootTabBarViewController.h
//  BRCFastTest
//
//  Created by sunzhixiong on 2024/8/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRCTestRootTabBarViewController : UITabBarController
<UITabBarControllerDelegate>
- (NSArray *)tabImageArray;
- (NSArray *)tabTitleKeyArray;
- (NSArray *)controllerClassArray;
@end

NS_ASSUME_NONNULL_END
