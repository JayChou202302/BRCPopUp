//
//  BRCAppDelegate.m
//  BRCPopUp
//
//  Created by zhixiongsun on 07/30/2021.
//  Copyright (c) 2021 zhixiongsun. All rights reserved.
//

#import "BRCAppDelegate.h"
#import "BRCViewRootController.h"
#import <FLEX/FLEXManager.h>

@implementation BRCAppDelegate

- (UIViewController *)rootController {
    return [BRCViewRootController new];
}

@end
