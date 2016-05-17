//
//  ACGroup.h
//  NetworkingDemo
//
//  Created by zhourx5211 on 12/23/14.
//  Copyright (c) 2014 zhourx5211. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ACGroupStatusDisabled = 0,
    ACGroupStatusEnabled,
} ACGroupStatus;

@interface ACGroup : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger groupId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger owner;
@property (nonatomic, assign) ACGroupStatus status;

@end
