//
//  ACPushTable.h
//  AbleCloudLib
//
//  Created by 乞萌 on 15/10/12.
//  Copyright (c) 2015年 ACloud. All rights reserved.
//
#import "ACObject.h"
typedef enum :NSInteger{
     OPTYPE_CREATE =1,
     OPTYPE_DELETE = 2,
     OPTYPE_REPLACE= 3,
     OPTYPE_UPDATE =4
}ACPushTableOpType;
#import <Foundation/Foundation.h>

@interface ACPushTable : NSObject<NSCoding>

//订阅的表名
@property(nonatomic,copy) NSString * className;

//订阅的columns行(内部元素应为字符串类型) ,包含行的信息如:(time type action)
@property(nonatomic,retain)NSMutableArray * cloumns;

//监听主键，此处对应添加数据集时的监控主键(监控主键必须是数据集主键的子集)
@property(nonatomic,retain)ACObject * primaryKey;

//监听类型，如以下为只要发生创建、删除、替换、更新数据集的时候即会推送数据
@property(nonatomic,unsafe_unretained) ACPushTableOpType opType;

@end
