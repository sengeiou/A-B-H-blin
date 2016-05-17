//
//  AppDelegate.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/3.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "AppDelegate.h"
#import "SmaTabBarViewController.h"
#import "SmaNewfeatureViewController.h"
#import "SmaLoginViewController.h"
#import "SmaUserInfo.h"
#import "SmaAccountTool.h"
#import "SmaWatchTool.h"
#import "ACloudLib.h"
//#import "ACNotificationManager.h"
#import "UMessage.h"
#import "SmaLoverViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "SmaAnalysisWebServiceTool.h"
#import "SmaNavMyInfoController.h"
#import "Common.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
//电话功能

#define kAppId           @"CIIWiy5muG7KzdFMsTzgV1"
#define kAppKey          @"X5QFg0R3Oc6VyL9oq7clU6"
#define kAppSecret       @"u36FSTKbMN6QpbAsuxtyk7"

#define ksubAppId           @"pLZOh8wgtb5bD7L0MoLQ99"
#define ksubAppKey          @"CLjhKGFjFX9JB99dSxN24"
#define ksubAppSecret       @"ZQu8TCCCuc6B7HS9IpMFX9"

NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface AppDelegate ()<UIAlertViewDelegate>
//@property (nonatomic, strong) MMPDeepSleepPreventer *sleepPreventer;
{
    CTCallCenter *center ;
     NSString *kStoreAppId;
}
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTaskID;

@end

@implementation AppDelegate
@synthesize applica;
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    kStoreAppId = @"1066104697";
    self.applica = application;
    self.isBackground=@"1";
    NSDictionary* defaults = [NSDictionary dictionaryWithObjects:@[@"2.3", [NSNumber numberWithInt:10]] forKeys:@[@"key_diameter", @"dfu_number_of_packets"]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
//    [ACloudLib setHost:@"http://test.ablecloud.cn:5000"];
    [ACloudLib setMode:PRODUCTION_MODE Region:REGIONAL_CHINA];
    [ACloudLib setMajorDomain:@"lijunhu" majorDomainId:282];
    
    
//      [self checkAppUpdate];
//    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
//    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
//    [MobClick startWithAppkey:@"566406f467e58ee30a005634" reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
//    [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
//    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
//    
//    [MobClick updateOnlineConfig];  //在线参数配置

//    [UMessage startWithAppkey:@"55ed4b4667e58edec600279a" launchOptions:launchOptions];
//    [ACNotificationManager startWithAppkey:@"55ed4b4667e58edec600279a" launchOptions:launchOptions];
    
//    if ([SmaAccountTool userInfo].loginName && ![[SmaAccountTool userInfo].loginName isEqualToString:@""]) {
//        [self registerUMessageRemoteNotification];
//    }
    [SMS_SDK registerApp:@"6fc671d73c00" withSecret:@"4eca9f17c8c523202d4b4047d66f0128"];
    
    [ShareSDK registerApp:@"6cfc18b7fa82"];//字符串api20为您的ShareSDK的AppKey
    //添加新浪微博应用 注册网址 http://open.weibo.com
//    [ShareSDK connectSinaWeiboWithAppKey:@"2619987508"
//                               appSecret:@"39eae4d15b9a07635cd9e253b2b01b38"
//                             redirectUri:@"http://www.sharesdk.cn"];
    
    
    //添加QQ应用  注册网址  http://mobile.qq.com/api/
    //      [ShareSDK connectQQWithQZoneAppKey:@"100371282"∫
    //                     qqApiInterfaceCls:[QQApiInterface class]
    //                       tencentOAuthCls:[TencentOAuth class]];
    
    
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1104591966"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"801312852"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx4f2063a41862dbc4"
                           wechatCls:[WXApi class]];
    
    
    //        self.sleepPreventer = [[MMPDeepSleepPreventer alloc] init];
    
    //        self.bgTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    //            [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskID];
    //            self.bgTaskID = UIBackgroundTaskInvalid;
    //        }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    SmaUserInfo *userInfo = [SmaAccountTool userInfo];
//    if(userInfo && ![userInfo.userName isEqualToString:@""])//登录成功
//    {
        if(userInfo.nickname && userInfo.sex && userInfo.height && userInfo.weight)
        {
            //if(userInfo.watchUID && userInfo.watchName)
            //{
            SmaTabBarViewController *vc = [[SmaTabBarViewController alloc]init];
            //               UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
            self.window.rootViewController=vc;
            [UIApplication sharedApplication].statusBarHidden=NO;
            MyLog(@"哈哈哈哈");
            
            
            //}©
        }else{
            MyLog(@"sdfdsfdsfsdf");
            SmaNavMyInfoController *vc=[[SmaNavMyInfoController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            self.window.rootViewController=nav;//[[SmaTabBarViewController alloc]init];
        }
//    }
//    else { // 之前没有登录成功
//        [UIApplication sharedApplication].statusBarHidden=NO;
//        self.window.rootViewController=[[SmaTabBarViewController alloc]init];
//        [SmaWatchTool chooseRootController:self.window];
//    }
    [self.window makeKeyAndVisible];
    //当日启动APP次数
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString *today = [fmt stringFromDate:[NSDate date]];
    NSString *openNum = [SmaUserDefaults stringForKey:@"SetAppNum"];
    int num = [openNum substringFromIndex:8].intValue;
    if (!openNum || [openNum isEqualToString:@""]) {
        [SmaUserDefaults setObject:[NSString stringWithFormat:@"%@1",today] forKey:@"SetAppNum"];
    }
    else if (openNum && ![openNum isEqualToString:@""]){
        if (![[openNum substringToIndex:8] isEqualToString:today]) {
            [SmaUserDefaults setObject:[NSString stringWithFormat:@"%@1",today] forKey:@"SetAppNum"];
        }
        else{
            num =  num+1;
            [SmaUserDefaults setObject:[NSString stringWithFormat:@"%@%d",today,num] forKey:@"SetAppNum"];
        }
    }
    //首次打开APP
    [SmaUserDefaults setInteger:0 forKey:@"firstRun"];
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
        [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    
    //上传 APPSTORE
    //    [self startSdkWith:ksubAppId appKey:ksubAppKey appSecret:ksubAppSecret];
    // [2]:注册APNS
        [self registerRemoteNotification];
    
    // [2-EXT]: 获取启动时收到的APN
    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        NSString *payloadMsg = [message objectForKey:@"payload"];
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
        MyLog(@"%@",record);
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    
    //test
    center = [[CTCallCenter alloc] init];
    center.callEventHandler = ^(CTCall *call) {
        if (call.callState == CTCallStateDialing){
            NSLog(@"Call Dialing");
        } else if (call.callState == CTCallStateIncoming) {
            NSLog(@"Call Incoming");
            [SmaBleMgr setphonespark];
            
        } else if (call.callState == CTCallStateConnected){
            NSLog(@"Call Connected");
            
        } else if (call.callState == CTCallStateDisconnected){
            NSLog(@"Call Disconnected");
            
        }
        
        //        NSString *number = CTCallCopyAddress(NULL, call);
        //        NSLog(@"number: %@", number);
    };
    
    if (!path) {
        path = [ [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Album"];
        NSFileManager *fileMgr=[NSFileManager defaultManager];
        BOOL flag=NO;
        if (![fileMgr fileExistsAtPath:path isDirectory:&flag]) {
            [fileMgr createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    if (!self.btStateMonitorTimer) {
        self.btStateMonitorTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checkUnreadCount) userInfo:nil repeats:YES];
    }
    //         真机测试时保存日志
    //    if ([[[UIDevice currentDevice] model] rangeOfString:@"simulator"].location) {
    //        [self redirectNSLogToDocumentFolder];
    //    }
    return YES;
    
}

- (void)redirectNSLogToDocumentFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

/**
 *  获取到用户对应当前应用程序的deviceToken时就会调用
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    [SmaUserDefaults setObject:deviceToken forKey:@"clientId"];
    NSLog(@"这个是的deviceToken---%@", _deviceToken);
    [GeTuiSdk registerDeviceToken:_deviceToken];
}

//接收到远程服务器推送过来的内容就会调用
// ios7以后用这个处理后台任务接收到得远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"didReceiveRemoteNotification");
    //      [UMessage didReceiveRemoteNotification:userInfo];
    /*
     UIBackgroundFetchResultNewData, 成功接收到数据
     UIBackgroundFetchResultNoData, 没有;接收到数据
     UIBackgroundFetchResultFailed 接收失败
     
     */
    NSLog(@"userInfo %@", userInfo);
    NSString *aps = [userInfo objectForKey:@"payload"];
    if (aps) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:aps]];
        });
        return;
    }
//    NSNumber *contentid =  userInfo[@"aps"];
//        if (contentid) {
//            UILabel *label = [[UILabel alloc] init];
//            label.frame = CGRectMake(0, 250, 200, 200);
//            label.numberOfLines = 0;
//            label.textColor = [UIColor whiteColor];
//            label.text = [NSString stringWithFormat:@"%@", contentid];
//            label.font = [UIFont systemFontOfSize:30];
//            label.backgroundColor = [UIColor grayColor];
//            [self.window.rootViewController.view addSubview:label];
//            //注意: 在此方法中一定要调用这个调用block, 告诉系统是否处理成功.
//            // 以便于系统在后台更新UI等操作
//            completionHandler(UIBackgroundFetchResultNewData);
//        }else
//        {
//            completionHandler(UIBackgroundFetchResultFailed);
//        }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"-didReceiveLocalNotification-");
    [self appshow];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
     [GeTuiSdk registerDeviceToken:@""];
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //    [self.sleepPreventer startPreventSleep];
    
    self.backgroundTaskIdentifier=[application beginBackgroundTaskWithExpirationHandler:^(void) {
        
        [self endBackgroundTask];
        
    }];
    
    MyLog(@"进入后台");
    self.isBackground=@"0";
    if(SmaBleMgr && SmaBleMgr.mgr && SmaBleMgr.characteristicWrite && SmaBleMgr.peripheral )// 判断蓝牙是否存在
    {
#pragma mark - 解决后台蓝牙总是断开的问题  不管app 进入前台还是进入后台都要判断蓝牙是否在连接状态如果是断开的话 就重新链接  如果在连接状态的话同步数据
        if (SmaBleMgr.peripheral.state == CBPeripheralStateConnected) {
            MyLog(@"关闭");
            //            [SmaUserDefaults setInteger:0 forKey:@"openSyn"];
            [SmaBleMgr openSyncdata:false];
        }else if(SmaBleMgr.peripheral.state == CBPeripheralStateDisconnected){
            //            [self coreBlueConnected];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    self.isBackground=@"1";
    if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid){
        NSLog(@"yes");
        [self endBackgroundTask]; }
    
    else{
        NSLog(@"no");
        [self endBackgroundTask];
    }
    
    //    [self.sleepPreventer stopPreventSleep];
    MyLog(@"进入前台");
    if(SmaBleMgr && SmaBleMgr.mgr && SmaBleMgr.characteristicWrite && SmaBleMgr.peripheral)
    {
        if (SmaBleMgr.peripheral.state == CBPeripheralStateConnected) {
            MyLog(@"开启数据同步");
            //            [SmaUserDefaults setInteger:1 forKey:@"openSyn"];
            [SmaBleMgr openSyncdata:true];
        }else if (SmaBleMgr.peripheral.state == CBPeripheralStateDisconnected){
            //            [self coreBlueConnected];
        }
    }
     [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UPDATEUI" object:nil userInfo:nil]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [SmaUserDefaults removeObjectForKey:@"FirstLun"];
    NSLog(@"我要退出啦888*****");
    [SmaBleMgr openSyncdata:NO];
    [SmaBleMgr logOut];
    
}

- (void) endBackgroundTask{
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    __weak AppDelegate *weakSelf = self;
    
    dispatch_async(mainQueue, ^(void) {
        
        AppDelegate *strongSelf = weakSelf;
        
        if (strongSelf != nil){
            
            [self.applica endBackgroundTask:self.backgroundTaskIdentifier];
            self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
            
        }
        
    });
}

/*个推  begin*/
- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"取消"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"回复"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[action1, action2]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                       UIRemoteNotificationTypeSound|
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                   UIRemoteNotificationTypeSound|
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif

}

- (void)registerUMessageRemoteNotification{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
//        [ACNotificationManager registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
//        [ACNotificationManager registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//         |UIRemoteNotificationTypeSound
//         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    [ACNotificationManager registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    
    //for log
    [UMessage setLogEnabled:YES];
}

- (NSString *)currentLogFilePath
{
    NSMutableArray * listing = [NSMutableArray array];
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray * fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docsDirectory error:nil];
    if (!fileNames) {
        return nil;
    }
    
    for (NSString * file in fileNames) {
        if (![file hasPrefix:@"_log_"]) {
            continue;
        }
        
        NSString * absPath = [docsDirectory stringByAppendingPathComponent:file];
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:absPath isDirectory:&isDir]) {
            if (isDir) {
                [listing addObject:absPath];
            } else {
                [listing addObject:absPath];
            }
        }
    }
    
    [listing sortUsingComparator:^(NSString *l, NSString *r) {
        return [l compare:r];
    }];
    
    if (listing.count) {
        return [listing objectAtIndex:listing.count - 1];
    }
    
    return nil;
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        _sdkStatus = SdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        
        _clientId = nil;
        
        NSError *err = nil;
        [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self error:&err];
        //[1-2]:设置是否后台运行开关
        [GeTuiSdk runBackgroundEnable:YES];
        //[1-3]:设置电子围栏功能，开启LBS定位服务 和 是否允许SDK 弹出用户定位请求
        [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
        if (!_gexinPusher) {
        } else {
            _sdkStatus = SdkStatusStarting;
        }
            }
}

- (void)stopSdk
{
    if (_gexinPusher) {
        [GeTuiSdk enterBackground];
        
        _gexinPusher = nil;
        
        _sdkStatus = SdkStatusStoped;
        
        _clientId = nil;
    }
}

- (BOOL)checkSdkInstance
{
    if (!_gexinPusher) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"alert_erro") message:SmaLocalizedString(@"sdk_start") delegate:nil cancelButtonTitle:nil otherButtonTitles:SmaLocalizedString(@"clockadd_confirm"), nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (void)setDeviceToken:(NSString *)aToken
{
    [GeTuiSdk registerDeviceToken:aToken];}

- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    return [GeTuiSdk setTags:aTags];
    
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    return [GeTuiSdk sendMessage:body error:error];
}

- (void)bindAlias:(NSString *)aAlias {
    [GeTuiSdk bindAlias:aAlias];
}

- (void)unbindAlias:(NSString *)aAlias {
    [GeTuiSdk unbindAlias:aAlias];
}


- (void)testSdkFunction
{
    //  UIViewController *funcsView = [[TestFunctionController alloc] initWithNibName:@"TestFunctionController" bundle:nil];
    //[_naviController pushViewController:funcsView animated:YES];
    
}

// 判断蓝牙是否在连接状态方法
- (void)coreBlueConnected{
    [MBProgressHUD showMessage:SmaLocalizedString(@"bt_connecting")];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
    //    [SmaBleMgr beginLinkPeripheral];
    [SmaBleMgr oneScanBand:NO];
}
//- (void)testSendMessage
//{
//    UIViewController *sendMessageView = [[SendMessageController alloc] initWithNibName:@"SendMessageController" bundle:nil];
//    [_naviController pushViewController:sendMessageView animated:YES];
//    [sendMessageView release];
//}

- (void)testGetClientId {
    NSString *clientId = [GeTuiSdk clientId];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"now_cid") message:clientId delegate:nil cancelButtonTitle:nil otherButtonTitles:SmaLocalizedString(@"clockadd_confirm"), nil];
    [alertView show];
}

#pragma mark - GexinSdkDelegate
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    //[4-EXT-1]: 个推SDK已注册
    _sdkStatus = SdkStatusStarted;
    // [_clientId release];
    _clientId = clientId;
    NSLog(@"clientId=====%@",clientId);
    [SmaUserDefaults setObject:clientId forKey:@"clientId"];
//    [self setDeviceToken:clientId];
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    
    if (_deviceToken) {
        [GeTuiSdk registerDeviceToken:_deviceToken];
    }
    //[_viewController updateStatusView:self];
    //[self stopSdk];
}
-(NSDictionary *)dict
{
    if(!_dict)
    {
        _dict=[NSDictionary dictionary];
    }
    return _dict;
}
- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId
{
    MyLog(@"受到个腿消息");
    // [4]: 收到个推消息
    _payloadId = payloadId;
    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
    }
    //    NSString *record = [NSString stringWithFormat:@"%d, %@, %@", ++_lastPayloadIndex, [NSDate date], payloadMsg];
    //  [_viewController logMsg:record];
    //    [payloadMsg release];
    NSError *error;
    NSData *jsonData =[payloadMsg dataUsingEncoding:NSUTF8StringEncoding];
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadId options:NSJSONWritingPrettyPrinted error:&error];
    
    //NSJSONReadingMutableLeaves
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    self.dict=jsonDict;
    NSString *method=[jsonDict objectForKey:@"method"];
    NSString *acount=[jsonDict objectForKey:@"userAccount"];
    NSString *removeRes = [jsonDict objectForKey:@"result"];
    NSLog(@"---------推送消息-------%@",jsonDict);
    
    if([method isEqualToString:@"askFriend"])//邀请
    {
        if([self.isBackground isEqualToString:@"0"])
        {
            [self createLocalNotification];
            
        }else{
            [self appshow];
        }
        
        
    }
    else if ([method isEqualToString:@"responseAsk"]){
        if ([[jsonDict objectForKey:@"agree"] intValue] == 0) {
            if(![self.isBackground isEqualToString:@"0"]){
                [MBProgressHUD hideHUD];
            [MBProgressHUD showMessage:[NSString stringWithFormat:@"%@ %@",[jsonDict objectForKey:@"nickName"],SmaLocalizedString(@"refuse_friend")]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                });
            }
        }
        else{
            NSString *nickName=[jsonDict objectForKey:@"nickName"];
            NSString *friendAccount = [jsonDict objectForKey:@"uAccount"];
            SmaUserInfo *info=[SmaAccountTool userInfo];
            info.nicknameLove=nickName;
            info.friendAccount = friendAccount;
            [SmaAccountTool saveUser:info];
            if (self.createUIDelegate && [self.createUIDelegate respondsToSelector:@selector(createLoveUI)]) {
                [self.createUIDelegate createLoveUI];
            }
            NSLog(@"=======****==%@",[SmaAccountTool userInfo].friendAccount);
        }
    }
//    else if([method isEqualToString:@"matchResponse"])
//    {
//        MyLog(@"%@________",jsonDict);
//        NSString *result=[jsonDict objectForKey:@"result"];
//        if([result isEqualToString:@"1"])
//        {
//            
//            NSString *nickName=[jsonDict objectForKey:@"nickName"];
//            NSString *friendAccount = [jsonDict objectForKey:@"friendAccount"];
//            SmaUserInfo *info=[SmaAccountTool userInfo];
//            info.nicknameLove=nickName;
//            info.friendAccount = friendAccount;
//            [SmaAccountTool saveUser:info];
//            NSLog(@"=======****==%@",[SmaAccountTool userInfo].friendAccount);
//        }
//    }
else if([method isEqualToString:@"dispatcherMsg"])
    {
        NSString *acount=[jsonDict objectForKey:@"content_key"];
        MyLog(@"来了--%d",[acount intValue]);
        if (SmaBleMgr.peripheral && SmaBleMgr.peripheral.state == CBPeripheralStateConnected && [SmaBleMgr.islink isEqualToString:@"1"]) {
            if([acount intValue]==32)
            {
                MyLog(@"来--%d",[acount intValue]);
                [SmaBleMgr setInteractone];
                
            }else if([acount intValue]==33)
            {
                MyLog(@"来--%d",[acount intValue]);
                [SmaBleMgr setInteracttwo];
            }
        }
    }else if([method isEqualToString:@"unBondFriends"]){
        
        SmaUserInfo *info=[SmaAccountTool userInfo];
        info.nicknameLove=@"";
        info.friendAccount=@"";
        [SmaAccountTool saveUser:info];
        if (self.createUIDelegate && [self.createUIDelegate respondsToSelector:@selector(createLoveUI)]) {
            [self.createUIDelegate createLoveUI];
        }

        
    }
    
    
    
    else if ([removeRes isEqualToString:@"okay"]){
        SmaUserInfo *info=[SmaAccountTool userInfo];
        info.nicknameLove=@"";
        info.friendAccount=@"";
        [SmaAccountTool saveUser:info];
    }
}

-(void)appshow
{
    NSString *acount=[self.dict objectForKey:@"nickName"];
    NSString *msg=[NSString stringWithFormat:@"%@ %@",acount,SmaLocalizedString(@"pair_addFriend")];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"pair_title")
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:SmaLocalizedString(@"pair_disagree")
                                          otherButtonTitles:SmaLocalizedString(@"pair_consent"),nil];
    [alert show];
}


-(void)createLocalNotification {
    
    NSString *acount=[self.dict objectForKey:@"userAccount"];
    NSString *msg=[NSString stringWithFormat:@"%@%@",acount,SmaLocalizedString(@"pair_addFriend")];
    
    // 创建一个本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置10秒之后
    if (notification != nil) {
        // 设置推送时间
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:10];//10秒后通知
        notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
        notification.alertBody=msg;//提示信息 弹出提示框
        notification.alertAction = @"打开";  //提示框按钮
        notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
        
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        notification.userInfo = infoDict; //添加额外的信息
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == updateAlert) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", kStoreAppId]]];
        }
    }
    else{
    SmaAnalysisWebServiceTool *dal=[SmaAnalysisWebServiceTool alloc];
    NSString *friendAccount=[self.dict objectForKey:@"uAccount"];
    NSString *userAccount=[SmaAccountTool userInfo].loginName;
    NSString *friendNickName=[self.dict objectForKey:@"nickName"];//对方的昵称
    
    NSString *clientID=[SmaUserDefaults objectForKey:@"clientId"];
    NSString *friend_id=[self.dict objectForKey:@"user_id"];
    
    
    SmaUserInfo *userInfo=[SmaAccountTool userInfo];
    NSString *nickName=userInfo.nickname;//自己的昵称
    
    if(buttonIndex==1)
    {
        if (userAccount) {
            [dal acloudReplyFriendAccount:friendAccount FrName:friendNickName MyAccount:userAccount MyName:nickName agree:1 success:^(id success) {
                
                userInfo.nicknameLove=friendNickName;
                userInfo.friendAccount=friendAccount;
                [SmaAccountTool saveUser:userInfo];
                if (self.createUIDelegate && [self.createUIDelegate respondsToSelector:@selector(createLoveUI)]) {
                    [self.createUIDelegate createLoveUI];
                }
            } failure:^(NSError *error) {
                
                [MBProgressHUD showMessage:SmaLocalizedString(@"send_fail")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                });
            }];

        }
        
    }else{
        if (userAccount) {
        [dal acloudReplyFriendAccount:friendAccount FrName:friendNickName MyAccount:userAccount MyName:nickName agree:0 success:^(id success) {
            [MBProgressHUD showMessage:SmaLocalizedString(@"reject_succ")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            
        } failure:^(NSError *error) {
            [MBProgressHUD showMessage:SmaLocalizedString(@"send_fail")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            
        }];
        }
        //         [dal sendBackNatchesResult:@"IOS" friendAccount:friendAccount userAccount:userAccount client_id:clientID friend_id:friend_id agree:@"0" nickName:userNickName success:^(id json) {
        //
        //        } failure:^(NSError *error) {
        //        }];
    }
    }
}

- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    MyLog(@"qwewqeewqe--------");
    // NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    //[_viewController logMsg:record];
}

- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    MyLog(@"errorrr-----------------");
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    // [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]];
}
/*个推  end*/

-(void)checkAppUpdate
{
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kStoreAppId];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                
                if ( ![versionsInAppStore count] ) { // No versions of app in AppStore
                    
                    return;
                    
                } else {
                    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
                    NSString *nowVersion = [[infoDict objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""];
                    NSString *currentAppStoreVersion = [[versionsInAppStore objectAtIndex:0] stringByReplacingOccurrencesOfString:@"." withString:@""];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (nowVersion.intValue < currentAppStoreVersion.intValue) {
                            updateAlert = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"alert_title") message:SmaLocalizedString(@"setting_update_App") delegate:self cancelButtonTitle:SmaLocalizedString(@"clockadd_cancel") otherButtonTitles:SmaLocalizedString(@"clockadd_confirm"), nil];
                            [updateAlert show];
                        }
                    });
                }
            });
        }
    }];
}

-(void)checkUnreadCount
{
//    if (!appDele) {
//        appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    }
    MyLog(@"%d 定时去请求 %ld  SmaBleMgr.saveMgr==%@   %@  %@ %ld",SmaBleMgr.OTA,(long)SmaBleMgr.peripheral.state,SmaBleMgr.saveMgr,SmaBleMgr.peripheral.name,SmaBleMgr.islink,(long)SmaBleMgr.peripheral.state);
    
    if (SmaBleMgr.peripheral.state != CBPeripheralStateConnected && SmaBleMgr.peripheral && [SmaAccountTool userInfo].watchUID && [self.isBackground isEqualToString:@"0"]) {
        NSLog(@"断线重连");
        if (SmaBleMgr.peripheral.state == CBPeripheralStateConnecting) {
            [SmaBleMgr.mgr cancelPeripheralConnection:SmaBleMgr.peripheral];
        }
        [SmaBleMgr connectPeripheral:SmaBleMgr.peripheral Bool:YES];
        return;
    }
    
    if(!SmaBleMgr.mgr || !SmaBleMgr.peripheral || /*!SmaBleMgr.characteristicElectric || !SmaBleMgr.characteristicRead || !SmaBleMgr.characteristicWrite || */SmaBleMgr.peripheral.state != CBPeripheralStateConnected/* || [SmaBleMgr.islink isEqualToString:@"0"]*/)
    {
        MyLog(@"开始扫描");
        SmaBleMgr.peripherals=nil;
        SmaBleMgr.rssivalue=@"-200";
        if (SmaBleMgr.peripheral.state != CBPeripheralStateConnected  || [SmaBleMgr.islink isEqualToString:@"0"]) {
            [SmaBleMgr oneScanBand:NO];
        }
    }
}

//- (void)updateMethod:(NSDictionary *)appInfo {
//    NSString *nowVersion = [appInfo objectForKey:@"current_version"];
//    NSString *newVersion = [appInfo objectForKey:@"version"];
//    updateUrl = [appInfo objectForKey:@"path"];
//    if(![nowVersion isEqualToString:newVersion] && newVersion)
//    {
//    updateAlert = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"alert_title") message:SmaLocalizedString(@"setting_update_App") delegate:self cancelButtonTitle:SmaLocalizedString(@"clockadd_cancel") otherButtonTitles:SmaLocalizedString(@"clockadd_confirm"), nil];
//        [updateAlert show];
//    }
//}

@end
