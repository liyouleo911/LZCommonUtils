//
//  SingletonDefine.h
//  LZCommonUtils
//
//  Created by liyou on 15/4/5.
//  Copyright (c) 2015年 liyou. All rights reserved.
//

#import <objc/runtime.h>

#define kDispatchAllocSingleton(instance, implement) \
static id instance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[objc_getClass(implement) alloc] init];\
});