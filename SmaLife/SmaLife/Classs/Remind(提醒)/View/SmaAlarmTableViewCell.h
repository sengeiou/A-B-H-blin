//
//  SmaAlarmTableViewCell.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/12.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SmaAlarmInfo;
@protocol SmaAlarmTableViewCellDelegate <NSObject>
@optional
- (void)loadTableViewController;
@end

@interface SmaAlarmTableViewCell : UITableViewCell
@property (weak, nonatomic) UILabel *timeLab;
@property (weak, nonatomic) UIImageView *timeImg;
@property (weak, nonatomic) UILabel *alarmSort;
@property (weak, nonatomic) UIButton *alarmSwitch;
@property (weak, nonatomic) UILabel *weeklab;
@property (nonatomic, weak) id<SmaAlarmTableViewCellDelegate> delegate;
@property (nonatomic, strong) SmaAlarmInfo *alarmInfo;

@property (nonatomic, weak) UIView *topView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
