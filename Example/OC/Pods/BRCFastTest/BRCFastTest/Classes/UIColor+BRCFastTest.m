//
//  UIColor+BRCFastTest.m
//  BRCFastTest
//
//  Created by sunzhixiong on 2024/8/8.
//

#import "UIColor+BRCFastTest.h"

#define BRCDesignedDynamic(lightColor,DarkColor)        \
^UIColor *(){                                                       \
    static UIColor *color;                              \
    static dispatch_once_t onceToken;                   \
    dispatch_once(&onceToken, ^{                        \
        color = [UIColor colorWithLightColor:lightColor darkColor:DarkColor];  \
    });                                                                                     \
    return color;                                                                           \
}()

#ifndef BRCColorHex
#define BRCColorHex(c)                                                                                                  \
    [UIColor colorWithRed:((c >> 16) & 0xFF) / 255.0 green:((c >> 8) & 0xFF) / 255.0 blue:((c)&0xFF) / 255.0 alpha:1.0]
#endif


@implementation UIColor (BRCFastTest)

+ (UIColor *)brtest_brandingOrange{
    return BRCDesignedDynamic(BRCColorHex(0xFFB400), BRCColorHex(0xFFD266));
}

+ (UIColor *)brtest_orange{
    return BRCDesignedDynamic(BRCColorHex(0xFF6F00), BRCColorHex(0xFFA866));
}

+(UIColor *)brtest_secondaryOrange{
    return BRCDesignedDynamic(BRCColorHex(0xFF9500), BRCColorHex(0xFFB866));
}

+ (UIColor *)brtest_red{
    return BRCDesignedDynamic(BRCColorHex(0xEE3B28),BRCColorHex(0xF37668));
}

+ (UIColor *)brtest_secondaryRed{
    return BRCDesignedDynamic(BRCColorHex(0xF5594A),BRCColorHex(0xF78A7F));
}

+ (UIColor *)brtest_cyan{
    return BRCDesignedDynamic(BRCColorHex(0x06AEBD),BRCColorHex(0x50C6D0));
}

+ (UIColor *)brtest_green{
    return BRCDesignedDynamic(BRCColorHex(0x4FB443),BRCColorHex(0x84CA7B));
}

+ (UIColor *)brtest_blue{
    return BRCDesignedDynamic(BRCColorHex(0x1136A6),BRCColorHex(0x5872C0));
}

+ (UIColor *)brtest_black{
    return BRCDesignedDynamic(BRCColorHex(0x0F294D),BRCColorHex(0xFFFFFF));
}

+ (UIColor *)brtest_secondaryBlack{
    return BRCDesignedDynamic(BRCColorHex(0x455873),BRCColorHex(0xB8C4D4));
}

+ (UIColor *)brtest_tertiaryBlack{
    return BRCDesignedDynamic(BRCColorHex(0x8592A6),BRCColorHex(0x99A6BA));
}

+ (UIColor *)brtest_gray{
    return BRCDesignedDynamic(BRCColorHex(0xACB4BF),BRCColorHex(0x5C697C));
}

+ (UIColor *)brtest_secondaryGray{
    return BRCDesignedDynamic(BRCColorHex(0xCED2D9),BRCColorHex(0x5C697C));
}

+ (UIColor *)brtest_white{
    return BRCDesignedDynamic(BRCColorHex(0xFFFFFF),BRCColorHex(0xFFFFFF));
}

+ (UIColor *)brtest_tertiaryGray{
    return BRCDesignedDynamic(BRCColorHex(0xDADFE6),BRCColorHex(0x434C59));
}

+ (UIColor *)brtest_quaternaryGray{
    return BRCDesignedDynamic(BRCColorHex(0xF0F2F5),BRCColorHex(0x0D131A));
}

+ (UIColor *)brtest_fifthGray{
    return BRCDesignedDynamic(BRCColorHex(0xF5F7FA),BRCColorHex(0x333B46));
}

+ (UIColor *)brtest_placeholderGray{
    return BRCDesignedDynamic(BRCColorHex(0xF0F2F5),BRCColorHex(0x333B46));
}

+ (UIColor *)brtest_lightOrange{
    return BRCDesignedDynamic(BRCColorHex(0xFFF7EB),BRCColorHex(0x50473B));
}

+ (UIColor *)brtest_contentWhite{
    return BRCDesignedDynamic(BRCColorHex(0xFFFFFF),BRCColorHex(0x333333));
}

+ (UIColor *)brtest_secondaryContentWhite{
    return BRCDesignedDynamic(BRCColorHex(0xFFFFFF),BRCColorHex(0x333B46));
}

+ (UIColor *)brtest_pink{
    return BRCDesignedDynamic(BRCColorHex(0xF94C86),BRCColorHex(0xFA82AA));
}

+ (UIColor *)brtest_gradationRed{
    return BRCDesignedDynamic(BRCColorHex(0xBA4338), BRCColorHex(0xF78A7F));
}

+ (UIColor *)brtest_gold {
    return BRCDesignedDynamic(BRCColorHex(0x996C00), BRCColorHex(0xC2A766));
}

+ (UIColor *)brtest_goldBrown {
    return BRCDesignedDynamic(BRCColorHex(0x673114), BRCColorHex(0xF4C498));
}

/// Light: #EB5600 , Dark: #FFA866
+ (UIColor *)brtest_deepOrange {
    return BRCDesignedDynamic(BRCColorHex(0xEB5600), BRCColorHex(0xFFA866));
}

/// Light: #D92917 , Dark: #F37668
+ (UIColor *)brtest_deepRed {
    return BRCDesignedDynamic(BRCColorHex(0xD92917), BRCColorHex(0xF37668));
}

/// Light: #05939F , Dark: #50C6D0
+ (UIColor *)brtest_deepCyan {
    return BRCDesignedDynamic(BRCColorHex(0x05939F), BRCColorHex(0x50C6D0));
}

/// Light: #EC3C77 , Dark: #FA82AA
+ (UIColor *)brtest_deepPink {
    return BRCDesignedDynamic(BRCColorHex(0xEC3C77), BRCColorHex(0xFA82AA));
}

/// Light: #6866DB , Dark: #9DA0ED
+ (UIColor *)brtest_deepPurple {
    return BRCDesignedDynamic(BRCColorHex(0x6866DB), BRCColorHex(0x9DA0ED));
}

+ (UIColor *)colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor{
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return darkColor;
            }else{
                return lightColor;
            }
        }];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned hexInt = 0;
    // 创建扫描器
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    // 扫描十六进制值
    [scanner scanHexInt:&hexInt];
    return [UIColor colorWithHex:hexInt alpha:1.0];
}

+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha {
    // 分解成RGB组件
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;

    return [UIColor colorWithRed:(CGFloat)r / 255.0
                           green:(CGFloat)g / 255.0
                            blue:(CGFloat)b / 255.0
                           alpha:alpha];
}

+ (NSArray *)componentTagColors {
    return @[
        @"#F5A623", // 亮橙色
        @"#7ED321", // 温和的绿
        @"#F8E71C", // 亮黄色
        @"#BD10E0", // 明亮的紫色
        @"#4A90E2", // 亮蓝色
        @"#D0021B", // 亮红色
        @"#FFB74D", // 温暖的橙色
        @"#4DB6AC", // 清新的青色
        @"#7986CB", // 温和的蓝紫色
        @"#4CAF50", // 亮绿色
        @"#E57373", // 温和的红色
        @"#BA68C8", // 温和的紫色
        @"#F48FB1", // 明亮的粉色
        @"#CE93D8", // 温和的紫色
        @"#B3E5FC", // 亮蓝色
        @"#F0F4C3" // 温暖的黄色
    ];
}


@end
