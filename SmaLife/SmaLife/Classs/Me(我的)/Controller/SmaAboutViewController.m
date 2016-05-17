
//
//  SmaAboutViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/23.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaAboutViewController.h"

@interface SmaAboutViewController ()

@end

@implementation SmaAboutViewController

- (void)viewDidLoad {
   [super viewDidLoad];
    self.title=SmaLocalizedString(@"set_about_title");
    UIImageView *imgView= [[UIImageView alloc]init];
    UIImage *img=[UIImage imageLocalWithName:@"about_abox"];
    [imgView setImage:img];
    MyLog(@"%.f_______%.f",self.view.frame.size.width, self.view.frame.size.height);
    imgView.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-64);
    [self.view addSubview:imgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
