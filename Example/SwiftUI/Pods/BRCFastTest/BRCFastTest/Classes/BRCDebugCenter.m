//
//  BRCDebugCenter.m
//  BRCFastTest
//
//  Created by sunzhixiong on 2024/8/8.
//

#import "BRCDebugCenter.h"
#import "BRCDebugWindow.h"

@interface BRCDebugCenter()

@property (nonatomic, strong) BRCDebugWindow *window;

@end

@implementation BRCDebugCenter

+ (BRCDebugCenter *)share{
    static dispatch_once_t onceToken;
    static BRCDebugCenter *center;
    dispatch_once(&onceToken, ^{
        center = [[BRCDebugCenter alloc] init];
        center.window = [[BRCDebugWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        center.window.hidden = YES;
    });
    return center;
}


- (void)show {
    [self.window makeKeyAndVisible];
    self.window.hidden = NO;
}

- (void)dismiss {
    [self.window resignKeyWindow];
    self.window = nil;
}

@end
