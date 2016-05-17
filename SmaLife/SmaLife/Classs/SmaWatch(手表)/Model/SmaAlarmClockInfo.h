//
//  SmaAlarmClockInfo.h
//  SmaWatch
//
//  Created by 有限公司 深圳市 on 15/4/2.
//  Copyright (c) 2015年 smawatch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmaAlarmClockInfo : NSObject
/* 年*/
@property (nonatomic, strong) NSString *year;
/*月*/
@property (nonatomic, strong) NSString *month;
/* 日*/
@property (nonatomic, strong) NSString *day;
/*时*/
@property (nonatomic, strong) NSString *hour;
/*分*/
@property (nonatomic, strong) NSString *minute;
/*秒*/
@property (nonatomic, strong) NSString *second;
/*秒*/
@property (nonatomic, retain) NSNumber *acId;
@end
