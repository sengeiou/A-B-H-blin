//
//  SmaAccountTool.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/7.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaAccountTool.h"
#import "SmaUserInfo.h"
#import "SmaSeatInfo.h"
#import "SmaSleepInfo.h"
/*用户登录归档文件 */
#define SmaAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]
/*久坐归档文件 */
#define SmaSeatFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"seatFile.data"]
#define SmasleepFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"sleepFile.data"]

@implementation SmaAccountTool
+ (void)saveUser:(SmaUserInfo *)userInfo
{
    //账号每天都需要重新登录
//    NSDate *now = [NSDate date];
//    userInfo.expiresTime = [now dateByAddingTimeInterval:60*60*24];
    
    [NSKeyedArchiver archiveRootObject:userInfo toFile:SmaAccountFile];
}

+ (SmaUserInfo *)userInfo
{
    // 取出账号
    SmaUserInfo *account = [NSKeyedUnarchiver unarchiveObjectWithFile:SmaAccountFile];
    // 判断账号是否过期
    return account;
//    NSDate *now = [NSDate date];
//    if ([now compare:account.expiresTime] == NSOrderedAscending) { // 还没有过期
//        return account;
//    } else { // 过期
//        return nil;
//    }
}
/*久坐设置 begin*/
+ (void)saveSeat:(SmaSeatInfo *)seatInfo
{
    [NSKeyedArchiver archiveRootObject:seatInfo toFile:SmaSeatFile];
}

+ (SmaSeatInfo *)seatInfo
{
    // 取出账号
    SmaSeatInfo *account = [NSKeyedUnarchiver unarchiveObjectWithFile:SmaSeatFile];
    return account;
}
/*久坐设置 end*/
//睡眠
+ (void)saveSleep: (SmaSleepInfo *)sleepInfo{
    [NSKeyedArchiver archiveRootObject:sleepInfo toFile:SmasleepFile];
}

+ (SmaSleepInfo *)sleepInfo{
    SmaSleepInfo *account = [NSKeyedUnarchiver unarchiveObjectWithFile:SmasleepFile];
    return account;
}
@end
