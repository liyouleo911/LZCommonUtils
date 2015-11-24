//
//  LZViewController.m
//  LZCommonUtils
//
//  Created by liyou on 11/05/2015.
//  Copyright (c) 2015 liyou. All rights reserved.
//

#import "LZViewController.h"
#import <LZCommonUtils/BlockCreateUIDefine.h>
#import <LZCommonUtils/UIApplication+AppVersion.h>
#import <LZCommonUtils/UIDevice+DeviceLogic.h>

@interface LZViewController ()

@end

@implementation LZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = block_createLabel([UIColor blackColor], 15);
    [label setFrame:CGRectMake(100, 100, 100, 100)];
    label.text = [NSString stringWithFormat:@"%@%@", [UIApplication build], [UIDevice machineType]];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
