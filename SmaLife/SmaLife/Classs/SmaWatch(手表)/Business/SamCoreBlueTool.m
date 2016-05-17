//
//  SamCoreBlueTool.m
//  SmaWatch
//
//  Created by 有限公司 深圳市 on 15/4/2.
//  Copyright (c) 2015年 smawatch. All rights reserved.
//

#import "SamCoreBlueTool.h"
#import "SmaAccountTool.h"
#import "SmaUserInfo.h"
#import "SmaSeatInfo.h"
#import "SmaAlarmInfo.h"
#import "SmaSleepInfo.h"
#import "SmaDataDAL.h"
#import "SmaSportInfo.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "DFUController.h"
#import "SmaMeMainViewController.h"
#import "DFUViewController.h"
#import "SmaTabBarViewController.h"
@interface SamCoreBlueTool()
{
    AppDelegate *appdelegate;
    NSArray *SystemArr;
    float maxRSSI;           //最大的RSSI值
    int closestDeviceIndex;  //距离手机最近的设备下标（在peripherals中的下标）
    SmaTabBarViewController *smaTabVc;
    NSNotification *notification;
    NSNotification *versonNotification;
    NSNotification *OTAnotification;
    NSNotification *OTAnotPeripheral;
}
@property (nonatomic,strong) SmaUserInfo *smaUserInfo;
@property (nonatomic,strong) SmaDataDAL *smaDal;
/*蓝牙列表*/
//DFUController *duf=[[DFUController alloc]init];
@property (nonatomic,strong) DFUController *dfu;
@property (nonatomic,strong) NSMutableArray *alarmArray;

@end


@implementation SamCoreBlueTool
-(NSString *)islink
{
    if(!_islink ||  [_islink isEqualToString:@""])
    {
        _islink=@"0";
    }
    return _islink;
}
/*********** 蓝牙单例公共对象构建  begin ***********/
// 用来保存唯一的单例对象
static id _instace;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}
-(DFUController *)dfu
{
    
    if(_dfu==nil)
        _dfu=[[DFUController alloc] init];
    
    return _dfu;
}

+ (instancetype)sharedCoreBlueTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instace;
}

//加载dal对象
-(SmaDataDAL *)smaDal
{
    if(!_smaDal)
    {
        _smaDal=[[SmaDataDAL alloc]init];
    }
    return _smaDal;
}
/*********** 蓝牙单例公共对象构建  end ***********/
//-(NSMutableArray *)peripherals
//{
//    if(!_peripherals)
//        _peripherals=[NSMutableArray array];
//
//    return _peripherals;
//}
-(NSMutableArray *)systemPerpheral{
    if (!_systemPerpheral) {
        _systemPerpheral = [NSMutableArray array];
    }
    return _systemPerpheral;
}
/*********** 蓝牙主动操作 回调  begin ***********/
/*第一次扫描*/
//需要点击的扫描按钮
-(void)oneScanBand:(BOOL)isOTA{
    //搜索系统已连接设备
    //     self.OTA = isOTA;
    
    _smaUserInfo=[SmaAccountTool userInfo];
    self.rssivalue=@"-200";
    if (self.peripherals) {
        self.peripherals=nil;
        [self.peripherals removeAllObjects];
    }
    if (self.peripheralDicts) {
        [self.peripheralDicts removeAllObjects];
        self.peripheralDicts = nil;
    }
    self.mgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    if (!_smaMeVC) {
        _smaMeVC = [[SmaMeMainViewController alloc] init];
    }
    if (!_dfuVC) {
        _dfuVC = [[DFUViewController alloc] init];
    }
    if (self.systemPerpheral) {
        [self.systemPerpheral removeAllObjects];
    }
    if (isOTA == NO) {
        SystemArr = [self.mgr retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"]]];
        if (SystemArr.count > 0) {
            self.systemPerpheral = (NSMutableArray *)SystemArr;
        }
    }
    
}
-(void)oneScanBand{
    if (!self.peripheralDicts) {
        _smaUserInfo=[SmaAccountTool userInfo];
        self.rssivalue=@"-200";
        self.mgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
}
//弹出框处理
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    printf("Status of CoreBluetooth central manager changed %ld n",(long)central.state);
    NSString *message=[[NSString alloc]init];
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            message = @"初始化中，请稍后……";
            break;
        case CBCentralManagerStateResetting:
            message = @"设备不支持状态，过会请重试……";
            break;
        case CBCentralManagerStateUnsupported:
            message = @"设备未授权状态，过会请重试……";
            break;
        case CBCentralManagerStateUnauthorized:
            message = @"设备未授权状态，过会请重试……";
            break;
        case CBCentralManagerStatePoweredOff:
            message = @"尚未打开蓝牙，请在设置中打开……";
            self.islink = @"0";
            
            break;
        case CBCentralManagerStatePoweredOn:
            message = @"蓝牙已经成功开启，正在扫描蓝牙接口……";
            if (SmaBleMgr.OTA) {
                if (!OTAnotification) {
                    NSLog(@"通知搜索设备");
                    OTAnotification =[NSNotification notificationWithName:@"OTAnotification" object:nil userInfo:nil];
                    //                    通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:OTAnotification];
                }
            }
            
            break;
        default:
            break;
    }
    MyLog(@"检测蓝牙开启状态*****%@  %@  self.OT===%d",self.systemPerpheral,[SmaAccountTool userInfo].watchUID,self.OTA);
    
    if (self.systemPerpheral && self.systemPerpheral.count > 0 && [SmaAccountTool userInfo].watchUID && ![self.smaUserInfo.watchUID isEqual:@""] ) {
        [self.systemPerpheral enumerateObjectsUsingBlock:^(CBPeripheral *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.identifier isEqual:self.smaUserInfo.watchUID]) {
                if (obj.state == CBPeripheralStateConnecting) {
                    [SmaBleMgr.mgr cancelPeripheralConnection:obj];
                }
                
                [self connectPeripheral:obj Bool:NO];
            }
            else {
                
                [self performSelector:@selector(startScan) withObject:nil afterDelay:0.0f];
                
            }
        }];
    }
    else {
        [self performSelector:@selector(startScan) withObject:nil afterDelay:0.0f];
        
    }
}

//扫描
-(void)startScan
{
    if ([self.delegate respondsToSelector:@selector(beginFindWatch)]) {
        [self.delegate beginFindWatch];
    }
    [self.mgr scanForPeripheralsWithServices:nil options:nil];
}
-(void)OTAscan{
    [self startScan];
}

//    NSLog(@"对比各设备");
//    //只有当app还没有绑定手环时才会绑定距离最近的手环
//    if([self.smaUserInfo.watchUID isEqual:@""] || [self.smaUserInfo.watchName isEqualToString:@""]){
//
//        if (self.smaUserInfo.scnaSwatchName && ![self.smaUserInfo.scnaSwatchName isEqualToString:@""] && self.smaUserInfo.orScnaSwatchName && ![self.smaUserInfo.orScnaSwatchName isEqualToString:@""]) {
//            NSArray *rssiArr = [[NSArray alloc]init];
//            NSMutableDictionary *perDict= [[NSMutableDictionary alloc]init];;
//            for (int i=0 ;i<self.peripheralDicts.count; i++) {
//                [perDict setObject:[[self.peripheralDicts objectAtIndex:i] objectForKey:[[[self.peripheralDicts objectAtIndex:i] allKeys] objectAtIndex:0]] forKey:[[[self.peripheralDicts objectAtIndex:i] allKeys] objectAtIndex:0]];
//            }
//            rssiArr = [perDict allKeys];
//            NSArray *sortedArray = [rssiArr sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
//                if ([obj1 intValue] > [obj2 intValue]) {
//                    return NSOrderedDescending;
//                } else {
//                    return NSOrderedAscending;
//                }
//            }];
//
//            if (sortedArray && sortedArray.count > 0 ) {
//
//                self.peripheral = [perDict objectForKey:[sortedArray objectAtIndex:0]];
//                 NSLog(@"---连接最近的手环==%@  %@  %@",sortedArray,self.peripheral,[perDict objectForKey:[sortedArray objectAtIndex:0]]);
//                [self beginLinkPeripheral];//找到了久开始连接
//
//            }
//        }
//    }





/******************* 事件操作  being *******************/
//－－－－－－－－－－－－－－－开始链接蓝牙设备
-(void)beginLinkPeripheral
{
    if(self.peripheral)
    {
        NSLog(@"连接找到对象");
        NSLog(@"没有找到对象");
        [self.mgr stopScan];
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnNotificationKey];
        self.peripheral.delegate = self;
        [self.mgr connectPeripheral:self.peripheral options:nil];
        
        
    }else{
        if ([self.delegate respondsToSelector:@selector(nofindWatch)]) {
            [self.delegate nofindWatch];
        }
        NSLog(@"没有找到对象");
        [self.mgr stopScan];
    }
}

- (void)connectPeripheral:(CBPeripheral *)peripheral Bool:(BOOL)background {
    
    //    printf("Connecting to peripheral with UUID : %s \r\n  ",[self UUIDToString:peripheral.UUID]);
    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    if (background) {
        NSLog(@"后台连接设备");
        [self.saveMgr stopScan];
        [self.saveMgr connectPeripheral:peripheral options:nil];
    }else{
        NSLog(@"连接系统设备");
        [self.mgr stopScan];
        [self.mgr connectPeripheral:peripheral options:nil];
    }
    //    [CM cancelPeripheralConnection:activePeripheral];
    
    
    //    [TIBLEConnectBtn setTitle:@"Connect" forState:UIControlStateNormal];
}

//－－－－－－－－－－－－－－绑定手表
-(void)bindUser
{
    if(self.mgr && self.peripheral)
    {
        MyLog(@"开始绑定");
        if ([self.delegate respondsToSelector:@selector(beginBondWatch:)]) {
            [self.delegate beginBondWatch:self.peripheral.name];
        }
        
        [self bindBloacUserID:[NSString stringWithFormat:@"%@",self.smaUserInfo.userId] characteristic:self.characteristicWrite ident:0];//绑定
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(nofindWatch)]) {
            [self.delegate nofindWatch];
        }
        NSLog(@"没有找到对象");
        [self.mgr stopScan];
    }
}
//－－－－－－－－－登录用户
-(void)LoginUser
{
    MyLog(@"发送登录命令 %@",self.smaUserInfo.userId );
    //    self.islink=@"1";
    if(self.mgr && self.peripheral && self.characteristicWrite)
        [self bindBloacUserID:[NSString stringWithFormat:@"%@",self.smaUserInfo.userId ] characteristic:self.characteristicWrite ident:1];//登陆
    
}
//－－－－－－－－－退出登录

-(void)logOut{
    Byte results[14];
    Byte buf[1];
    buf[0] = 0x00;
    [SmaBusinessTool getSpliceCmd:0x03 Key:0x06 bytes1:buf len:1 results:results];
    NSData * data0 = [NSData dataWithBytes:results length:14];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
}
/******************* 事件操作  end *******************/
-(NSString *)rssivalue
{
    if([_rssivalue isEqualToString:@""])
    {
        _rssivalue=@"-200";
    }
    return _rssivalue;
}

/**
 *  扫描所有蓝牙设备
 *
 *  @param central           中心设备
 *  @param peripheral        外设
 *  @param advertisementData <#advertisementData description#>
 *  @param RSSI              设备信号强度
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    MyLog(@"%@——————————%f——--11111111-----%@--%@  %@ %@",peripheral,RSSI.floatValue,self.smaUserInfo.scnaSwatchName ,self.smaUserInfo.watchUID ,self.smaUserInfo.watchName,self.smaUserInfo.orScnaSwatchName);
    NSLog(@"-____===%@",self.smaUserInfo.watchName);
    //
    if(![self.smaUserInfo.watchUID isEqual:@""]&& self.smaUserInfo.watchUID && self.smaUserInfo.watchName && ![self.smaUserInfo.watchName isEqualToString:@""])
    {
        NSLog(@"连接绑定手表==%d",self.OTA);
        
        if (self.OTA && [peripheral.name isEqualToString:self.smaUserInfo.watchName] && [peripheral.identifier isEqual:self.smaUserInfo.watchUID]) {
            NSLog(@"连OTA手表");
            self.peripheral=peripheral;
            [self beginLinkPeripheral];//找到了久开始连接
            [self.mgr stopScan];
        }
        else if([peripheral.identifier isEqual:self.smaUserInfo.watchUID])
        {
            
            
            if(![self.peripherals containsObject:self.smaUserInfo.scnaSwatchName])
            {
                self.peripheral=peripheral;
                [self beginLinkPeripheral];//找到了久开始连接
            }
        }
    }
    else//没有绑定
    {
        //
        //        if ([peripheral.name isEqualToString:self.smaUserInfo.scnaSwatchName] || [peripheral.name isEqualToString:self.smaUserInfo.orScnaSwatchName]) {
        //            if (!self.peripherals) {
        //                self.peripherals = [[NSMutableArray alloc] initWithObjects:peripheral,nil];
        //                if (!self.peripheralDicts) {
        //
        //                    self.peripheralDicts = [[NSMutableArray alloc]init];
        //                }
        //                closestDeviceIndex = 0;
        //                maxRSSI = -999999;
        //
        //            } else {
        //                for(int i = 0; i < self.peripherals.count; i++) {
        //                    CBPeripheral *p = [self.peripherals objectAtIndex:i];
        //                    if ([self UUIDSAreEqual:(__bridge CFUUIDRef)(p.identifier) u2:(__bridge CFUUIDRef)(peripheral.identifier)]) {
        //                        [self.peripherals replaceObjectAtIndex:i withObject:peripheral];
        //                        printf("Duplicate UUID found updating ...\r\n");
        //                        return;
        //                    }
        //                }
        //                if (RSSI.intValue <0) {
        //
        //                    NSMutableDictionary *peripheralDict = [[NSMutableDictionary alloc] init];
        //                    [self->_peripherals addObject:peripheral];
        //                    [peripheralDict setObject:peripheral forKey:[NSString stringWithFormat:@"%d",abs(RSSI.intValue)]];
        //                    //                    [peripheralDict setObject:RSSI forKey:@"rssi"];
        //                    [self.peripheralDicts addObject:peripheralDict];
        //
        //                    printf("New UUID, adding  %d  %f   \r\n",RSSI.intValue,maxRSSI);
        //                    NSLog(@",self.peripheralDict==%@",self.peripheralDicts);
        //                }
        //记录下RSSI最大的设备下标
        //                if (maxRSSI < RSSI.floatValue) {
        //                    maxRSSI = RSSI.floatValue;
        //                closestDeviceIndex = self.peripherals.count-1;
        //                self.peripheral = peripheral;
        //                NSLog(@"self.peripheral =%f  %f  %d  %lu",maxRSSI,RSSI.floatValue,closestDeviceIndex,(unsigned long)self.peripherals.count );
        //                }
        
        //            }
        //
        //        }
        
        //需要重新绑定就需要重新设置系统时间
        if([peripheral.name isEqualToString:self.swatchName]|| [peripheral.name isEqualToString:self.smaUserInfo.orScnaSwatchName])
        {
            if(![self.peripherals containsObject:peripheral])
            {
                
                [self.peripherals addObject:peripheral];
                float rssiv=[RSSI floatValue];
                if(rssiv>[self.rssivalue floatValue])//得到信号最强的蓝牙设备
                {
                    
                    _rssivalue=[NSString stringWithFormat:@"%.f",rssiv];
                    self.peripheral=peripheral;
                    [self beginLinkPeripheral];//找到了久开始连接
                }
            }
        }
    }
}
/**
 *  <#Description#> 开始链接蓝牙外设
 *  @param central   中心设备(手机)
 *  @param peripheral 外设(蓝牙手表)
 */
- (int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2 {
    CFUUIDBytes b1 = CFUUIDGetUUIDBytes(u1);
    CFUUIDBytes b2 = CFUUIDGetUUIDBytes(u2);
    if (memcmp(&b1, &b2, 16) == 0) {
        return 1;
    }
    else return 0;
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    [SmaBleMgr.mgr stopScan];
    if(self.peripheral)
    {
        // 扫描外设中得服务
        self.peripheral = peripheral;
        self.peripheral.delegate=self;
        [self.peripheral discoverServices:nil];
        
    }else
    {
        if ([self.delegate respondsToSelector:@selector(nofindWatch)]) {
            [self.delegate nofindWatch];
        }
    }
}

/**
 *  只要链接蓝牙失败调用
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.islink=@"0";//失败
    NSLog(@"===%@",error.localizedDescription);
    if ([self.delegate respondsToSelector:@selector(connectWatchFailure)]) {
        [self.delegate connectWatchFailure];
    }
    //    self.peripherals=nil;
    //    self.rssivalue=@"-200";
    //    [self oneScanBand];//重新扫扫描
    //    if (peripheral.state == CBPeripheralStateDisconnected ) {
    //        [self beginLinkPeripheral];
    //        if (_smaMeVC) {
    //            [_smaMeVC setBlueView];
    //        }
    //    }
    
    //    if (self.peripherals) {
    //        self.peripherals=nil;
    //        [self.peripherals removeAllObjects];
    //    }
    //    if (self.peripheralDicts) {
    //        [self.peripheralDicts removeAllObjects];
    //        self.peripheralDicts = nil;
    //    }
    
    
}
/**
 *  只要扫描到服务就会调用
 *
 *  @param peripheral 服务所在的外设
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    // 获取外设中所有扫描到得服务
    //MyLog(@"哈哈哈哈");
    if (self.OTA) {
        OTAnotPeripheral =[NSNotification notificationWithName:@"OTAnotPeripheral" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:OTAnotPeripheral];
    }
    NSArray *services = peripheral.services;
    for (CBService *service in services) {
        MyLog(@"服务的UUID ＝＝＝＝＝＝＝＝＝＝＝＝＝  %@ ",service.UUID.UUIDString);
        [self.peripheral discoverCharacteristics:nil  forService:service];
        if ([service.UUID.UUIDString isEqualToString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"])
        {
            // NSLog(@"找到服务");
            // 从peripheral中得service中扫描特征
            [self.peripheral discoverCharacteristics:nil  forService:service];
            
        }
        else if([service.UUID.UUIDString isEqualToString:@"180F"])
        {
            //电量服务
            [self.peripheral discoverCharacteristics:nil  forService:service];
            
        }
        
        //            else if([service.UUID.UUIDString isEqualToString:@"00001530-1212-EFDE-1523-785FEABCD123"])
        //        {
        //            [self.dfuperipheral discoverCharacteristics:nil  forService:service];
        //        }
    }
}

/**
 *  只要扫描到特征就会调用
 *  @param peripheral 特征所属的外设
 *  @param service    特征所属的服务
 */
static int login = 1;
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // 拿到服务中所有的特诊
    
    if (!appdelegate) {
        appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    NSArray *characteristics =  service.characteristics;
    if ([appdelegate.isBackground isEqualToString:@"1"]) {
        SmaBleMgr.saveMgr = SmaBleMgr.mgr;
    }
    
    // 遍历特征, 拿到需要的特征处理
    
    for (CBCharacteristic * characteristic in characteristics) {
        MyLog(@"特性的UUID ＝＝＝＝＝＝＝＝＝＝＝＝＝  %@ %d",characteristic.UUID.UUIDString,characteristics.count);
        
        if ([characteristic.UUID.UUIDString isEqualToString:@"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            self.characteristicWrite=characteristic;
            
            if(!self.smaUserInfo.watchUID ||[self.smaUserInfo.watchUID.UUIDString isEqualToString:@""])
            {
                [self bindUser];
                
            }else
            {
                [self LoginUser];
                
            }
        }else if ([characteristic.UUID.UUIDString isEqualToString:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            self.characteristicRead=characteristic;
            /* 监听蓝牙返回的情况 */
            [self.peripheral readValueForCharacteristic:self.characteristicRead];
            [self.peripheral setNotifyValue:YES forCharacteristic:self.characteristicRead];
            
        }
        else if([characteristic.UUID.UUIDString isEqualToString:@"2A19"])//电量
        {
            _characteristicElectric=characteristic;//电量
        }
        else if ([characteristic.UUID.UUIDString isEqualToString:@"2A26"]){
            _characteristicVersion = characteristic;
        }
    }
    
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (!error) {
        
    } else {
        NSLog(@"%s: error=%@", __func__, error);
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error{
    NSLog(@": rssi2 = %d", RSSI.intValue);
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"%s: 7RSSI=%d", __func__, peripheral.RSSI.intValue);
}
- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals{
    NSLog(@"============%@",peripherals);
}

-(void)getElectric
{
    //    UInt16 sever = 0x180F;
    UInt16 s = [self swap:0x180F];
    UInt16 c = [self swap:0x2A19];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:self.peripheral];
    if (!service) {
        
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        //            NSLog(@"s: 7RSSI=");
        return;
    }
    
    [self.peripheral readValueForCharacteristic:characteristic];
    
    
    //    if(self.peripheral && self.characteristicElectric)
    //    {
    //        MyLog(@"laile ");
    //        [self.peripheral readValueForCharacteristic:self.characteristicElectric];
    //    }else{
    //        MyLog(@"CUOLE ");
    //       // [self oneScanBand];
    //    }
}

- (void)getBLsystemVersion{
    UInt16 s = [self swap:0x180A];
    UInt16 c = [self swap:0x2A26];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:self.peripheral];
    if (!service) {
        
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        //            NSLog(@"s: 7RSSI=");
        return;
    }
    
    [self.peripheral readValueForCharacteristic:characteristic];
    
    //    if (self.peripheral && self.characteristicVersion) {
    //        [self.peripheral readValueForCharacteristic:_characteristicVersion];
    //    }
    
}
- (UInt8)readUInt8Value:(uint8_t **)p_encoded_data
{
    return *(*p_encoded_data)++;
}
-(UInt16) CBUUIDToInt:(CBUUID *) UUID {
    char b1[16];
    [UUID.data getBytes:b1];
    return ((b1[0] << 8) | b1[1]);
}
//监听蓝牙返回情况
static int receive_state=0;
static int sum_length_to_receive=0;
static Byte received_buffer[128];
static int length_to_receive=0;

-(void)peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    MyLog(@"------111--------这个是啥------------%@               %@",characteristic.UUID.UUIDString,characteristic.value);
    NSData *data = characteristic.value;
    uint8_t *array = (uint8_t*) data.bytes;
    if ([characteristic.UUID.UUIDString isEqualToString:@"2A26"]) {
        uint8_t cmd_data[20];
        uint32_t cmd_len = (uint32_t)[data length];
        memset(cmd_data, 0, 20);
        [data getBytes:(void *)cmd_data length:cmd_len];
        NSString *VersionStr = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
        
        
        [SmaUserDefaults setObject:VersionStr forKey:@"BLSystemVersion"];
        NSLog(@"BLE version Rev=%@  command=%@  %@",data,VersionStr,[SmaUserDefaults stringForKey:@"BLSystemVersion"]);
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:VersionStr,@"VersionStr", nil];
        versonNotification = [NSNotification notificationWithName:@"systemVersion" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:versonNotification];
    }
    else if ([characteristic.UUID.UUIDString isEqualToString:@"2A19"])
    {
        //MyLog(@"HAHAHA__________2A19");
        //        UInt8 batteryLevel = [self readUInt8Value:&array];
        uint8_t cmd_data[20];
        uint32_t cmd_len = (uint32_t)[data length];
        memset(cmd_data, 0, 20);
        [data getBytes:(void *)cmd_data length:cmd_len];
        NSLog(@"BLE CELL Rev=%@  command=%d",data,cmd_data[0]);
        
        NSString* text = [[NSString alloc] initWithFormat:@"%d%%", cmd_data[0]];
        
        if ([self.delegate respondsToSelector:@selector(NotificationElectric:)]) {
            [self.delegate NotificationElectric:text];
            
        }
    }else
    {
        Byte *testByte = (Byte *)[characteristic.value bytes];
        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@_________坑啊",characteristic.value);
        if (characteristic.value) {
            
            if([SmaBusinessTool checkNckBytes:testByte])//非应答信号
            {
                _characteristicValue=characteristic;
                if(receive_state==AWAIT_RECEVER1 && testByte[0]==0xAB)//等待接受
                {
                    //获取此批次需要接收的长度
                    int i=(int)(testByte[3]|testByte[2]<<8);
                    MyLog(@"接受过来的字节长度：%d--%x",i,testByte[3]);
                    sum_length_to_receive=(i+8);
                    length_to_receive=0;
                }
                int len=characteristic.value.length;
                MyLog(@"------传过来的长度---------%d",len);
                [self getSpliceByte:testByte len:len totallenght:sum_length_to_receive];
            }
        }
    }
    
    //[characteristic addObserver:self forKeyPath:@"value" options:0 context:nil];
}
//销毁
- (void)dealloc
{
    [self.characteristicValue removeObserver:self forKeyPath:@"value"];
}
/*********** 蓝牙主动操作 回调  end ***********/




/******************* 蓝牙回调  being *******************/


//接受传送过来的植进行匹配


//static Byte old_buffer[128];
//通知   监控返回蓝牙返回的数据
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    Byte *testByte = (Byte *)[self.characteristicValue.value bytes];
//
//    if([SmaBusinessTool checkNckBytes:testByte])//非应答信号
//    {
//        if(receive_state==AWAIT_RECEVER1 && testByte[0]==0xAB)//等待接受
//        {
//            //获取此批次需要接收的长度
//            int i=(int16_t)(testByte[3]+testByte[2]<<8);
//            MyLog(@"i=%d",i);
//            sum_length_to_receive=(i+8);
//            length_to_receive=0;
//            MyLog(@"都不进来");
//        }
//         MyLog(@"都不进来");
//        [self getSpliceByte:testByte len:self.characteristicValue.value.length totallenght:sum_length_to_receive];
//    }else
//    {
//        MyLog(@"都不进来");
//        length_to_receive=0;
//    }
//}
//组装蓝牙返回的数据
-(void)getSpliceByte:(Byte [])testBytes len:(int)len totallenght:(int)totallenght
{
    if(receive_state==AWAIT_RECEVER1)
    {
        if(testBytes[0]!=0xAB)//开始接收包
            return;
        
        receive_state=ALREADY_RECEVER1;//继续等待接收
        memcpy(&received_buffer,testBytes,len);//拷贝到对应的Byte 数组中
        length_to_receive=len;//已经接收的长度
        if(totallenght==length_to_receive)//一次就全部接收完成
        {
            BOOL bol= [SmaBusinessTool checkCRC16:received_buffer];
            //检查命令类型
            [self checkCmdKeyType:received_buffer len:totallenght bol:bol];
            //完成操作
            receive_state=AWAIT_RECEVER1;
        }
    }else if(receive_state==ALREADY_RECEVER1)
    {
        if(testBytes[0]!=0xAB)//开始接收包
        {
            MyLog(@"长度:------ %d---状态：%d--需要接受的长度：%d    零字节--%s    \n---%hhu",length_to_receive,receive_state,len,testBytes,testBytes[0]);
            memcpy(&received_buffer[length_to_receive],testBytes,len);
            length_to_receive=length_to_receive+len;
            
            MyLog(@"%d----------%d ****** %s",length_to_receive,totallenght,received_buffer);
            if(length_to_receive>=totallenght)//接收完毕©∫
            {
                sum_length_to_receive=0;
                length_to_receive=0;
                MyLog(@"进来了-------%d",length_to_receive);
                //                for (int i = 0; i<totallenght; i ++) {
                //                    NSLog(@"***received_buffer ===== %hhu ***testbytes ===== %hhu",received_buffer[i],testBytes[i]);
                //                }
                receive_state=AWAIT_RECEVER1;
                BOOL bol= [SmaBusinessTool checkCRC16:received_buffer];
                //检查命令类型
                [self checkCmdKeyType:received_buffer len:totallenght bol:bol];
                
            }
        }
    }
}
//检查命令类型
-(void)checkCmdKeyType:(Byte *)bytes len:(int)len bol:(BOOL)bol
{
    //    MyLog(@"%x*****________%x  %hhu   %hhu  %hhu",received_buffer[6],received_buffer[7],bytes[8],bytes[10],bytes[13]);
    [self retAckAndNackBol:bol ckByte:((received_buffer[6]<<8)+received_buffer[7])];
    
    if(bytes[8]==0x03 && bytes[10]==0x02)//绑定请求返回命令,验证是否绑定成功
    {
        if(bol)//绑定成功
        {
            NSLog(@"绑定成功");
            
            [self retAckAndNackBol:bol ckByte:received_buffer[7]];
            [self setSystemTime];
            [self setAppSportData];
            if ([self.delegate respondsToSelector:@selector(beginWatchLogin)]) {
                [self.delegate beginWatchLogin];
            }
            [SmaBleMgr logOut];
            [self.mgr cancelPeripheralConnection:self.peripheral];
            //绑定成功后需要记录手表信息
            if([self.smaUserInfo.watchUID isEqual:@""] || [self.smaUserInfo.watchName isEqualToString:@""] || self.smaUserInfo==nil || self.smaUserInfo.watchName==nil)
            {
                self.smaUserInfo.watchName=self.peripheral.name;
                self.smaUserInfo.OTAwatchName = self.peripheral.name;
                //NSCFType
                self.smaUserInfo.watchUID=self.peripheral.identifier;
                [SmaAccountTool saveUser:self.smaUserInfo];
                SmaUserInfo *info= [SmaAccountTool userInfo];
                NSLog(@"sfjeiow===%@    %@   %@  %@ ",self.smaUserInfo.watchName,self.smaUserInfo.watchUID,info.watchUID,info.watchUID);
                //断开连接
                
                self.mgr=nil;
                
                [self oneScanBand:NO];
            }
            //            else
            //            {
            //                //用户登录
            //                [self LoginUser];
            //            }
            
        }else//绑定失败
        {
            //[self retAckAndNackBol:bol ckByte:received_buffer[7]];
            NSLog(@"绑定失败");
            if ([self.delegate respondsToSelector:@selector(BondWatchFailure)]) {
                [self.delegate BondWatchFailure];
            }
        }
        
        
    }else if(bytes[8]==0x03 && bytes[10]==0x04)//登录请求返还命令,验证登录是否成功
    {
        if(bol)//登录成功成功，
        {
            [SmaBleMgr.mgr stopScan];
            self.islink=@"1";//登陆成功
            NSLog(@"登录成功");
            [self retAckAndNackBol:bol ckByte:received_buffer[7]];
            if ([self.delegate respondsToSelector:@selector(loginWatchsucceed)]) {
                MyLog(@"实现了这个方法");
                [self.delegate loginWatchsucceed];
            }
            //绑定成功后需要记录手表信息
            if(![self.smaUserInfo.isLogin isEqualToString:@"true"])
            {
                self.smaUserInfo.isLogin=@"true";
                MyLog(@"设置系统时间");
                [self setSystemTime];
                [SmaAccountTool saveUser:self.smaUserInfo];
            }
            else
            {
                MyLog(@"设置系统时间");
                [self setSystemTime];
            }
            int antioBind = (int)[SmaUserDefaults integerForKey:@"myLoseInt"];
            if(antioBind==1){
                MyLog(@"打开防丢");
                [SmaBleMgr openDefendLose];//打开防丢
            }
            else{
                MyLog(@"关闭防丢");
                [SmaBleMgr closeDefendLose];//关闭防丢
            }
            SmaSeatInfo *info = [SmaAccountTool seatInfo];
            
            if (info.isOpen.intValue == 1) {
                MyLog(@"开始久座");
                [SmaBleMgr seatLongTimeInfo:info];
            }
            else {
                MyLog(@"关闭久座");
                [SmaBleMgr closeLongTimeInfo];
            }
            
            int setph = (int)[SmaUserDefaults integerForKey:@"myTelRemindInt"];
            int setSms = (int)[SmaUserDefaults integerForKey:@"mySmsRemindInt"];
            if (setph == 1) {
                
                [SmaBleMgr setphonespark:YES];
            }
            else {
                [SmaBleMgr setphonespark:NO];
            }
            if (setSms == 1) {
                [SmaBleMgr setSmsPhonespark:YES];
            }
            else {
                [SmaBleMgr setSmsPhonespark:NO];
            }
            //设置闹钟
            NSMutableArray *colockArry=[NSMutableArray array];
            NSMutableArray *alarmArry = [NSMutableArray array];
            
            SmaDataDAL *dal=[[SmaDataDAL alloc]init];
            alarmArry=[dal selectClockList];
            int aid=0;
            for (int i=0; i<alarmArry.count; i++) {
                SmaAlarmInfo *info=(SmaAlarmInfo *)alarmArry[i];
                if([info.isopen intValue]>0)
                {
                    info.aid=[NSString stringWithFormat:@"%d",aid];
                    [colockArry addObject:info];
                    aid++;
                }
            }
            
            if(colockArry.count> 0)
            {
                
                [SmaBleMgr setCalarmClockInfo:colockArry];
            }
            NSLog(@"设置目标");
            NSString *goal = [SmaUserDefaults objectForKey:@"stepPlan"];
            if (!goal || [goal isEqualToString:@""]) {
                goal = @"35";
            }
            [self setStepNumber:goal.intValue * 200];
            [self getBLsystemVersion];
            [self openSyncdata:true];
            
            //            [SmaUserDefaults setInteger:1 forKey:@"openSyn"];
            //            [SmaBleMgr openSyncdata:true];
            //登陆成功后需要重新设置
            //            NSInteger myTelInteger = [SmaUserDefaults integerForKey:@"openSyn"];
            //            if(myTelInteger==1)//没有开启发防丢
            //            {
            
            //            }
            
        }else//登录失败
        {
            //[self retAckAndNackBol:bol ckByte:received_buffer[7]];
            if ([self.delegate respondsToSelector:@selector(loginWatchFailure)]) {
                [self.delegate loginWatchFailure];
            }
            
        }
    }else if(bytes[8]==0x02 && bytes[10]==0x04)//返回闹钟列表
    {
        MyLog(@"返回闹钟列表");
        [self analysisAlarmClockData:bytes len:len];
    }
    else if(bytes[8]==0x05 && bytes[10]==0x02)
    {
        MyLog(@"运动数据开始返回");
        //[self retAckAndNackBol:true ckByte:received_buffer[7]];
        [self analySportData:bytes len:len];
        
    }else if(bytes[8]==0x05 && bytes[10]==0x03){
        MyLog(@"睡眠数据返回");
        [self analysisSleepData:bytes len:len];
        
    }else if(bytes[8]==0x05 && bytes[10]==0x05){
        [self analysisSetSleepData:bytes len:len];
        //[self retAckAndNackBol:true ckByte:received_buffer[7]];
    }else if(bytes[8]==0x05 && bytes[10]==0x05){
        [self analysisSetSleepData:bytes len:len];
    }
    else if(bytes[8]==0x05 && bytes[10]==0x07){//开始同步
        // isSynch=0;
        //         [self retAckAndNackBol:true ckByte:received_buffer[7]];
    }
    else if(bytes[8]==0x05 && bytes[10]==0x08){
        //         isSynch=1;
        //         [self retAckAndNackBol:true ckByte:received_buffer[7]];
    } else if(bytes[8]==0x07 && bytes[10]==0x01){//双击
        //
        SmaUserInfo *info=[SmaAccountTool userInfo];
        if(bytes[13]==0x11)
        {
            if ([self.delegate respondsToSelector:@selector(photoClick)]) {
                [self.delegate photoClick];
            }
        }else if(bytes[13]==0x02)
        {
            
            if(info.friendAccount && ![info.friendAccount isEqualToString:@""])
            {
                MyLog(@"来了命令32");
                SmaAnalysisWebServiceTool *dal=[SmaAnalysisWebServiceTool alloc];
                //                [dal sendInteraction:@"IOS" friendAccount:info.tel content:@"32"];
                [dal acloudDispatcherFriendAccount:info.friendAccount content:@"32" success:^(id success) {
                    
                } failure:^(NSError *error) {
                    
                }];
            }
            
        }else if(bytes[13]==0x12)
        {
            if(info.friendAccount && ![info.friendAccount isEqualToString:@""])
            {
                MyLog(@"来了命令33");
                SmaAnalysisWebServiceTool *dal=[SmaAnalysisWebServiceTool alloc];
                //                [dal sendInteraction:@"IOS" friendAccount:info.tel content:@"33"];
                [dal acloudDispatcherFriendAccount:info.friendAccount content:@"33" success:^(id success) {
                    
                } failure:^(NSError *error) {
                    
                }];
            }
        }
    }
}
//ack 或Nack 回应
-(void)retAckAndNackBol:(BOOL)bol ckByte:(int16_t)ckByte
{
    if(bol)//绑定成功
    {
        [SmaBusinessTool setAckCmdSeqId:ckByte peripheral:self.peripheral characteristic:self.characteristicWrite];//登录成功
    }else//绑定失败
    {
        [SmaBusinessTool setNackCmdSeqId:ckByte peripheral:self.peripheral characteristic:self.characteristicWrite];//登录失败
    }
}
/******************* 蓝牙回调  end  *******************/





/*******************  数据解析  being *******************/

//---------------------解析闹钟数据
-(NSMutableArray *)alarmArray
{
    if (_alarmArray==nil) {
        _alarmArray=[NSMutableArray array];
    }
    return _alarmArray;
}

//解析闹钟
-(void)analysisAlarmClockData:(Byte *)bytes len:(int)len
{
    _alarmArray=nil;
    int begin=12;
    int listLen=(len-13)/5;
    for (int i=0; i<listLen; i++) {
        alarm_union_t user_clock;
        user_clock.data=(((uint64_t)bytes[begin+(1+(i*5))])<<32)+((uint64_t)bytes[begin+(2+(i*5))]<<24)+((uint64_t)bytes[begin+(3+(i*5))]<<16)+((uint64_t)bytes[begin+(4+(i*5))]<<8)+((uint64_t)bytes[begin+(5+(i*5))]<<0);
        
        SmaAlarmInfo *alarInfo=[[SmaAlarmInfo alloc]init];
        alarInfo.year=[NSString stringWithFormat:@"%d",user_clock.alarm.year];
        alarInfo.mounth=[NSString stringWithFormat:@"%d",user_clock.alarm.month];
        alarInfo.day=[NSString stringWithFormat:@"%d",user_clock.alarm.day];
        alarInfo.hour=[NSString stringWithFormat:@"%d",user_clock.alarm.hour];
        alarInfo.minute=[NSString stringWithFormat:@"%d",user_clock.alarm.minute];
        alarInfo.mounth=[NSString stringWithFormat:@"%d",user_clock.alarm.month];
        alarInfo.aid=[NSString stringWithFormat:@"%d",user_clock.alarm.id];
        
        burntheplanks_week_union_t week_t1;
        week_t1.week=user_clock.alarm.day_repeat_flag;
        
        NSString *str=[NSString stringWithFormat:@"%d,%d,%d,%d,%d,%d,%d",week_t1.bit_week.monday,week_t1.bit_week.tuesday,week_t1.bit_week.wednesday,week_t1.bit_week.thursday,week_t1.bit_week.friday,week_t1.bit_week.saturday,week_t1.bit_week.sunday];
        alarInfo.dayFlags=[NSString stringWithFormat:@"%d",user_clock.alarm.day_repeat_flag];
        
        //clock_data.alarm.day_repeat_flag =week_t1.week;
        alarInfo.dayFlags=str;
        
        [self.alarmArray addObject:alarInfo];
        MyLog(@"在组装闹钟");
    }
    //这样才算发送成功
    if ([self.delegate respondsToSelector:@selector(dlgReturnAlermList:)]) {
        NSLog(@"组装完成");
        [self.delegate dlgReturnAlermList:self.alarmArray];
    }
}

//--解析运动数据Ok
-(void)analySportData:(Byte *)bytes1 len:(int)len
{
    NSMutableArray *infos=[NSMutableArray array];
    
    SportsHead_t sport_head;
    sport_head.Date.data=((uint16_t)bytes1[13]<<8)+((uint16_t)bytes1[14]<<0);
    NSLog(@"(uint16_t)bytes1[13===%hu   %hu",(uint16_t)bytes1[13],(uint16_t)bytes1[14]);
    sport_head.length=((uint8_t)bytes1[16]<<0);
    
    SmaUserInfo *user= [SmaAccountTool userInfo];
    int count=sport_head.length;
    //MyLog(@"运动数据长度－－－－－－－－－%d",count);
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    [dateFor setDateFormat:@"yyyyMMdd"];
    NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSLog(@"date====%@",[format1 stringFromDate:[NSDate date]]);
    int begin=16;
    for (int i=0; i<count; i++) {
        SportsData_U sport_data;
        sport_data.data=((uint64_t)bytes1[begin+(1+(i*8))]<<56)+((uint64_t)bytes1[begin+(2+(i*8))]<<48)+((uint64_t)bytes1[begin+(3+(i*8))]<<40)+((uint64_t)bytes1[begin+(4+(i*8))]<<32)+((uint64_t)bytes1[begin+(5+(i*8))]<<24)+((uint64_t)bytes1[begin+(6+(i*8))]<<16)+((uint64_t)bytes1[begin+(7+(i*8))]<<8)+((uint64_t)bytes1[begin+(8+(i*8))]<<0);
        
        int temp=sport_head.Date.date.month;
        NSString *month=[NSString stringWithFormat:@"%d",temp];
        if(temp<10)
            month=[NSString stringWithFormat:@"%@%@",@"0",month];
        int temp1=sport_head.Date.date.day;
        NSString *day=[NSString stringWithFormat:@"%d",temp1];
        if(temp1<10)
            day=[NSString stringWithFormat:@"%@%@",@"0",day];
        
        
        SmaSportInfo *info=[[SmaSportInfo alloc]init];
        NSString *sleep_date=[NSString stringWithFormat:@"%@%d%@%@",@"20",sport_head.Date.date.year,month,day];
        NSDate *accurateDate = [NSDate dateWithTimeInterval:sport_data.bits.offset*15/1440 * 24*3600 sinceDate:[dateFor dateFromString:sleep_date]];
        NSString *sleep_da = [dateFor stringFromDate:accurateDate];
        info.user_id=user.userId;
        
        info.sport_data=sleep_da;
        //        info.sport_time=[NSNumber numberWithInt:sport_data.bits.offset];
        info.sport_step=[NSNumber numberWithFloat:sport_data.bits.steps];
        info.sport_calory=[NSNumber numberWithFloat:sport_data.bits.Calory];
        info.sport_distance=[NSNumber numberWithFloat:sport_data.bits.Distance];
        info.sport_time=[NSNumber numberWithFloat:[NSString stringWithFormat:@"%d",sport_data.bits.offset-96>0? sport_data.bits.offset-96*(sport_data.bits.offset*15/1440) : sport_data.bits.offset].floatValue];
        //         info.sport_id = [NSString stringWithFormat:@"%@%@",info.sport_data,info.sport_time];
        
        info.sport_activetime=[NSNumber numberWithFloat:sport_data.bits.active_time];
        info.sport_web = @0;
        info.sport_id = [NSString stringWithFormat:@"%@%@",info.sport_data,info.sport_time];
        MyLog(@"第%d条数据________步数:%@--卡路里：%@－－里程：%@  %d info.sport_id==%@",i,[NSString stringWithFormat:@"%d",[info.sport_step intValue]],[NSString stringWithFormat:@"%d",[info.sport_calory intValue]]
              ,[NSString stringWithFormat:@"%d",[info.sport_distance intValue]],info.sport_time.intValue,info.sport_id);
        
        [infos addObject:info];
    }
    if(infos.count>0)
    {
        MyLog(@"有运动数据");
        
        
        [self.smaDal insertSmaSport:infos];
        
        if ([self.delegate respondsToSelector:@selector(NotificationSportRefresh)])
        {
            [self.delegate NotificationSportRefresh];
        }
        
    }else
    {
        MyLog(@"无运动数据");
    }
    
    //    if ([self.delegate respondsToSelector:@selector(getRequestData:)]) {
    //        [self.delegate getRequestData:@"确实调用了"];
    //    }
}

#pragma mark ---------历史运动数据解释

- (void)analysisHisAct:(Byte *)bytes len:(int)len{
    
}


//－－－－－－－－－－－－－解析睡眠数据ok
-(void)analysisSleepData:(Byte *)bytes1 len:(int)len
{
    NSMutableArray *infos=[NSMutableArray array];
    NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyyMMddHHmmssSSS"];
    SleepHead_t sleep_head;
    sleep_head.Date.data=((uint16_t)bytes1[13]<<8)+((uint16_t)bytes1[14]<<0);
    //    NSLog(@"运动数据时间：%d%d%d",data_file.date.year,data_file.date.month,data_file.date.day);
    sleep_head.length=((uint16_t)bytes1[15]<<8)+((uint16_t)bytes1[16]<<0);
    int count=sleep_head.length;
    int begin=16;
    SmaUserInfo *user= [SmaAccountTool userInfo];
    for (int i=0; i<count; i++) {
        SleepData_U sleep_data;
        sleep_data.data=((uint32_t)bytes1[begin+(1+(i*4))]<<24)+((uint32_t)bytes1[begin+(2+(i*4))]<<16)+((uint32_t)bytes1[begin+(3+(i*4))]<<8)+((uint32_t)bytes1[begin+(4+(i*4))]<<0);
        
        SmaSleepInfo *info=[[SmaSleepInfo alloc]init];
        
        int temp=sleep_head.Date.date.month;
        NSString *month=[NSString stringWithFormat:@"%d",temp];
        if(temp<10)
            month=[NSString stringWithFormat:@"%@%@",@"0",month];
        
        
        int temp1=sleep_head.Date.date.day;
        NSString *day=[NSString stringWithFormat:@"%d",temp1];
        if(temp1<10)
            day=[NSString stringWithFormat:@"%@%@",@"0",day];
        
        int slee_da = [[NSString stringWithFormat:@"%@%d%@%@",@"20",sleep_head.Date.date.year,month,day] intValue];
        info.sleep_id = [format1 stringFromDate:[NSDate date]];
        info.sleep_data=[NSNumber numberWithInt:slee_da];
        info.sleep_softly = [NSNumber numberWithInt:sleep_data.bits.softly_action];
        info.sleep_strong = [NSNumber numberWithInt:sleep_data.bits.strong_action];
        info.sleep_mode=[NSNumber numberWithInt:sleep_data.bits.mode];
        info.sleep_time=[NSString stringWithFormat:@"%d",sleep_data.bits.timeStamp];
        info.sleep_type=@0;
        info.sleep_wear = @1;
        info.sleep_web = @0;
        info.user_id=user.userId;
        [infos addObject:info];
    }
    if(infos.count>0)
    {
        MyLog(@"有睡眠数据");
        [self.smaDal insertSleepInfo:infos];
        if ([self.delegate respondsToSelector:@selector(NotificationSleepData)]) {
            [self.delegate NotificationSleepData];
        }
    }else
    {
        MyLog(@"无睡眠数据");
    }
}



//－－－－－－－－－－－－－－－睡眠设定解析
-(void)analysisSetSleepData:(Byte *)bytes1 len:(int)len
{
    
    NSMutableArray *infos=[NSMutableArray array];
    NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyyMMddHHmmssSSS"];
    SmaUserInfo *user= [SmaAccountTool userInfo];
    SleepHead_t sleep_head;
    sleep_head.Date.data=((uint16_t)bytes1[13]<<8)+((uint16_t)bytes1[14]<<0);
    
    sleep_head.length=((uint16_t)bytes1[15]<<8)+((uint16_t)bytes1[16]<<0);
    int count=sleep_head.length;
    int begin=16;
    for (int i=0; i<count; i++) {
        SleepData_U sleep_data;
        sleep_data.data=((uint32_t)bytes1[begin+(1+(i*4))]<<24)+((uint32_t)bytes1[begin+(2+(i*4))]<<16)+((uint32_t)bytes1[begin+(3+(i*4))]<<8)+((uint32_t)bytes1[begin+(4+(i*4))]<<0);
        
        //睡眠数据
        int temp=sleep_head.Date.date.month;
        NSString *month=[NSString stringWithFormat:@"%d",temp];
        if(temp<10)
            month=[NSString stringWithFormat:@"%@%@",@"0",month];
        
        int temp1=sleep_head.Date.date.day;
        NSString *day=[NSString stringWithFormat:@"%d",temp1];
        if(temp1<10)
            day=[NSString stringWithFormat:@"%@%@",@"0",day];
        SmaSleepInfo *info=[[SmaSleepInfo alloc]init];
        info.sleep_id = [format1 stringFromDate:[NSDate date]];
        info.sleep_data=[NSString stringWithFormat:@"%@%d%@%@",@"20",sleep_head.Date.date.year,month,day];
        info.sleep_mode=[NSNumber numberWithInt:sleep_data.bits.mode];
        info.sleep_time=[NSString stringWithFormat:@"%d",sleep_data.bits.timeStamp];
        info.user_id=user.userId;
        info.sleep_type=@1;
        info.sleep_wear = @1;
        info.sleep_web = @0;
        [infos addObject:info];
        NSLog(@"----sleep_id**%@  sleep_data** %@   %@",info.sleep_id,info.sleep_data,info.sleep_time);
    }
    if(infos.count>0)
    {
        MyLog(@"有睡眠设定数据");
        [self.smaDal insertSleepInfo:infos];
        
        if ([self.delegate respondsToSelector:@selector(NotificationSleepData)]) {
            [self.delegate NotificationSleepData];
        }
        
    }else
    {
        MyLog(@"无睡眠设定数据");
    }
    
}
/*******************数据解析  end *******************/



/*******************蓝牙命令发送与请求   being*******************/
-(void)bindBloacUserID:(NSString *)userID characteristic:(CBCharacteristic *)characteristic ident:(int)ident
{
    username_union_t username_id;
    username_id.bit_field.userId =[userID intValue];
    
    Byte buf[32];
    buf[0] = username_id.data>>24;
    buf[1] = username_id.data>>16;
    buf[2] = username_id.data>>8;
    buf[3] = username_id.data>>0;
    for (int i=4; i<32; i++) {
        buf[i]=0x00;
    }
    Byte results[45];
    if(ident==0)
    {
        [SmaBusinessTool getSpliceCmd:0x03 Key:0x01 bytes1:buf len:32 results:results];//绑定
    }else
    {
        [SmaBusinessTool getSpliceCmd:0x03 Key:0x03 bytes1:buf len:32 results:results];//登陆
    }
    Byte but0[20];
    int j=0;
    for (int i=0; i<20; i++) {
        but0[i]=results[i];
        j++;
    }
    
    NSData * data0 = [NSData dataWithBytes:but0 length:20];
    [self.peripheral writeValue:data0 forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    
    Byte but1[20];
    for (int i=0; i<20; i++) {
        but1[i]=results[j];
        j++;
        
    }
    NSData * data1 = [NSData dataWithBytes:but1 length:20];
    [self.peripheral writeValue:data1 forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    
    Byte but2[5];
    for (int i=0; i<5; i++) {
        but2[i]=results[j];
        j++;
        
    }
    NSData * data2 = [NSData dataWithBytes:but2 length:5];
    [self.peripheral writeValue:data2 forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    
}

//解除绑定
-(void)relieveWatchBound
{
    Byte results[14];
    [SmaBusinessTool getSpliceCmdBand:0x03 Key:0x05 bytes1:nil len:0 results:results];//解除绑定
    NSData * data1 = [NSData dataWithBytes:results length:20];
    if(self.peripheral && self.characteristicWrite)
    {
        [self.peripheral writeValue:data1 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
    }
    
}

- (void)setAppSportData{
    sport_data soprt_da;
    step_data step_da;
    soprt_da.stort_data.calor = [SmaUserDefaults stringForKey:@"KCAL"].intValue;
    soprt_da.stort_data.distance = [SmaUserDefaults stringForKey:@"KM"].floatValue*1000;
    step_da.St_data.step = [SmaUserDefaults stringForKey:@"STEP"].intValue;
    Byte buf [12];
    buf[0] = step_da.data >> 24;
    buf[1] = step_da.data >> 16;
    buf[2] = step_da.data >> 8;
    buf[3] = step_da.data >> 0;
    buf[4] = soprt_da.data >> 56;
    buf[5] = soprt_da.data >> 48;
    buf[6] = soprt_da.data >> 40;
    buf[7] = soprt_da.data >> 32;
    buf[8] = soprt_da.data >> 24;
    buf[9] = soprt_da.data >> 16;
    buf[10] = soprt_da.data >> 8;
    buf[11] = soprt_da.data >> 0;
    Byte results[25];
    [SmaBusinessTool getSpliceCmd:0x05 Key:0x09 bytes1:buf len:12 results:results];
    
    Byte buf0[20];
    memcpy(&buf0, &results[0], 20);
    Byte buf1[5];
    memcpy(&buf1, &results[20], 5);
    NSData *data0 = [NSData dataWithBytes:buf0 length:20];
    NSData *data1 = [NSData dataWithBytes:buf1 length:5];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
    [self.peripheral writeValue:data1 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
    
}

//设置系统时间
-(void)setSystemTime{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    usercdata_union_t user_data;
    user_data.bit_field.second = [dateComponent second];
    user_data.bit_field.minute =  [dateComponent minute];
    user_data.bit_field.hour  = [dateComponent hour];
    user_data.bit_field.day =  [dateComponent day];
    user_data.bit_field.Month = [dateComponent month];
    user_data.bit_field.Year = [dateComponent year]%2000;
    
    
    Byte buf[4];
    buf[0] = user_data.data>>24;
    buf[1] = user_data.data>>16;
    buf[2] = user_data.data>>8;
    buf[3] = user_data.data>>0;
    
    Byte results[17];
    [SmaBusinessTool getSpliceCmd:0x02 Key:0x01 bytes1:buf len:4 results:results];//绑定
    
    NSData * data0 = [NSData dataWithBytes:results length:17];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
}

//是否打开同步数据
-(void)setSynchState:(BOOL)isOpen
{
    Byte results[14];
    Byte buf[1];
    if(isOpen)
        buf[0]=0x01;
    else
        buf[0]=0x00;
    
    [SmaBusinessTool getSpliceCmd:0x02 Key:0x01 bytes1:buf len:1 results:results];//设置是否同步
    
}
//33
-(void)setInteractone33
{
    Byte results[13];
    [SmaBusinessTool getSpliceCmd:0x04 Key:0x31 bytes1:nil len:0 results:results];//交互一
    NSData * data0 = [NSData dataWithBytes:results length:13];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
}
//31
-(void)setInteractone31
{
    Byte results[13];
    [SmaBusinessTool getSpliceCmd:0x04 Key:0x30 bytes1:nil len:0 results:results];//交互一
    NSData * data0 = [NSData dataWithBytes:results length:13];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
}
//32
-(void)setInteractone
{
    Byte results[13];
    [SmaBusinessTool getSpliceCmd:0x04 Key:0x20 bytes1:nil len:0 results:results];//交互一
    NSData * data0 = [NSData dataWithBytes:results length:13];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
}
//33
-(void)setInteracttwo
{
    Byte results[13];
    [SmaBusinessTool getSpliceCmd:0x04 Key:0x21 bytes1:nil len:0 results:results];//交互二
    NSData * data0 = [NSData dataWithBytes:results length:13];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];}

//打开关闭同步
-(void)openSyncdata:(BOOL)bol
{
    Byte buf[1];
    if(bol)
        buf[0]=0x01;
    else
        buf[0]=0x00;
    
    Byte results[14];
    if(self.peripheral && self.characteristicWrite)
    {
        [SmaBusinessTool getSpliceCmd:0x05 Key:0x06 bytes1:buf len:1 results:results];//关闭同步
        NSData * data0 = [NSData dataWithBytes:results length:14];
        [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
    }
    //    Byte results[13];
    //    [SmaBusinessTool getSpliceCmd:0x05 Key:0x00 bytes1:nil len:0 results:results];//关闭同步
    //    results[0]= 0xAB;
    //    results[1]= 0x00;
    //    results[2]= 0x00;
    //    results[3]= 0x05;
    //    results[4]= 0xC0;
    //    results[5]= 0x9D;
    //    results[6]= 0x00;
    //    results[7]= 0x15;
    //    results[8]= 0x05;
    //    results[9]= 0x00;
    //    results[10]= 0x01;
    //    results[12]= 0x00;
    //
    //    NSData * data0 = [NSData dataWithBytes:results length:13];
    //    [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
}
//手机来电
-(void)setphonespark
{
    NSInteger myTelInteger = [SmaUserDefaults integerForKey:@"myTelRemindInt"];
    if(myTelInteger && myTelInteger!=0)//开启发防丢
    {
        if(self.peripheral && self.characteristicWrite)
        {
            Byte results[13];
            [SmaBusinessTool getSpliceCmd:0x04 Key:0x01 bytes1:nil len:0 results:results];//来电提醒
            NSData * data0 = [NSData dataWithBytes:results length:13];
            [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
        }
    }
    
}
//SM04手机来电
-(void)setphonespark: (BOOL)bol
{
    if(self.peripheral && self.characteristicWrite)
    {
        Byte buf[1];
        if(bol)
            buf[0]=0x01;
        else
            buf[0]=0x00;
        
        Byte results[14];
        [SmaBusinessTool getSpliceCmd:0x02 Key:0x26 bytes1:buf len:1 results:results];//来电提醒
        NSData * data0 = [NSData dataWithBytes:results length:14];
        [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
    }
    
}
//手机短信
-(void)setSmsPhonespark
{
    Byte results[13];
    [SmaBusinessTool getSpliceCmd:0x04 Key:0x04 bytes1:nil len:0 results:results];//短信提醒
    NSData * data0 = [NSData dataWithBytes:results length:13];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
}

//SM04短信
-(void)setSmsPhonespark: (BOOL)bol
{
    Byte buf[1];
    if(bol)
        buf[0]=0x01;
    else
        buf[0]=0x00;
    Byte results[14];
    [SmaBusinessTool getSpliceCmd:0x02 Key:0x27 bytes1:buf len:1 results:results];//短信提醒
    NSData * data0 = [NSData dataWithBytes:results length:14];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
}

//设置闹钟
-(void)setCalarmClockInfo:(NSMutableArray *)smaACs
{
    
    int counts=smaACs.count;
    int rscount=13+(counts*5);
    
    Byte results1[rscount];
    Byte buf[5*counts];
    
    for (int i=0; i<counts; i++) {
        SmaAlarmInfo *smaAcInfo=smaACs[i];
        alarm_union_t clock_data;
        NSArray *array = [smaAcInfo.dayFlags componentsSeparatedByString:@","];
        burntheplanks_week_union_t week_t1;
        week_t1.bit_week.monday=([array[0] isEqualToString:@"0"])?0x00:0x01;
        week_t1.bit_week.tuesday=([array[1] isEqualToString:@"0"])?0x00:0x01;
        week_t1.bit_week.wednesday=([array[2] isEqualToString:@"0"])?0x00:0x01;
        week_t1.bit_week.thursday=([array[3] isEqualToString:@"0"])?0x00:0x01;
        week_t1.bit_week.friday=([array[4] isEqualToString:@"0"])?0x00:0x01;
        week_t1.bit_week.saturday=([array[5] isEqualToString:@"0"])?0x00:0x01;
        week_t1.bit_week.sunday=([array[6] isEqualToString:@"0"])?0x00:0x01;
        
        clock_data.alarm.day_repeat_flag =week_t1.week;
        //clock_data.alarm.reserved = 52;
        clock_data.alarm.id=[smaAcInfo.aid intValue];
        clock_data.alarm.minute =[smaAcInfo.minute intValue];
        clock_data.alarm.hour = [smaAcInfo.hour intValue];
        clock_data.alarm.day = [smaAcInfo.day intValue];
        clock_data.alarm.month=[smaAcInfo.mounth intValue];
        clock_data.alarm.year=[smaAcInfo.year intValue]%100;
        
        buf[0+(5*i)] = clock_data.data>>32;
        buf[1+(5*i)] = clock_data.data>>24;
        buf[2+(5*i)] = clock_data.data>>16;
        buf[3+(5*i)] = clock_data.data>>8;
        buf[4+(5*i)] = clock_data.data>>0;
    }
    
    [SmaBusinessTool getSpliceCmd:0x02 Key:0x02 bytes1:buf len:(5*counts) results:results1];//绑定
    MyLog(@"发送闹钟成功");
    
    if(self.peripheral && self.characteristicWrite)
    {
        int degree=rscount/20;
        int surplus=rscount%20;
        if(surplus>0)
            degree=degree+1;
        
        for (int i=0; i<degree; i++) {
            int alen=(((degree-1)==i)?surplus:20);
            Byte arr[alen];
            
            memcpy(&arr,&results1[0+(20*i)],alen);//拷贝到对应的Byte 数组中
            
            NSData * data0 = [NSData dataWithBytes:arr length:(((degree-1)==i)?surplus:20)];
            [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
            
        }
        NSLog(@"设置成功");
        //    /* 监听蓝牙返回的情况 */
        [self.peripheral readValueForCharacteristic:self.characteristicRead];
        [self.peripheral setNotifyValue:YES forCharacteristic:self.characteristicRead];
    }
}
/**
 *  <#Description#> 获取闹钟列表闹钟  请求闹钟列表
 */
-(void)getCalarmClockList
{
    
    //Byte buf[0];
    Byte results[13];
    [SmaBusinessTool getSpliceCmd:0x02 Key:0x03 bytes1:nil len:0 results:results];//绑定
    
    if(self.peripheral && self.characteristicWrite)
    {
        NSLog(@"这里");
        receive_state=0;
        NSData * data0 = [NSData dataWithBytes:results length:13];
        [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
    }
    
}

/*请求运动数据*/
-(void)requestExerciseData
{
    Byte results[13];
    if(self.peripheral && self.characteristicRead)
    {
        [SmaBusinessTool getSpliceCmd:0x05 Key:0x01 bytes1:nil len:0 results:results];//设定用户信息
        NSData * data0 = [NSData dataWithBytes:results length:13];
        [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
    }
}
/*关闭数据同步*/
-(void)closeDataSync
{
    Byte results[13];
    Byte buf[1];
    buf[0]=0x00;
    if(self.peripheral && self.characteristicRead)
    {
        [SmaBusinessTool getSpliceCmd:0x05 Key:0x06 bytes1:buf len:1 results:results];//设定用户信息
        NSData * data0 = [NSData dataWithBytes:results length:14];
        [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
    }
}
/*开启数据同步*/
-(void)openDataSync
{
    Byte results[13];
    Byte buf[1];
    buf[0]=0x01;
    if(self.peripheral && self.characteristicWrite)
    {
        [SmaBusinessTool getSpliceCmd:0x05 Key:0x06 bytes1:buf len:1 results:results];//设定用户信息
        NSData * data0 = [NSData dataWithBytes:results length:14];
        [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
    }
}
/**
 *   打开防止丢失
 */
-(void)openDefendLose
{
    defendlose_union_t defendlose_t;
    defendlose_t.bit_fieldreserve.mode = 2;
    defendlose_t.bit_fieldreserve.reserve=0;
    Byte buf[1];
    buf[0] = defendlose_t.data	;
    Byte results[14];
    [SmaBusinessTool getSpliceCmd:0x02 Key:0x20 bytes1:buf len:1 results:results];
    
    NSData * data0 = [NSData dataWithBytes:results length:14];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
}
/**
 *  关闭防止丢失
 */
-(void)closeDefendLose
{
    defendlose_union_t defendlose_t;
    defendlose_t.bit_fieldreserve.mode = 0;
    defendlose_t.bit_fieldreserve.reserve=0;
    
    Byte buf[2];
    buf[0] = defendlose_t.data;
    Byte results[14];
    [SmaBusinessTool getSpliceCmd:0x02 Key:0x20 bytes1:buf len:1 results:results];
    
    NSData * data0 = [NSData dataWithBytes:results length:14];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
}

/**
 *  <#Description#> 久坐提醒
 */
-(void)seatLongTimeInfo:(SmaSeatInfo *)info
{
    NSArray *array = [info.pepeatWeek componentsSeparatedByString:@","];
    
    burntheplanks_week_union_t week_t1;
    week_t1.bit_week.monday=([array[0] isEqualToString:@"0"])?0x00:0x01;
    week_t1.bit_week.tuesday=([array[1] isEqualToString:@"0"])?0x00:0x01;
    week_t1.bit_week.wednesday=([array[2] isEqualToString:@"0"])?0x00:0x01;
    week_t1.bit_week.thursday=([array[3] isEqualToString:@"0"])?0x00:0x01;
    week_t1.bit_week.friday=([array[4] isEqualToString:@"0"])?0x00:0x01;
    week_t1.bit_week.saturday=([array[5] isEqualToString:@"0"])?0x00:0x01;
    week_t1.bit_week.sunday=([array[6] isEqualToString:@"0"])?0x00:0x01;
    
    
    burntheplanks_union_t burnthe_t;
    burnthe_t.bit_plank.dayflags = week_t1.week;
    burnthe_t.bit_plank.endtime =[info.endTime intValue];
    burnthe_t.bit_plank.begintime = [info.beginTime intValue];
    burnthe_t.bit_plank.whenminute = [info.seatValue intValue];
    burnthe_t.bit_plank.enable=1;
    burnthe_t.bit_plank.thresholdvalue = 30;//[info.seatValue intValue];
    Byte buf1[8];
    buf1[0] = burnthe_t.data>>56;
    buf1[1] = burnthe_t.data>>48;
    buf1[2] = burnthe_t.data>>40;
    buf1[3] = burnthe_t.data>>32;
    buf1[4] = burnthe_t.data>>24;
    buf1[5] = burnthe_t.data>>16;
    buf1[6] = burnthe_t.data>>8;
    buf1[7] = burnthe_t.data>>0;
    //    Byte buf2[1];
    //    buf2[0] = burnthe_t.data>>0;
    Byte results[21];
    [SmaBusinessTool getSpliceCmd:0x02 Key:0x21 bytes1:buf1 len:8 results:results];//久坐设置
    int degree=21/20;
    int surplus=21%20;
    if(surplus>0)
        degree=degree+1;
    Byte byt[21];
    if(self.characteristicWrite && self.peripheral && self.mgr)
    {
        for (int i=0; i<degree; i++) {
            int alen=(((degree-1)==i)?surplus:20);
            Byte arr[alen];
            
            memcpy(&arr,&results[0+(20*i)],alen);//拷贝到对应的Byte 数组中
            
            NSData * data0 = [NSData dataWithBytes:arr length:(((degree-1)==i)?surplus:20)];
            
            [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
            
        }
        [SmaAccountTool saveSeat:info];
    }else
    {
        [MBProgressHUD showError:SmaLocalizedString(@"bt_searching")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        
    }
    
    //    for (int i=0; i<2; i++) {
    //         if(i==0)
    //         {
    //             Byte results[20];
    //             [SmaBusinessTool getSpliceCmd:0x02 Key:0x21 bytes1:buf1 len:8 results:results];//久坐设置
    //             NSData * data01 = [NSData dataWithBytes:results length:20];
    //
    //             [self.peripheral writeValue:data01 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
    //         }else
    //         {
    //             NSData * data01 = [NSData dataWithBytes:buf2 length:1];
    //             [self.peripheral writeValue:data01 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
    //         }
    //    }
}
//关闭久坐
-(void)closeLongTimeInfo
{
    Byte buf[8];
    buf[0] = 0x00;
    buf[1] = 0x00;
    buf[2] = 0x00;
    buf[3] = 0x00;
    buf[4] = 0x00;
    buf[5] = 0x00;
    buf[6] = 0x00;
    buf[7] = 0x00;
    
    Byte buf2[1];
    buf2[0] = 0x00;
    
    if(SmaBleMgr.mgr && SmaBleMgr.peripheral && self.characteristicWrite)
    {
        Byte results[21];
        [SmaBusinessTool getSpliceCmd1:0x02 Key:0x21 bytes1:buf len:8 results:results];//久坐设置
        Byte arr1[20];
        memcpy(&arr1,&results[0],20);
        NSData * data01 = [NSData dataWithBytes:arr1 length:20];
        [self.peripheral writeValue:data01 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
        Byte arr2[1];
        memcpy(&arr2,&results[20],1);
        
        NSData * data02 = [NSData dataWithBytes:arr2 length:1];
        [self.peripheral writeValue:data02 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
    }
    
    //    [SmaBusinessTool getSpliceCmd:0x02 Key:0x21 bytes1:buf len:8 results:results];//久坐设置
    //    NSData * data0 = [NSData dataWithBytes:results length:21];
    //    [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
}
-(void)setOTAstate
{
    Byte buf[13];
    buf[0] = 0xAB;
    buf[1] = 0x00;
    buf[2] = 0x00;
    buf[3] = 0x05;
    buf[4] = 0x00;
    buf[5] = 0x6C;
    buf[6] = 0x00;
    buf[7] = 0x00;
    buf[8] = 0x01;
    buf[9] = 0x00;
    buf[10] = 0x01;
    buf[11] = 0x00;
    buf[12] = 0x00;
    //    if (!smaTabVc) {
    //        smaTabVc = [[SmaTabBarViewController alloc]init];
    //    }
    NSLog(@"暂停定时器");
    //创建通知
    //    if (!notification) {
    notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //    }
    
    MyLog(@"准备进入OTA模式");
    if(self.peripheral && self.characteristicWrite)
    {
        MyLog(@"开始进入OTA模式");
        SmaUserInfo *user= [SmaAccountTool userInfo];
        user.watchName=@"DfuTarg";
        [SmaAccountTool saveUser:user];
        NSData * data01 = [NSData dataWithBytes:buf length:13];
        [self.peripheral writeValue:data01 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MyLog(@"开始进入OTA模式___________ %llu",DISPATCH_TIME_NOW);
            
            self.OTA = YES;
            //            [self oneScanBand:YES];
            
        });
    }
    
    
    
}
/**
 *  <#Description#> 设置用户信息
 */
-(void)setUserMnerberInfo:(SmaUserInfo *)info
{
    userprofile_union_t user_info;
    user_info.bit_field.reserved = 0;
    user_info.bit_field.weight =[info.weight intValue]*2;
    user_info.bit_field.hight = [info.height intValue]*2;
    user_info.bit_field.age = 0;
    user_info.bit_field.gender =[info.sex intValue];
    Byte buf[4];
    buf[0] = user_info.data>>24;
    buf[1] = user_info.data>>16;
    buf[2] = user_info.data>>8;
    buf[3] = user_info.data>>0;
    Byte results[17];
    [SmaBusinessTool getSpliceCmd:0x02 Key:0x10 bytes1:buf len:4 results:results];
    NSData * data0 = [NSData dataWithBytes:results length:17];
    if (self.peripheral) {
        [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
    }
    
}

/**
 *  <#Description#> 设置记步目标
 */
-(void)setStepNumber:(int)count
{
    stepnumber_union_t stepnumber;
    stepnumber.step_number.stepnumber =count;
    
    Byte buf[4];
    buf[0] = stepnumber.data>>24;
    buf[1] = stepnumber.data>>16;
    buf[2] = stepnumber.data>>8;
    buf[3] = stepnumber.data>>0;
    
    Byte results[17];
    
    [SmaBusinessTool getSpliceCmd:0x02 Key:0x05 bytes1:buf len:4 results:results];
    NSData * data0 = [NSData dataWithBytes:results length:17];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
}

//查看蓝牙状态
-(BOOL)checkBleStatus
{
    SmaUserInfo *info= [SmaAccountTool userInfo];
    if([info.watchName isEqual:@""] || [info.watchUID isEqual:@""] || info.watchName==nil || info.watchUID==nil)
    {
        //MBProgressHUD *hud=[[MBProgressHUD alloc]init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:SmaLocalizedString(@"alert_nobangswm")];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return false;
    }else if(SmaBleMgr.peripheral && SmaBleMgr.peripheral.state!=CBPeripheralStateConnected)
    {
        if (SmaBleMgr.firstBind != NO) {
            SmaBleMgr.firstBind = NO;
        }
        else{
            //             [MBProgressHUD showMessage:@"蓝牙设备已断开，正在扫描设备"];
        }
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [MBProgressHUD hideHUD];
        //        });
        [self oneScanBand:NO];
        return false;
    }
    return true;
}

-(void)backKvaudio
{
    //        MyLog(@"后台运行");
    //        AVAudioSession *session = [AVAudioSession sharedInstance];
    //        [session setActive:YES error:nil];
    //        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //
    //        //让app支持接受远程控制事件
    //        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //
    //        //播放背景音乐
    //        NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"mp3"];
    //        NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    //
    //        //创建播放器
    //        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //        [player prepareToPlay];
    //        [player setVolume:1];
    //        player.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    //        [player play]; //播放
}

//从UUID中寻找服务
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil; //Service not found on this peripheral
}

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
}

//从UUID中寻找特定设备
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}
/****************** 蓝牙命令发送与请求   being******************/

/****************** 数据结构体 begin ************/


/* 防丢 begin */

typedef struct
{
    uint8_t mode   :
    5;
    uint8_t reserve     :
    4;
}
defendlose_bit_field_type_t;

typedef union {
    uint8_t data;
    defendlose_bit_field_type_t bit_fieldreserve;
} defendlose_union_t;

/*防丢信息结束 begin*/

/*久坐设置 begin*/
typedef struct
{
    uint64_t dayflags     :
    8;
    uint64_t endtime     :
    8;
    uint64_t begintime     :
    8;
    uint64_t whenminute     :
    8;
    uint64_t  thresholdvalue     :
    16;
    uint64_t enable    :
    8;
    uint64_t  reserve     :
    8;
}
burntheplanks_bit_field_type_t;

typedef union {
    uint64_t data;
    burntheplanks_bit_field_type_t bit_plank;
} burntheplanks_union_t;

typedef struct
{
    uint8_t monday     :
    1;
    uint8_t  tuesday     :
    1;
    uint8_t  wednesday      :
    1;
    uint8_t thursday      :
    1;
    uint8_t  friday     :
    1;
    uint8_t saturday    :
    1;
    uint8_t  sunday     :
    1;
    uint8_t  reserve     :
    1;
    
}burntheplanks_pepeat_week_t;

typedef union {
    uint8_t week;
    burntheplanks_pepeat_week_t bit_week;
} burntheplanks_week_union_t;

/*久坐设置 begin*/


/*结构体  begin*/
typedef uint32_t DateType;
/* time bit field */
typedef struct
{
    uint16_t day   :
    5;
    uint16_t month  :
    4;
    uint16_t year   :
    6;
    uint16_t reserved   :
    1;
}
Date_bit_field_type_t;

typedef union
{
    uint16_t data;
    Date_bit_field_type_t date;
} Date_union_t;


typedef struct SportsHead
{
    uint8_t key;
    uint8_t length;
    Date_union_t Date;
}
SportsHead_t;

typedef struct SleepHead
{
    Date_union_t Date;
    uint16_t length;
}
SleepHead_t;

typedef struct
{
    uint64_t Distance  :
    16;
    uint64_t Calory   :
    19;
    uint64_t active_time :
    4;
    uint64_t steps   :
    12;
    uint64_t mode   :
    2;
    uint64_t offset   :
    11;
}
SportsData_bit_field_type_t;

typedef union SportsData {
    uint64_t data;
    SportsData_bit_field_type_t bits;
} SportsData_U;

typedef struct
{
    uint32_t mode   :
    4;
    uint32_t sleeping_flag :
    1;
    uint32_t strong_action  :
    5;
    uint32_t softly_action  :
    6;
    uint32_t timeStamp  :
    16;
}
SleepData_bit_field_type_t;

typedef union SleepDataU {
    uint32_t data;
    SleepData_bit_field_type_t bits;
} SleepData_U;

//APP数据同步手表
typedef struct
{
    uint64_t calor : 32;
    uint64_t distance : 32;
    
}appSportData;

typedef union{
    uint64_t data;
    appSportData stort_data;
}sport_data;

typedef struct
{
    uint32_t step : 32;
}appStepData;

typedef union{
    uint32_t data;
    appStepData St_data;
}step_data;
/*运动数据结束 end*/

/*用户ID begin*/
typedef struct
{
    uint32_t userId   :
    32; /*秒*/
}
username_bit_field_type_t;

typedef union {
    uint32_t data;
    username_bit_field_type_t bit_field;
} username_union_t;
/*用户ID begin*/

/*系统时间结构 begin*/
typedef struct
{
    uint32_t second   :
    6; /*秒*/
    uint32_t minute     :
    6; /*分*/
    uint32_t hour      :
    5;  /*时*/
    uint32_t day     :
    5;  /*日*/
    uint32_t Month     :
    4;  /*月*/
    uint32_t Year     :
    6;  /*年*/
}
userdatatime_bit_field_type_t;

typedef union {
    uint32_t data;
    userdatatime_bit_field_type_t bit_field;
} usercdata_union_t;
/*系统时间结构 end*/
/*闹钟结构体 begin*/
typedef struct
{
    uint64_t day_repeat_flag    :
    7;
    uint64_t reserved   :
    4;
    uint64_t id     :
    3;
    uint64_t minute     :
    6;
    uint64_t hour       :
    5;
    uint64_t day            :
    5;
    uint64_t month      :
    4;
    uint64_t year           :
    6;
}
alarm_clock_bit_field_type_t;

typedef union {
    uint64_t data;
    alarm_clock_bit_field_type_t alarm;
} alarm_union_t;



/*闹钟结构体  end*/

/*用户信息开始 begin*/

typedef struct
{
    uint32_t reserved   :
    5;
    uint32_t weight     :
    10; /** accuracy: 0.5 kg, */
    uint32_t hight      :
    9;  /** hight accuracy : 0.5 m */
    uint32_t age        :
    7;  /**age 0~127*/
    uint32_t gender     :
    1;  /**0: female, 1: male*/
}
userprofile_bit_field_type_t;


typedef union {
    uint32_t data;
    userprofile_bit_field_type_t bit_field;
} userprofile_union_t;
/*用户信息开始 end*/
/*记步目标 begin*/
typedef struct
{
    uint32_t stepnumber   :
    32; /*秒*/
}
stepnumber_bit_field_type_t;

typedef union {
    uint32_t data;
    stepnumber_bit_field_type_t step_number;
} stepnumber_union_t;
/*记步目标 begin*/



/****************** 结构体 begin ************/




@end

