//
//  BRCFlexTagBoxView.h
//  BRCFlexTagBox
//
//  Created by sunzhixiong on 2024/8/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BRCFlexTagBoxView;

/// The Delegate For TagBox Event;
@protocol BRCFlexTagBoxDelegate <NSObject>

- (void)didSelectTagWithIndex:(NSInteger)index inTagBox:(BRCFlexTagBoxView *)tagBox NS_SWIFT_NAME(didSelectTagWithIndex(_:withTagBox:));

@end

/// The Style For Tag
@interface BRCFlexTagStyle : NSObject

@property (nonatomic, strong) UIColor *tagTextColor;
@property (nonatomic, strong) UIFont  *tagTextFont;
@property (nonatomic, strong) UIColor *tagBorderColor;
@property (nonatomic, strong) UIColor *tagBackgroundColor;
@property (nonatomic, strong) UIColor *tagShadowColor;
@property (nonatomic, assign) CGSize  tagShadowOffset;
@property (nonatomic, assign) CGFloat tagShadowOpacity;
@property (nonatomic, assign) CGFloat tagShadowRadius;
@property (nonatomic, assign) CGFloat tagMaxWidth;
@property (nonatomic, assign) CGFloat tagBorderWidth;
@property (nonatomic, assign) CGFloat tagCornerRadius;
@property (nonatomic, assign) UIEdgeInsets tagContentInsets;
@property (nonatomic, assign) NSTextAlignment tagTextAlignment;

@end

/// The Tag Model
@interface BRCFlexTagModel : NSObject

@property (nonatomic, strong) BRCFlexTagStyle *style;
@property (nonatomic, strong) id              text;

@end


@interface BRCFlexTagBoxView : UIView

@property (nonatomic, assign) UIEdgeInsets              contentInsets;
@property (nonatomic, weak)   id<BRCFlexTagBoxDelegate> delegate;

/**
 * LineSpacing / 行间距
 * default is `5`
 */
@property (nonatomic, assign) CGFloat lineSpacing;

/**
 * TagSpacing / 标签之间的间距
 * default is `5`
 */
@property (nonatomic, assign) CGFloat itemSpacing;

/**
 * Default Tag Style / 默认所有标签的样式
 */
@property (nonatomic, strong) BRCFlexTagStyle *defaultTagStyle;

/**
 * Content Size / 内部自适应的容器大小
 */
@property (nonatomic, assign, readonly) CGSize contentSize;

/**
 * Set Data Source / 设置标签
 * @param tagList [NSString/NSAttributedString/BRCFlexTagModel]
 */
- (void)setTagList:(NSArray *)tagList;


/**
 * Reload TagBox View / 刷新视图
 */
- (void)reloadView;

@end

NS_ASSUME_NONNULL_END
