//
//  BRCBubbleLayer.h
//  BRCPopUp
//
//  Created by sunzhixiong on 2025/4/6.
//

#import <QuartzCore/QuartzCore.h>
#import "BRCPopUpConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRCBubbleLayer : CALayer <BRCBubbleStyle>

- (void)updateLayer;

- (CGFloat)getArrowTopPointPosition:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
