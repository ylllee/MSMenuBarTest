//
//  MyTeamScrollView.h
//  Hupogu
//
//  Created by limingshan on 16/6/28.
//  Copyright © 2016年 hupogu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuBarHeaderFiles.h"

/**
 * 颜色rgb自定义
 */
#define kColorWith(r,g,b,al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al]

@protocol MyTeamScrollViewDelegate <NSObject>

- (void)myTeamScrollViewEditTeamButtonClicked;

- (void)myTeamScrollViewTitleButtonClicked:(NSString *)title;

@end

@interface MyTeamScrollView : UIView <UIScrollViewDelegate> {
    //编辑分组按钮
    UIButton *_editTeamButton;
    //头部、尾部视图按钮
    UIButton *_topMoreButton;
    UIButton *_bottomMoreButton;
    //小三角
    UIImageView *_triangleImageView;
    //以下视图的底部视图
    UIView *_bgView;
    //中部滚动视图
    UIScrollView *_contentScrollView;
    //保存标题按钮
    NSArray *_titleButtons;
    //显示的个数
    NSInteger _visibleTitleCount;
}

@property (nonatomic, strong) NSArray *myDataList;
@property (nonatomic, strong) NSString *currentTitle;

@property (nonatomic, weak) id <MyTeamScrollViewDelegate> myTeamScrollViewDelegate;

@end
