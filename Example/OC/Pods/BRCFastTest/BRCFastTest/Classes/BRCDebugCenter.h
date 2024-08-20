//
//  BRCDebugCenter.h
//  BRCFastTest
//
//  Created by sunzhixiong on 2024/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRCDebugCenter : NSObject

+ (BRCDebugCenter *)share;

- (void)show;

- (void)dismiss ;

@end

NS_ASSUME_NONNULL_END
