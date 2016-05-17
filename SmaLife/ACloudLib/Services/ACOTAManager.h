//
//  ACOTAManager.h
//  AbleCloudLib
//
//  Created by zhourx5211 on 7/15/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACOTAFileMeta.h"
#import "ACOTAUpgradeInfo.h"
#import "ACOTACheckInfo.h"

#define OTA_SERVICE @"zc-ota"

@interface ACOTAManager : NSObject

+ (void)checkUpdateWithSubDomain:(NSString *)subDomain
                        deviceId:(NSInteger)deviceId
                        callback:(void (^)(ACOTAUpgradeInfo *upgradeInfo, NSError *error))callback;

+ (void)confirmUpdateWithSubDomain:(NSString *)subDomain
                          deviceId:(NSInteger)deviceId
                        newVersion:(NSString *)newVersion
                          callback:(void (^)(NSError *error))callback;

+ (void)bluetoothVersionWithSubDomain:(NSString *)subDomain
                             callback:(void (^)(ACOTAUpgradeInfo *upgradeInfo, NSError *error))callback;

+ (void)listFilesWithSubDomain:(NSString *)subDomain
                       version:(NSString *)version
                      callback:(void (^)(NSArray *fileMetaArray, NSError *error))callback;

+ (void)bluetoothFileWithSubDomain:(NSString *)subDomain
                              type:(NSInteger)type
                          checksum:(NSInteger)checksum
                           version:(NSString *)version
                          callback:(void (^)(NSData *fileData, NSError *error))callback;
+(void)checkBluetoothUpdateWithSubDomain:(NSString *)subDomain CheckInfo:(ACOTACheckInfo *)checkInfo Callback:(void(^)(ACOTAUpgradeInfo * upgrateInfo,NSError * error))callback;
@end