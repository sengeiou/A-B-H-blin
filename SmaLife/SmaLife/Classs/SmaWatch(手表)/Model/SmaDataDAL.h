//
//  SmaDataDAL.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/17.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmaSleepPackageInfo.h"
#import "ACloudLib.h"
@class SmaSportResultInfo;
@class SmaAlarmInfo;

@interface SmaDataDAL : NSObject
//插入睡眠数据
-(void)insertSleepInfo:(NSMutableArray *)infos;
//更新睡眠数据
- (void)updateSleepInfo:(NSMutableArray *)infos;
- (void)updateSleepData:(NSNumber *)today yestday:(NSNumber *)yestday iswear:(BOOL)wear;
//获取睡眠数据
-(SmaSleepPackageInfo *)getSleepData;
//获取详细运动数据
- (NSMutableArray *)getMinuteSleep:(NSString *)userID;
//插入运动数据
-(void)insertSmaSport:(NSMutableArray *)infos;
//更新活动数据
- (void)updateSportInfo:(NSMutableArray *)infos;
//运动数据
-(SmaSportResultInfo *)getSmaSport:(NSNumber *)data;
//获取详细运动数据
- (NSMutableArray *)getMinuteSport:(NSString *)userID;
/**
 *  <#Description#>
 *
 *  @param typeInt 统计类型 0 按天，1 按周，2 按月
 *
 *  @return 返回统计结果，以及返回统计图结果
 */
-(NSMutableArray *)getSportCount:(int)typeInt;

/**
 *  <#Description#> 获取今天的睡眠数据
 *
 *  @param today   昨天
 *  @param yestday 今天
 *
 *  @return <#return value description#>
 */
-(NSMutableDictionary *)getSleepDataDay:(NSNumber *)today yestday:(NSNumber *)yestday;
//获取闹钟列表

-(NSMutableArray *)selectClockList;
-(NSMutableArray *)selectWebClockList:(NSString *)userID;
//插入闹钟
-(void)insertClockInfo:(SmaAlarmInfo *)clockInfo;
//修改闹钟
-(void)updateClockInfo:(SmaAlarmInfo *)clockInfo;
//删除闹钟
-(void)deleteClockInfo:(NSString *)clockId;
-(void)deleteClockUserInfo:(NSString *)userID success:(void (^)(id))success failure:(void (^)(id))failure;
//查询闹钟数
-(NSMutableArray *)getSelectClockCount;

-(void)updateClockIsOpenOrderById:(NSString *)clockId isOpen:(BOOL)isOpen;
@end
