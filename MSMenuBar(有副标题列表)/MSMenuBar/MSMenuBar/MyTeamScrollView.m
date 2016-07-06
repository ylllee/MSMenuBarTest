//
//  MyTeamScrollView.m
//  Hupogu
//
//  Created by limingshan on 16/6/28.
//  Copyright © 2016年 hupogu.com. All rights reserved.
//

#define kMyTeamVisible_max 11
#define kMyTeamCell_height 32

#import "MyTeamScrollView.h"

@implementation MyTeamScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        if ([UIScreen mainScreen].bounds.size.width > 320) {
            _visibleTitleCount = kMyTeamVisible_max;
        }else {
            _visibleTitleCount = kMyTeamVisible_max - 1;
        }
        // 1.创建三角形图片 22 12
        _triangleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 15 - 11, 0, 11, 6)];
        _triangleImageView.image = [UIImage imageNamed:@"arrow-4.7.png"];
        [self addSubview:_triangleImageView];
        // 2.以下视图的底部视图
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _triangleImageView.bottom, frame.size.width, frame.size.height - _triangleImageView.bottom)];
        _bgView.backgroundColor = kColorWith(73, 72, 75, 1);
        [self addSubview:_bgView];
        // 3.创建编辑按钮视图
        _editTeamButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editTeamButton.frame = CGRectMake(0, 0, frame.size.width, kMyTeamCell_height - 1);
        _editTeamButton.backgroundColor = [UIColor clearColor];
        [_editTeamButton setTitle:@"编辑分组" forState:UIControlStateNormal];
        _editTeamButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_editTeamButton setTitleColor:kColorWith(173, 216, 234, 1) forState:UIControlStateNormal];
        [_editTeamButton addTarget:self action:@selector(myTeamEditButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_editTeamButton];
        // 4.它下方的下划线
        UIView *editButtonLine = [[UIView alloc] initWithFrame:CGRectMake(0, _editTeamButton.bottom, frame.size.width, 1)];
        editButtonLine.backgroundColor = kColorWith(92, 91, 93, 1);
        [_bgView addSubview:editButtonLine];
        // 5.顶部的更多按钮
        _topMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topMoreButton.frame = CGRectMake(0, editButtonLine.bottom, frame.size.width, kMyTeamCell_height - 1);
        _topMoreButton.backgroundColor = [UIColor clearColor];
        //顶部的图片 arrow-bottom-4.7@2x.png
        [_topMoreButton setImage:[UIImage imageNamed:@"arrow-bottom-4.7.png"] forState:UIControlStateNormal];
        [_topMoreButton setImage:[UIImage imageNamed:@"arrow-bottom-4.7.png"] forState:UIControlStateHighlighted];
        _topMoreButton.transform = CGAffineTransformMakeRotation(M_PI);
        [_topMoreButton addTarget:self action:@selector(topMoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _topMoreButton.hidden = YES;
        [_bgView addSubview:_topMoreButton];
        // 6.中间的滚动视图
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, editButtonLine.bottom, frame.size.width, frame.size.height - editButtonLine.bottom - kMyTeamCell_height)];
        _contentScrollView.delegate = self;
        _contentScrollView.bounces = NO;
        _contentScrollView.backgroundColor = [UIColor clearColor];
        //隐藏滚动条
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        //翻页功能
        _contentScrollView.pagingEnabled = YES;
        [_bgView addSubview:_contentScrollView];
        // 7.底部的更多按钮
        _bottomMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomMoreButton.frame = CGRectMake(0, _contentScrollView.bottom, frame.size.width, kMyTeamCell_height);
        [_bottomMoreButton setImage:[UIImage imageNamed:@"arrow-bottom-4.7.png"] forState:UIControlStateNormal];
        [_bottomMoreButton setImage:[UIImage imageNamed:@"arrow-bottom-4.7.png"] forState:UIControlStateHighlighted];
        _bottomMoreButton.backgroundColor = kColorWith(73, 72, 75, 1);
        [_bottomMoreButton addTarget:self action:@selector(bottomMoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_bottomMoreButton];
    }
    return self;
}

//顶部更多按钮点击事件
- (void)topMoreButtonAction:(UIButton *)button {
    if (_contentScrollView.contentOffset.y == kMyTeamCell_height * _visibleTitleCount) {
        // 1.刚好滚动了一个界面的高度
        // 设置偏移量
        [UIView animateWithDuration:.25 animations:^{
           _contentScrollView.contentOffset = CGPointMake(0, 0);
            //隐藏顶部更多按钮
            _topMoreButton.hidden = YES;
            //改变滚动视图的frame
            _contentScrollView.frame = CGRectMake(0, kMyTeamCell_height, self.frame.size.width, self.frame.size.height - kMyTeamCell_height - _bottomMoreButton.height);
        }];
    }else {
        // 设置偏移量
        [UIView animateWithDuration:.25 animations:^{
            _contentScrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
}

//底部更多按钮点击事件
- (void)bottomMoreButtonAction:(UIButton *)button {
    if (_contentScrollView.contentOffset.y == 0 && _myDataList.count > _visibleTitleCount) {
        //如果当前滚动视图偏移位置为最初位置
        // 1.显示顶部更多按钮
        _topMoreButton.hidden = NO;
        // 2.改变滚动视图的frame值
        _contentScrollView.frame = CGRectMake(0, _topMoreButton.bottom, self.frame.size.width, self.frame.size.height - _topMoreButton.bottom - _bottomMoreButton.height - _editTeamButton.height);
        // 3.设置偏移量
        [UIView animateWithDuration:.25 animations:^{
            _contentScrollView.contentOffset = CGPointMake(0, kMyTeamCell_height * _visibleTitleCount);
        }];
    }else if ((_contentScrollView.contentOffset.y == 0 && _myDataList.count <= _visibleTitleCount)||(_contentScrollView.contentOffset.y > 0 && _contentScrollView.contentSize.height - _contentScrollView.contentOffset.y <= kMyTeamCell_height * _visibleTitleCount)) {
        NSLog(@"没有更多了");
    }else {
        [UIView animateWithDuration:.25 animations:^{
            // 设置偏移量
            _contentScrollView.contentOffset = CGPointMake(0, kMyTeamCell_height * (_visibleTitleCount - 1) + _contentScrollView.contentOffset.y);
        }];
    }
}

//编辑按钮点击事件
- (void)myTeamEditButtonAction:(UIButton *)button {
    if ([_myTeamScrollViewDelegate respondsToSelector:@selector(myTeamScrollViewEditTeamButtonClicked)]) {
        [_myTeamScrollViewDelegate myTeamScrollViewEditTeamButtonClicked];
    }
}

//处理数据
- (void)setMyDataList:(NSArray *)myDataList {
    // 1.保存数据
    if (_myDataList != myDataList) {
        _myDataList = myDataList;
    }
    // 2.内容视图的大小 需要让它是frame.size.height的整数倍
    //计算滚动视图至少是多长 因为单元格的高度是整数，所以得出结果是一个整数
    NSInteger scrollView_height_min = kMyTeamCell_height * _myDataList.count;
    NSInteger scrollView_frame_height = (NSInteger)_contentScrollView.frame.size.height;
    //判断这个长度是不是frame.size.height的整数倍，如果不是就凑足整数倍
    if (scrollView_height_min % scrollView_frame_height == 0) {
        //无论何种情况，只要是整数倍就是 kMyTeamCell_height * _myDataList.count
        _contentScrollView.contentSize = CGSizeMake(self.frame.size.width, kMyTeamCell_height * _myDataList.count);
    }else {
        //不是整数倍
        if (scrollView_height_min < scrollView_frame_height) {
            //内容不满足一屏
            _contentScrollView.contentSize = CGSizeMake(self.frame.size.width, kMyTeamCell_height * _myDataList.count);
        }else {
            //最后一部分不足scrollView_frame_height
            //获取倍数
            NSInteger multiple_min = scrollView_height_min / scrollView_frame_height;
            //让contentSize.height是scrollView_frame_height * (multiple_min + 1)
            _contentScrollView.contentSize = CGSizeMake(self.frame.size.width, scrollView_frame_height * multiple_min + kMyTeamCell_height * (_visibleTitleCount - 1));
        }
    }
    // 3.在滚动视图上创建相应数量的标题按钮和下划线
    // 创建可变数组存放标题按钮
    NSMutableArray *titleButtons = [NSMutableArray array];
    for (int i = 0; i < _myDataList.count; i ++) {
        //标题按钮
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(0, i * kMyTeamCell_height, self.frame.size.width, kMyTeamCell_height - 1);
        titleButton.backgroundColor = [UIColor clearColor];
        [titleButton setTitle:_myDataList[i] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:kTitleBgColor forState:UIControlStateSelected];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [titleButton addTarget:self action:@selector(contentScrollViewTitleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentScrollView addSubview:titleButton];
        
        [titleButtons addObject:titleButton];
        
        //下划线
        UIView *titleButtonLine = [[UIView alloc] initWithFrame:CGRectMake(15, titleButton.bottom, self.frame.size.width - 30, 1)];
        titleButtonLine.backgroundColor = kColorWith(92, 91, 93, 1);
        [_contentScrollView addSubview:titleButtonLine];
    }
    _titleButtons = titleButtons;
}

//获取当前标题
- (void)setCurrentTitle:(NSString *)currentTitle {
    if (_currentTitle != currentTitle) {
        _currentTitle = currentTitle;
    }
    for (UIButton *titleButton in _titleButtons) {
        //设置选中标题样式
        if ([titleButton.titleLabel.text isEqualToString:_currentTitle]) {
            titleButton.backgroundColor = kColorWith(103, 101, 103, 1);
            [titleButton setTitleColor:kTitleBgColor forState:UIControlStateNormal];
        }
    }
}

//滚动视图上标题按钮点击事件
- (void)contentScrollViewTitleButtonAction:(UIButton *)button {
    // 1.按钮的选中状态改变
    button.selected = !button.selected;
    // 2.改变按钮的背景颜色
    button.backgroundColor = kColorWith(103, 101, 103, 1);
    // 3.移除自己
    [self removeFromSuperview];
    // 4.代理调用方法
    if ([_myTeamScrollViewDelegate respondsToSelector:@selector(myTeamScrollViewTitleButtonClicked:)]) {
        [_myTeamScrollViewDelegate myTeamScrollViewTitleButtonClicked:button.titleLabel.text];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == 0) {
        [UIView animateWithDuration:.25 animations:^{
            _topMoreButton.hidden = YES;
            _contentScrollView.frame = CGRectMake(0, kMyTeamCell_height, self.frame.size.width, self.frame.size.height - kMyTeamCell_height - _bottomMoreButton.height);
        }];
    }else {
        [UIView animateWithDuration:.25 animations:^{
            _contentScrollView.frame = CGRectMake(0, _topMoreButton.bottom, self.frame.size.width, self.frame.size.height - _topMoreButton.bottom - _bottomMoreButton.height);
            _topMoreButton.hidden = NO;
        }];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (velocity.y < 0) {
        [UIView animateWithDuration:.25 animations:^{
            _topMoreButton.hidden = YES;
            _contentScrollView.frame = CGRectMake(0, kMyTeamCell_height, self.frame.size.width, self.frame.size.height - kMyTeamCell_height - _bottomMoreButton.height);
        }];
    }else {
        [UIView animateWithDuration:.25 animations:^{
            _contentScrollView.frame = CGRectMake(0, _topMoreButton.bottom, self.frame.size.width, self.frame.size.height - _topMoreButton.bottom - _bottomMoreButton.height);
            _topMoreButton.hidden = NO;
        }];
    }
}



@end
