//
//  SmaSleepInfo.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/16.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//睡眠数据
//

#import "SmaSleepInfo.h"

@implementation SmaSleepInfo
//归档
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.user_id forKey:@"user_id"];
    [encoder encodeObject:self.sleep_id forKey:@"sleep_id"];
    [encoder encodeObject:self.sleep_data forKey:@"sleep_data"];
    [encoder encodeObject:self.sleep_time forKey:@"sleep_time"];
    [encoder encodeObject:self.sleep_mode forKey:@"sleep_mode"];
    [encoder encodeObject:self.sleep_softly forKey:@"sleep_softly"];
    [encoder encodeObject:self.sleep_strong forKey:@"sleep_strong"];
    [encoder encodeObject:self.sleep_type forKey:@"sleep_type"];
    [encoder encodeObject:self.sleep_wear forKey:@"sleep_wear"];
    [encoder encodeObject:self.sleep_web forKey:@"sleep_web"];
}
//解当
-(id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.user_id = [decoder decodeObjectForKey:@"user_id"];
        self.sleep_id = [decoder decodeObjectForKey:@"sleep_id"];
        self.sleep_data = [decoder decodeObjectForKey:@"sleep_data"];
        self.sleep_time = [decoder decodeObjectForKey:@"sleep_time"];
        self.sleep_mode = [decoder decodeObjectForKey:@"sleep_mode"];
        self.sleep_softly = [decoder decodeObjectForKey:@"sleep_softly"];
        self.sleep_strong = [decoder decodeObjectForKey:@"sleep_strong"];
        self.sleep_type=[decoder decodeObjectForKey:@"sleep_type"];
        self.sleep_wear=[decoder decodeObjectForKey:@"sleep_wear"];
        self.sleep_web=[decoder decodeObjectForKey:@"sleep_web"];
    }
    return self;
    
}

@end
