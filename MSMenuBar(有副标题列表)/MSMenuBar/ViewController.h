//
//  ViewController.h
//  MSMenuBar
//
//  Created by limingshan on 16/7/5.
//  Copyright © 2016年 limingshan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuBarHeaderFiles.h"

#import "MSMenuBar.h"

#import "FinanceCell.h"

@interface ViewController : UIViewController <MSMenuBarDelegate,UITableViewDelegate,UITableViewDataSource,FinanceCellDelegate> {
    MSMenuBar *_menuBar;
    //我的分组中标题对应数据显示的表视图
    UITableView *_myTeamTitleTableView_finance;
    //内容视图数组
    NSArray *_contentViews;
    //菜单栏控件下的内容滚动视图
    UIScrollView *_contentScrollView;
}


@end

