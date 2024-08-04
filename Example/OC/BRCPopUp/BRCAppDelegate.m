//
//  BRCAppDelegate.m
//  BRCPopUp
//
//  Created by zhixiongsun on 07/30/2021.
//  Copyright (c) 2021 zhixiongsun. All rights reserved.
//

#import "BRCAppDelegate.h"
#import "BRCViewRootController.h"
#import <SDWebImage/SDWebImage.h>
#import <FLEX/FLEXManager.h>

@implementation BRCAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:[self rootController]];
    [self.window makeKeyAndVisible];
    [self setSDWebImageCacheConfig];
    [[FLEXManager sharedManager] showExplorer];
    return YES;
}

- (void)setSDWebImageCacheConfig{
    // 设置SDWebImage的最大内存缓存大小
    [SDImageCache sharedImageCache].config.maxMemoryCount = 80; // 20MB内存大小
    // 设置SDWebImage的最大磁盘缓存大小
    [SDImageCache sharedImageCache].config.maxDiskSize = 100 * 1024 * 1024;
    // 设置SDWebImage的缓存过期时间
    [SDImageCache sharedImageCache].config.maxDiskAge = 60 * 60 * 24 * 15; // 15天
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[SDImageCache sharedImageCache] clearMemory];
}

- (UIViewController *)rootController {
    return [BRCViewRootController new];
}

@end
