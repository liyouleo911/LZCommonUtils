//
//  UIView+loadFromXib.m
//  YiRecycle
//
//  Created by liyou on 15/4/26.
//  Copyright (c) 2015年 liyou. All rights reserved.
//

#import "UIView+loadFromXib.h"

@implementation UIView (loadFromXib)

+ (instancetype)loadFromXib
{
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    return [nibView objectAtIndex:0];
}

@end
