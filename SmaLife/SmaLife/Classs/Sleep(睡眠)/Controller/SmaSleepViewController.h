//
//  SmaSleepViewController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/12.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmaSleepViewController : UIViewController<UIAlertViewDelegate>
{
    UIAlertView *sleepAler;
    int prevTime;//上一时间点
    int prevData;//上一天数
    int prevType;//上一类型
    int soberAmount;//清醒时间
    int simpleSleepAmount;//浅睡眠时长
    int deepSleepAmount;//深睡时长
    int slBeTime; //睡眠时间
    int slEnTime; //醒来时间
    int atType;// 睡眠状态
    int deepTypeNum;
    BOOL wear;
}
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *datelab;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

- (IBAction)rightBtnClick:(id)sender;
- (IBAction)leftBtnClick:(id)sender;



@property (weak, nonatomic) IBOutlet UIImageView *bodyView;

@property (weak, nonatomic) IBOutlet UIView *circleView;



@property (weak, nonatomic) IBOutlet UIView *planView;
@property (weak, nonatomic) IBOutlet UIImageView *downIView;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;
@property (weak, nonatomic) IBOutlet UILabel *sleepStatu;


@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UILabel *deepSleep;
@property (weak, nonatomic) IBOutlet UILabel *simpleSleep;
@property (weak, nonatomic) IBOutlet UILabel *soberSleep;



@end
