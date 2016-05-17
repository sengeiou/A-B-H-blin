//
//  SmaSleepInfo.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/16.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmaSleepInfo : NSObject
/*用户ID*/
@property (nonatomic,strong) NSString *user_id;
/*用户ID*/
@property (nonatomic,strong) NSString *sleep_id;
/*发生时间*/
@property (nonatomic,strong) NSString *sleep_data;
/*从Date 0点开始的分钟数, 例如1440, 就 表示这个数据时 11月10日 0点发生的*/
@property (nonatomic) NSString *sleep_time;
/*睡眠模式*/
@property (nonatomic) NSNumber *sleep_mode;
/*轻微活动*/
@property (nonatomic) NSNumber *sleep_softly;
/*剧烈活动*/
@property (nonatomic) NSNumber *sleep_strong;
/* 睡眠类型 0 睡眠数据  1 睡眠设定数据  */
@property (nonatomic) NSNumber *sleep_type;
/* 是否带表*/
@property (nonatomic) NSNumber *sleep_wear;
/* 是否上传*/
@property (nonatomic) NSNumber *sleep_web;
@end
