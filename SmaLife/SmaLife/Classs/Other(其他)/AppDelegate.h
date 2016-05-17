//
//  AppDelegate.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/3.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeTuiSdk.h"
#import "MobClick.h"
//typedef enum {
//    SdkStatusStoped,
//    SdkStatusStarting,
//    SdkStatusStarted
//} SdkStatus;
@class SmaTabBarViewController;
@protocol AppCreateUIDelegate <NSObject>
- (void)createLoveUI;

@end
@interface AppDelegate : UIResponder <UIApplicationDelegate,SetSamCoreBlueToolDelegate,GeTuiSdkDelegate>
{
     NSNotification *OTAnotification;
    NSString *path;
    NSString *_deviceToken;
    NSString *updateUrl;
    UIAlertView *updateAlert;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SmaTabBarViewController *tabVC;
@property (nonatomic, strong) NSTimer *btStateMonitorTimer;
@property (strong, nonatomic) GeTuiSdk *gexinPusher;
@property (strong, nonatomic) NSString *appKey;
@property (strong, nonatomic) NSString *appSecret;
@property (strong, nonatomic) NSString *appID;
@property (strong, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;
@property (strong, nonatomic) UIApplication *applica;
@property (assign, nonatomic) int lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;
@property (nonatomic, strong) NSString *isBackground;
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic, weak) id<AppCreateUIDelegate> createUIDelegate;
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (void)stopSdk;

- (void)setDeviceToken:(NSString *)aToken;
- (BOOL)setTags:(NSArray *)aTag error:(NSError *)error;
- (NSString *)sendMessage:(NSData *)body error:(NSError *)error;

- (void)bindAlias:(NSString *)aAlias;
- (void)unbindAlias:(NSString *)aAlias;

- (void)testSdkFunction;
//- (void)testSendMessage;
- (void)testGetClientId;
- (void)registerUMessageRemoteNotification;
@end

