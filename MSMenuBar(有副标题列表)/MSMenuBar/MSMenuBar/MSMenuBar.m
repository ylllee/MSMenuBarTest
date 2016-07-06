//
//  MSMenuBar.m
//  MSMenuBar
//
//  Created by limingshan on 16/5/30.
//  Copyright © 2016年 limingshan. All rights reserved.
//

#import "MSMenuBar.h"

@implementation MSMenuBar

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"_menuEditButton.selected"];
    [self removeObserver:self forKeyPath:@"_menuEditButton.titleLabel.text"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置默认值
        [self _defaultValue];
    }
    return self;
}

//设置默认值
- (void)_defaultValue {
    _menuBarHeight = 40;
    _menuBarTitleNormalFont = [UIFont systemFontOfSize:14];
    _menuBarTitleSelectedFont = [UIFont boldSystemFontOfSize:14];
    _menuTitleSelectedLineColor = [UIColor blueColor];
    _menuTitleSelectedColor = [UIColor colorWithRed:51 / 255.0 green:158 / 255.0 blue:210 / 255.0 alpha:1];
    _menuTitleNormalColor = [UIColor lightGrayColor];
    _menuLayerBorderWidth = 1;
    _menuLayerBorderColor = [UIColor blueColor];
    _myTeamButton_Y = kMenu_height + 64;
    
    //创建“我的分组”内容视图
    if (_myTeamContentView == nil) {
        _myTeamContentView = [[UIView alloc] initWithFrame:CGRectMake(0, _menuBarHeight, self.frame.size.width, self.frame.size.height - _menuBarBgView.frame.size.height)];
        _myTeamContentView.backgroundColor = [UIColor clearColor];
    }
    [self addSubview:_myTeamContentView];
    _myTeamContentView.hidden = YES;
}

#pragma mark ========= 菜单栏的设置 =========

//创建菜单栏
- (void)_initMenuBar {
    // 0.菜单栏背景视图
    _menuBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _menuBarHeight)];
    _menuBarBgView.backgroundColor = [UIColor whiteColor];
    _menuBarBgView.layer.borderWidth = _menuLayerBorderWidth;
    _menuBarBgView.layer.borderColor = _menuLayerBorderColor.CGColor;
    [self addSubview:_menuBarBgView];
    // 1.创建菜单滚动视图
    CGFloat editButtonWidth = kScreen_width > 320 ? (kMenuEditButton_width + 10) : kMenuEditButton_width;
    _menuBarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - editButtonWidth, _menuBarHeight)];
    _menuBarScrollView.delegate = self;
    _menuBarScrollView.showsHorizontalScrollIndicator = NO;
    _menuBarScrollView.showsVerticalScrollIndicator = NO;
    _menuBarScrollView.backgroundColor = [UIColor clearColor];
    [_menuBarBgView addSubview:_menuBarScrollView];
    
    // 2.创建左右遮罩视图
    // 左侧视图
    _maskLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, 20, _menuBarHeight - 2)];
    _maskLeftImageView.image = [[UIImage imageNamed:@"msmenuBar_maskView_white_l.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:10];
    [_menuBarBgView addSubview:_maskLeftImageView];
    // 右侧视图
    _maskRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_menuBarScrollView.frame.size.width - 19, 1, 20, _menuBarHeight - 2)];
    _maskRightImageView.image = [[UIImage imageNamed:@"msmenuBar_maskView_white_r.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:10];
//    [_menuBarBgView addSubview:_maskRightImageView];
    // 3.编辑按钮 team_edit-4.7@2x.png 46 46 _menuBarTitleNormalFont
    _menuEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuEditButton.frame = CGRectMake(kScreen_width - editButtonWidth - 20 - 10, 1, editButtonWidth, kMenu_height - 2);
    _menuEditButton.backgroundColor = [UIColor whiteColor];
    [_menuEditButton setTitle:@"我的分组" forState:UIControlStateNormal];
    _menuEditButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _menuEditButton.titleLabel.font = [UIFont systemFontOfSize:kMenuTitle_font];
    //设置编辑按钮字体颜色
    if ([_menuEditButton.titleLabel.text isEqualToString:@"我的分组"]) {
        [_menuEditButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_menuEditButton setTitleColor:kTitleBgColor forState:UIControlStateSelected];
    }else {
        [_menuEditButton setTitleColor:kTitleBgColor forState:UIControlStateNormal];
        [_menuEditButton setTitleColor:kTitleBgColor forState:UIControlStateSelected];
    }
    [_menuEditButton addTarget:self action:@selector(menuBarEidtButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_menuBarBgView addSubview:_menuEditButton];
    //左侧分割线
    CALayer *menuEditButtonLayer = [CALayer layer];
    menuEditButtonLayer.frame = CGRectMake(0, 0, 1, _menuEditButton.frame.size.height);
    menuEditButtonLayer.backgroundColor = kColorWith(214, 215, 220, 1).CGColor;
    [_menuEditButton.layer addSublayer:menuEditButtonLayer];
    
    //小三角 创建一个图片
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_menuEditButton.frame.size.width + 7, (_menuEditButton.frame.size.height - 5) / 2.0, 10, 5)];
    _iconImageView.image = [UIImage imageNamed:@"sanjiao-n4.7.png"];
    [_menuEditButton addSubview:_iconImageView];
    //给小三角添加点击事件
    _triangleTapView = [[UIView alloc] initWithFrame:CGRectMake(_menuEditButton.right, _menuEditButton.top, kScreen_width - _menuEditButton.right, _menuEditButton.height)];
    _triangleTapView.backgroundColor = [UIColor clearColor];
    _triangleTapView.multipleTouchEnabled = YES;
    UITapGestureRecognizer *triangleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuBarEidtButtonAction:)];
    [_triangleTapView addGestureRecognizer:triangleTap];
    [_menuBarBgView addSubview:_triangleTapView];
    
    //注册观察者
    [self addObserver:self forKeyPath:@"_menuEditButton.selected" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"_menuEditButton.titleLabel.text" options:NSKeyValueObservingOptionNew context:nil];
    
    //菜单栏不发生自动滚动的临界值
    _scroll_max = self.bounds.size.width - _maskLeftImageView.bounds.size.width - kMenuEditButton_width - 50;
    // 4.选中下划线
    _menuSelectedLine = [[UIView alloc] initWithFrame:CGRectZero];
    _menuSelectedLine.backgroundColor = _menuTitleSelectedLineColor;
}

//创建菜单栏
- (void)_initMenuBarItems {
    // 1.移除滑动视图所有的子视图
    for (UIView *subView in _menuBarScrollView.subviews) {
        // 从父视图上移除当前子视图
        [subView removeFromSuperview];
    }
    
    _allMenuCell = [NSMutableArray array];
    // 2.根据文本标题创建滑动视图的内容
    for (int i = 0; i < _menuTitles.count; i++) {
        // 01 创建文本视图
        UILabel *menuCell = [[UILabel alloc] initWithFrame:CGRectZero];
        //保存menuCell
        [_allMenuCell addObject:menuCell];
        menuCell.font = _menuBarTitleNormalFont;
        menuCell.textColor = _menuTitleNormalColor;
        menuCell.backgroundColor = [UIColor clearColor];
        menuCell.tag = MSMenuInitTag + i;
        // 添加点击事件
        menuCell.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuCellTapAction:)];
        [menuCell addGestureRecognizer:tap];
        // 02 设置文本内容
        menuCell.text = _menuTitles[i];
        // 设置视图文本内容自适应
        // 获取文本的尺寸
        CGSize menuTitleSize = [_menuTitles[i] sizeWithAttributes:@{NSFontAttributeName:_menuBarTitleSelectedFont}];
        menuCell.frame = CGRectMake(0, 0, menuTitleSize.width + .1, _menuBarHeight - 2);
        // 03 获取前一个文本视图
        UILabel *beforeMenuCell = [_menuBarScrollView.subviews lastObject];
        CGFloat beforeMenuCell_right = beforeMenuCell.frame.origin.x + beforeMenuCell.frame.size.width;
        // 04 设置当前文本视图的大小和位置
        menuCell.frame = CGRectMake(beforeMenuCell_right + MSMenuBarTitleSpace, 0, menuCell.frame.size.width, _menuBarHeight - 2);
        [_menuBarScrollView addSubview:menuCell];
        // 05 设置滑动视图内容视图的大小
        if (i == _menuTitles.count - 1) {
            // 当前循环创建了最后一个文本视图
            // 获取当文本视图右边的位置
            CGFloat menuCell_right = menuCell.frame.origin.x + menuCell.frame.size.width;
            float contentSize_w = MAX(_menuBarScrollView.frame.size.width + 1, menuCell_right + MSMenuBarTitleSpace);
            _menuBarScrollView.contentSize = CGSizeMake(contentSize_w, _menuBarScrollView.frame.size.height);
        }
        // 06 设置选中视图位置和大小
        if (i == _menuCellSelectedIndex) {
            // 01 设置选中视图的大小和位置
            _menuSelectedLine.frame = CGRectMake(menuCell.frame.origin.x, _menuBarHeight - 3, menuCell.frame.size.width, 2);
//            [_menuBarScrollView addSubview:_menuSelectedLine];
            // 02 设置选中文本
            menuCell.font = _menuBarTitleSelectedFont;
            menuCell.textColor = kTitleBgColor;
        }
    }
}

#pragma mark - TAP ACTION
- (void)menuCellTapAction:(UITapGestureRecognizer *)tap {
    if ([tap.view isKindOfClass:[UILabel class]]) {
        // 获取当前点击视图的位置
        NSInteger selectedIndex = tap.view.tag - MSMenuInitTag;
        self.selectedIndex = selectedIndex;
        _menuCellSelectedIndex = selectedIndex;
        
        //修改内容滚动视图的偏移量
        [UIView animateWithDuration:.25 animations:^{
            _contentScrollView.contentOffset = CGPointMake(_selectedIndex * _contentScrollView.bounds.size.width, 0);
        }];
        [self setScrollAnimation];
    }
    //显示内容视图
    _contentScrollView.hidden = NO;
    //“我的分组”按钮恢复默认状态
    _menuEditButton.selected = NO;
    //隐藏“我的分组”内容视图
    _myTeamContentView.hidden = YES;
}

/**
 * 菜单栏高度
 */
- (void)setMenuBarHeight:(CGFloat)menuBarHeight {
    _menuBarHeight = menuBarHeight;
    //创建菜单栏
    [self _initMenuBar];
    //改变我的分组表视图的frame
    _myTeamContentView.frame = CGRectMake(0, _menuBarHeight, self.width, self.height - _menuBarBgView.bottom);
}

/**
 * 菜单栏标题字体_默认
 */
- (void)setMenuBarTitleNormalFont:(UIFont *)menuBarTitleNormalFont {
    if (_menuBarTitleNormalFont != menuBarTitleNormalFont) {
        _menuBarTitleNormalFont = menuBarTitleNormalFont;
    }
    for (UIView *view in _menuBarScrollView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *menuCell = (UILabel *)view;
            if (menuCell.tag == MSMenuInitTag + _selectedIndex) {
                menuCell.font = _menuBarTitleSelectedFont;
            }else {
                menuCell.font = _menuBarTitleNormalFont;
            }
        }
    }
}

/**
 * 菜单栏标题字体_选中
 */
- (void)setMenuBarTitleSelectedFont:(UIFont *)menuBarTitleSelectedFont {
    if (_menuBarTitleSelectedFont != menuBarTitleSelectedFont) {
        _menuBarTitleSelectedFont = menuBarTitleSelectedFont;
    }
    for (UIView *view in _menuBarScrollView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *menuCell = (UILabel *)view;
            if (menuCell.tag == MSMenuInitTag + _selectedIndex) {
                menuCell.font = _menuBarTitleSelectedFont;
            }else {
                menuCell.font = _menuBarTitleNormalFont;
            }
        }
    }
}

/**
 * 菜单栏标题字体颜色_选中
 */
- (void)setMenuTitleSelectedColor:(UIColor *)menuTitleSelectedColor {
    if (_menuTitleSelectedColor != menuTitleSelectedColor) {
        _menuTitleSelectedColor = menuTitleSelectedColor;
    }
    //菜单栏标题设置
    for (UIView *view in _menuBarScrollView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *menuCell = (UILabel *)view;
            if (menuCell.tag == MSMenuInitTag + _selectedIndex) {
                menuCell.textColor = _menuTitleSelectedColor;
            }else {
                menuCell.textColor = _menuTitleNormalColor;
            }
        }
    }
    //我的分组按钮设置
    [_menuEditButton setTitleColor:_menuTitleSelectedColor forState:UIControlStateSelected];
}

/**
 * 菜单栏标题字体颜色_默认
 */
- (void)setMenuTitleNormalColor:(UIColor *)menuTitleNormalColor {
    if (_menuTitleNormalColor!= menuTitleNormalColor) {
        _menuTitleNormalColor = menuTitleNormalColor;
    }
    //菜单栏标题设置
    for (UIView *view in _menuBarScrollView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *menuCell = (UILabel *)view;
            if (menuCell.tag == MSMenuInitTag + _selectedIndex) {
                menuCell.textColor = _menuTitleSelectedColor;
            }else {
                menuCell.textColor = _menuTitleNormalColor;
            }
        }
    }
    //我的分组按钮设置
    [_menuEditButton setTitleColor:_menuTitleNormalColor forState:UIControlStateNormal];
    [_menuEditButton setTitleColor:_menuTitleNormalColor forState:UIControlStateDisabled];
}

/**
 * 菜单栏标题选中下划线颜色
 */
- (void)setMenuTitleSelectedLineColor:(UIColor *)menuTitleSelectedLineColor {
    if (_menuTitleSelectedLineColor != menuTitleSelectedLineColor) {
        _menuTitleSelectedLineColor = menuTitleSelectedLineColor;
    }
    _menuSelectedLine.backgroundColor = _menuTitleSelectedLineColor;
}

/*
 * 菜单栏的表框的颜色
 */
- (void)setMenuLayerBorderColor:(UIColor *)menuLayerBorderColor {
    if (_menuLayerBorderColor != menuLayerBorderColor) {
        _menuLayerBorderColor = menuLayerBorderColor;
    }
    _menuBarBgView.layer.borderColor = _menuLayerBorderColor.CGColor;
}

/*
 * 菜单栏的表框的宽度
 */
- (void)setMenuLayerBorderWidth:(CGFloat)menuLayerBorderWidth {
    _menuLayerBorderWidth = menuLayerBorderWidth;
    _menuBarBgView.layer.borderWidth = _menuLayerBorderWidth;
}

/*
 *  菜单栏控件选中按钮索引位置
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self setScrollAnimation];
}
/*
 * 菜单栏的背景颜色
 */
- (void)setMenuBarBgColor:(UIColor *)menuBarBgColor {
    if (_menuBarBgColor != menuBarBgColor) {
        _menuBarBgColor = menuBarBgColor;
    }
    _menuBarBgView.backgroundColor = _menuBarBgColor;
}

/*
 * 菜单栏是否显示遮罩视图
 */
- (void)setIsShowMaskViews:(BOOL)isShowMaskViews {
    _isShowMaskViews = isShowMaskViews;
    if (_isShowMaskViews == YES) {
        _maskLeftImageView.hidden = NO;
        _maskRightImageView.hidden = NO;
    }else {
        _maskLeftImageView.hidden = YES;
        _maskRightImageView.hidden = YES;
    }
}

/**
 * 菜单栏遮罩视图设置
 */
- (void)setMaskImageNames:(NSArray *)maskImageNames {
    if (_maskImageNames != maskImageNames) {
        _maskImageNames = maskImageNames;
    }
    _maskLeftImageView.image = [[UIImage imageNamed:_maskImageNames[0]] stretchableImageWithLeftCapWidth:0 topCapHeight:10];
    _maskRightImageView.image = [[UIImage imageNamed:_maskImageNames[1]] stretchableImageWithLeftCapWidth:0 topCapHeight:10];
}


#pragma mark ========= "我的分组"按钮的设置 =========

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"_menuEditButton.titleLabel.text"]) {
        
    }else if ([keyPath isEqualToString:@"_menuEditButton.selected"]) {
        //观察编辑按钮选中状态
        NSString *changeNewString = change[@"new"];
        BOOL changeNew = [changeNewString boolValue];
        if (changeNew == 1) {
            //选中状态
            _iconImageView.image = [UIImage imageNamed:@"sanjiao-h4.7.png"];
            if ([_menuEditButton.titleLabel.text isEqualToString:@"我的分组"]) {
                
            }else {
                //菜单栏标题全部恢复默认状态并隐藏内容视图
                [self hideContentViewsDefaultMenuTitles];
                //显示“我的分组”内容视图
                _myTeamContentView.hidden = NO;
            }
        }else {
            //未选中状态
            _iconImageView.image = [UIImage imageNamed:@"sanjiao-n4.7.png"];
        }
    }
}

#pragma mark - “我的分组”按钮点击事件
- (void)menuBarEidtButtonAction:(UIButton *)button {
    //是否改变按钮的状态
    if ([_menuEditButton.titleLabel.text isEqualToString:@"我的分组"]) {
        _menuEditButton.selected = !_menuEditButton.selected;
    }else {
        _menuEditButton.selected = YES;
    }
    //出现遮罩视图
    if (_superMaskView == nil) {
        _superMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, [UIScreen mainScreen].bounds.size.height)];
        _superMaskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
    }
    //给遮罩视图添加点击事件
    UITapGestureRecognizer *superMaskViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editButtonMaskTapAction:)];
    [_superMaskView addGestureRecognizer:superMaskViewTap];
    [[UIApplication sharedApplication].keyWindow addSubview:_superMaskView];
    //创建遮罩视图上的编辑分组视图
    _myTeamView = [[MyTeamScrollView alloc] initWithFrame:CGRectMake(kScreen_width - 10 - 160, _myTeamButton_Y, 160, 32 * (_visibleTitleCount + 2))];
    _myTeamView.myTeamScrollViewDelegate = self;
    _myTeamView.myDataList = self.myTeamTitles;
    _myTeamView.currentTitle = _menuEditButton.titleLabel.text;
    [_superMaskView addSubview:_myTeamView];
}

/**
 * “我的分组”列表中显示的标题个数
 */
- (void)setVisibleTitleCount:(NSInteger)visibleTitleCount {
    _visibleTitleCount = visibleTitleCount;
    _myTeamView.frame = CGRectMake(kScreen_width - 10 - 160, kMenu_height + 64, 160, 32 * (_visibleTitleCount + 2));
    _myTeamView.currentTitle = _menuEditButton.titleLabel.text;
}

/**
 * 展示“我的分组”列表中数据所需要的子视图
 */
- (void)setMyTeamDataDisplaySubView:(UIView *)myTeamDataDisplaySubView {
    if (_myTeamDataDisplaySubView != myTeamDataDisplaySubView) {
        _myTeamDataDisplaySubView = myTeamDataDisplaySubView;
    }
    _myTeamDataDisplaySubView.frame = CGRectMake(0, 0, _myTeamContentView.frame.size.width, _myTeamContentView.frame.size.height);
    [_myTeamContentView addSubview:_myTeamDataDisplaySubView];
}

#pragma mark - MyTeamScrollViewDelegate
- (void)myTeamScrollViewEditTeamButtonClicked {
    //移除我的分组视图
    [_myTeamView removeFromSuperview];
    //移除遮罩视图
    [_superMaskView removeFromSuperview];
    
    //判断按钮是否需要恢复默认状态
    if ([_menuEditButton.titleLabel.text isEqualToString:@"我的分组"]) {
        _menuEditButton.selected = NO;
    }else {
        _menuEditButton.selected = YES;
    }
    
    //代理调用方法
    if ([_delegate respondsToSelector:@selector(msMenuBar:didEditButtonClicked:)]) {
        [_delegate msMenuBar:self didEditButtonClicked:nil];
    }
}

- (void)myTeamScrollViewTitleButtonClicked:(NSString *)title {
    //改变编辑按钮的标题
    [_menuEditButton setTitle:title forState:UIControlStateNormal];
    //移除遮罩视图
    [_superMaskView removeFromSuperview];
    //菜单栏标题全部恢复默认状态并隐藏内容视图
    [self hideContentViewsDefaultMenuTitles];
    //显示“我的分组”内容视图
    _myTeamContentView.hidden = NO;
}

//点击遮罩视图事件
- (void)editButtonMaskTapAction:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:.25 animations:^{
        //移除表视图
        [_myTeamView removeFromSuperview];
        //移除遮罩视图
        [_superMaskView removeFromSuperview];
    }];
    //编辑按钮标题是否改变
    if ([_menuEditButton.titleLabel.text isEqualToString:@"我的分组"]) {
        _menuEditButton.selected = !_menuEditButton.selected;
    }
}

/**
 * 我的分组按钮的背景颜色
 */
- (void)setMyTeamButtonBgColor:(UIColor *)myTeamButtonBgColor {
    if (_myTeamButtonBgColor != myTeamButtonBgColor) {
        _myTeamButtonBgColor = myTeamButtonBgColor;
    }
    _menuEditButton.backgroundColor = _myTeamButtonBgColor;
}
/**
 * 我的分组按钮的y值
 */
- (void)setMyTeamButton_Y:(CGFloat)myTeamButton_Y {
    _myTeamButton_Y = myTeamButton_Y;
    _myTeamView.frame = CGRectMake(kScreen_width - 10 - 160, _myTeamButton_Y, 160, 32 * (_visibleTitleCount + 2));
}

#pragma mark ============ 标题数组 ============
/**
 * 菜单栏标题数组
 */
- (void)setMenuTitles:(NSArray *)menuTitles {
    if (_menuTitles != menuTitles) {
        _menuTitles = menuTitles;
    }
    [self _initMenuBarItems];
}
/**
 * “我的分组”标题数组
 */
- (void)setMyTeamTitles:(NSArray *)myTeamTitles {
    if (_myTeamTitles != myTeamTitles) {
        _myTeamTitles = myTeamTitles;
    }
}

#pragma mark ========= 内容视图的设置 =========

//创建内容视图
- (void)_initContentScrollView {
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _menuBarBgView.bounds.size.height, self.bounds.size.width, self.bounds.size.height - _menuBarBgView.bounds.size.height)];
    _contentScrollView.backgroundColor = [UIColor clearColor];
    _contentScrollView.contentSize = CGSizeMake(_menuTitles.count * self.bounds.size.width, self.bounds.size.height - _menuBarBgView.bounds.size.height);
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate = self;
    
    _contentScrollView.contentOffset = CGPointMake(_menuCellSelectedIndex * self.bounds.size.width, 0);
    
    [self addSubview:_contentScrollView];
}

/*
 *  内容视图数组
 */
- (void)setContentViews:(NSArray *)contentViews {
    if (_contentViews != contentViews) {
        _contentViews = contentViews;
    }
    //创建内容滚动视图
    [self _initContentScrollView];
    
    //移除之前的视图
    for (UIView *view in _contentScrollView.subviews) {
        [view removeFromSuperview];
    }
    //创建视图
    for (int i = 0; i < _contentViews.count; i ++) {
        UIView *view = _contentViews[i];
        view.frame = CGRectMake(i * _contentScrollView.bounds.size.width, 0, _contentScrollView.contentSize.width, _contentScrollView.contentSize.height);
        [_contentScrollView addSubview:view];
    }
}

#pragma mark -  菜单栏添加标题 内容视图添加视图

- (void)addMenuTitle:(NSString *)menuTitle contentView:(UIView *)contentView {
    //添加菜单栏标题
    NSMutableArray *menuTitles = [_menuTitles mutableCopy];
    [menuTitles addObject:menuTitle];
    self.menuTitles = menuTitles;
    //添加内容视图
    NSMutableArray *contentViews = [_contentViews mutableCopy];
    [contentViews addObject:contentView];
    self.contentViews = contentViews;
}

#pragma mark -  菜单栏移除标题 内容视图移除视图

- (void)removeMenuTitleAndContentViewWithIndex:(NSInteger)removeIndex {
    //得到要删掉的标题
    UILabel *currentMenuCell = _allMenuCell[removeIndex];
    //得到之前的标题
    UILabel *lastMenuCell = _allMenuCell[removeIndex - 1];

    //如果下划线在要删掉标题上
    if (_menuSelectedLine.frame.origin.x == currentMenuCell.frame.origin.x) {
        //设置选中下划线的位置
        [UIView animateWithDuration:.25 animations:^{
            _menuSelectedLine.frame = CGRectMake(lastMenuCell.frame.origin.x, _menuBarHeight - 3, lastMenuCell.frame.size.width, 2);
        }];
        
        //内容视图切换
        _contentScrollView.contentOffset = CGPointMake((removeIndex - 1) * _contentScrollView.bounds.size.width, 0);
    }else {
        //下划线不在要删掉标题上
    }
    
    //移除菜单栏标题
    NSString *removeTitle = _menuTitles[removeIndex];
    NSMutableArray *menuTitles = [_menuTitles mutableCopy];
    [menuTitles removeObject:removeTitle];
    self.menuTitles = menuTitles;
    
    //移除内容视图
    //移除数组中的视图
    NSMutableArray *contentViews = [_contentViews mutableCopy];
    UIView *contentRomoveView = contentViews[removeIndex];
    //在内容视图滚动视图上移除
    [contentRomoveView removeFromSuperview];
    [contentViews removeObject:contentRomoveView];
    self.contentViews = contentViews;
}

#pragma mark - 更新菜单栏标题和内容视图

- (void)reloadMenuBarWithMenuTitles:(NSArray *)menuTitles contentViews:(NSArray *)contentViews {
    self.menuTitles = menuTitles;
    self.contentViews = contentViews;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _menuBarScrollView) {//菜单栏的滚动视图
        
    }else if (scrollView == _contentScrollView) {//内容视图的滚动视图
        NSInteger page = scrollView.contentOffset.x / self.bounds.size.width;
        self.selectedIndex = page;
        _menuCellSelectedIndex = page;
    }
}

/*
 * 隐藏内容视图并且使菜单栏标题的文字颜色变为默认状态
 */
- (void)hideContentViewsDefaultMenuTitles {
    //隐藏内容视图
    _contentScrollView.hidden = YES;
    //使菜单栏标题的文字颜色变为默认状态
    for (UIView *view in _menuBarScrollView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *menuCell = (UILabel *)view;
            menuCell.textColor = _menuTitleNormalColor;
            menuCell.font = _menuBarTitleNormalFont;
            [UIView animateWithDuration:.25 animations:^{
                _menuBarScrollView.contentOffset = CGPointMake(0, 0);
            }];
        }
    }
}

#pragma mark - 滑动效果
- (void)setScrollAnimation {
    //修改标题文本的字体
    for (int i = 0; i < _menuBarScrollView.subviews.count; i ++) {
        UIView *view = _menuBarScrollView.subviews[i];
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *menuCell = (UILabel *)view;
            if (menuCell.tag == _selectedIndex + MSMenuInitTag) {
                menuCell.font = _menuBarTitleSelectedFont;
                menuCell.textColor = _menuTitleSelectedColor;
                //设置选中下划线的位置
                [UIView animateWithDuration:.25 animations:^{
                    _menuSelectedLine.frame = CGRectMake(menuCell.frame.origin.x, _menuBarHeight - 3, menuCell.frame.size.width, 2);
                }];
                //判断菜单栏是否需要滚动
                CGFloat selectedLineX = _menuSelectedLine.frame.origin.x;
                if (selectedLineX > [UIScreen mainScreen].bounds.size.width / 2.0)                                                                                                 {
                    //下划线的X超过了半屏
                    //得到当前标题的X和W
                    CGFloat currentCellX = menuCell.frame.origin.x;
//                    CGFloat currentCellWidth = menuCell.bounds.size.width;
                    if (i == _menuTitles.count) {
                        //显示最后一个标题需要的偏移量
                        CGFloat lastContentOffsetX = _menuBarScrollView.contentSize.width - (self.bounds.size.width - kMenuEditButton_width);
                        [UIView animateWithDuration:.25 animations:^{
                            _menuBarScrollView.contentOffset = CGPointMake(lastContentOffsetX, 0);
                        }];
                    }else {
                        //下一个标题及以后剩下的宽度
                        CGFloat remainLastWidth = _menuBarScrollView.contentSize.width - currentCellX ;//- currentCellWidth - MSMenuBarTitleSpace;
                        if (remainLastWidth < [UIScreen mainScreen].bounds.size.width / 2.0 - kMenuEditButton_width - _maskRightImageView.bounds.size.width) {
                            
                        }else {
                            //菜单栏选中标题滚动到中央
                            [UIView animateWithDuration:.25 animations:^{
                                _menuBarScrollView.contentOffset = CGPointMake(selectedLineX - [UIScreen mainScreen].bounds.size.width / 2.0 + menuCell.bounds.size.width / 2.0, 0);
                            }];
                        }
                    }
                }else if (selectedLineX < [UIScreen mainScreen].bounds.size.width / 2.0) {
                    //下划线的X没超过半屏
                    [UIView animateWithDuration:.25 animations:^{
                        _menuBarScrollView.contentOffset = CGPointMake(0, 0);
                    }];
                }
            }else {
                menuCell.textColor = _menuTitleNormalColor;
                menuCell.font = _menuBarTitleNormalFont;
            }
        }
    }
}








































@end
