//
//  SmaRelieveBoundViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/8.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaRelieveBoundViewController.h"
#import "SmaAccountTool.h"
#import "SmaUserInfo.h"
#import "SamCoreBlueTool.h"
#import "SmaSelectWatchViewController.h"

@interface SmaRelieveBoundViewController ()

@end

@implementation SmaRelieveBoundViewController
@synthesize systemLab;
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:YES];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController.navigationItem setHidesBackButton:YES];
    
    SamCoreBlueTool *coreblue=[SamCoreBlueTool sharedCoreBlueTool];
    //扫描
    [coreblue relieveWatchBound];
    coreblue.swatchName = @"";
    coreblue.orSwatchName = @"";
    SmaUserInfo *userInfo=[SmaAccountTool userInfo];
    userInfo.scnaSwatchName = nil;
    userInfo.orScnaSwatchName = nil;
    userInfo.watchName=@"";
    userInfo.OTAwatchName = @"";
    userInfo.watchUID=[[NSUUID alloc]initWithUUIDString:@""];
    [SmaAccountTool saveUser:userInfo];
    if (SmaBleMgr.peripheral.state == CBPeripheralStateConnected) {
        [SmaBleMgr.mgr cancelPeripheralConnection:SmaBleMgr.peripheral];
    }
    SmaBleMgr.mgr=nil;
    SmaBleMgr.saveMgr = nil;
    SmaBleMgr.peripherals=nil;
    SmaBleMgr.peripheral = nil;
    [self.succeedbtn setTitle:SmaLocalizedString(@"relievebandbnttitle") forState:UIControlStateNormal];
    [self.againbtn setTitle:SmaLocalizedString(@"againbandbnttitle") forState:UIControlStateNormal];
    NSLog(@"30023-023===%d",[[SmaUserDefaults stringForKey:@"BLSystemVersion"] stringByReplacingOccurrencesOfString:@"." withString:@""].intValue);
//    if ([[SmaUserDefaults stringForKey:@"BLSystemVersion"] stringByReplacingOccurrencesOfString:@"." withString:@""].intValue >= 304) {
        self.attenLab.hidden = NO;
        self.attenLab.text = SmaLocalizedString(@"selectConnetcAgain");
//        [self.attenLab sizeToFit];
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.attenLab.frame.origin.y + self.attenLab.frame.size.height + 10);
//    }
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"alert_title") message:SmaLocalizedString(@"selectConnetcAgain") delegate:self cancelButtonTitle:SmaLocalizedString(@"clockadd_confirm") otherButtonTitles:nil, nil];
//    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



//确定绑定，返回到上一页
- (IBAction)backClick:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}
//重新绑定
- (IBAction)againBound:(id)sender {
    SmaSelectWatchViewController *bondWatchVc = [[SmaSelectWatchViewController alloc] init];
    [self.navigationController pushViewController:bondWatchVc animated:YES];

   }
@end
