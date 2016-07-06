//
//  ViewController.m
//  MSMenuBar
//
//  Created by limingshan on 16/7/5.
//  Copyright © 2016年 limingshan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 1.标题
    self.title = @"MenuBarTest";
    // 1.取消滑动视图内填充
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // 2.创建菜单栏
    [self _initMenuBar];
}

// 3.创建菜单栏
- (void)_initMenuBar {
    if (_menuBar == nil) {
        _menuBar = [[MSMenuBar alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
        _menuBar.backgroundColor = [UIColor clearColor];
        _menuBar.delegate = self;
        _menuBar.menuBarHeight = kMenu_height;
        _menuBar.menuTitleSelectedLineColor = kTitleBgColor;
        _menuBar.menuBarTitleNormalFont = [UIFont systemFontOfSize:kMenuTitle_font];
        _menuBar.menuBarTitleSelectedFont = [UIFont boldSystemFontOfSize:kMenuTitle_font];
        _menuBar.menuTitleNormalColor = [UIColor blackColor];
        _menuBar.menuTitleSelectedColor = kTitleBgColor;
        _menuBar.menuLayerBorderWidth = 1;
        _menuBar.menuLayerBorderColor = kColorWith(214, 215, 220, 1);
    }
    //获取菜单栏标题
    //获取json数据
    NSString *json_path = [[NSBundle mainBundle] pathForResource:@"MenuTitleJson" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:json_path];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _menuBar.menuTitles = result[@"menuTitles"];
    // 显示的分组视图上的标题个数
    if ([UIScreen mainScreen].bounds.size.width > 320) {
        _menuBar.visibleTitleCount = 11;
    }else {
        _menuBar.visibleTitleCount = 11 - 1;
    }
    //"我的分组"标题数组
    _menuBar.myTeamTitles = result[@"selfTitles"];
    // 4.创建内容视图
    [self _initContentViews];
    // 6."我的分组"数据显示视图
    _myTeamTitleTableView_finance = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _myTeamTitleTableView_finance.backgroundColor = [UIColor clearColor];
    _myTeamTitleTableView_finance.dataSource = self;
    _myTeamTitleTableView_finance.delegate = self;
    _menuBar.myTeamDataDisplaySubView = _myTeamTitleTableView_finance;
    
    [self.view addSubview:_menuBar];
}

// 4.创建内容视图
- (void)_initContentViews {
    NSMutableArray *contentViews = [NSMutableArray array];
    for (int i = 0; i < _menuBar.menuTitles.count; i ++) {
        //创建表视图
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        [contentViews addObject:tableView];
    }
    _menuBar.contentViews = contentViews;
    _contentViews = contentViews;
    
    for (UIView *view in _menuBar.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            _contentScrollView = (UIScrollView *)view;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 45;//_dataList.count;
}

//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //单元格高度
    CGFloat cellHeight;
    //内容文本的宽度
    CGFloat width = kScreen_width - kFinanceCellContentLabel_x - 10 * 2 - 10;
    NSString *text = kFinanceCellContent;
    //获得文本的size
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    if (textSize.width > width && textSize.width < width * 2) {
        cellHeight = 17 * 2;
    }else if (textSize.width > width * 2) {
        cellHeight = 17 * 3;
    }else {
        cellHeight = 17;
    }
    return cellHeight + 85;
}

//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = kDefault_bgColor;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _myTeamTitleTableView_finance) {
        static NSString *myTeamTitleTableViewCell_finance = @"myTeamTitleTableViewCell_finance";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTeamTitleTableViewCell_finance];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTeamTitleTableViewCell_finance];
        }
        cell.textLabel.text = @"我的分组";
        return cell;
    }else {
        static NSString *cellId = @"editTeamCellId";
        FinanceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[FinanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.delegate = self;
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中样式
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //点击单元格事件
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
