//
//  BRCToast.h
//
//  Created by sunzhixiong on 2023/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRCToast : UIView

+ (void)show:(NSString *)text;

+ (void)show:(NSString *)text druation:(CGFloat)druation;

@end

NS_ASSUME_NONNULL_END
