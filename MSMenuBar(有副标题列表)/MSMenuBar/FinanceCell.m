//
//  FinanceCell.m
//  Hupogu
//
//  Created by limingshan on 16/6/7.
//  Copyright © 2016年 hupogu.com. All rights reserved.
//

#import "FinanceCell.h"

#define kFinanceCellButton 100

@implementation FinanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //头像
        _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headButton addTarget:self action:@selector(headButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _headButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _headButton.tag = kFinanceCellButton;
        _headButton.backgroundColor = kNavBg_color;
        [self.contentView addSubview:_headButton];
        //公司名称
        _companyNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _companyNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _companyNameButton.tag = kFinanceCellButton + 1;
        _companyNameButton.backgroundColor = [UIColor clearColor];
        [_companyNameButton setTitleColor:kFinanceTitleColor forState:UIControlStateNormal];
        _companyNameButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_companyNameButton addTarget:self action:@selector(companyNameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_companyNameButton];
        //股价文本
        _sharePriceLabel = [[UILabel alloc] init];
        _sharePriceLabel.backgroundColor = [UIColor clearColor];
        _sharePriceLabel.font = [UIFont systemFontOfSize:12];
        _sharePriceLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
        _sharePriceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_sharePriceLabel];
        //内容文本
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
        [self.contentView addSubview:_contentLabel];
        //资本
        _financeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _financeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _financeButton.tag = kFinanceCellButton + 2;
        _financeButton.backgroundColor = [UIColor clearColor];
        _financeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_financeButton addTarget:self action:@selector(financeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_financeButton setTitleColor:kFinanceTitleColor forState:UIControlStateNormal];
        [self.contentView addSubview:_financeButton];
        //日期文本
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textColor = [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1];
        [self.contentView addSubview:_dateLabel];
        //关注按钮
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followButton.tag = kFinanceCellButton + 3;
        _followButton.backgroundColor = kColorWith(82, 176, 62, 1);
        //        _followButton.backgroundColor = kColorWith(235, 235, 235, 1);
        [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_followButton setTitleColor:kColorWith(50, 50, 50, 1) forState:UIControlStateSelected];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
        [_followButton setTitle:@"关注" forState:UIControlStateDisabled];
        [_followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_followButton setTitleColor:kColorWith(50, 50, 50, 1) forState:UIControlStateSelected];
        _followButton.layer.cornerRadius = 1.5;
        _followButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_followButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //头像
    _headButton.frame = CGRectMake(10, 10, 31, 31);
    [_headButton setTitle:@"B" forState:UIControlStateNormal];
    //公司名称
    _companyNameButton.frame = CGRectMake(_headButton.right + 7, _headButton.top - 8, kScreen_width - (_headButton.right + 7) - 80 - 10, 30);
    [_companyNameButton setTitle:@"伯克希尔哈撒韦(BRK.A)" forState:UIControlStateNormal];
    //股价文本
    _sharePriceLabel.frame = CGRectMake(kScreen_width - 10 - 80, _companyNameButton.top - 1, 80, 30);
    _sharePriceLabel.text = @"$5000万-B轮";
    //内容文本
    NSString *text = kFinanceCellContent;
    _contentLabel.frame = CGRectMake(_companyNameButton.left, _companyNameButton.bottom, kScreen_width - _companyNameButton.left - 10 * 2, 51);
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = text;
    [_contentLabel sizeToFit];
    //资本
    _financeButton.frame = CGRectMake(_contentLabel.left, _contentLabel.bottom - 1, kScreen_width - _companyNameButton.left, 31);
    [_financeButton setTitle:@"-红杉资本" forState:UIControlStateNormal];
    //日期文本
    _dateLabel.frame = CGRectMake(_financeButton.left, self.frame.size.height - 12 - 8, kScreen_width - _financeButton.left - 59 - 10, 12);
    _dateLabel.text = @"今天";
    //关注按钮
    _followButton.frame = CGRectMake(_dateLabel.right, self.frame.size.height - 19 - 8, 59, 19);
}

//关注按钮点击事件
- (void)followButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = kColorWith(235, 235, 235, 1);
    }else {
        button.backgroundColor = kColorWith(82, 176, 62, 1);
    }
    if ([_delegate respondsToSelector:@selector(financeCell:whenButtonClicked:)]) {
        [_delegate financeCell:self whenButtonClicked:button];
    }
}

//资本名称点击事件
- (void)financeButtonAction:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(financeCell:whenButtonClicked:)]) {
        [_delegate financeCell:self whenButtonClicked:button];
    }
}

//公司名称点击事件
- (void)companyNameButtonAction:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(financeCell:whenButtonClicked:)]) {
        [_delegate financeCell:self whenButtonClicked:button];
    }
}


//头像点击事件
- (void)headButtonAction:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(financeCell:whenButtonClicked:)]) {
        [_delegate financeCell:self whenButtonClicked:button];
    }
}

@end
