//
//  ACAnalysisManager.h
//  AbleCloudLib
//
//  Created by 乞萌 on 15/10/22.
//  Copyright © 2015年 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACAnalysisManager : NSObject
+(void)writeAppEventWithString:(NSString *)event Callback:(void(^)(NSError * error))callback;
+(void)writeControlEventWithDeviceId:(NSInteger )deviceId Cmd:(NSString *)cmd Callback:(void(^)(NSError * error))callback;
@end
