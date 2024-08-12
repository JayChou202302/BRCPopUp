//
//  BRCDebugWindow.m
//  BRCFastTest
//
//  Created by sunzhixiong on 2024/8/8.
//

#import "BRCDebugWindow.h"
#import "UIColor+BRCFastTest.h"
#import "UIView+YYAdd.h"

#if DEBUG
#import <FLEX/FLEXManager.h>
#endif

#define kScreenBounds  [UIScreen mainScreen].bounds
#define kScreenSize    [UIScreen mainScreen].bounds.size
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface BRCDebugWindow()

@property (nonatomic, strong) UIButton *entranceButton;

@end

@implementation BRCDebugWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 200;
        self.rootViewController = UIViewController.new;
        self.entranceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.entranceButton.frame = CGRectMake(kScreenWidth - 55.f, kScreenHeight - 150, 50.0, 50.0);
        self.entranceButton.layer.cornerRadius = 25;
        self.entranceButton.clipsToBounds = YES;
        self.entranceButton.tintColor = [UIColor whiteColor];
        self.entranceButton.backgroundColor = [UIColor brtest_red];
        self.entranceButton.layer.zPosition = MAXFLOAT;
       [self.entranceButton setImage:[UIImage systemImageNamed:@"hammer"]
                        forState:UIControlStateNormal];
        [self.entranceButton addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *panRecognizer;
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(wasDragged:)];
        panRecognizer.cancelsTouchesInView = YES;
        [self.entranceButton addGestureRecognizer:panRecognizer];

        [self.rootViewController.view addSubview:self.entranceButton];
    }
    return self;
}

- (void)choose {
#if DEBUG
    [[FLEXManager sharedManager] toggleExplorer];
#endif
}

//手势事件 －－ 改变位置
- (void)wasDragged:(UIPanGestureRecognizer *)gesture {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:keyWindow];
        CGPoint newCenter = CGPointMake(gesture.view.center.x + translation.x,
                                        gesture.view.center.y + translation.y);
        if (newCenter.y + 20 > (kScreenHeight - 80) || newCenter.y < 110){
            return;
        }
       
        // 重置手势的translation
        [UIView animateWithDuration:0.05f animations:^{
            gesture.view.center = newCenter;
            [gesture setTranslation:CGPointZero inView:keyWindow];
        }];
    }
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
        [UIView animateWithDuration:0.1 animations:^{
            if (gesture.view.centerX > kScreenWidth / 2){
                gesture.view.centerX = kScreenWidth - 40;
            } else {
                gesture.view.centerX = 40;
            }
            [gesture setTranslation:CGPointZero inView:keyWindow];
        }];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint converted = [self convertPoint:point toView:self.entranceButton];
    return [self.entranceButton pointInside:converted withEvent:event];
}

- (BOOL)shouldAffectStatusBarAppearance
{
    return [self isKeyWindow];
}


@end

