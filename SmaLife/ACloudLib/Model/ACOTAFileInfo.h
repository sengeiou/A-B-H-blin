//
//  ACOTAFileInfo.h
//  AbleCloudLib
//
//  Created by leverly on 15/7/11.
//  Copyright (c) 2015年 ACloud. All rights reserved.
//


#import <Foundation/Foundation.h>

//  OTA基本信息
@interface ACOTAFileInfo : NSObject

// 文件类型
@property(nonatomic,assign) NSInteger type;
// 文件校验和
@property(nonatomic,assign) NSInteger checksum;
// 版本号
@property(nonatomic,copy) NSString *version;
// 版本描述
@property(nonatomic,copy) NSString *desp;

@end
