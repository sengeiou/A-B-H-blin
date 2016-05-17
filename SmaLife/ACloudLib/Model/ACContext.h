//
//  ACContext.h
//  ACloudLib
//
//  Created by zhourx5211 on 12/11/14.
//  Copyright (c) 2014 zcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ACContext : NSObject

@property (nonatomic, strong) NSString *os; // 操作系统
@property (nonatomic, strong) NSString *version; // 系统版本
@property (nonatomic, strong) NSString *majorDomain; // 服务所属主域名
@property (nonatomic, unsafe_unretained)NSInteger majorDomainId;//服务器所属主域ID
@property (nonatomic, strong) NSString *subDomain; // 服务所属子域名
@property (nonatomic, strong) NSNumber *userId; // 用户id
@property (nonatomic, strong) NSString *traceId; // 事件id，可用于追查问题
@property (nonatomic, strong) NSString *traceStartTime; // 起始时间
@property (nonatomic, strong) NSString *nonce; // 用于签名的随机字符串
@property (nonatomic, strong) NSString *timeout; // 为防止签名被截获，设置签名的有效超时时间
@property (nonatomic, strong) NSString *timestamp; // 请求发起的时间戳，单位秒
@property (nonatomic, strong) NSString *signature; // 请求的签名

/**
 * 生成context主要用于包含重要的上下文信息
 * @param subDomain   服务所属子域名
 */
+ (ACContext *)generateContextWithSubDomain:(NSString *)subDomain;

@end
