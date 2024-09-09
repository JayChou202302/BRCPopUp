//
//  BRCFlexTagBoxView.m
//  BRCFlexTagBox
//
//  Created by sunzhixiong on 2024/8/29.
//

#import "BRCFlexTagBoxView.h"

@class BRCFlexBoxCell;

NSString *const kBRCFlexBoxCellID = @"kBRCFlexBoxCellID";

void setLabelText(id text,UILabel *label) {
    if (![label isKindOfClass:[UILabel class]]) return;
    if ([text isKindOfClass:[NSString class]]) {
        label.text = text;
    } else if ([text isKindOfClass:[NSAttributedString class]]) {
        label.attributedText = text;
    }
}

CGSize sigleLineHeightForText(id text,UIFont *font,CGFloat maxWidth,UIEdgeInsets contentInsets) {
    static UILabel *textLabel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textLabel = [UILabel new];
        textLabel.numberOfLines = 1;
    });
    textLabel.font = font;
    setLabelText(text, textLabel);
    CGSize fitSize = [textLabel sizeThatFits:CGSizeMake(maxWidth, HUGE)];
    return CGSizeMake(ceil(fitSize.width) + contentInsets.left + contentInsets.right + 1, ceil(fitSize.height) + contentInsets.top + contentInsets.bottom + 1);
}

#pragma mark - layout

@interface BRCFlexLayout : UICollectionViewFlowLayout

@end

@implementation BRCFlexLayout

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    if (attributes.count == 1) {
        UICollectionViewLayoutAttributes *firstAttribute = attributes.firstObject;
        CGRect frame = firstAttribute.frame;
        frame.origin.x = self.sectionInset.left;
    } else {
        for (int i = 1; i < [attributes count]; ++i) {
            UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
            UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
            NSInteger maximumSpacing = self.minimumInteritemSpacing;
            NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
            if (origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width - self.sectionInset.right - self.sectionInset.left) {
                CGRect frame = currentLayoutAttributes.frame;
                frame.origin.x = origin + maximumSpacing;
                currentLayoutAttributes.frame = frame;
            }
        }
    }
   return [attributes copy];
}

@end

#pragma mark - cell

@interface BRCFlexBoxCell : UICollectionViewCell

@property (nonatomic, strong) BRCFlexTagStyle *defaultStyle;
@property (nonatomic, strong) UILabel         *titleLabel;
@property (nonatomic, strong) NSArray         *labelConstraints;

@end

@implementation BRCFlexBoxCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.labelConstraints = @[];
        [self.contentView addSubview:self.titleLabel];
        [self updateContentInsets];
    }
    return self;
}

- (void)updateContentInsets {
    [NSLayoutConstraint deactivateConstraints:self.labelConstraints];
    self.labelConstraints = @[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:self.defaultStyle.tagContentInsets.left],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-self.defaultStyle.tagContentInsets.right],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:self.defaultStyle.tagContentInsets.top],
        [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-self.defaultStyle.tagContentInsets.bottom]
    ];
    [NSLayoutConstraint activateConstraints:self.labelConstraints];
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    self.defaultStyle.tagContentInsets = contentInsets;
    [self updateContentInsets];
}

#pragma mark - props

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end

#pragma mark - style

@implementation BRCFlexTagStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tagTextColor = [UIColor blackColor];
        _tagTextFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
        _tagMaxWidth = HUGE;
        _tagBackgroundColor = [UIColor clearColor];
        _tagBorderColor = [UIColor clearColor];
        _tagBorderWidth = 0;
        _tagShadowColor = [UIColor clearColor];
        _tagShadowRadius = 0;
        _tagShadowOpacity = 1;
        _tagCornerRadius = 0;
        _tagShadowOffset = CGSizeZero;
        _tagContentInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        _tagTextAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)configerWithCell:(BRCFlexBoxCell *)cell {
    if ([self.tagTextColor isKindOfClass:[UIColor class]]) {
        cell.titleLabel.textColor = self.tagTextColor;
    }
    if ([self.tagTextFont isKindOfClass:[UIFont class]]) {
        cell.titleLabel.font = self.tagTextFont;
    }
    cell.titleLabel.textAlignment = self.tagTextAlignment;
    if ([self.tagBackgroundColor isKindOfClass:[UIColor class]]) {
        cell.contentView.backgroundColor = self.tagBackgroundColor;
    }
    if ([self.tagBorderColor isKindOfClass:[UIColor class]]) {
        cell.contentView.layer.borderColor = self.tagBorderColor.CGColor;
    }
    if ([self.tagShadowColor isKindOfClass:[UIColor class]]) {
        cell.contentView.layer.shadowColor = self.tagShadowColor.CGColor;
    }
    cell.contentView.layer.borderWidth = self.tagBorderWidth;
    cell.contentView.layer.shadowOffset = self.tagShadowOffset;
    cell.contentView.layer.shadowRadius = self.tagShadowRadius;
    cell.contentView.layer.shadowOpacity = self.tagShadowOpacity;
    cell.contentView.layer.cornerRadius = self.tagCornerRadius;
    [cell setContentInsets:self.tagContentInsets];
}

- (BOOL)safeEqual:(id)object1 object2:(id)object2 {
    if (object1 != nil && object2 != nil) {
        return [object1 isEqual:object2];
    }
    return NO;
}

- (BOOL)isEqual:(id)other
{
    if ([other isKindOfClass:[BRCFlexTagStyle class]]) {
        BRCFlexTagStyle *otherStyle = (BRCFlexTagStyle *)other;
        return
        [self safeEqual:self.tagBorderColor object2:otherStyle.tagBorderColor] &&
        [self safeEqual:@(self.tagBorderWidth) object2:@(otherStyle.tagBorderWidth)] &&
        [self safeEqual:@(self.tagShadowRadius) object2:@(otherStyle.tagShadowRadius)] &&
        [self safeEqual:@(self.tagCornerRadius) object2:@(otherStyle.tagCornerRadius)] &&
        [self safeEqual:self.tagTextColor object2:otherStyle.tagTextColor] &&
        [self safeEqual:self.tagBackgroundColor object2:otherStyle.tagBackgroundColor] &&
        [self safeEqual:self.tagBorderColor object2:otherStyle.tagBorderColor] &&
        [self safeEqual:self.tagShadowColor object2:otherStyle.tagShadowColor] &&
        [self safeEqual:self.tagTextFont object2:otherStyle.tagTextFont] &&
        [self safeEqual:@(self.tagMaxWidth) object2:@(otherStyle.tagMaxWidth)] &&
        [self safeEqual:@(self.tagShadowOffset) object2:@(otherStyle.tagShadowOffset)] &&
        UIEdgeInsetsEqualToEdgeInsets(self.tagContentInsets, otherStyle.tagContentInsets) &&
        self.tagTextAlignment == otherStyle.tagTextAlignment;
    }
    return NO;
}

@end

#pragma mark - model

@implementation BRCFlexTagModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _style = [BRCFlexTagStyle new];
    }
    return self;
}

- (void)configerWithCell:(BRCFlexBoxCell *)cell {
    if (![cell.titleLabel isKindOfClass:[UILabel class]]) return;
    setLabelText(self.text, cell.titleLabel);
    if ([self.style isKindOfClass:[BRCFlexTagStyle class]]) {
        [self.style configerWithCell:cell];
    }
}

@end


#pragma mark - box

@interface BRCFlexTagBoxView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BRCFlexLayout    *collectionLayout;
@property (nonatomic, strong) NSMutableArray   *dataSource;

@end

@implementation BRCFlexTagBoxView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self addSubview:self.collectionView];
        [self updateCollectionViewConstraints];
    }
    return self;
}

- (void)commonInit {
    _lineSpacing = 5;
    _itemSpacing = 5;
    _dataSource = [NSMutableArray array];
    _contentInsets = UIEdgeInsetsZero;
    _defaultTagStyle = [BRCFlexTagStyle new];
}

- (void)updateCollectionViewConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:self.contentInsets.left],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-self.contentInsets.right],
        [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor constant:self.contentInsets.top],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-self.contentInsets.bottom]
    ]];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGSizeEqualToSize(self.contentSize, CGSizeZero)) {
        [NSLayoutConstraint activateConstraints:@[
            [self.collectionView.widthAnchor constraintEqualToConstant:self.contentSize.width],
            [self.collectionView.heightAnchor constraintEqualToConstant:self.contentSize.height],
        ]];
    }
}

#pragma mark - public

- (void)setTagList:(NSArray *)tagList {
    if (![tagList isKindOfClass:[NSArray class]]) return;
    if ([self.dataSource isEqualToArray:tagList]) return;
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:tagList];
    [self reloadView];
}

- (void)reloadView {
    [self.collectionView reloadData];
    [self updateCollectionViewConstraints];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item < self.dataSource.count) {
        id object = self.dataSource[indexPath.item];
        NSString *text = object;
        UIFont *textFont = self.defaultTagStyle.tagTextFont;
        CGFloat maxWidth = self.defaultTagStyle.tagMaxWidth;
        UIEdgeInsets contentInsets = self.defaultTagStyle.tagContentInsets;
        if ([object isKindOfClass:[BRCFlexTagModel class]] &&
            [[(BRCFlexTagModel *)object style] isKindOfClass:[BRCFlexTagStyle class]]) {
            maxWidth = [(BRCFlexTagModel *)object style].tagMaxWidth;
            contentInsets = [(BRCFlexTagModel *)object style].tagContentInsets;
            text = [(BRCFlexTagModel *)object text];
            textFont = [(BRCFlexTagModel *)object style].tagTextFont;
        }
        return sigleLineHeightForText(text,textFont, maxWidth, contentInsets);
    }
    return CGSizeMake(0, 0);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectTagWithIndex:inTagBox:)]) {
        [self.delegate didSelectTagWithIndex:indexPath.item inTagBox:self];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BRCFlexBoxCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBRCFlexBoxCellID forIndexPath:indexPath];
    cell.defaultStyle = self.defaultTagStyle;
    if (indexPath.item < self.dataSource.count) {
        id object = self.dataSource[indexPath.row];
        if ([object isKindOfClass:[BRCFlexTagModel class]]) {
            [(BRCFlexTagModel *)object configerWithCell:cell];
        } else {
            setLabelText(object, cell.titleLabel);
            [self.defaultTagStyle configerWithCell:cell];
        }
    }
    return cell;
}

#pragma mark - setter

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    [self updateCollectionViewConstraints];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.collectionView.backgroundColor = backgroundColor;
}

#pragma mark - getter

- (CGSize)contentSize {
    return self.collectionLayout.collectionViewContentSize;
}

#pragma mark - props

- (UICollectionView *)collectionView{
    if (!_collectionView){
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[BRCFlexBoxCell class] forCellWithReuseIdentifier:kBRCFlexBoxCellID];
    }
    return _collectionView;
}

- (BRCFlexLayout *)layout{
    if (!_collectionLayout){
        BRCFlexLayout *layout = [BRCFlexLayout new];
        layout.minimumLineSpacing = self.lineSpacing;
        layout.minimumInteritemSpacing = self.itemSpacing;
        _collectionLayout = layout;
    }
    return _collectionLayout;
}

@end
