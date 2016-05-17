//
//  SmaSportMainViewController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/10.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmaSportMainViewController : UIViewController

/*head begin*/
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIButton *lefebtn;
@property (weak, nonatomic) IBOutlet UIButton *rigthbtn;
/*head end*/

/*foot  begin*/


@property (weak, nonatomic) IBOutlet UIImageView *footView;
@property (weak, nonatomic) IBOutlet UIView *planView;
@property (weak, nonatomic) IBOutlet UILabel *remarklab;
@property (weak, nonatomic) IBOutlet UILabel *unitlable;
//目标步数
@property (weak, nonatomic) IBOutlet UILabel *stepNumberLab;
//底部里程，卡路里的View
@property (weak, nonatomic) IBOutlet UIView *bottomView;

/*foot  end*/

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIView *chartView;
//报表
@property (weak, nonatomic) IBOutlet UILabel *chartLab;

//里程
@property (weak, nonatomic) IBOutlet UILabel *mileageLab;
//步数
@property (weak, nonatomic) IBOutlet UILabel *stepsLab;
//热量
@property (weak, nonatomic) IBOutlet UILabel *hotLab;
@property (weak, nonatomic) IBOutlet UILabel *dataLab;
//计划的View
@property (weak, nonatomic) IBOutlet UIView *planView1;

//日前增加
- (IBAction)dataAddClick:(id)sender;
//日前减少
- (IBAction)dataCutClick:(id)sender;


@end
