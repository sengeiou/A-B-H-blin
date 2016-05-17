//
//  ACServiceClient.h
//  ACloudLib
//
//  Created by zhourx5211 on 12/11/14.
//  Copyright (c) 2014 zcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACMsg.h"

@interface ACServiceClient : NSObject

@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *service;
@property (nonatomic, assign) NSInteger serviceVersion;

- (id)initWithHost:(NSString *)host service:(NSString *)service version:(NSInteger)version;

+ (instancetype)serviceClientWithHost:(NSString *)host service:(NSString *)service version:(NSInteger)version;

- (void)sendToService:(ACMsg *)req callback:(void (^)(ACMsg *responseObject, NSError *error))callback;

@end
