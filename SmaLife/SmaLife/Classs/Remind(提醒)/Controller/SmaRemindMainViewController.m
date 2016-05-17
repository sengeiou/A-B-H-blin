//
//  SmaRemindMainViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/9.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaRemindMainViewController.h"
#import "SmaTravelViewController.h"
#import "SmaAlarmClockViewController.h"
#import "SmaAlarMainController.h"
#import "SmaRravelViewController.h"
#import "SmaDataDAL.h"
#import "SmaSeatInfo.h"



@interface SmaRemindMainViewController ()<SetSamCoreBlueToolDelegate>
{
    CGFloat _percentage;
}
@end

@implementation SmaRemindMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=SmaLocalizedString(@"remind_navtilte");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithName:@"remind_nav_background"] forBarMetrics:UIBarMetricsDefault];
    
    [self loadLayout];
    PercentageChart *chart=[[PercentageChart alloc]init];
    _chart=chart;
    [self.chart setMainColor:SmaColor(195,14,46)];
    [self.chart setLineColor:SmaColor(195,14,46)];
    [self.chart setSecondaryColor:SmaColor(140,140,140)];
    [self.chart setFontName:@"Helvetica-Bold"];
    [self.chart setFontSize:8.0];
    [self.chart setText:@""];
    self.chart.frame=CGRectMake(5, 10, self.electricityTitle.frame.size.width-10,  self.electricityTitle.frame.size.height-10) ;
    [self.electricityTitle addSubview:self.chart];
    
    [self.chart setPercentage:0];
    
    SmaBleMgr.delegate=self;
    
    [self loadViewSelect];
    
    //self.titleBtn.userInteractionEnabled=YES;
    
}


-(void)loadViewSelect
{
    SmaDataDAL *dal=[[SmaDataDAL alloc]init];
    NSMutableArray *dictw=[dal getSelectClockCount];
    NSString *count=@"0";
    if(dictw.count>0)
        count=(NSString *)dictw[0];
    
    if([count intValue]>0)
    {
        self.alarmClockBtn.selected=true;
    }else{
        self.alarmClockBtn.selected=false;
    }
    SmaSeatInfo *info=[SmaAccountTool seatInfo];
    
    if(info && [info.isOpen intValue]>0)
    {
        self.BurnRemindBtn.selected=true;
        MyLog(@"开启了");
    }else
    {
        self.BurnRemindBtn.selected=false;
        MyLog(@"关闭了");
    }
    
    [self.lostBnt setImage:[UIImage imageLocalWithName:@"prevent_lose_button_img"] forState:UIControlStateNormal];
    [self.lostBnt setImage:[UIImage imageLocalWithName:@"prevent_lose_button_img_sel"] forState:UIControlStateSelected];
    
    [self.noteRemindBtn setImage:[UIImage imageLocalWithName:@"note_button_img"] forState:UIControlStateNormal];
    [self.noteRemindBtn setImage:[UIImage imageLocalWithName:@"note_button_img_sel"] forState:UIControlStateSelected];
    
    [self.mobileRemindBtn setImage:[UIImage imageLocalWithName:@"phone_remind_button_img"] forState:UIControlStateNormal];
    [self.mobileRemindBtn setImage:[UIImage imageLocalWithName:@"phone_remind_button_img_sel"] forState:UIControlStateSelected];
    
    [self.BurnRemindBtn setImage:[UIImage imageLocalWithName:@"burntheplanks_button_img"] forState:UIControlStateNormal];
    [self.BurnRemindBtn setImage:[UIImage imageLocalWithName:@"burntheplanks_button_img_sel"] forState:UIControlStateSelected];
    
    [self.alarmClockBtn setImage:[UIImage imageLocalWithName:@"alarmclock_button_img"] forState:UIControlStateNormal];
    [self.alarmClockBtn setImage:[UIImage imageLocalWithName:@"alarmclock_button_img_sel"] forState:UIControlStateSelected];
    
}
-(void)loadLayout
{
    /*获取本地数据*/
    
    NSInteger myInteger = [SmaUserDefaults integerForKey:@"myLoseInt"];
    
    if(!myInteger || myInteger==0)//没有开启防丢
    {
        self.lostBnt.selected=false;
        
    }else //没有开启了防丢
    {
        self.lostBnt.selected=true;
    }
    
    NSInteger myTelInteger = [SmaUserDefaults integerForKey:@"myTelRemindInt"];
    if(!myTelInteger || myTelInteger==0)//没有开启来电显示
    {
        self.mobileRemindBtn.selected=false;
    }else //没有开启来电显示
    {
        self.mobileRemindBtn.selected=true;
    }
    
    NSInteger mySmsRemind = [SmaUserDefaults integerForKey:@"mySmsRemindInt"];
    if(!mySmsRemind || mySmsRemind==0)//没有开启短信
    {
        self.noteRemindBtn.selected=false;
    }else //没有开启短信
    {
        self.noteRemindBtn.selected=true;
    }
    
    
    
    CGFloat marginAbout=4;
    CGFloat leftmargin=12;
    CGFloat topmargin=5;
    CGFloat f4sh=0;
    CGFloat mtop=14;
    CGFloat top=19;
    CGFloat left=16;
    if(!fourInch)
    {
        topmargin=2;
        leftmargin=18;
        top=2;
        mtop=8;
        f4sh=10;
        marginAbout=8;
        left=24;
    }
    UIImage *title=[UIImage imageNamed:@"title_button_img"];
    
    self.titleBtn.frame=CGRectMake(leftmargin,mtop,title.size.width-f4sh,title.size.height-f4sh);
    
    UIImage *electricity=[UIImage imageNamed:@"electricity_button_img"];
    
    self.electricityTitle.frame=CGRectMake(self.titleBtn.frame.origin.x+title.size.width+marginAbout,mtop,electricity.size.width-f4sh,electricity.size.height-f4sh);
    
    UIImage *lose=[UIImage imageNamed:@"prevent_lose_button_img"];
    
    self.lostBnt.frame=CGRectMake(leftmargin,topmargin+self.electricityTitle.frame.size.height+self.electricityTitle.frame.origin.y,lose.size.width-f4sh,lose.size.height-f4sh);
    self.noteRemindBtn.frame=CGRectMake(leftmargin,self.lostBnt.frame.origin.y+self.lostBnt.frame.size.height+topmargin,lose.size.width-f4sh,lose.size.height-f4sh);
    self.mobileRemindBtn.frame=CGRectMake(leftmargin,self.noteRemindBtn.frame.origin.y+self.noteRemindBtn.frame.size.height+topmargin,lose.size.width-f4sh,lose.size.height-f4sh);
    
    UIImage *burntheplanks=[UIImage imageNamed:@"burntheplanks_button_img"];
    self.BurnRemindBtn.frame=CGRectMake(lose.size.width+left,title.size.height+top,burntheplanks.size.width-f4sh,burntheplanks.size.height-2*f4sh);
    
    self.alarmClockBtn.frame=CGRectMake(lose.size.width+left,self.BurnRemindBtn.frame.origin.y+self.BurnRemindBtn.frame.size.height+topmargin+f4sh*0.5,burntheplanks.size.width-f4sh,burntheplanks.size.height-2*f4sh);
    
}

//请求电量
-(void)requestElectric
{
    MyLog(@"这是什么情况");
    if(SmaBleMgr.checkBleStatus)
    {
        [SmaBleMgr getElectric];
        MyLog(@"这是什么情况11");
        // MyLog(@"___________%@________________",SmaLocalizedString(@"remind_linkstateom"));
        //        [self.chart setPercentage:95.0];
        [self.chart setText:SmaLocalizedString(@"remind_linkstateom")];
        
    }else
    {
        MyLog(@"这是什么情况2");
        [self.chart setPercentage:0.0];
        [self.chart setText:SmaLocalizedString(@"remind_linkstateoff")];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    SmaBleMgr.delegate=self;
    [self loadViewSelect];
    [self loadLayout];
    [self requestElectric];
}

-(void)NotificationElectric:(NSString *)ratioStr
{
    MyLog(@"获取电量__%@",ratioStr);
    if([ratioStr intValue] == 0)
    {
        [self requestElectric];
    }
    NSString *str= [ratioStr stringByReplacingOccurrencesOfString:@"%" withString:@""];
    [self.chart setPercentage:[str floatValue]];
    [self.chart setText:SmaLocalizedString(@"remind_linkstateom")];
}


//防丢设置
- (IBAction)loseClick:(UIButton *)checkbox {
    
    if([SmaBleMgr checkBleStatus])
    {
        checkbox.selected = !checkbox.isSelected;
        int myInteger = (checkbox.selected)?1:0;
        [SmaUserDefaults setInteger:myInteger forKey:@"myLoseInt"];
        if(myInteger==1)
            [SmaBleMgr openDefendLose];//打开防丢
        else
            [SmaBleMgr closeDefendLose];//关闭防丢
    }
}

- (IBAction)TravelClick:(id)sender {
    if([SmaBleMgr checkBleStatus])
    {
        SmaRravelViewController *settingVc = [[SmaRravelViewController alloc] init];
        [self.navigationController pushViewController:settingVc animated:YES];
    }
}

- (IBAction)clockClick:(id)sender {
    if([SmaBleMgr checkBleStatus])
    {
        SmaAlarMainController *settingVc = [[SmaAlarMainController alloc] init];
        [self.navigationController pushViewController:settingVc animated:YES];
    }
}

- (IBAction)webClick:(id)sender {
    MyLog(@"哈哈哈");
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://en.emie.com/nevo"]];
}

- (IBAction)TelephoneClick:(UIButton *)sender {
    
    if([SmaBleMgr checkBleStatus])
    {
        sender.selected = !sender.isSelected;
        int myInteger = (sender.selected)?1:0;
        [SmaUserDefaults setInteger:myInteger forKey:@"myTelRemindInt"];
//        if ([SmaBleMgr.peripheral.name isEqualToString:@"SM02"] ||[SmaBleMgr.peripheral.name isEqualToString:@"SM04"]) {
            if (myInteger == 1) {
                [SmaBleMgr setphonespark:YES];
            }
            else {
                [SmaBleMgr setphonespark:NO];
            }
//        }
        
    }
}

- (IBAction)SmsClick:(UIButton *)sender {
    if([SmaBleMgr checkBleStatus])
    {
        sender.selected = !sender.isSelected;
        int myInteger = (sender.selected)?1:0;
        [SmaUserDefaults setInteger:myInteger forKey:@"mySmsRemindInt"];
//        if ([SmaBleMgr.peripheral.name isEqualToString:@"SM02"] ||[SmaBleMgr.peripheral.name isEqualToString:@"SM04"]) {
        
            if (myInteger == 1) {
                [SmaBleMgr setSmsPhonespark:YES];
            }
            else {
                [SmaBleMgr setSmsPhonespark:NO];
            }
//        }
    }
}
@end
