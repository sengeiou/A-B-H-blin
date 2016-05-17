//
//  SmaSportInfo.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/20.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmaSportInfo : NSObject
/*用户ID*/
@property (nonatomic,strong) NSString *user_id;
/*用户ID*/
@property (nonatomic,strong) NSString *sport_id;
/*发生时间*/
@property (nonatomic,strong) NSString *sport_data;
/*从每天 0 点 开始,每 15 分钟偏移+1*/
@property (nonatomic,strong) NSNumber *sport_time;
/*步数*/
@property (nonatomic,strong) NSNumber *sport_step;
/*时间段*/
@property (nonatomic,strong) NSNumber *sport_activetime;
/*卡路里*/
@property (nonatomic,strong) NSNumber *sport_calory;
/*运动距离*/
@property (nonatomic,strong) NSNumber *sport_distance;
/*运动上传*/
@property (nonatomic,strong) NSNumber *sport_web;
@end
