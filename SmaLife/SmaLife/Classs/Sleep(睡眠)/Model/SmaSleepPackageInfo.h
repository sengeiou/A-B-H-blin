//
//  SmaSleepPackageInfo.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/20.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmaSleepPackageInfo : NSObject
/* 睡眠时长 */
@property (nonatomic,strong) NSString *sleephour;
/* 入睡时间 */
@property (nonatomic,strong) NSString *fallAsleepTime;
/* 醒来时间 */
@property (nonatomic,strong) NSString *wakeSleepTime;
/* 醒来时长 */
@property (nonatomic,strong) NSString *soberAmount;
/* 睡眠时长 */
@property (nonatomic,strong) NSString *sleepAmount;
/* 深睡时长 */
@property (nonatomic,strong) NSString *wideSleepAmount;
/* 浅睡时长 */
@property (nonatomic,strong) NSString *lightSleepAmount;
@end
