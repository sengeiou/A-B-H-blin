//
//  ACKLVDeviceMsgMarshaller.h
//  AbleCloudLib
//
//  Created by zhourx5211 on 8/23/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACKLVDeviceMsg.h"

@interface ACKLVDeviceMsgMarshaller : NSObject

+ (NSData *)marshalWithACKLVDeviceMsg:(ACKLVDeviceMsg *)msg;
+ (ACKLVDeviceMsg *)unmarshalWithMsgCode:(NSInteger)msgCode data:(NSData *)data;

@end
