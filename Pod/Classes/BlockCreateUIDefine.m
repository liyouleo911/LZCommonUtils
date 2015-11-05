//
//  BlockCreateUIDefine.m
//  nineclub
//
//  Created by logiph on 4/13/13.
//  Copyright (c) 2013 logiph. All rights reserved.
//

#import "BlockCreateUIDefine.h"

UILabel *(^block_createLabel)(UIColor *color, CGFloat fontSize) = ^(UIColor *color, CGFloat fontSize) {
    
    UILabel *label = [[UILabel alloc] init];
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = NSTextAlignmentLeft;
    
    return label;
};

UIImageView *(^block_createImageView)(NSString *imageName) = ^(NSString *imageName) {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    
    return imageView;
};

UIButton *(^block_createButton)(NSString *imageName,
                                id delegate,
                                SEL selector
                                ) = ^(NSString *imageName,
                                      id delegate,
                                      SEL selector
                                      ) {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName]
                      forState:UIControlStateNormal];
    [button addTarget:delegate
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
};


