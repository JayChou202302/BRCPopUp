//
//  BRCPopUpMenu.m
//  BRCPopUp
//
//  Created by sunzhixiong on 2024/8/22.
//

#import "BRCPopUpMenu.h"

NSString *const kBRCPopUpMenuCellID = @"kBRCPopUpMenuCellID";

@implementation BRCPopUpMenuAction

+ (instancetype)actionWithTitle:(NSString *)title image:(id)image handler:(void (^)(BRCPopUpMenuAction *))handler {
    __kindof BRCPopUpMenuAction *action = [[self alloc] init];
    action.title = title;
    action.image = image;
    action.onClickMenuAction = handler;
    return action;
}

@end

@interface BRCPopUpMenuCell : UITableViewCell
@property (nonatomic, strong) UIView *separatorLineView;
@end

@implementation BRCPopUpMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.separatorLineView];
        [NSLayoutConstraint activateConstraints:@[
            [self.separatorLineView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
            [self.separatorLineView.heightAnchor constraintEqualToConstant:1],
            [self.separatorLineView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            [self.separatorLineView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
            [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
            [self.imageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
            [self.imageView.widthAnchor constraintEqualToConstant:20],
            [self.imageView.heightAnchor constraintEqualToConstant:20],
            
            [self.textLabel.leadingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor constant:5],
            [self.textLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
            [self.textLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [self.textLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
        ]];
    }
    return self;
}

- (void)updateSubViewConstraints {
    if (self.imageView.image == nil) {
        [NSLayoutConstraint activateConstraints:@[
            [self.imageView.widthAnchor constraintEqualToConstant:0],
            [self.imageView.heightAnchor constraintEqualToConstant:0],
        ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
            [self.imageView.widthAnchor constraintEqualToConstant:20],
            [self.imageView.heightAnchor constraintEqualToConstant:20],
        ]];
    }
}

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [UIView new];
        _separatorLineView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _separatorLineView;
}

@end

@interface BRCPopUpMenu ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<BRCPopUpMenuAction *> *menuActions;

@end

@implementation BRCPopUpMenu

+ (instancetype)menuWithActions:(NSArray<BRCPopUpMenuAction *> *)actions {
    BRCPopUpMenu *menu = [[self alloc] initWithFrame:CGRectZero];
    if ([actions isKindOfClass:[NSArray class]]) {
        [menu.menuActions addObjectsFromArray:actions];
    }
    return menu;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    _isNeedSeparator = YES;
    _textFont = [UIFont boldSystemFontOfSize:15.0];
    _foregroundColor = [UIColor blackColor];
    [self addSubview:self.tableView];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)reloadView {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.menuActions.count) {
        BRCPopUpMenuAction *action = self.menuActions[indexPath.row];
        if (action.onClickMenuAction) action.onClickMenuAction(action);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuActions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    BRCPopUpMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kBRCPopUpMenuCellID forIndexPath:indexPath];
    if ([cell isKindOfClass:[UITableViewCell class]] &&
        indexPath.row < self.menuActions.count) {
        BRCPopUpMenuAction *action = self.menuActions[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = action.title;
        if ([action.image isKindOfClass:[UIImage class]]) {
            cell.imageView.image = action.image;
        } else if ([action.image isKindOfClass:[NSString class]]) {
            NSURL *url = [NSURL URLWithString:action.image];
            if (self.webImageLoadBlock) self.webImageLoadBlock(cell.imageView, url);
        } else if ([action.image isKindOfClass:[NSURL class]]) {
            if (self.webImageLoadBlock) self.webImageLoadBlock(cell.imageView, action.image);
        }
        cell.textLabel.font = self.textFont;
        cell.textLabel.textColor = self.foregroundColor;
        cell.imageView.tintColor = self.foregroundColor;
        cell.separatorLineView.backgroundColor = tableView.separatorColor;
        cell.separatorLineView.hidden = !self.isNeedSeparator;
        [cell updateSubViewConstraints];
    }
    return cell;
}

- (void)setLineColor:(UIColor *)lineColor {
    self.tableView.separatorColor = lineColor;
}

#pragma mark - props

- (NSMutableArray *)menuActions {
    if (!_menuActions) {
        _menuActions = [NSMutableArray array];
    }
    return _menuActions;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor systemGray5Color];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[BRCPopUpMenuCell class] forCellReuseIdentifier:kBRCPopUpMenuCellID];
    }
    return _tableView;
}

@end
