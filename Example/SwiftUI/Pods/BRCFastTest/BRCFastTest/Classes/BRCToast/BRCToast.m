//
//  BRCToast.m
//
//  Created by sunzhixiong on 2023/12/2.
//

#import "BRCToast.h"
#import <BRCFastTest/Masonry.h>
#import <BRCFastTest/MBProgressHUD.h>

@implementation BRCToast

+ (void)show:(NSString *)text{
    [self show:text druation:2.0];
}

+ (void)show:(NSString *)text druation:(CGFloat)druation{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *hud = [[MBProgressHUD alloc] init];
        [window addSubview:hud];
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(window);
            make.height.mas_greaterThanOrEqualTo(35);
        }];
        hud.label.text = text;
        hud.mode = MBProgressHUDModeText;
        hud.animationType = MBProgressHUDAnimationZoom;
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:druation];
    });
}

@end
