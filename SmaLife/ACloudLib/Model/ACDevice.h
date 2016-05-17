//
//  ACDevice.h
//  NetworkingDemo
//
//  Created by zhourx5211 on 12/23/14.
//  Copyright (c) 2014 zhourx5211. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ACDeviceStatusDisabled = 0,
    ACDeviceStatusEnabled,
} ACDeviceStatus;

@interface ACDevice : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger deviceId;
@property (nonatomic, assign) NSInteger groupId;
@property (nonatomic, assign) NSInteger masterDeviceId;
@property (nonatomic, copy) NSString *physicalDeviceId;
@property (nonatomic, assign) NSInteger subdomainId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSData *AESKey;
@property (nonatomic, assign) ACDeviceStatus status;

@end
