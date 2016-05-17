//
//  Common.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/3.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 2.获得RGB颜色
#define SmaColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 3.自定义Log
#ifdef DEBUG
#define MyLog(...) NSLog(__VA_ARGS__)
#else
#define MyLog(...)
#endif

// 4.是否为4inch
#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)
//存储数据
#define SmaUserDefaults [NSUserDefaults standardUserDefaults]
//蓝牙工具类
#define SmaBleMgr [SamCoreBlueTool sharedCoreBlueTool]


#define getUserINFO [SmaAccountTool userInfo]
//国际化宏
#define SmaLocalizedString(...) [SmaCommonStudio DPLocalizedString:__VA_ARGS__]
//国际化宏
#define SmaSystemLocalizStr(str) [SmaCommonStudio DPLocalizedString:str]
//
#define SmaNotificationCenter [NSNotificationCenter defaultCenter]
//用于修改数据库
#define SPLITEVERSION 1





