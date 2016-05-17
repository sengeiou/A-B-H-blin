//
//  MJFriendCell.m
//  03-QQ好友列表
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "SmaSettingCell.h"
#import "SmaSetting.h"

@implementation SmaSettingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"setId";
    SmaSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SmaSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (void)setSettingData:(SmaSetting *)sittingData
{
    _settingData = sittingData;
    
    self.textLabel.text =SmaLocalizedString(sittingData.name);
    self.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:14];
}

@end
