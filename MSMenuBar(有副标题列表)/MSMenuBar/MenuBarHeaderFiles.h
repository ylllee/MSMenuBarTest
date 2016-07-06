//
//  MenuBar.h
//  MSMenuBar
//
//  Created by limingshan on 16/7/6.
//  Copyright © 2016年 limingshan. All rights reserved.
//

/**
 * 这是一个类似预编译文件的文件
 * 为了省事儿，导入了UIViewExt
 */

#ifndef MenuBar_h
#define MenuBar_h

// 获取CXMenuBar.bundle下的图片
#define MSMenuBarBundleName @"MSMenuBar.bundle"
#define MSMenuBarImagePathWithImageName(imageName) [MSMenuBarBundleName stringByAppendingPathComponent:imageName]
#define MSMenuBarImageWithImageName(imageName) [UIImage imageNamed:MSMenuBarImagePathWithImageName(imageName)]
//"我的分组"按钮的宽度
#define kMenuEditButton_width 61
#define MSMenuInitTag 1000000
//菜单栏标题间距
#define MSMenuBarTitleSpace 25
//菜单栏的高度
#define kMenu_height 48
//屏幕宽度
#define kScreen_width [UIScreen mainScreen].bounds.size.width
/**
 * 颜色rgb自定义
 */
#define kColorWith(r,g,b,al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al]
//选择标题文本颜色
#define kTitleBgColor kColorWith(51, 158, 210, 1)
/**
 * 根据是否是6sp宽度设置字体大小
 */
#define kSetFontCGfloat(f) [UIScreen mainScreen].bounds.size.width == 414 ? (f) * 1.1 : (f)
//菜单栏标题字体大小
#define kMenuTitle_font kSetFontCGfloat(14)
/**
 * 默认的背景颜色
 */
#define kDefault_bgColor kColorWith(240,240,240,1)
//内容文本的x
#define kFinanceCellContentLabel_x 48
//内容文本
#define kFinanceCellContent @"伯克希尔哈撒韦伯克希尔哈撒韦伯克希尔哈撒韦伯克希尔"
/**
 * 导航栏的背景颜色
 */
#define kNavBg_color kColorWith(3,108,153,1)
//公司名称的颜色
#define kFinanceTitleColor kColorWith(3, 108, 153, 1)

#import "UIViewExt.h"

#endif /* MenuBar_h */
