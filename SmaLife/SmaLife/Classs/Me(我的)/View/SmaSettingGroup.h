//
//  MJFriendGroup.h
//  03-QQ好友列表
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmaSettingGroup : NSObject
@property (nonatomic, copy) NSString *name;
/**
 *  数组中装的都是settings模型
 */
@property (nonatomic, strong) NSArray *settings;


+ (instancetype)groupWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
