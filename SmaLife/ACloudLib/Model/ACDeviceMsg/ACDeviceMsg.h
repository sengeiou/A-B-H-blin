//
//  ACDeviceMsg.h
//  NetworkingDemo
//
//  Created by zhourx5211 on 12/25/14.
//  Copyright (c) 2014 zhourx5211. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACDeviceMsg : NSObject

@property (nonatomic, assign) NSInteger msgId;
@property (nonatomic, assign) NSInteger msgCode;
@property (nonatomic, strong) NSData *payload;
@property (nonatomic, strong) NSArray *optArray;

+ (instancetype)unmarshalWithData:(NSData *)data;
+ (instancetype)unmarshalWithData:(NSData *)data AESKey:(NSData *)AESKey;
- (NSData *)marshal;
- (NSData *)marshalWithAESKey:(NSData *)AESKey;

@end
