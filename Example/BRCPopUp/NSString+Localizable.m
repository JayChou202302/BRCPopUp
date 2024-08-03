//
//  NSString+Localizable.m
//  BRCPopUp_Example
//
//  Created by sunzhixiong on 2024/8/3.
//  Copyright © 2024 zhixiongsun. All rights reserved.
//

#import "NSString+Localizable.h"

@implementation NSString (Localizable)

+ (NSString *)localizableWithKey:(NSString *)key {
    return NSLocalizedString(key, @"");;
}

+ (NSString *)localizationStringWithFormat:(NSString *)key, ... {
    va_list args;
    id arg;
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    
    va_start(args, key);
    while ((arg = va_arg(args, id))) {
        if (arg) {
            [argsArray addObject:arg];
        }
    }
    va_end(args);
    
    NSString *localString = NSLocalizedString(key, @"");
    if ([localString containsString:@"%@"]) {
        NSString *formatString1 = [[NSString stringWithFormat:localString,argsArray] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        return [formatString1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return localString;
}

@end
