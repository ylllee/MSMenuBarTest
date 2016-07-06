//
//  FinanceCell.h
//  Hupogu
//
//  Created by limingshan on 16/6/7.
//  Copyright © 2016年 hupogu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuBarHeaderFiles.h"

@class FinanceCell;

@protocol FinanceCellDelegate <NSObject>

- (void)financeCell:(FinanceCell *)financeCell whenButtonClicked:(UIButton *)button;

@end

@interface FinanceCell : UITableViewCell {
    UIButton *_headButton;
    UIButton *_companyNameButton;
    UIButton *_financeButton;
    UIButton *_followButton;
    UILabel *_contentLabel;
    UILabel *_dateLabel;
    UILabel *_sharePriceLabel;
}

@property (nonatomic, weak) id <FinanceCellDelegate> delegate;

@end
