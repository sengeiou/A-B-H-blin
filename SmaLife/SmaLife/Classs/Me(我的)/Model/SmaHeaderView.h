//
//  MJHeaderView.h
//  03-QQ好友列表
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SmaSettingGroup;

@interface SmaHeaderView : UITableViewHeaderFooterView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) SmaSettingGroup *group;
@end
