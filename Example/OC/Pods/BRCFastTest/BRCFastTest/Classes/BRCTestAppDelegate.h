//
//  BRCTestAppDelegate.h
//  BRCFastTest
//
//  Created by sunzhixiong on 2024/8/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRCTestAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

- (UIViewController *)rootController;

- (BOOL)isNeedDebugWindow;

@end

NS_ASSUME_NONNULL_END
