//
//  BRCPopUpMenu.h
//  BRCPopUp
//
//  Created by sunzhixiong on 2024/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRCPopUpMenuAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) id       image;
@property (nonatomic, copy) void(^onClickMenuAction)(BRCPopUpMenuAction *action);

+ (instancetype)actionWithTitle:(nullable NSString *)title
                          image:(nullable id)image
                        handler:(nullable void (^)(BRCPopUpMenuAction * action))handler;

@end

@interface BRCPopUpMenu : UIView

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIFont  *textFont;
@property (nonatomic, assign) BOOL    isNeedSeparator;
@property (nonatomic, copy)   void (^webImageLoadBlock)(UIImageView *imageView, NSURL *imageUrl);

+ (instancetype)menuWithActions:(NSArray<BRCPopUpMenuAction *> *)actions;

- (void)reloadView;

@end

NS_ASSUME_NONNULL_END
