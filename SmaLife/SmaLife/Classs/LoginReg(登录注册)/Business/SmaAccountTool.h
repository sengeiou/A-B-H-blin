//
//  SmaAccountTool.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/7.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SmaUserInfo;
@class SmaSeatInfo;
@class SmaSleepInfo;
@interface SmaAccountTool : NSObject
//保存用户
+ (void)saveUser:(SmaUserInfo *)userInfo;
//获取用户
+ (SmaUserInfo *)userInfo;


/*久坐设置 begin*/
+ (void)saveSeat:(SmaSeatInfo *)seatInfo;

+ (SmaSeatInfo *)seatInfo;
/*久坐设置 end*/
+ (void)saveSleep: (SmaSleepInfo *)sleepInfo;
+ (SmaSleepInfo *)sleepInfo;
@end
