//
//  SmaAlarmInfo.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/15.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmaAlarmInfo : NSObject
@property (nonatomic,strong) NSString *clockid;
@property (nonatomic,strong) NSString *dayFlags;
@property (nonatomic,strong) NSString *aid;
@property (nonatomic,strong) NSString *minute;
@property (nonatomic,strong) NSString *hour;
@property (nonatomic,strong) NSString *day;
@property (nonatomic,strong) NSString *mounth;
@property (nonatomic,strong) NSString *year;
@property (nonatomic,strong) NSString *tagname;
@property (nonatomic,strong) NSString *isopen;//是否开启
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *web;
@end
