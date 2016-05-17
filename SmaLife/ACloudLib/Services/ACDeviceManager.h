//
//  ACDeviceManager.h
//  ACloudLib
//
//  Created by zhourx5211 on 12/16/14.
//  Copyright (c) 2014 zcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACMsg.h"

#define DEVICE_SERVICE @"zc-device"

@interface ACDeviceManager : NSObject

+ (void)createGroupWithName:(NSString *)name
                   callback:(void (^)(ACMsg *msg, NSError *error))callback;

+ (void)modifyGroupWithGroupId:(NSInteger)groupId
                          name:(NSString *)name
                      callback:(void (^)(NSError *error))callback;

+ (void)disableGroupWithGroupId:(NSInteger)groupId
                       callback:(void (^)(NSError *error))callback;

+ (void)enableGroupWithGroupId:(NSInteger)groupId
                      callback:(void (^)(NSError *error))callback;

+ (void)deleteGroupWithGroupId:(NSInteger)groupId
                      callback:(void (^)(NSError *error))callback;
/**
 * 列举某一用户的所有分组。
 * @return 所有组信息
 */
+ (void)listGroupsWithCallback:(void (^)(NSArray *groups, NSError *error))callback;

+ (NSArray *)listGroupsFromCache;

+ (void)addMemberWithGroupId:(NSInteger)groupId
                     account:(NSString *)account
                        name:(NSString *)name
                    callback:(void (^)(NSError *error))callback;

+ (void)modifyMemberWithGroupId:(NSInteger)groupId
                         userId:(NSInteger)userId
                           name:(NSString *)name
                       callback:(void (^)(NSError *error))callback;

+ (void)disableMemberWithGroupId:(NSInteger)groupId
                          userId:(NSInteger)userId
                        callback:(void (^)(NSError *error))callback;

+ (void)enableMemberWithGroupId:(NSInteger)groupId
                         userId:(NSInteger)userId
                       callback:(void (^)(NSError *error))callback;

+ (void)deleteMemberWithGroupId:(NSInteger)groupId
                         userId:(NSInteger)userId
                       callback:(void (^)(NSError *error))callback;
/**
 * 列举某一组内所有成员
 * @param groupId       组id
 * @return 所有成员信息
 */
+ (void)listMembersWithGroupId:(NSInteger)groupId
                      callback:(void (^)(NSArray *members, NSError *error))callback;

+ (void)bindDeviceWithSubDomain:(NSString *)subDomain
                        groupId:(NSInteger)groupId
               physicalDeviceId:(NSString *)physicalDeviceId
                 masterDeviceId:(NSInteger)masterDeviceId
                           name:(NSString *)name
                       bindCode:(NSString *)bindCode
                       callback:(void (^)(ACMsg *msg, NSError *error))callback;

+ (void)changeDeviceWithSubDomain:(NSString *)subDomain
                          groupId:(NSInteger)groupId
                         deviceId:(NSInteger)deviceId
                 physicalDeviceId:(NSString *)physicalDeviceId
                         bindCode:(NSString *)bindCode
                         callback:(void (^)(NSError *error))callback;

+ (void)modifyDeviceWithSubDomain:(NSString *)subDomain
                          groupId:(NSInteger)groupId
                         deviceId:(NSInteger)deviceId
                             name:(NSString *)name
                         callback:(void (^)(NSError *error))callback;

+ (void)disableDeviceWithSubDomain:(NSString *)subDomain
                           groupId:(NSInteger)groupId
                          deviceId:(NSInteger)deviceId
                          callback:(void (^)(NSError *error))callback;


+ (void)enableDeviceWithSubDomain:(NSString *)subDomain
                          groupId:(NSInteger)groupId
                         deviceId:(NSInteger)deviceId
                         callback:(void (^)(NSError *error))callback;

+ (void)deleteDeviceWithSubDomain:(NSString *)subDomain
                          groupId:(NSInteger)groupId
                         deviceId:(NSInteger)deviceId
                         callback:(void (^)(NSError *error))callback;

+ (void)isDeviceOnlineWithSubDomain:(NSString *)subDomain
                            groupId:(NSInteger)groupId
                           deviceId:(NSInteger)deviceId
                           callback:(void (^)(BOOL online, NSError *error))callback;

/**
 * 列举某一组内所有设备
 * @param groupId    组id
 * @return 所有设备信息
 */
+ (void)listDevicesWithGroupId:(NSInteger)groupId
                      callback:(void (^)(NSArray *devices, NSError *error))callback;

+ (NSArray *)listDevicesFromCache;

+ (void)sendToDevice:(NSString *)subDomain
            deviceId:(NSInteger)deviceId
                 msg:(ACDeviceMsg *)msg
            callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback;
@end
