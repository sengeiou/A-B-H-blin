//
//  SmaSeatInfo.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/14.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmaSeatInfo : NSObject<NSCoding>
//是否开启  0：关闭  1:开启
@property (nonatomic,strong) NSString *isOpen;
//步数阈值
@property (nonatomic,strong) NSString *stepValue;
//是否开启  0：关闭  1:开启
@property (nonatomic,strong) NSString *seatValue;
//开始时间
@property (nonatomic,strong) NSString *beginTime;
//结束时间
@property (nonatomic,strong) NSString *endTime;
//重复周
@property (nonatomic,strong) NSString *pepeatWeek;

@end
