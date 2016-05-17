//
//  SmaTabBar.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/3.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SmaTabBar;

@protocol SmaTabBarDelegate <NSObject>

@optional
- (void)tabBar:(SmaTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;
- (void)tabBarDidClickedPlusButton:(SmaTabBar *)tabBar;

@end

@interface SmaTabBar : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem *)item;
@property (nonatomic, weak) id<SmaTabBarDelegate> delegate;
@end
