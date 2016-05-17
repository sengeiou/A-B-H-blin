//
//  ACloudLib.h
//  ACloudLib
//
//  Created by zhourx5211 on 14/12/8.
//  Copyright (c) 2014年 zcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACMsg.h"
#import "ACDeviceMsg.h"


//*****测试开发环境******
#define TEST_MODE @"test"
//*****正式开发环境******
#define PRODUCTION_MODE @"production"

//*****国内开发环境******
#define REGIONAL_CHINA @"REGIONAL_CHINA"
//*****国外开发环境******
//东南亚开发环境
#define REGIONAL_SOUTHEAST_ASIA @"REGIONAL_SOUTHEAST_ASIA"

@interface ACloudLib : NSObject

+ (void)setMode:(NSString *)mode Region:(NSString *)region;
+ (NSString *)getHost;

+ (void)setMajorDomain:(NSString *)majorDomain majorDomainId:(NSInteger)majorDomainId;
+ (NSString *)getMajorDomain;
+ (NSInteger)getMajorDomainId;

+ (void)setHttpRequestTimeout:(NSString *)timeout;
+ (NSString *)getHttpRequestTimeout;

+ (void)sendToService:(NSString *)subDomain
          serviceName:(NSString *)name
              version:(NSInteger)version
                  msg:(ACMsg *)msg
             callback:(void (^)(ACMsg *responseMsg, NSError *error))callback;


+ (void)sendToLocalDevice:(NSTimeInterval)timeout
                 deviceId:(NSInteger)deviceId
                      msg:(ACDeviceMsg *)msg
                 callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback;
/**
 *  局域网发现设备
 *
 *  @param timeout     超时时间
 *  @param subDomainId 子域id
 *  @param callback    返回结果的回调
 */
-(void)findDeviceTimeout:(NSInteger )timeout
             SudDomainId:(NSInteger)subDomainId
                callback:(void(^)(NSArray * deviceList,NSError * error))callback;
@end
