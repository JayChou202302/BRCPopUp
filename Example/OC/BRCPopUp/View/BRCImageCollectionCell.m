//
//  BRCImageCollectionCell.m
//  BRCDropDown_Example
//
//  Created by sunzhixiong on 2024/5/9.
//  Copyright © 2024 zhixiongsun. All rights reserved.
//

#import "BRCImageCollectionCell.h"
#import <Masonry/Masonry.h>

@implementation BRCImageCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 10;
        _imageView.layer.cornerCurve = kCACornerCurveContinuous;
    }
    return _imageView;
}

@end
