//
//  SmaSportDetailViewController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/20.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBChartView;

@interface SmaSportDetailViewController : UIViewController
{
    int selectIndex;
}
@property (weak, nonatomic) IBOutlet UIImageView *bodyView;

@property (weak, nonatomic) IBOutlet UIImageView *dataView;


@property (weak, nonatomic) IBOutlet UISegmentedControl *actualTypeValue;
@property (nonatomic,weak) CBChartView *chart;
- (IBAction)ValueChange:(UISegmentedControl *)sender;


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

//里程
@property (weak, nonatomic) IBOutlet UILabel *mileageLab;
//步数
@property (weak, nonatomic) IBOutlet UILabel *stepsLab;
//热量
@property (weak, nonatomic) IBOutlet UILabel *hotLab;


@end
