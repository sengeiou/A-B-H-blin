//
//  SmaBindWatchViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/8.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaBindWatchViewController.h"
#import "SamCoreBlueTool.h"
#import "SmaTabBarViewController.h"

@interface SmaBindWatchViewController ()<SetSamCoreBlueToolDelegate>

@end

@implementation SmaBindWatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.hidesBottomBarWhenPushed=YES;
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text =SmaLocalizedString(@"seatch_title");
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLab;
    self.navigationItem.titleView.hidden = YES;
    
    SamCoreBlueTool *coreblue=[SamCoreBlueTool sharedCoreBlueTool];
    SmaBleMgr.delegate=self;
    SmaBleMgr.swatchName=self.smaWatchName;
    SmaBleMgr.orSwatchName = self.orSmaWatchName;
    SmaUserInfo *info = [SmaAccountTool userInfo];
    info.scnaSwatchName = self.smaWatchName;
    info.orScnaSwatchName = self.orSmaWatchName;
    [SmaAccountTool saveUser:info];
    
    self.againSearchBtn.hidden=YES;
    self.bindreminderlab.text=SmaLocalizedString(@"seatch_formen");
    self.bindreminderlab.lineBreakMode=NSLineBreakByWordWrapping;
    self.bindreminderlab.numberOfLines=0;
    //扫描
    
  self.title=@"";
  
    self.headremindlab.lineBreakMode=NSLineBreakByWordWrapping;
    self.headremindlab.numberOfLines=0;
    
    self.reminlab.text=SmaLocalizedString(@"beginingseatch_title");
    [self.againSearchBtn setTitle:SmaLocalizedString(@"again_seatch_title") forState:UIControlStateNormal];
    [self.nobangbtn setTitle:SmaLocalizedString(@"nobangtitle") forState:UIControlStateNormal];
//    if ([[SmaUserDefaults stringForKey:@"BLSystemVersion"] stringByReplacingOccurrencesOfString:@"." withString:@""].intValue >= 304) {
//        remindLab.hidden = YES;
         remindLab.text = [NSString stringWithFormat:@"%@",[self.orSmaWatchName isEqualToString:@"SM02"]? SmaLocalizedString(@"bound_remind_02"):SmaLocalizedString(@"bound_remind_04")];
    [remindLab sizeToFit];
    scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, remindLab.frame.origin.y + remindLab.frame.size.height + 10);
    NSLog(@"==%f  %f  %f  %f   %f  %f %f",scrollview.contentOffset.x,scrollview.contentOffset.y,[UIScreen mainScreen].bounds.size.height,remindLab.frame.origin.y,remindLab.frame.size.height,_nobangbtn.frame.origin.y,_nobangbtn.frame.size.height);
//    }
    //self.nobangbtn.titleLabel.text=SmaLocalizedString(@"nobangtitle");
//    [SmaBleMgr oneScanBand:NO];
   
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [SmaBleMgr.mgr stopScan];
    if (SmaBleMgr.peripheral.state != CBPeripheralStateDisconnected) {
        [SmaBleMgr.mgr cancelPeripheralConnection:SmaBleMgr.peripheral];
    }
//    self.orSmaWatchName = nil;
//    self.smaWatchName = nil;
//    SamCoreBlueTool *coreblue=[SamCoreBlueTool sharedCoreBlueTool];
//    coreblue.swatchName=nil;
//    coreblue.orSwatchName = nil;
//    SmaUserInfo *info = [SmaAccountTool userInfo];
//    info.scnaSwatchName = nil;
//    info.orScnaSwatchName = nil;
//    info.watchUID = nil;
//    [SmaAccountTool saveUser:info];
//    SmaBleMgr.mgr=nil;
//    SmaBleMgr.saveMgr = nil;
//    SmaBleMgr.peripherals=nil;
}
-(void)beginFindWatch
{
    MyLog(@"正在开始寻找蓝牙设备");
}
//回调方法，告诉开始绑定按钮
-(void)beginBondWatch:(NSString *)watchName
{

//    self.title = SmaLocalizedString(@"seatch_title");
 self.navigationItem.titleView.hidden = NO;
self.bindreminderlab.text=SmaLocalizedString(@"seatch_forwmen");
    remindLab.text = SmaLocalizedString(@"binging_notif");
self.reminlab.text=SmaLocalizedString(@"binging_title");
    [remindLab sizeToFit];
    SmaBleMgr.bindIng = YES;
}

-(void)nofindWatch
{
//    self.reminImg.image=[UIImage imageNamed:@"is_error"];
    self.reminlab.text=@"";
    self.headremindlab.text=SmaLocalizedString(@"choose_bang_watch_title");
    self.againSearchBtn.hidden=NO;
}
-(void)beginWatchLogin
{
//    self.reminImg.image=[UIImage imageNamed:@"is_succeed_login"];
    self.againSearchBtn.hidden=NO;
    self.nobangbtn.hidden = YES;
 [self.againSearchBtn setTitle:SmaLocalizedString(@"begin_experience") forState:UIControlStateNormal];
    remindLab.text=SmaLocalizedString(@"watch_formen_alt");
    self.reminlab.text=@"";
    self.againSearchBtn.tag=1;
    self.againSearchBtn.titleLabel.text=SmaLocalizedString(@"begin_experience");
    SmaBleMgr.firstBind = YES;
    SmaBleMgr.bindIng = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)aginSearchClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(button.tag==0)
    {
      [SmaBleMgr.mgr stopScan];
//      SmaBleMgr.mgr=nil;
//      SmaBleMgr.saveMgr = nil;
//      [SmaBleMgr oneScanBand];
       self.againSearchBtn.hidden=YES;
       self.headremindlab.text=SmaLocalizedString(@"beginband_seatch");
    }else
    {
       [UIApplication sharedApplication].keyWindow.rootViewController =[[SmaTabBarViewController alloc] init];
    }
}

- (IBAction)stopBindClick:(id)sender {
    [SmaBleMgr.mgr stopScan];
    if (SmaBleMgr.peripheral.state != CBPeripheralStateDisconnected) {
        [SmaBleMgr.mgr cancelPeripheralConnection:SmaBleMgr.peripheral];
    }
    self.orSmaWatchName = nil;
    self.smaWatchName = nil;
    SamCoreBlueTool *coreblue=[SamCoreBlueTool sharedCoreBlueTool];
    coreblue.swatchName=nil;
    coreblue.orSwatchName = nil;
    SmaUserInfo *info = [SmaAccountTool userInfo];
    info.scnaSwatchName = nil;
    info.orScnaSwatchName = nil;
    info.watchUID = nil;
    info.watchName = nil;
    [SmaAccountTool saveUser:info];
    NSLog(@"-___======%@   %@",[SmaAccountTool userInfo].watchName,coreblue.swatchName);
    SmaBleMgr.mgr=nil;
    SmaBleMgr.saveMgr = nil;
    SmaBleMgr.peripherals=nil;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
