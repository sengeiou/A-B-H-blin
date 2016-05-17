//
//  ACOTACheckInfo.h
//  AbleCloudLib
//
//  Created by 乞萌 on 15/10/30.
//  Copyright © 2015年 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACOTACheckInfo : NSObject
@property (nonatomic,copy) NSString * physicalDeviceId;
@property (nonatomic,copy) NSString * version;
@property (nonatomic,copy) NSString * channel;
@property (nonatomic,copy) NSString * batch;
@property (nonatomic,copy) NSString * regional;


@end
