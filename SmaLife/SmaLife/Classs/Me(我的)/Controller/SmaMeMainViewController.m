//
//  SmaMeMianViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/3.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaMeMainViewController.h"
#import "SmaSetting.h"
#import "SmaSettingGroup.h"
#import "SmaSettingCell.h"
#import "SmaHeaderView.h"
#import "SmaUserInfo.h"
#import "SmaAccountTool.h"
#import "SmaLoginViewController.h"
#import "SmaSwatchNavViewController.h"
#import "SmaSelectWatchViewController.h"
#import "SmaWatchPairViewController.h"
#import "SmaSelectWatchViewController.h"
#import "SmaRelieveBoundViewController.h"
#import "SmaLoverViewController.h"
#import "SCNavigationController.h"
#import "SmaPlanSetViewController.h"
#import "SmaUpdateMyInfoController.h"
#import "SmaSportPlanController.h"
#import "SmaHelpViewController.h"
#import "SmaAboutViewController.h"
#import "RSKImageCropViewController.h"
#import "DFUViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface SmaMeMainViewController ()<UITableViewDelegate,UITableViewDataSource,SCNavigationControllerDelegate,UIAlertViewDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,SetSamCoreBlueToolDelegate>{
    UIImageView *bluetoothView;
    UIImage *imgconnect;
    UIImage *imgdosconnect;
    UIAlertView *OTAalert;
    UIAlertView *updateAlert;
    NSString *app_Version ;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic,strong) UIImageView *bluetoothView;
@property (nonatomic,strong) UIImageView *uiimgfaceImg;
@property (nonatomic,strong) DFUViewController *dfuController;
@property (nonatomic,strong) UILabel *userNameLab;
@end

@implementation SmaMeMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithName:@"setting_navgitionbar_background"] forBarMetrics:UIBarMetricsDefault];
    self.title=SmaLocalizedString(@"setting_navtitle");
    
    SmaBleMgr.delegate=self;
    //加载显示头像
    [self loadUerHead];
    //夹在现实功能列表
    [self loadTableView];
    
    // 每一行cell的高度
    self.tableView.rowHeight = 38;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(setbluetoothView) userInfo:nil repeats:YES];
    //[self getbluetoothView];
    /*照相功能 begin */
    
    /*照相功能 end */
    NSNotificationCenter *versionNot = [NSNotificationCenter defaultCenter];
    [versionNot addObserver:self selector:@selector(systemVersion:) name:@"systemVersion" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVersion:) name:@"systemVersion" object:nil];
}

-(void)setbluetoothView
{
    NSLog(@"islink===%@",SmaBleMgr.islink);
    if(SmaBleMgr.peripheral.state !=CBPeripheralStateConnected || !SmaBleMgr.peripheral || SmaBleMgr.islink.intValue == 0)
    {
        [self.bluetoothView setImage:[UIImage imageNamed:@"蓝牙已断开"]];
        
    }else
    {
        [self.bluetoothView setImage:[UIImage imageNamed:@"蓝牙已连接"]];
    }
}

-(void)getbluetoothView
{
    //    NSLog(@"------%d",[SmaBleMgr checkBleStatus]);
    if([SmaBleMgr checkBleStatus] && SmaBleMgr.islink.intValue == 1)
    {
        [self.bluetoothView setImage:[UIImage imageNamed:@"蓝牙已连接"]];
        
    }else
    {
        [self.bluetoothView setImage:[UIImage imageNamed:@"蓝牙已断开"]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getbluetoothView];
    [self setBlueView];
}
- (NSArray *)groups
{
    if (_groups == nil) {
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"setting.plist" ofType:nil]];
        
        NSMutableArray *groupArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            SmaSettingGroup *group = [SmaSettingGroup groupWithDict:dict];
            [groupArray addObject:group];
        }
        _groups = groupArray;
    }
    return _groups;
}

- (void)downL{
    SmaAnalysisWebServiceTool *TOOL =[[SmaAnalysisWebServiceTool alloc] init];
    [TOOL acloudDownLHeadUrlWithAccount:[SmaAccountTool userInfo].loginName Success:^(id result) {
        
    } failure:^(NSError *error) {
        
    }];

}

-(void)loadUerHead
{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    UIImageView *imgView=[[UIImageView alloc]init];
    imgView.frame=CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height*0.3);
    [imgView setImage:[UIImage imageWithName:@"usershow_background"]];
    [self.view addSubview:imgView];
    imgView.userInteractionEnabled=YES;
    
    UIImageView *faceImg = [[UIImageView alloc] init];
    CGFloat centerX = imgView.frame.size.width * 0.5;
    CGFloat centerY = imgView.frame.size.height * 0.4;
    faceImg.center = CGPointMake(centerX, centerY);
    faceImg.bounds = CGRectMake(0, 0, self.view.frame.size.width*0.3, self.view.frame.size.width*0.3);
    CALayer *lay  = faceImg.layer;//获取ImageView的层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:48.0];//值越大，角度越圆
    [faceImg setImage:[UIImage imageLocalWithName:@"default_head_img"]];
    faceImg.layer.masksToBounds = YES;
    faceImg.layer.cornerRadius = CGRectGetHeight(faceImg.bounds)/2;
    faceImg.layer.borderWidth = 0.5f;
    faceImg.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _uiimgfaceImg=faceImg;
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachesDir = [NSString stringWithFormat:@"%@/%@.jpg",[paths objectAtIndex:0],[SmaAccountTool userInfo].loginName];
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[SmaAccountTool userInfo].loginName]];
    NSData *data = [NSData dataWithContentsOfFile:uniquePath];
    UIImage *img = [[UIImage alloc] initWithData:data];
    if(img)
        [self.uiimgfaceImg setImage:img];
    
    
    [imgView addSubview:faceImg];
    UIButton *btn=[[UIButton alloc]init];
    [btn addTarget:self action:@selector(onButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame=faceImg.frame;
    [imgView addSubview:btn];
    faceImg.userInteractionEnabled=YES;
    
    
    
    
    UILabel *userNameLab= [[UILabel alloc]init];
    _userNameLab=userNameLab;
    SmaUserInfo *userInfo=[SmaAccountTool userInfo];
    if(userInfo)
        userNameLab.text=userInfo.nickname;
    else
        userNameLab.text=@"Blinkked";
    
    
    userNameLab.font=[UIFont systemFontOfSize: 18.0];
    userNameLab.textColor = [UIColor whiteColor];
    userNameLab.textAlignment=NSTextAlignmentCenter;
    userNameLab.center = CGPointMake(centerX, faceImg.frame.origin.y+20+faceImg.frame.size.height);
    //CGSize fontsize3 = [userNameLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    userNameLab.bounds = CGRectMake(0, 0,100, 25);
    
    [imgView addSubview:userNameLab];
    
    imgconnect=[UIImage imageNamed:@"蓝牙已连接"];
    imgdosconnect=[UIImage imageNamed:@"蓝牙已断开"];
    bluetoothView=[[UIImageView alloc]init];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(setBlueView) userInfo:nil repeats:YES];
    if(!SmaBleMgr.peripheral || SmaBleMgr.peripheral.state==CBPeripheralStateDisconnected || SmaBleMgr.islink.intValue == 0)
    {
        [bluetoothView setImage:imgdosconnect];
        
    }else
    {
        [bluetoothView setImage:imgconnect];
    }
    _bluetoothView=bluetoothView;
    bluetoothView.frame=CGRectMake(imgView.frame.size.width-20-imgconnect.size.width, imgView.frame.size.height-20-imgconnect.size.height, imgconnect.size.width, imgconnect.size.height);
    [imgView addSubview:bluetoothView];
    
//    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
//    but.frame = CGRectMake(20, 60, 30, 40);
//    but.backgroundColor = [UIColor redColor];
//    [but addTarget:self action:@selector(downL) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:but];

    
}
-(void)loadTableView
{
    CGRect rect = CGRectMake(0, self.view.frame.size.height*0.3+5, self.view.frame.size.width,self.view.frame.size.height*0.49);
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] init];
    _tableView=tableView;
    
}

- (void)setBlueView{
    
    if( !SmaBleMgr.peripheral || SmaBleMgr.peripheral.state != CBPeripheralStateConnected)
    {
        [bluetoothView setImage:imgdosconnect];
        
    }else
    {
        [bluetoothView setImage:imgconnect];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SmaSettingGroup *group = self.groups[section];
    return group.settings.count-1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

//绘制Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.chart setFontName:@"Helvetica-Bold"];
    SmaSettingCell *cell = [SmaSettingCell cellWithTableView:tableView];
    
    // 2.设置cell的数据
    SmaSettingGroup *group = self.groups[indexPath.section];
    
    cell.settingData=group.settings[indexPath.row];
    if (indexPath.row == 4) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",SmaLocalizedString(@"version"),app_Version];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    }
    if (indexPath.row == 5) {
        //        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        NSString *BLEversion;
        BLEversion = [SmaUserDefaults stringForKey:@"BLSystemVersion"];
        if (!BLEversion) {
            BLEversion = @"";
        }
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",SmaLocalizedString(@"version"),app_Version];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        if ([[SmaUserDefaults stringForKey:@"BLSystemVersion"] stringByReplacingOccurrencesOfString:@"." withString:@""].intValue < 170) {
            cell.detailTextLabel.attributedText = [self appendAttributedString:[NSString stringWithFormat:@"·%@ %@",SmaLocalizedString(@"version"),BLEversion]];
        }

    }
    //    if(indexPath.row==5)
    //    {
    //alarm_close_bg
    //        UIImage *closeImg=[UIImage imageNamed:@"alarm_close_bg"];
    //        UIImage *openImg=[UIImage imageNamed:@"alarm_open_bg"];
    //        UIButton *switchview = [[UIButton alloc] init];
    //        [switchview setImage:closeImg forState:UIControlStateNormal];
    //        [switchview setImage:openImg forState:UIControlStateSelected];
    //        switchview.frame=CGRectMake(0, 0, closeImg.size.width, closeImg.size.height);
    //
    //       [switchview addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    //       cell.accessoryView = switchview;
    //        NSInteger myTelInteger = [SmaUserDefaults integerForKey:@"openSyn"];
    //        if(!myTelInteger || myTelInteger==0)//没有开启发防丢
    //        {
    //            switchview.selected=false;
    //        }else //没有开启了防丢
    //        {
    //            switchview.selected=YES;
    //        }
    //    }else
    //    {
    //
    //       cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //    }
    
    
    return cell;
}

- (void)updateSwitchAtIndexPath:(id)sender {
    
    UIButton *switchView = (UIButton *)sender;
    switchView.selected=!switchView.isSelected;
    
    if (switchView.selected)
    {
        if([SmaBleMgr checkBleStatus])
        {
            MyLog(@"开启数据同步");
            [SmaUserDefaults setInteger:1 forKey:@"openSyn"];
            [SmaBleMgr openSyncdata:true];
        }
    }
    else
    {
        if([SmaBleMgr checkBleStatus])
        {
            MyLog(@"关闭数据同步");
            [SmaBleMgr openSyncdata:false];
            [SmaUserDefaults setInteger:0 forKey:@"openSyn"];
        }
    }
    
}

- (void)onButtonTouch:(UIButton *)sender
{
    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:picker animated:YES];
   
    
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
    
  UIImage *image1 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *data;
    
    if (UIImagePNGRepresentation(image1) == nil) {
        
        data = UIImageJPEGRepresentation(image1, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(image1);
        
    }
    
    [self performSelector:@selector(selectPic:) withObject:image afterDelay:0.1];
}
-(void)imagePickerControllerDIdCancel:(UIImagePickerController*)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}
-(void)selectPic:(UIImage*)image
{
    [self.uiimgfaceImg setImage:image];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[SmaAccountTool userInfo].loginName]];
    NSData * data = UIImageJPEGRepresentation(image, 0.8);
    ;
    BOOL result = [[self scaleToSize:image] writeToFile: filePath  atomically:YES];
//    BOOL result = [UIImagePNGRepresentation(image) writeToFile: filePath    atomically:YES];
    if(result)
    {
        MyLog(@"保存成功");
         SmaUserInfo *userInfo=[SmaAccountTool userInfo];
        userInfo.header_url = filePath;
        [SmaAccountTool saveUser:userInfo];
         SmaAnalysisWebServiceTool *webservice=[[SmaAnalysisWebServiceTool alloc]init];
        [webservice acloudHeadUrlSuccess:^(id result) {
             MyLog(@"上传成功");
        } failure:^(NSError *error) {
           
        }];
    }else{
        MyLog(@"保存失败");
    }
    // UIImage *image = [UIImage imageNamed:@"new_feature_2"];
    //   RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    //   imageCropVC.delegate = self;
    //   [self.navigationController pushViewController:imageCropVC animated:YES];
}

-(void)imageCropViewController:(RSKImageCropViewController *)controller willCropImage:(UIImage *)originalImage
{
    UIImage *img=originalImage;
    
    MyLog(@"%.f--%.f--",img.size.width,img.size.height);
}
-(void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    
    MyLog(@"-----------%.f--%.f--",croppedImage.size.width,croppedImage.size.height);
    
}
-(void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle
{
    
    [self.uiimgfaceImg setImage:croppedImage];
//    MyLog(@"----111111111-------%.f--%.f--",croppedImage.size.width,croppedImage.size.height);
}
/**
 *  返回每一组需要显示的头部标题(字符出纳)
 */
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    // 1.创建头部控件
//    SmaHeaderView *header = [SmaHeaderView headerViewWithTableView:tableView];
//    // 2.给header设置数据(给header传递模型)
//    header.group = self.groups[section];
//    return header;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==0)//个人信息
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyTable" bundle:nil];
        SmaUpdateMyInfoController *myInfo = [storyboard instantiateViewControllerWithIdentifier:@"myinfo"];
        [self.navigationController pushViewController:myInfo animated:YES];
    }
    else if(indexPath.section==0 && indexPath.row==1)//目标计划
    {
        //SmaPlanSetViewController *settingVc = [[SmaPlanSetViewController alloc] init];//目标计划
        SmaSportPlanController *settingVc = [[SmaSportPlanController alloc] init];
        [self.navigationController pushViewController:settingVc animated:YES];
        
    }else if(indexPath.section==0 && indexPath.row==2)//绑定手表
    {
        SmaUserInfo *user=[SmaAccountTool userInfo];
        if([user.watchUID.UUIDString isEqualToString:@""] || [user.watchName isEqualToString:@""] || user.watchUID==nil || user.watchName==nil)
        {
            SmaSelectWatchViewController *settingVc = [[SmaSelectWatchViewController alloc] init];
            [self.navigationController pushViewController:settingVc animated:YES];
            
        }else
        {
            [MBProgressHUD showError: SmaLocalizedString(@"alert_alreadyband")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
        }
        
    }
    else if(indexPath.section==0 && indexPath.row==3)
    {
        
        
        SmaUserInfo *user=[SmaAccountTool userInfo];
         MyLog(@"————————————--222222-----%@--%@  %@ %@  %@",user.scnaSwatchName ,user.watchUID ,user.watchName,user.orScnaSwatchName,user.OTAwatchName);
        if([user.watchUID.UUIDString isEqualToString:@""] || [user.watchName isEqualToString:@""] || user.watchUID==nil || user.watchName==nil)
        {
            [MBProgressHUD showError: SmaLocalizedString(@"alert_alreadynoband")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            
        }else
        {
//
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AlertViewTest"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:SmaLocalizedString(@"clockadd_cancel")
                                                  otherButtonTitles:SmaLocalizedString(@"clockadd_confirm"),nil];
            //设置标题与信息，通常在使用frame初始化AlertView时使用
            alert.title = SmaLocalizedString(@"relieve_band");
            alert.message =SmaLocalizedString(@"alert_relieveband");
            [alert show];
        }
    
    }
    else if(indexPath.section==0 && indexPath.row==4){
//         [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];

    }
    else if(indexPath.section==0 && indexPath.row==5)
    {
//   return;
        NSLog(@"fwef==^%d",[[SmaUserDefaults stringForKey:@"BLSystemVersion"] stringByReplacingOccurrencesOfString:@"." withString:@""].intValue);
        if (SmaBleMgr.peripheral.state == CBPeripheralStateConnected ) {
            if ([SmaBleMgr.islink isEqualToString:@"0"] || [[SmaUserDefaults stringForKey:@"BLSystemVersion"] isEqualToString:@""]) {
                [MBProgressHUD showError: SmaLocalizedString(@"alera_updateData")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                });
                return;
            }
            if ([[SmaUserDefaults stringForKey:@"BLSystemVersion"] stringByReplacingOccurrencesOfString:@"." withString:@""].intValue < 170) {
                OTAalert = [[UIAlertView alloc]initWithTitle:nil message:SmaLocalizedString(@"alera_systemUp") delegate:self cancelButtonTitle:SmaLocalizedString(@"clockadd_cancel") otherButtonTitles:SmaLocalizedString(@"clockadd_confirm"), nil];
                [OTAalert show];
            }
            else {
                 [MBProgressHUD showSuccess: SmaLocalizedString(@"setting_update_note")];
            }
        }
        else{
            [MBProgressHUD showError: SmaLocalizedString(@"connect_first")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
        }
    }

    else if(indexPath.section==0 && indexPath.row==6)
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
        
        NSString * preferredLang = [allLanguages objectAtIndex:0];
        //英文
        if(![preferredLang isEqualToString:@"zh-Hans"]){
//             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.smawatchusa.com/help3"]];
        }
        else{
//             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.smawatchusa.com/help"]];
        }
//        SmaHelpViewController *helpVc=[[SmaHelpViewController alloc]init];
//        [self.navigationController pushViewController:helpVc animated:YES];http://www.smawatchusa.com/help
        
    }else if(indexPath.section==0 && indexPath.row==7)
    {
        
        SmaAboutViewController *aboutVc=[[SmaAboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVc animated:YES];
    }
    
    else if(indexPath.section==0 && indexPath.row==8)
    {
         SmaDataDAL *dal = [[SmaDataDAL alloc]init];
        NSString *loutNum = [SmaAccountTool userInfo].loginName;
         SmaAnalysisWebServiceTool *webservice=[[SmaAnalysisWebServiceTool alloc]init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableArray *sumSpArray = [dal getMinuteSport:loutNum];
            NSMutableArray *sumSlArray = [dal getMinuteSleep:loutNum];
            NSMutableArray *sumClArray = [dal selectWebClockList:loutNum];
            if (sumSpArray.count > 0 || sumSlArray.count > 0 || sumClArray.count > 0) {
                [webservice acloudSyncAllDataWithAccount:loutNum sportDic:sumSpArray sleepDic:sumSlArray clockDic:sumClArray success:^(id success) {
                    NSLog(@"数据上传成功");
                } failure:^(NSError *error) {
                    NSLog(@"数据上传失败");
                }];
            }
        });
        [SmaUserDefaults setObject:@"" forKey:@"clientId"];
        [webservice acloudCIDSuccess:^(id result) {
            
        } failure:^(NSError *error) {
            
        }];
        SmaUserInfo *userInfo=[[SmaUserInfo alloc]init];
//         SmaUserInfo *userInfo=[SmaAccountTool userInfo];
        userInfo.watchUID=[[NSUUID alloc]initWithUUIDString:@""];
        userInfo.OTAwatchName = @"";
        userInfo.watchName=@"";
        userInfo.loginName=@"";
        userInfo.userName=@"";
        userInfo.isLogin=@"";
        [SmaAccountTool saveUser:userInfo];
        if (SmaBleMgr.peripheral.state == CBPeripheralStateConnected) {
            [SmaBleMgr.mgr cancelPeripheralConnection:SmaBleMgr.peripheral];
        }
        SamCoreBlueTool *coreblue=[SamCoreBlueTool sharedCoreBlueTool];
        coreblue.swatchName=nil;
        coreblue.orSwatchName = nil;
        SmaUserInfo *info = [SmaAccountTool userInfo];
        info.scnaSwatchName = nil;
        info.orScnaSwatchName = nil;
        [SmaAccountTool saveUser:info];
        SmaBleMgr.mgr=nil;
        SmaBleMgr.saveMgr = nil;
        SmaBleMgr.peripherals=nil;
        SmaLoginViewController *charVc=[[SmaLoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:charVc];
        UINavigationBar *navBar = nav.navigationBar;
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] =SmaColor(255, 255, 255);
        attrs[NSFontAttributeName]=[UIFont fontWithName:@"STHeitiSC-Light" size:19];
        [navBar setTitleTextAttributes:attrs];
        [UIApplication sharedApplication].keyWindow.rootViewController=nav;
        
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        SmaUserInfo *userInfo=[[SmaUserInfo alloc]init];
        userInfo.watchUID=[[NSUUID alloc]initWithUUIDString:@""];
        userInfo.OTAwatchName = @"";
        userInfo.watchName=@"";
        userInfo.loginName=@"";
        userInfo.userName=@"";
        userInfo.isLogin=@"";
        [SmaAccountTool saveUser:userInfo];
        SamCoreBlueTool *coreblue=[SamCoreBlueTool sharedCoreBlueTool];
        coreblue.swatchName=nil;
        coreblue.orSwatchName = nil;
        SmaBleMgr.mgr=nil;
        SmaBleMgr.saveMgr = nil;
        SmaBleMgr.peripherals=nil;
        SmaUserInfo *info = [SmaAccountTool userInfo];
        info.scnaSwatchName = nil;
        info.orScnaSwatchName = nil;
        [SmaAccountTool saveUser:info];
        SmaLoginViewController *charVc=[[SmaLoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:charVc];
        UINavigationBar *navBar = nav.navigationBar;
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] =SmaColor(255, 255, 255);
        attrs[NSFontAttributeName]=[UIFont fontWithName:@"STHeitiSC-Light" size:19];
        [navBar setTitleTextAttributes:attrs];
        [UIApplication sharedApplication].keyWindow.rootViewController=nav;
        actionSheet =nil;
    }
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == OTAalert && buttonIndex == 1) {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DFUViewController *viewCtl = [storyBoard instantiateViewControllerWithIdentifier:@"DFUViewController"];
        _dfuController=[[DFUViewController alloc]init];
        NSString *userInfoName = [SmaAccountTool userInfo].watchName;
//        userInfoName = nil;  PION_V1.3.0
        NSLog(@"---___|+++==%@",userInfoName);
        if ([userInfoName isEqualToString:@"BLKK"] || [userInfoName isEqualToString:@"BLKK"]) {
            viewCtl.bindName = [[NSBundle mainBundle] pathForResource:@"BLKK_V1.6.0" ofType:@"hex"];
        }
        else{
            viewCtl.bindName = [[NSBundle mainBundle] pathForResource:@"BLKK_V1.6.0" ofType:@"hex"];
        }
        
        [self.navigationController pushViewController:viewCtl animated:YES];
        [SmaBleMgr setOTAstate];
        //        [MBProgressHUD showError: SmaLocalizedString(@"no_update")];
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [MBProgressHUD hideHUD];
        //        });
        SmaBleMgr.delegate=self;
        [self.dfuController uploadPressed];
        //[SmaBleMgr setOTAstate];
    }
    else   if (alertView == updateAlert && buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
    }
    else  if(buttonIndex==1)
    {
        SmaUserInfo *user=[SmaAccountTool userInfo];
        SmaRelieveBoundViewController *settingVc = [[SmaRelieveBoundViewController alloc] init];
        settingVc.systemLab = user.watchName;
        user.watchUID=nil;
        user.watchName=nil;
        user.isLogin=nil;
        [SmaAccountTool saveUser:user];
        SamCoreBlueTool *coreblue=[SamCoreBlueTool sharedCoreBlueTool];
        coreblue.swatchName=nil;
        coreblue.orSwatchName = nil;
        SmaBleMgr.mgr=nil;
        SmaBleMgr.saveMgr = nil;
        SmaBleMgr.peripherals=nil;
        SmaUserInfo *info = [SmaAccountTool userInfo];
        info.scnaSwatchName = nil;
        info.orScnaSwatchName = nil;
        [SmaAccountTool saveUser:info];
        NSLog(@"===%@  %@",[SmaAccountTool userInfo].watchName,coreblue.swatchName);
        [self.navigationController pushViewController:settingVc animated:YES];
    }
}

- (void)systemVersion:(id)version{
    
    NSNotification *ver = version;
    NSLog(@"修改版本号==%@", ver.userInfo);
     [self.tableView reloadData];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"systemVersion" object:nil];
}

- (void)btnPressed:(id)sender {
    NSLog(@"开启");
    SCNavigationController *nav = [[SCNavigationController alloc] init];
    nav.scNaigationDelegate = self;
    [nav showCameraWithParentController:self];
}
-(void)NotificationOTA
{
    MyLog(@"来了");
    [self.dfuController statcPressed];
}
-(void)viewDidAppear:(BOOL)animated
{
    SmaUserInfo *userInfo=[SmaAccountTool userInfo];
    if(userInfo)
        self.userNameLab.text=userInfo.nickname;
    else
        self.userNameLab.text=@"Blinkked";
}

- (void)updateMethod:(NSDictionary *)appInfo {
    NSString *nowVersion = [appInfo objectForKey:@"current_version"];
    NSString *newVersion = [appInfo objectForKey:@"version"];
    updateUrl = [appInfo objectForKey:@"path"];
    if(![nowVersion isEqualToString:newVersion] && newVersion)
    {
        updateAlert = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"alert_title") message:SmaLocalizedString(@"setting_update_App") delegate:self cancelButtonTitle:SmaLocalizedString(@"clockadd_cancel") otherButtonTitles:SmaLocalizedString(@"clockadd_confirm"), nil];
        [updateAlert show];
    }
    else {
        [MBProgressHUD showSuccess: SmaLocalizedString(@"setting_update_note")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
    }
}

#pragma mark - SCNavigationController delegate
//- (void)didTakePicture:(SCNavigationController *)navigationController image:(UIImage *)image {
//    NSLog(@"获取图片");
//    PostViewController *con = [[PostViewController alloc] init];
//    con.postImage = image;
//    [navigationController pushViewController:con animated:YES];
//}

static float i = 0.1; float A = 0;
- (NSData *)scaleToSize:(UIImage *)imge{
    
   
    NSData *data;
    data= UIImageJPEGRepresentation(imge, 1);
   
    if (data.length > 70000) {
        [self zoomImaData:imge];
         data = UIImageJPEGRepresentation(imge,1-A);
        A = 0;
    }
    NSLog(@"datalien==%lu",(unsigned long)data.length);
    return data;
    
}

- (void)zoomImaData:(UIImage *)image{
     A = A + i;
    NSData *data = UIImageJPEGRepresentation(image,1-A);
    if (data.length > 70000) {
        [self zoomImaData:image];
    }
}

- (NSMutableAttributedString *)appendAttributedString:(NSString *)attrString{
    NSMutableAttributedString *hour = [[NSMutableAttributedString alloc] initWithString:attrString];
    [hour addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 1)];
    [hour addAttribute:NSForegroundColorAttributeName
                 value:(id)[UIColor redColor] range:NSMakeRange(0, 1)];
    [hour addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(1, attrString.length-1)];
    return hour;
}
@end
