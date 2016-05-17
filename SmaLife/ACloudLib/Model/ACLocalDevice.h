//
//  ACLocalDevice.h
//  AbleCloud
//
//  Created by zhourx5211 on 1/18/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACLocalDevice : NSObject

@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, assign) NSInteger subDomainId;
@property (nonatomic, strong) NSString *ip;

@end
