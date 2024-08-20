//
//  NSString+BRCTestLocalizable.m
//  BRCFastTest
//
//  Created by sunzhixiong on 2024/8/8.
//

#import "NSString+BRCTestLocalizable.h"

@implementation NSString (BRCTestLocalizable)

+ (NSString *)brctest_localizableWithKey:(NSString *)key {
    return [self brctest_localizationStringWithFormat:key,nil];
}

+ (NSString *)brctest_localizationStringWithFormat:(NSString *)key, ... {
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
