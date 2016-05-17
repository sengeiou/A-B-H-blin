//
//  SmaMyInfoController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/15.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaMyInfoController.h"

@interface SmaMyInfoController ()

@end

@implementation SmaMyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人信息";
    
    [self loadInfo];
    // Do any additional setup after loading the view.
}

-(void)loadInfo
{
   UIImageView *view = [[UIImageView alloc]init];
   UIImage *bgImg = [UIImage imageNamed:@"login_background"];
   [view setImage:bgImg];
    
   UIImage *headimg=[UIImage imageNamed:@"default_head_img"];
   UIImageView *headView = [[UIImageView alloc]init];
   [headView setImage:headimg];
   headView.frame=CGRectMake((self.view.frame.size.width-headimg.size.width)/2, 18, headimg.size.width, headimg.size.height);
   [view addSubview:headView];
    
    UIImage *bodyImg=[UIImage imageNamed:@"body_img_bg"];
    UIImageView *bodyView=[[UIImageView alloc]init];
    [bodyView setImage:bodyImg];
    bodyView.frame=CGRectMake(4, headView.frame.size.height+headView.frame.origin.y+11, bodyImg.size.width, bodyImg.size.height);
    
    UITextField *accountName=[[UITextField alloc]init];
    accountName.frame=CGRectMake(0, 0,bodyImg.size.width, 40);
    [bodyView addSubview:accountName];
    
    UIButton *birthBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *birthImg=[UIImage imageNamed:@"birthday_ico"];
    birthBtn.frame=CGRectMake(28,(54-birthImg.size.height)/2+37, 100, birthImg.size.height);
    [bodyView addSubview:birthBtn];
    
    
    UIButton *sexBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *sexImg=[UIImage imageNamed:@"sex-ico"];
    sexBtn.frame=CGRectMake(28,(54-birthImg.size.height)/2+37+54, 100, sexImg.size.height);
    [bodyView addSubview:sexBtn];
    
    UIButton *heightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *heightImg=[UIImage imageNamed:@"height_ico"];
    heightBtn.frame=CGRectMake(28,(54-birthImg.size.height)/2+37+54*2, 100, heightImg.size.height);
    [bodyView addSubview:heightBtn];
    
    UIButton *weightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *weightmg=[UIImage imageNamed:@"weight_ico"];
    weightBtn.frame=CGRectMake(28,(54-birthImg.size.height)/2+74*2, 100, weightmg.size.height);
    [bodyView addSubview:weightBtn];

    [view addSubview:bodyView];
    
    view.frame=CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
