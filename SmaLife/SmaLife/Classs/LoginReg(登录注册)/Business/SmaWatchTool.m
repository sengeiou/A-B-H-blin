//
//  SmaWatchTool.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/7.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaWatchTool.h"
#import "SmaNewfeatureViewController.h"
#import "SmaLoginViewController.h"

@implementation SmaWatchTool
+ (void)chooseRootController:(UIWindow *)window
{
    NSString *key = @"CFBundleVersion";
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    MyLog(@"%@----------%@",lastVersion,currentVersion);
    
//    if ([currentVersion isEqualToString:lastVersion] && lastVersion) {
        [UIApplication sharedApplication].statusBarHidden = NO;
        
        //window.rootViewController=[[SmaLoginViewController alloc] init];
        SmaLoginViewController *charVc=[[SmaLoginViewController alloc]init];
 
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:charVc];
        UINavigationBar *navBar = nav.navigationBar;
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] =SmaColor(255, 255, 255);
        attrs[NSFontAttributeName]=[UIFont fontWithName:@"STHeitiSC-Light" size:19];
        [navBar setTitleTextAttributes:attrs];
        window.rootViewController=nav;
        //[UIApplication sharedApplication].keyWindow.rootViewController =[[SmaLoginViewController alloc] init];
        
//    } else { // 新版本
//        window.rootViewController=[[SmaNewfeatureViewController alloc] init];
//        //[UIApplication sharedApplication].keyWindow.rootViewController = [[SmaNewfeatureViewController alloc] init];
//        // 存储新版本
//        [defaults setObject:currentVersion forKey:key];
//        [defaults synchronize];
//    }
}
@end
