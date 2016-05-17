//
//  SmaUINavigationController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/3.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaNavigationController.h"
#import "SmaUpdateMyInfoController.h"
#import "UIImage+CKQ.h"


@class SmaNoTabBarViewController;
@interface SmaNavigationController ()

@end

@implementation SmaNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    //自定义返回按钮
    UIImage *img=[UIImage imageNamed:@"nav_back_button"];
    CGSize size={img.size.width *0.5,img.size.height*0.5};
    UIImage *backButtonImage = [[UIImage imageByScalingAndCroppingForSize:size imageName:@"nav_back_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,30,0,5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] =SmaColor(255, 255, 255);
    attrs[NSFontAttributeName]=[UIFont fontWithName:@"STHeitiSC-Light" size:19];
    [navBar setTitleTextAttributes:attrs];
    

   [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(320, 3)]];
}



- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:NO];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([viewController isKindOfClass:[SmaNoTabBarViewController class]] || [viewController isKindOfClass:[SmaUpdateMyInfoController class]] )
    {
      viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
}



@end
