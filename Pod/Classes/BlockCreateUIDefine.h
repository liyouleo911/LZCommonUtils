//
//  BlockCreateUIDefine.h
//  common
//
//  Created by logiph on 4/13/13.
//  Copyright (c) 2013 logiph. All rights reserved.
//
#import <UIKit/UIKit.h>

extern UILabel *(^block_createLabel)(UIColor *color, CGFloat fontSize);

extern UIImageView *(^block_createImageView)(NSString *imageName);

extern UIButton *(^block_createButton)(NSString *imageName, id delegate, SEL selector);