//
//  SamCoreBlueTool.h
//  SmaWatch
//
//  Created by 有限公司 深圳市 on 15/4/2.
//  Copyright (c) 2015年 smawatch. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SamCoreBlueTool;
@class SmaSeatInfo;
@class SmaUserInfo;
@class AppDelegate;
@class SmaMeMainViewController;
@class DFUViewController;
@protocol SetSamCoreBlueToolDelegate <NSObject>

@optional
- (void)getRequestData:(NSString *)Bytes;
/***********  绑定代理  begin  ******/
//开始查找蓝牙设备
-(void)beginFindWatch;
//开始绑定手表
-(void)beginBondWatch:(NSString *)watchName;
//没有找到蓝牙设备就调用
-(void)nofindWatch;
//绑定失败调用
-(void)BondWatchFailure;
//开始登录
-(void)beginWatchLogin;
//登录失败
-(void)loginWatchFailure;
//登录成功
-(void)loginWatchsucceed;
//连接蓝牙失败
-(void)connectWatchFailure;
//解除绑定
-(void)relieveWatchBound;
//返回蓝牙闹钟列表
-(void)dlgReturnAlermList:(NSMutableArray *)alermArray;
//拍照
-(void)photographClick;

-(void)photoClick;
//通知运动数据要刷新
-(void)NotificationSportRefresh;
//

-(void)NotificationElectric:(NSString *)ratioStr;
//刷新睡眠界面
-(void)NotificationSleepData;

-(void)NotificationOTA;

/***********  绑定代理  end  ******/
@end

@interface SamCoreBlueTool : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) SmaMeMainViewController *smaMeVC;
@property (nonatomic, strong) DFUViewController *dfuVC;

@property (nonatomic, weak) id<SetSamCoreBlueToolDelegate> delegate;
@property (nonatomic,strong) NSString *islink;//0 断开 : 1 链接
/* 中心管理者*/
@property (nonatomic, strong) CBCentralManager *mgr;
/*保存中心管理者*/
@property (nonatomic, strong) CBCentralManager *saveMgr;
/*外设设备集合*/
@property (nonatomic, strong) NSMutableArray *peripherals;
@property (nonatomic, strong) NSMutableArray *peripheralDicts;
/*外设设备字典*/
//@property (nonatomic, strong) NSMutableDictionary *peripheralDict;
@property (nonatomic, strong) NSMutableArray *systemPerpheral;
/*信号最强的那个蓝牙设备*/
@property (nonatomic,strong) CBPeripheral *peripheral;
/*设备写的特性*/
@property (nonatomic,strong) CBCharacteristic *characteristicWrite;
/*设备读的特性*/
@property (nonatomic,strong) CBCharacteristic *characteristicRead;

/*发送过来的植*/
@property (nonatomic,strong) CBCharacteristic *characteristicValue;

@property (nonatomic,assign) BOOL OTA;


/*电量 的特性在*/
@property (nonatomic,strong) CBCharacteristic *characteristicElectric;
@property (nonatomic,strong) NSString *rssivalue;
//系统版本
@property (nonatomic,strong) CBCharacteristic *characteristicVersion;

@property (nonatomic,strong) NSNumber *identiNumber;
/*蓝牙名称*/
@property (nonatomic,strong) NSString *swatchName;
@property (nonatomic,strong) NSString *orSwatchName;

/*ATO  模式*/
@property (nonatomic,strong) CBPeripheral *dfuperipheral;
@property (nonatomic,strong) CBCharacteristic *dfuControlPointCharacteristic;
@property (nonatomic,strong) CBCharacteristic *dfuPacketCharacteristic;
@property (nonatomic,strong) CBCharacteristic *dfuVersionCharacteristic;

@property (nonatomic, assign) BOOL firstBind;
@property (nonatomic, assign) BOOL bindIng;
//@property (nonatomic, assign) BOOL Background;

typedef enum {
    AWAIT_RECEVER1=0,//等待接收
    ALREADY_RECEVER1=1,
    VERIFT_RECEVER1=2
}RECEVER_STATUS_TYPE1;


+ (instancetype)sharedCoreBlueTool;
//第一次扫描绑定
-(void)oneScanBand:(BOOL)isOTA;
-(void)oneScanBand;
//设置闹钟
-(void)setCalarmClockInfo:(NSMutableArray *)smaACs;
//获取闹钟列表
-(void)getCalarmClockList;
-(void)LoginUser;
-(void)logOut;
-(void)setSystemTime;
//请求运动数据
-(void)requestExerciseData;
-(void)analysisSleepData:(Byte *)bytes len:(int)len;
//解除绑定
-(void)relieveWatchBound;
//同步APP数据
- (void)setAppSportData;
//请求运动数据
//查看蓝牙状况
-(BOOL)checkBleStatus;
//久坐设置
-(void)seatLongTimeInfo:(SmaSeatInfo *)info;

-(void)analySportData:(Byte *)bytes len:(int)len;
//设置用户信息
-(void)setUserMnerberInfo:(SmaUserInfo *)info;
//计步目标
-(void)setStepNumber:(int)count;
//手机 来电
-(void)setphonespark;
-(void)setphonespark: (BOOL)bol;
//手机来信息了
-(void)setSmsPhonespark;
-(void)setSmsPhonespark: (BOOL)bol;
/**
 *  关闭防止丢失
 */
-(void)closeDefendLose;
/**
 *  打开防止丢失
 */
-(void)openDefendLose;

/*后台播放音乐*/
-(void)backKvaudio;

//打开关闭同步
-(void)openSyncdata:(BOOL)bol;
//获取电量
-(void)getElectric;
//获取版本
- (void)getBLsystemVersion;
//交互一
-(void)setInteractone;
//交互二
-(void)setInteracttwo;

-(void)setInteractone33;
-(void)setInteractone31;
//关闭久坐
-(void)closeLongTimeInfo;
//进入OTA模式
-(void)setOTAstate;

- (void)beginLinkPeripheral;
- (void)connectPeripheral:(CBPeripheral *)peripheral Bool:(BOOL)background;
@end
