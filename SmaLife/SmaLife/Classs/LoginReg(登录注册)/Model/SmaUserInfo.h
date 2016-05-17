//
//  SmaUserInfo.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/7.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmaUserInfo : NSObject<NSCoding>

//r搜索设备名称
@property (nonatomic, strong) NSString *scnaSwatchName;
@property (nonatomic, strong) NSString *orScnaSwatchName;
/*用户ID*/
@property (nonatomic, copy) NSString *userId;
/*昵称*/
@property (nonatomic, copy) NSString *nickname;
/*手机号码*/
@property (nonatomic, copy) NSString *tel;
/*用户登录名*/
@property (nonatomic, copy) NSString *loginName;
/*密码*/
@property (nonatomic, copy) NSString *userPwd;
/*用户目标步数*/
@property (nonatomic, copy) NSString *aim_steps;
/*用户蓝牙ID*/
@property (nonatomic, copy) NSString *bli_id;
/*用户头像链接*/
@property (nonatomic, copy) NSString *header_url;
/*用户友盟token*/
@property (nonatomic, copy) NSString *token;
/*用户是否同意好友请求*/
@property (nonatomic, copy) NSString *agree;

@property (nonatomic, copy) NSString *age;
/*用户真实姓名*/
@property (nonatomic, copy) NSString *userName;
/*账号的过期时间*/
@property (nonatomic, strong) NSDate *expiresTime;
/*当前绑定的手表UID*/
@property (nonatomic, strong) NSUUID *watchUID;
//*服务UUID
//@property (nonatomic, strong) CBPeripheral *actiPeripheral;
//绑定活动设备
@property (nonatomic, strong) NSUUID *severUid;
/*当前绑定的手表名称*/
@property (nonatomic, strong) NSString *watchName;
/*OTA绑定的手表名称*/
@property (nonatomic, strong) NSString *OTAwatchName;
/*当前绑定的手表名称*/
@property (nonatomic, strong) NSString *isLogin;
/*昵称*/
@property (nonatomic, strong) NSString *nickn;
/*生日*/
@property (nonatomic, strong) NSString *birth;
/*身高*/
@property (nonatomic, strong) NSString *height;
/*体重*/
@property (nonatomic, strong) NSString *weight;
/*地区*/
@property (nonatomic, strong) NSString *area;
/*性别*/
@property (nonatomic, strong) NSString *sex;
/*已经配对*/
/*单位*/
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *nicknameLove;//对方昵称
@property (nonatomic, strong) NSString *friendAccount;//对方昵称
@end
