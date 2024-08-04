//
//  NSString+Localizable.h
//  BRCPopUp_Example
//
//  Created by sunzhixiong on 2024/8/3.
//  Copyright © 2024 zhixiongsun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Localizable)

+ (NSString *)localizableWithKey:(NSString *)key;

+ (NSString *)localizationStringWithFormat:(NSString *)key, ... ;

@end

NS_ASSUME_NONNULL_END
