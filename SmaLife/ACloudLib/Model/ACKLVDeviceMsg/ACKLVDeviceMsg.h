//
//  ACKLVDeviceMsg.h
//  AbleCloudLib
//
//  Created by zhourx5211 on 8/23/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACKLVObject.h"

@interface ACKLVDeviceMsg : NSObject

@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) ACKLVObject *object;

- (id)initWithCode:(NSInteger)code object:(ACKLVObject *)object;

@end
