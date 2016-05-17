//
//  ACMember.h
//  NetworkingDemo
//
//  Created by zhourx5211 on 12/23/14.
//  Copyright (c) 2014 zhourx5211. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ACMemberTypeNormal = 0,
    ACMemberTypeOwner,
} ACMemberType;

typedef enum : NSUInteger {
    ACMemberStatusDisabled = 0,
    ACMemberStatusEnabled,
} ACMemberStatus;

@interface ACMember : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) ACMemberType type;
@property (nonatomic, assign) ACMemberStatus status;

@end
