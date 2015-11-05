//
//  UIImage+Util.h
//  LZCommonUtils
//
//  Created by liyou on 15/4/5.
//  Copyright (c) 2015年 liyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    UIImageRoundedCornerTopLeft = 1,
    UIImageRoundedCornerTopRight = 1 << 1,
    UIImageRoundedCornerBottomRight = 1 << 2,
    UIImageRoundedCornerBottomLeft = 1 << 3,
    UIImageRoundedCornerAll = 0x0f,
} UIImageRoundedCorner;

@interface UIImage (Util)

+ (UIImage *)imageWithColor:(UIColor *)color;                       //纯颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size;

+ (UIImage *)grayscaleImageForImage:(UIImage *)image;               //生成黑白图片

- (UIImage *)imageWithRoundedRectWithRadius:(float)radius cornerMask:(UIImageRoundedCorner)cornerMask;
- (UIImage *)imageWithGrayScale;

@end
