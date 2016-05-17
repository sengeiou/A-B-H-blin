//
//  ACKeyChain.h
//  ACloudLib
//
//  Created by zhourx5211 on 12/14/14.
//  Copyright (c) 2014 zcloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACKeyChain : NSObject

/**
 *  保存用户ID
 */
+ (void)saveUserId:(NSNumber *)userId;
/**
 *  获取用户ID
 */
+ (NSNumber *)getUserId;
/**
 *  删除当前用户的id
 */
+ (void)removeUserId;


/**
 *  保存以后 Token
 */
+ (void)saveToken:(NSString *)token;
/**
 *  获取用户 Token
 */
+ (NSString *)getToken;
/**
 *  删除当前用户的token
 */
+ (void)removeToken;

@end
