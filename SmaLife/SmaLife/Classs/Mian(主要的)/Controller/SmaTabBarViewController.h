//
//  SmaTabBarViewController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/3.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@interface SmaTabBarViewController : UITabBarController<CBCentralManagerDelegate,CBPeripheralDelegate,UIAlertViewDelegate>
{
    AppDelegate *appDele;
    UIAlertView *alert;
     UIAlertView *updateAlert;
    NSNotificationCenter *notifCenter;
}
@property (nonatomic, strong) NSTimer *btStateMonitorTimer;
- (void)setFireDate;
@end
