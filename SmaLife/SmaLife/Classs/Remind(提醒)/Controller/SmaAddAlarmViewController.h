//
//  SmaAddAlarmViewController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/12.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SmaAlarmInfo;
@protocol SmaWeekClickControllerDelegate <NSObject>
@optional
- (void)loadClickView;
@end

@interface SmaAddAlarmViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) SmaAlarmInfo *alarmInfo;
@property (nonatomic, weak) id<SmaWeekClickControllerDelegate> delegate;
@end
