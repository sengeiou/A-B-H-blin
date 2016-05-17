//
//  SmaRemindMainViewController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/9.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PercentageChart.h"

#define MAIN_ORANGE [UIColor colorWithRed:0.83 green:0.38 blue:0.0 alpha:0.5]
#define LINE_ORANGE [UIColor orangeColor]
#define MAIN_RED [UIColor colorWithRed:0.70 green:0.0 blue:0.0 alpha:0.5]
#define LINE_RED [UIColor redColor]
#define MAIN_GREEN [UIColor colorWithRed:0.47 green:0.7 blue:0.0 alpha:0.5]
#define LINE_GREEN [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:0.5


@interface SmaRemindMainViewController : UIViewController
/*标题*/
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
/*电量显示*/
@property (weak, nonatomic) IBOutlet UIButton *electricityTitle;
@property (nonatomic,weak) PercentageChart *chart;

/*防丢提醒*/
@property (weak, nonatomic) IBOutlet UIButton *lostBnt;
/*短信提醒*/
@property (weak, nonatomic) IBOutlet UIButton *noteRemindBtn;
/*来电提醒*/
@property (weak, nonatomic) IBOutlet UIButton *mobileRemindBtn;
/*久坐提醒*/
@property (weak, nonatomic) IBOutlet UIButton *BurnRemindBtn;
/*闹钟提醒*/
@property (weak, nonatomic) IBOutlet UIButton *alarmClockBtn;


- (IBAction)webClick:(id)sender;

- (IBAction)TelephoneClick:(UIButton *)sender;

- (IBAction)SmsClick:(UIButton *)sender;

//防丢按钮是否开启
- (IBAction)loseClick:(UIButton *)checkbox;

//久座设置
- (IBAction)TravelClick:(id)sender;

- (IBAction)clockClick:(id)sender;
@end
