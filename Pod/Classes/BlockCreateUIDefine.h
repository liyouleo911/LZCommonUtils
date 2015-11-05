//
//  BlockCreateUIDefine.h
//  LZCommonUtils
//
//  Created by liyou on 15/4/5.
//  Copyright (c) 2015年 liyou. All rights reserved.
//
#import <UIKit/UIKit.h>

extern UILabel *(^block_createLabel)(UIColor *color, CGFloat fontSize);

extern UIImageView *(^block_createImageView)(NSString *imageName);

extern UIButton *(^block_createButton)(NSString *imageName, id delegate, SEL selector);