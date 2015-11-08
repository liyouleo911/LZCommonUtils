//
//  GlobalVariableDefine.m
//  LZCommonUtils
//
//  Created by liyou on 15/4/5.
//  Copyright (c) 2015年 liyou. All rights reserved.
//

void *(^addObserver)(id object,
                     SEL selector,
                     NSString *name
                     ) = ^(id object,
                           SEL selector,
                           NSString *name
                           ) {

    [[NSNotificationCenter defaultCenter] addObserver:object
                                             selector:selector
                                                 name:name
                                               object:nil];
    return nil;
};

void *(^removeObserver)(id object,
                        NSString *name
                        ) = ^(id object,
                              NSString *name
                              ) {
    
    [[NSNotificationCenter defaultCenter] removeObserver:object
                                                    name:name
                                                  object:nil];
    return nil;
};

void *(^sendNotify)(NSString *name,
                          id obj
                     ) = ^(NSString *name,
                           id obj
                           ) {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];
    return nil;
};

void *(^sendNotifyWithInfo)(NSString *name,
                                  id obj,
                              NSDictionary *info
                            ) = ^(NSString *name,
                          id obj,
                          NSDictionary *info
                          ) {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj userInfo:info];
    return nil;
};


void *(^sendNotifyOnMain)(NSString *name,
                                id obj
                          ) = ^(NSString *name,
                                id obj
                                ) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];
    });
    return nil;
};

void *(^sendNotifyWithInfoOnMain)(NSString *name,
                                        id obj,
                             NSDictionary *info
                                ) = ^(NSString *name,
                                            id obj,
                                 NSDictionary *info
                                     ) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj userInfo:info];
    });
    return nil;
};
