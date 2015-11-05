//
//  BlockCreateUIDefine.h
//  LZCommonUtils
//
//  Created by liyou on 15/4/5.
//  Copyright (c) 2015年 liyou. All rights reserved.
//
#import <UIKit/UIKit.h>

/**
 * @brief 创建UILabel.
 *
 * @param color 字体颜色.
 *
 * @param fontSize 字体大小.
 *
 * @return 返回UILabel.
 */
extern UILabel *(^block_createLabel)(UIColor *color, CGFloat fontSize);

/**
 * @brief 创建UIImageView.
 *
 * @param imageName 图片名.
 *
 * @return 返回UIImageView.
 */
extern UIImageView *(^block_createImageView)(NSString *imageName);

/**
 * @brief 创建UIButton.
 *
 * @param imageName 背景图片名.
 *
 * @param delegate 回调实体.
 *
 * @param selector 回调方法.
 *
 * @return 返回UIButton.
 */
extern UIButton *(^block_createButton)(NSString *imageName, id delegate, SEL selector);