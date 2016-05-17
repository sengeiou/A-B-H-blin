//
//  SmaUserInfo.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/7.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaUserInfo.h"

@implementation SmaUserInfo
/**
 *  从文件中解析对象的时候调
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.tel = [decoder decodeObjectForKey:@"tel"];
        self.loginName = [decoder decodeObjectForKey:@"loginName"];
        self.userName = [decoder decodeObjectForKey:@"userName"];
        self.expiresTime = [decoder decodeObjectForKey:@"expiresTime"];
        self.userPwd=[decoder decodeObjectForKey:@"userPwd"];
        self.watchName = [decoder decodeObjectForKey:@"watchName"];
        self.OTAwatchName = [decoder decodeObjectForKey:@"OTAwatchName"];
        self.scnaSwatchName = [decoder decodeObjectForKey:@"scnaSwatchName"];
        self.orScnaSwatchName = [decoder decodeObjectForKey:@"orScnaSwatchName"];
        self.watchUID=[decoder decodeObjectForKey:@"watchUID"];
        self.isLogin=[decoder decodeObjectForKey:@"isLogin"];
        self.aim_steps=[decoder decodeObjectForKey:@"aim_steps"];
        self.bli_id=[decoder decodeObjectForKey:@"bli_id"];
        self.header_url=[decoder decodeObjectForKey:@"header_url"];
        self.token=[decoder decodeObjectForKey:@"token"];
        self.agree = [decoder decodeObjectForKey:@"agree"];
        
        self.nickn=[decoder decodeObjectForKey:@"nickn"];
        self.birth=[decoder decodeObjectForKey:@"birth"];
        self.height=[decoder decodeObjectForKey:@"height"];
        self.weight=[decoder decodeObjectForKey:@"weight"];
        self.area=[decoder decodeObjectForKey:@"area"];
        self.sex=[decoder decodeObjectForKey:@"sex"];
        self.nickname=[decoder decodeObjectForKey:@"nickname"];
        self.nicknameLove=[decoder decodeObjectForKey:@"nicknameLove"];
        self.friendAccount=[decoder decodeObjectForKey:@"friendAccount"];
        self.age=[decoder decodeObjectForKey:@"age"];
self.unit = [decoder decodeObjectForKey:@"unit"];
        

    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.tel forKey:@"tel"];
    [encoder encodeObject:self.loginName forKey:@"loginName"];
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:self.expiresTime forKey:@"expiresTime"];
    [encoder encodeObject:self.userPwd forKey:@"userPwd"];
    [encoder encodeObject:self.watchName forKey:@"watchName"];
    [encoder encodeObject:self.OTAwatchName forKey:@"OTAwatchName"];
    [encoder encodeObject:self.scnaSwatchName forKey:@"scnaSwatchName"];
    [encoder encodeObject:self.orScnaSwatchName forKey:@"orScnaSwatchName"];
    [encoder encodeObject:self.watchUID forKey:@"watchUID"];
    [encoder encodeObject:self.isLogin forKey:@"isLogin"];
    [encoder encodeObject:self.aim_steps forKey:@"aim_steps"];
    [encoder encodeObject:self.bli_id forKey:@"bli_id"];
    [encoder encodeObject:self.header_url forKey:@"header_url"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.agree forKey:@"agree"];
    
    [encoder encodeObject:self.nickn forKey:@"nickn"];
    [encoder encodeObject:self.birth forKey:@"birth"];
    [encoder encodeObject:self.height forKey:@"height"];
    [encoder encodeObject:self.weight forKey:@"weight"];
    [encoder encodeObject:self.area forKey:@"area"];
    [encoder encodeObject:self.sex forKey:@"sex"];
    [encoder  encodeObject:self.nickname forKey:@"nickname"];
    [encoder  encodeObject:self.nicknameLove forKey:@"nicknameLove"];
    [encoder  encodeObject:self.friendAccount forKey:@"friendAccount"];
    [encoder  encodeObject:self.age forKey:@"age"];
    [encoder encodeObject:self.unit forKey:@"unit"];
}
@end
