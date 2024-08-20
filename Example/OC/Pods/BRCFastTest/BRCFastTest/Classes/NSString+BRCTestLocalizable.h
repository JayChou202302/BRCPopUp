//
//  NSString+BRCTestLocalizable.h
//  BRCFastTest
//
//  Created by sunzhixiong on 2024/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BRCTestLocalizable)

+ (NSString *)brctest_localizableWithKey:(NSString *)key;

+ (NSString *)brctest_localizationStringWithFormat:(NSString *)key, ... ;

@end

NS_ASSUME_NONNULL_END
