//
//  SmaSelectWatchViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/8.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaSelectWatchViewController.h"
#import "SmaBindWatchViewController.h"
#import "SmaNavigationController.h"
#import "SmaTabBarViewController.h"
#import "AppDelegate.h"
@interface SmaSelectWatchViewController ()
{
    AppDelegate *appDele;
}
@end

@implementation SmaSelectWatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!appDele) {
        appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }

        [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.hidesBottomBarWhenPushed=YES;

     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"sport_navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    UIImage *img=[UIImage imageNamed:@"nav_back_button"];
    CGSize size={img.size.width *0.5,img.size.height*0.5};
    UIImage *backButtonImage = [[UIImage imageByScalingAndCroppingForSize:size imageName:@"nav_back_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,30,0,5)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 30);
    button.imageEdgeInsets =UIEdgeInsetsMake(0, -28, 0, 0);
    [button setImage:backButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;

    self.title=SmaLocalizedString(@"biandnav_tilte");
    self.formenlab.text=SmaLocalizedString(@"watch_model_forman");
    self.forwmenlab.text=SmaLocalizedString(@"watch_model_forwomen");
    [self.shopbtn setTitle:SmaLocalizedString(@"shops_watch") forState:UIControlStateNormal];
    [self.nobandbtn setTitle:SmaLocalizedString(@"nobangtitle") forState:UIControlStateNormal];
    watchArr = @[@"bond_1 - 副本",@"bond_2 - 副本"];
    watchSelArr = @[@"bond_1",@"bond_2"];
    selectIntex = 0;
    [watchBut setImage:[UIImage imageNamed:watchArr[selectIntex]] forState:UIControlStateNormal];
     [watchBut setImage:[UIImage imageNamed:watchSelArr[selectIntex]] forState:UIControlStateHighlighted];
    SmaUserInfo *userinfo = [SmaAccountTool userInfo];

}
- (void)backClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
    for (UIView *child in appDele.tabVC.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated{
    SmaUserInfo *info = [SmaAccountTool userInfo];
    info.watchUID=nil;
    info.OTAwatchName = nil;
    info.watchName=nil;
    info.scnaSwatchName = nil;
    info.orScnaSwatchName = nil;
    SamCoreBlueTool *coreblue=[SamCoreBlueTool sharedCoreBlueTool];
    coreblue.swatchName=nil;
    coreblue.orSwatchName = nil;
    [SmaAccountTool saveUser:info];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//绑定女表
- (IBAction)womenWatch:(id)sender {
    SmaBindWatchViewController *bondWatchVc = [[SmaBindWatchViewController alloc] init];
    bondWatchVc.smaWatchName=@"BLKK";//女款@"IOS-TESTIOS-TEST";//@"ANCS";//
    bondWatchVc.orSmaWatchName=@"BLKK";//女款@"IOS-TESTIOS-TEST";//@"ANCS";//
    [self.navigationController pushViewController:bondWatchVc animated:YES];
}
//绑定男表
- (IBAction)manWatch:(id)sender {
    SmaBindWatchViewController *bondWatchVc = [[SmaBindWatchViewController alloc] init];
    bondWatchVc.smaWatchName=@"BLKK";//女款@"IOS-TESTIOS-TEST";//@"ANCS";//
    bondWatchVc.orSmaWatchName=@"BLKK";//女款@"IOS-TESTIOS-TEST";//@"ANCS";//
    [self.navigationController pushViewController:bondWatchVc animated:YES];
}
//购买Watch
- (IBAction)shopWatch:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.blinkked.com"]];
}
//停止绑定
- (IBAction)backNoBind:(id)sender {
   if([self.parentViewController isKindOfClass:[SmaNavigationController class]])
   {
       [self.navigationController popToRootViewControllerAnimated:YES];
       for (UIView *child in appDele.tabVC.tabBar.subviews) {
           if ([child isKindOfClass:[UIControl class]]) {
               [child removeFromSuperview];
           }
       }
   }else
   {
     [UIApplication sharedApplication].keyWindow.rootViewController =[[SmaTabBarViewController alloc] init];
   }
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

//左右选择
- (IBAction)selectWatch:(id)sender{
    UIButton *but = (UIButton *)sender;
    if (but == leftBut) {
        selectIntex--;
        if (selectIntex<0) {
            selectIntex = 1;
        }
    }
    else{
        selectIntex ++;
        if (selectIntex>1) {
            selectIntex = 0;
        }
    }
     [watchBut setImage:[UIImage imageNamed:watchArr[selectIntex]] forState:UIControlStateNormal];
    [watchBut setImage:[UIImage imageNamed:watchSelArr[selectIntex]] forState:UIControlStateHighlighted];
    

}

-(void)viewWillDisappear:(BOOL)animated
{
   SmaBleMgr.rssivalue=@"-200";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"setting_navgitionbar_background"] forBarMetrics:UIBarMetricsDefault];
    [super viewWillDisappear:animated];
}
@end
