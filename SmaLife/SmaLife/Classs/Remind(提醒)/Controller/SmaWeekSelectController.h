//
//  SmaWeekSelectController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/13.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SmaAlarmInfo;
@class SmaSeatInfo;
@protocol SmaWeekSelectControllerDelegate <NSObject>
@optional
- (void)loadViewController;
@end


@interface SmaWeekSelectController : UIViewController

@property (nonatomic,weak) NSString  *weekstr;
@property (nonatomic,strong) SmaAlarmInfo *alarmInfo;
@property (nonatomic,strong) SmaSeatInfo *seatInfo;
@property (nonatomic, weak) id<SmaWeekSelectControllerDelegate> delegate;

@end
