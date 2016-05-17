//
//  ACOTAInfo.h
//  AbleCloudLib
//
//  Created by leverly on 15/7/11.
//  Copyright (c) 2015年 ACloud. All rights reserved.
//


#import <Foundation/Foundation.h>

//  OTA基本信息
@interface ACOTAUpgradeInfo : NSObject

// 原版本
@property(nonatomic,copy) NSString *oldVersion;
// 新版本
@property(nonatomic,copy) NSString *upgradeVersion;
// 升级描述
@property(nonatomic,copy) NSString *upgradeLog;
//file信息
@property(nonatomic,strong) NSArray * file;
//otaMode
@property(nonatomic,unsafe_unretained) long otaMode;

-(BOOL)isUpdate;

@end