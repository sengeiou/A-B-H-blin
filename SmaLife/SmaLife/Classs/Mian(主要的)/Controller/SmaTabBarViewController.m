//
//  SmaTabBarViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/3.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaTabBarViewController.h"
#import "SmaMeMainViewController.h"
#import "SmaSleepMainViewController.h"
#import "SmaRemindMainViewController.h"
#import "SmaSportMainViewController.h"
#import "SmaNavigationController.h"
#import "SmaTabBar.h"
#import "BROptionsButton.h"
#import "SmaLoverViewController.h"
#import "SmaSportViewController.h"
#import "CHAnimation.h"//动画
#import "SCNavigationController.h"
#import "SmaLoverViewController.h"
#import "SmaSleepViewController.h"
#import "HYActivityView.h"
#import "SmaSportInfo.h"
#import "SmaDataDAL.h"
#import "AppDelegate.h"
#define CHPpopUpMenuItemSize 60   //   按钮的高度和宽度
#define DateFormatter @ "yyyyMMdd"

@interface SmaTabBarViewController ()<SetSamCoreBlueToolDelegate,SmaTabBarDelegate>
//1.我的
@property (nonatomic, strong) SmaMeMainViewController *smaMe;
//2.睡眠
@property (nonatomic, strong) SmaSleepViewController *smaSleep;
//3.提醒
@property (nonatomic, strong) SmaRemindMainViewController *smaRemind;
//4.运动
@property (nonatomic, strong) SmaSportMainViewController *smaSport1;
//4.运动
@property (nonatomic, strong) SmaSportMainViewController *smaSport;
//5.自定义Tabbar
@property (nonatomic, weak) SmaTabBar *customTabBar;

@property (nonatomic, strong) BROptionsButton *brOptionsButton;
@property (nonatomic, weak) UIView *customview;

@property (nonatomic,strong) NSMutableArray *controllerArray;

//存放其他按钮
@property (nonatomic,strong) NSMutableArray *btnArrays;
//展开状态
@property (nonatomic,strong) NSNumber *isOpen;

@property (nonatomic, strong) HYActivityView *activityView;


@end

@implementation SmaTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if (!appDele) {
        appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    appDele.tabVC = self;
    [self setupTabbar];
    
    [self setupAllChildViewControllers];
    
    [self addOtherButton];
    
    [self loginBluetooth];
    
    [SmaBleMgr backKvaudio];
    
    if (!self.btStateMonitorTimer) {
//         self.btStateMonitorTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checkUnreadCount) userInfo:nil repeats:YES];
    }
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkUnreadCell) userInfo:nil repeats:YES];
    
}
-(void)checkUnreadCell{
    if ([appDele.isBackground isEqualToString:@"0"] && SmaBleMgr.peripheral.state == CBPeripheralStateConnected && SmaBleMgr.islink.intValue == 1) {
        
        [SmaBleMgr getElectric];
//
        
    }
}
-(void)checkUnreadCount
{
    if (!appDele) {
        appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDele.tabVC = self;
    }
   
    MyLog(@"%d 定时去请求 %ld  SmaBleMgr.saveMgr==%@   %@  %@ %ld",SmaBleMgr.OTA,(long)SmaBleMgr.peripheral.state,SmaBleMgr.saveMgr,SmaBleMgr.peripheral.name,SmaBleMgr.islink,(long)SmaBleMgr.peripheral.state);
    
    if (SmaBleMgr.peripheral.state != CBPeripheralStateConnected && SmaBleMgr.peripheral && [SmaAccountTool userInfo].watchUID && [appDele.isBackground isEqualToString:@"0"]) {
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
//懒加载，是否打开
-(NSNumber *)isOpen
{
    if(!_isOpen)
    {
        _isOpen=@0;
    }
    return _isOpen;
}
- (void)viewWillAppear:(BOOL)animated
{
    int i = 0;
    i++;
    NSLog(@"=====-----==%d",i++);
   
    [super viewWillAppear:animated];
    if (!notifCenter) {
        notifCenter = [NSNotificationCenter defaultCenter];
        [notifCenter addObserver:self selector:@selector(systemVersion:) name:@"systemVersion" object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setFireDate) name:@"tongzhi" object:nil];
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"systemVersion" object:nil];

    NSLog(@"8888");
}
- (void)didReceiveMemoryWarning{
    if (self.isViewLoaded && [self.view window] == nil)
    {
        // Add code to preserve data stored in the views that might be
        // needed later.
        
        // Add code to clean up other strong references to the view in
        // the view hierarchy.
        self.view = nil;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isOpen.boolValue==1) {
        [self dismissSubMenu];
    }
}
/**
 *  <#Description#> 初始化tabbar
 */
- (void)setupTabbar
{
    SmaTabBar *customTabBar = [[SmaTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

/**
 *  <#Description#> 初始化子控制器
 */
-(void)setupAllChildViewControllers
{
    
    SmaSportMainViewController *sport=[[SmaSportMainViewController alloc]init];
    [self setupChildViewController:sport title:SmaLocalizedString(@"sport_navtilte") imageName:@"tabbar_sport_button" selectedImageName:@"tabbar_sport_button_highlighted"];
    self.smaSport=sport;
    
    //SmaSleepMainViewController *sleep=[[SmaSleepMainViewController alloc]init];
    
    SmaSleepViewController *sleep=[[SmaSleepViewController alloc]init];
    [self setupChildViewController:sleep title:SmaLocalizedString(@"sleep_navtilte") imageName:@"tabbar_sleep_button" selectedImageName:@"tabbar_sleep_button_highlighted.png"];
    self.smaSleep=sleep;
    
    SmaRemindMainViewController *ramind=[[SmaRemindMainViewController alloc]init];
    [self setupChildViewController:ramind title:SmaLocalizedString(@"remind_navtilte") imageName:@"tabbar_remind_button" selectedImageName:@"tabbar_remind_button_highlighted"];
    self.smaRemind=ramind;
    
    
    SmaMeMainViewController *me=[[SmaMeMainViewController alloc]init];
    [self setupChildViewController:me title:SmaLocalizedString(@"setting_navtitle")  imageName:@"tabbar_person_button" selectedImageName:@"tabbar_person_button_highlighted"];
    self.smaMe=me;
    
    self.selectedIndex = 0;
}


/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(SmaTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to
{
    self.selectedIndex = to;
    if (self.isOpen.boolValue==1) {
        [self dismissSubMenu];
    }
    if(self.customview)
    {
        self.customview.frame=CGRectMake(0, 0, 0, 0);
    }
    
}

/**
 *  监听加号按钮点击
 */
- (void)tabBarDidClickedPlusButton:(SmaTabBar *)tabBar
{
    //    if (self.isOpen.boolValue==1) {
    //        [self dismissSubMenu];
    //    }
    //    else {
    //        [self presentSubMenu];
    //    }
    
//    if (!self.activityView) {
//        self.activityView = [[HYActivityView alloc]initWithTitle:@"" referView:self.view];
    
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
//        self.activityView.numberOfButtonPerLine = 2;
    
//        ButtonView *bv = [[ButtonView alloc]initWithText:@"" image:[UIImage imageLocalWithName:@"other_button_0"] handler:^(ButtonView *buttonView){
            SCNavigationController *nav = [[SCNavigationController alloc] init];
            nav.scNaigationDelegate = self;
            [nav showCameraWithParentController:self];
            
//        }];
//        [self.activityView addButtonView:bv];
//
//        bv = [[ButtonView alloc]initWithText:@"" image:[UIImage imageLocalWithName:@"other_button_1"] handler:^(ButtonView *buttonView){
//            SmaLoverViewController *settingVc = [[SmaLoverViewController alloc] init];
//            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:settingVc];
//            [self presentModalViewController:nav animated:YES];
//            
//        }];
//        [self.activityView addButtonView:bv];
        
//        bv = [[ButtonView alloc]initWithText:@"" image:[UIImage imageLocalWithName:@"other_button_2"] handler:^(ButtonView *buttonView){
//        
//        }];
//        [self.activityView addButtonView:bv];
        
//    }
    
//    [self.activityView show];
}

//显示
-(void)presentSubMenu
{
    _isOpen=@1;
    int iconNumber = 0;
    
    for (UIButton *icon in self.btnArrays) {
        CHAnimation *alpha = [CHAnimation new];
        alpha.fromValue = @0.0;
        alpha.toValue = @1.0;
        alpha.duration = 0.3;
        alpha.writeBlock = ^(id obj, id value) {
            icon.alpha = [value floatValue];
        };
        alpha.beginTime = CACurrentMediaTime() + iconNumber*0.1;
        [icon ch_addAnimation:alpha forKey:@"alpha1"];
        
        CHAnimation *push = [CHAnimation new];
        CGFloat angle = [self angleForIcon:iconNumber numberOfIcons:self.btnArrays.count];
        CGFloat radius = 90;
        push.beginTime = CACurrentMediaTime() + iconNumber*0.1;
        push.duration = 0.3;
        push.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height)];
        push.toValue = [NSValue valueWithCGPoint:CGPointMake(radius * cosf(angle) + self.view.frame.size.width/2, radius * sinf(angle) + self.view.bounds.size.height-30)];
        push.writeBlock = ^(id obj, id value) {
            icon.center = [value CGPointValue];
        };
        [icon ch_addAnimation:push forKey:@"push1"];
        iconNumber += 1;
    }
}


//隐藏
-(void)dismissSubMenu
{
    _isOpen=@0;
    int iconNumber = 0;
    
    for (UIButton *icon in self.btnArrays) {
        CHAnimation *alpha = [CHAnimation new];
        alpha.toValue = @0.0;
        alpha.fromValue = @1.0;
        alpha.duration = 0.3;
        alpha.writeBlock = ^(id obj, id value) {
            icon.alpha = [value floatValue];
        };
        
        alpha.beginTime = CACurrentMediaTime() + iconNumber*0.1;
        [icon ch_addAnimation:alpha forKey:@"alpha2"];
        
        CHAnimation *push = [CHAnimation new];
        CGFloat angle = [self angleForIcon:iconNumber numberOfIcons:self.btnArrays.count];
        CGFloat radius = 90;
        push.beginTime = CACurrentMediaTime() + iconNumber*0.1;
        push.duration = 0.3;
        
        push.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-30)];
        push.fromValue = [NSValue valueWithCGPoint:CGPointMake(radius * cosf(angle) + self.view.frame.size.width/2, radius * sinf(angle) + self.view.frame.size.height)];
        push.writeBlock = ^(id obj, id value) {
            icon.center = [value CGPointValue];
        };
        [icon ch_addAnimation:push forKey:@"push2"];
        
        iconNumber += 1;
    }
}

- (CGFloat) angleForIcon:(int)iconNumber numberOfIcons:(int)nIcons {
    //
    CGFloat interSpace = M_PI_4;
    CGFloat totalAngle = (nIcons -1) * interSpace;
    CGFloat startAngle = (-M_PI/2) - totalAngle/2;
    
    return startAngle + iconNumber*interSpace;
}


-(void)addOtherButton
{
    _btnArrays=[NSMutableArray array];
    for (int i=0; i<3; i++) {
        UIButton *btn=[[UIButton alloc]init];
        btn.tag=i;
        NSString *imgName=[NSString stringWithFormat:@"other_button_%d",i];
        [btn setBackgroundImage:[UIImage imageLocalWithName:imgName] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(self.view.frame.size.width/2 - CHPpopUpMenuItemSize/2, self.view.frame.size.height, CHPpopUpMenuItemSize, CHPpopUpMenuItemSize);
        [self.btnArrays addObject:btn];
        btn.alpha=0.0;
        [self.view addSubview:btn];
    }
}
-(void)openClick:(UIButton *)serind
{
    int tag=serind.tag;
    if(tag==0)
    {
        SCNavigationController *nav = [[SCNavigationController alloc] init];
        nav.scNaigationDelegate = self;
        [nav showCameraWithParentController:self];
    }else if(tag==1){
        SmaLoverViewController *settingVc = [[SmaLoverViewController alloc] init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:settingVc];
        [self presentModalViewController:nav animated:YES];
        
    }else{
        
    }
}
- (void)systemVersion:(NSNotification *)systemVersion{
    int i= 0;
     NSLog(@"－－－－－接收到VersionStr通知------ %d",i++);

//    if ([[SmaUserDefaults stringForKey:@"BLSystemVersion"] stringByReplacingOccurrencesOfString:@"." withString:@""].intValue < 304  ) {
//        if (!alert) {
//            alert = [[UIAlertView alloc]initWithTitle:SmaLocalizedString(@"alera_upgrade") message:SmaLocalizedString(@"alera_upgrade_function") delegate:self cancelButtonTitle:SmaLocalizedString(@"clockadd_confirm") otherButtonTitles:nil, nil];
//            [alert show];
//        }
//     
//    }
    
}
-(void)setFireDate{
    NSLog(@"－－－－－接收到通知------");
    [self.btStateMonitorTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView == alert) {
        [[NSNotificationCenter defaultCenter] removeObserver:@"systemVersion" name:nil object:self];
        [alert removeFromSuperview];
        alert = nil;
    }
}
/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    
    
    
    
    // UIImage *img=[UIImage imageNamed:imageName];
    
    //压缩图片大小
    //CGSize size={img.size.width *0.6,img.size.height*0.6};
    
    // childVc.tabBarItem.image = [UIImage imageByScalingAndCroppingForSize:size imageName:imageName];
    childVc.tabBarItem.image =[UIImage imageNamed:imageName];// [UIImage imageByScalingAndCroppingForSize:size imageName:imageName];
    // 设置选中的图标
    //UIImage *selectedImage = [UIImage imageByScalingAndCroppingForSize:size imageName:selectedImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];// [UIImage
    childVc.tabBarItem.selectedImage = selectedImage;
    
    // 2.包装一个导航控制器
    SmaNavigationController *nav = [[SmaNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

-(void)loginBluetooth{
    SmaUserInfo *user=[SmaAccountTool userInfo];
    SmaBleMgr.delegate=self;
    if(![user.watchUID.UUIDString isEqualToString:@""] && ![user.watchName isEqualToString:@""] && user.watchUID!=nil && user.watchName!=nil)//已经绑定
    {
        
        if(SmaBleMgr.mgr ==nil || SmaBleMgr.peripheral==nil || SmaBleMgr.characteristicValue==nil || SmaBleMgr.characteristicWrite)
        {
            [SmaBleMgr oneScanBand:NO];
            
        }
        
    }

        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:DateFormatter];
        NSString *hisSyncDate = [SmaUserDefaults stringForKey:@"hisSyncDate"];
        SmaDataDAL *dal = [[SmaDataDAL alloc]init];
        SmaAnalysisWebServiceTool *webservice=[[SmaAnalysisWebServiceTool alloc]init];
//        if (!hisSyncDate || hisSyncDate.intValue < [format stringFromDate:[NSDate date]].intValue) {
//            if ([SmaAccountTool userInfo].loginName) {
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    NSMutableArray *sumSpArray = [dal getMinuteSport:[SmaAccountTool userInfo].loginName];
//                    NSMutableArray *sumSlArray = [dal getMinuteSleep:[SmaAccountTool userInfo].loginName];
//                    NSMutableArray *sumClArray = [dal selectWebClockList:[SmaAccountTool userInfo].loginName];
//                    if (sumClArray.count>0 || sumSlArray.count>0 || sumClArray.count>0) {
//                        [webservice acloudSyncAllDataWithAccount:[SmaAccountTool userInfo].loginName sportDic:sumSpArray sleepDic:sumSlArray clockDic:sumClArray success:^(id success) {
//                            [SmaUserDefaults setObject:[format stringFromDate:[NSDate date]] forKey:@"hisSyncDate"];
//                            NSLog(@"数据上传成功");
//                        } failure:^(NSError *error) {
//                            NSLog(@"数据上传失败");
//                        }];
//                    }
//                });
//            }
//        }
}

-(void)loginWatchsucceed
{
    [self showLoginState:true];
}

- (void)showLoginState:(BOOL)islogin
{
    // 1.创建一个按钮
    UIButton *btn = [[UIButton alloc] init];
    // below : 下面  btn会显示在self.navigationController.navigationBar的下面
    [self.view insertSubview:btn belowSubview:self.tabBar];
    //[self.tabBar insertSubview:btn atIndex:2];
    //[self.view addSubview:btn];
    // 2.设置图片和文字
    btn.userInteractionEnabled = NO;
    [btn setBackgroundImage:[UIImage resizedImageWithName:@"timeline_new_status_background"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    if (islogin) {
        NSString *title = [NSString stringWithFormat:@"已经成功登录"];
        [btn setTitle:title forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"蓝牙已经断开" forState:UIControlStateNormal];
    }
    
    // 3.设置按钮的初始frame
    CGFloat btnH = 40;
    CGFloat btnY = 0 - btnH;
    CGFloat btnX = 2;
    CGFloat btnW = self.view.frame.size.width - 2 * btnX;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    // 4.通过动画移动按钮(按钮向下移动 btnH + 1)
    [UIView animateWithDuration:0.7 animations:^{
        
        btn.transform = CGAffineTransformMakeTranslation(0, btnH + 2);
        
    } completion:^(BOOL finished) { // 向下移动的动画执行完毕后
        
        // 建议:尽量使用animateWithDuration, 不要使用animateKeyframesWithDuration
        [UIView animateWithDuration:0.7 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // 将btn从内存中移除
            [btn removeFromSuperview];
        }];
        
    }];
}

@end
