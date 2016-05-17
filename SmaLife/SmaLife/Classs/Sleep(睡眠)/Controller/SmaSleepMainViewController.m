//
//  SmaSleepMianViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/3.
//  Copyright (c) 2015年 SmaLife. All rights reserved.


#import "SmaSleepMainViewController.h"
#import "SmaDataDal.h"
#import "SmaSleepInfo.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "SmaUserInfo.h"
#import "SmaAccountTool.h"
#import "AFNetworking.h"
#import "SmaSleepPackageInfo.h"

#define ImgViwqBodyRatio 0.4
#define LabViewBodyRatio 0.6


@interface SmaSleepMainViewController ()<SetSamCoreBlueToolDelegate>


/*昨晚睡了*/
@property (nonatomic,strong) UILabel *sumhour;
/*入睡时间*/
@property (nonatomic,strong) UILabel *sleephour;
/*入睡时间*/
@property (nonatomic,strong) UILabel *fallasleepTime;
/*醒来时间*/
@property (nonatomic,strong) UILabel *wakeupTime;
/*清醒时间*/
@property (nonatomic,strong) UILabel *soberTime;
/*睡眠时长*/
@property (nonatomic,strong) UILabel *sleepLen;
/*深睡时长*/
@property (nonatomic,strong) UILabel *deepsleepLen;
/*浅睡时长*/
@property (nonatomic,strong) UILabel *simplesleepLen;
/*当前时间*/
@property (nonatomic,strong) UILabel *atTime;
//当前日期


@property (nonatomic,strong) NSDate *newdata;
//
@property (nonatomic,strong) UILabel *datalable;


/*布局*/
@property (nonatomic,strong) UIImageView *bodyImgBgView;
@property (nonatomic,strong) UIImageView *rollimg;
@property (nonatomic,strong) UIImageView *bodyImg;
@property (nonatomic,strong) NSDate *nowDate;
@property (nonatomic,weak) UIView *stripView;
@end

@implementation SmaSleepMainViewController

int curveWeek=0;
int newdeffInt=7;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=SmaLocalizedString(@"sleepdetail_navtilte");
    _nowDate = self.newdata;
    curveWeek=[[SmaCommonStudio weekDayInt]intValue];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithName:@"sleep_detail_nav_bg"] forBarMetrics:UIBarMetricsDefault];
    UIImage *img=[UIImage imageNamed:@"nav_back_button"];
    CGSize size={img.size.width *0.5,img.size.height*0.5};
    UIImage *backButtonImage = [[UIImage imageByScalingAndCroppingForSize:size imageName:@"nav_back_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,30,0,5)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 30);
    button.imageEdgeInsets =UIEdgeInsetsMake(0, -28, 0, 0);
    [button setImage:backButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"UPDATEUI" object:nil];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //
    //    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"sport_share_ico" highIcon:@"sport_share_ico" target:self action:@selector(share)];
    
    [self loadImgView];
    
    //[self loadBody];
    
    [self loadLables];
    [self refreshData];
    //重新布局
    //[self weekButtonLayoutInt:curveWeek];
    
    SmaBleMgr.delegate=self;
    //[self postWebServer];
    //[self loginWebServer];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)postWebServer
{
    // NSString *address=@"http://192.168.0.137:8080/WebServiceTest/HelloJaxwsPort";//URL地址
    // NSString *nameSpace=@"http://jaxws/";//命名空间
    // 1.创建请求管理对象
    //AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //NSString *url=@"http://192.168.0.137:8080/WebServiceTest/HelloJaxwsPort?wsdl";
    
    
    NSString *soapMessage=[NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://webservice.smalife.com/\">"
                           "<soap:Body>"
                           "<ns1:userRegister>"
                           "<jsonString>{\"password\":\"123456\",\"account\":\"18818007585\",\"clientId\":\"26c986a07903f8e8e491e127e8531a12\"}</jsonString>"
                           "</ns1:userRegister>"
                           "</soap:Body>"
                           "</soap:Envelope>"];
    //
    NSURL *url = [NSURL URLWithString:@"http://192.168.0.137:8080/Smalife/services/userservice?wsdl"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //[request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //[request addValue: @"text/HTML; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str1 = [[NSString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
        MyLog(@"%@",str1);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MyLog(@"❌：%@",error);
    }];
    
    [operation start];
}


-(void)loginWebServer
{
    // NSString *address=@"http://192.168.0.137:8080/WebServiceTest/HelloJaxwsPort";//URL地址
    // NSString *nameSpace=@"http://jaxws/";//命名空间
    // 1.创建请求管理对象
    //AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //NSString *url=@"http://192.168.0.137:8080/WebServiceTest/HelloJaxwsPort?wsdl";
    
    
    NSString *soapMessage=[NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://webservice.smalife.com/\">"
                           "<soap:Body>"
                           "<ns1:userLogin>"
                           "<jsonString>{\"password\":\"123456\",\"account\":\"18818007585\"}</jsonString>"
                           "</ns1:userLogin>"
                           "</soap:Body>"
                           "</soap:Envelope>"];
    //
    NSURL *url = [NSURL URLWithString:@"http://192.168.0.137:8080/Smalife/services/userservice?wsdl"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //[request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //[request addValue: @"text/HTML; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str1 = [[NSString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
        MyLog(@"%@",str1);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MyLog(@"❌：%@",error);
    }];
    
    [operation start];
}

-(void)viewWillAppear:(BOOL)animated
{
    SmaBleMgr.delegate=self;
}


-(NSDate *)newdata
{
    _newdata=[NSDate date];
    return _newdata;
}
-(void)share

{  CGSize imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);//你要的截图的位置
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            
            CGContextConcatCTM(context, [window transform]);
            
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [SmaCommonStudio share:image];
}

- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext: context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
-(void)loadImgView
{
    
    UIImage *bgImg=[UIImage imageNamed:@"sleep_detail_body_bg"];
    UIImageView *bodyImg=[[UIImageView alloc]initWithImage:bgImg];
    if(fourInch)
    {
        bodyImg.frame=CGRectMake(0, 0, self.view.frame.size.width,bgImg.size.height);
    }else
    {
        bodyImg.frame=CGRectMake(0, 0, self.view.frame.size.width,216);
    }
    [self.view addSubview:bodyImg];
    _bodyImgBgView=bodyImg;
    
    UIImageView *imglien = [[UIImageView alloc]init];
    UIImage *img=[UIImage imageNamed:@"sleep_line_time"];
    [imglien setImage:img];
    imglien.frame=CGRectMake(0,self.bodyImgBgView.frame.size.height-40, self.view.frame.size.width, img.size.height);
    
    //    bodyImg.backgroundColor = [UIColor redColor];
    [bodyImg addSubview:imglien];
    
    
}
-(NSDate *)data
{
    if(_data==nil)
    {
        _data=[NSDate date];
    }
    return _data;
}

-(void)loadBody
{
    
    //    CGFloat y=self.view.frame.size.height*ImgViwqBodyRatio;
    //    if(fourInch)
    //        y= self.view.frame.size.height*(ImgViwqBodyRatio+0.1);
    CGFloat y=self.bodyImgBgView.frame.origin.y+self.bodyImgBgView.frame.size.height;
    
    UIImage *bgRollImg=[UIImage imageNamed:@"sleep_roll_background"];
    CGFloat w=(bgRollImg.size.width)/9;
    UIImageView *rollimg=[[UIImageView alloc]initWithImage:bgRollImg];
    if(fourInch)
    {
        rollimg.frame=CGRectMake(0,y,bgRollImg.size.width, bgRollImg.size.height);
    }else
    {
        rollimg.frame=CGRectMake(0,y,bgRollImg.size.width,30);
    }
    [self.view addSubview:rollimg];
    _rollimg=rollimg;
    rollimg.userInteractionEnabled = YES;
    
    
    UIImage *leftImg= [UIImage imageNamed:@"button_left"];
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:leftImg forState:UIControlStateNormal];
    leftBtn.contentHorizontalAlignment=NSTextAlignmentLeft;
    leftBtn.frame=CGRectMake(0,0,w,bgRollImg.size.height);
    [leftBtn addTarget:self action:@selector(weekLeft) forControlEvents:UIControlEventTouchUpInside];
    [rollimg addSubview:leftBtn];
    
    for (int i=1; i<8; i++) {
        NSString *weekStr=SmaLocalizedString(@"clockadd_sunday");
        switch (i) {
            case 1:
                weekStr=SmaLocalizedString(@"clockadd_sunday");
                break;
            case 2:
                weekStr=SmaLocalizedString(@"clockadd_monday");
                break;
            case 3:
                weekStr=@"周 二";
                break;
            case 4:
                weekStr=@"周 三";
                break;
            case 5:
                weekStr=@"周 四";
                break;
            case 6:
                weekStr=@"周 五";
                break;
            case 7:
                weekStr=@"周 六";
                break;
            default:
                weekStr=@"";
                break;
        }
        
        UIButton *weekbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if([[SmaCommonStudio weekDayStr] isEqualToString:weekStr])
        {
            weekStr=@"今  天";
        }
        
        // NSString* phoneModel = [[UIDevice currentDevice] model];
        //MyLog(@"%@",phoneModel);
        weekbtn.contentEdgeInsets = UIEdgeInsetsMake(-3,0, 0, 0);
        [weekbtn setTitleColor:SmaColor(160, 160, 160) forState:UIControlStateNormal];
        [weekbtn setTitle:weekStr forState:UIControlStateNormal];
        weekbtn.titleLabel.font=[UIFont systemFontOfSize:12];
        weekbtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        weekbtn.tag=i;
        
        //weekbtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        weekbtn.frame=CGRectMake(w*i,0,w, bgRollImg.size.height);
        
        [rollimg addSubview:weekbtn];
        
    }
    //MyLog(@"宽度:%.f",w);
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBtn setImage:[UIImage imageNamed:@"button_right"] forState:UIControlStateNormal];
    
    rightBtn.frame=CGRectMake(w*8,0,w,bgRollImg.size.height);
    rightBtn.contentHorizontalAlignment=NSTextAlignmentLeft;
    [rightBtn addTarget:self action:@selector(weekRight) forControlEvents:UIControlEventTouchUpInside];
    [rollimg addSubview:rightBtn];
    
}
-(void)NotificationSleepData
{
    [self refreshData];
}

- (NSString *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"M月d日";
    NSString *selfStr = [fmt stringFromDate:self.data];
    
    return selfStr;
}

//星期做移动
-(void)weekLeft
{
    if(newdeffInt>1)
    {
        newdeffInt--;
        curveWeek--;
        if(curveWeek<1)
            curveWeek=7;
        
        NSDate *nextDate = [NSDate dateWithTimeInterval:-(24*60*60*(7-newdeffInt)) sinceDate:self.newdata];
        _data=nextDate;
        
        [self weekButtonLayoutInt:curveWeek];
    }
}
//星期右移动
-(void)weekRight
{
    MyLog(@"右");
    if(newdeffInt<7)
    {
        newdeffInt++;
        curveWeek++;
        if(curveWeek>7)
            curveWeek=1;
        
        NSDate *nextDate = [NSDate dateWithTimeInterval:(24*60*60*(newdeffInt-7)) sinceDate:self.newdata];
        _data=nextDate;
        
        [self weekButtonLayoutInt:curveWeek];
    }
}
/**
 *  <#Description#> 重新布局星期
 */
-(void)weekButtonLayoutInt:(int)newWeek
{
    
    self.datalable.text=[self dateWithYMD];
    //    SmaUserInfo *userInfo =[SmaAccountTool userInfo];
    //    //SmaDataDAL *dal = [[SmaDataDAL alloc]init];
    //    NSMutableArray *infos=[NSMutableArray array];
    //    for (int i=0; i<20; i++) {
    //        SmaSleepInfo *info=[[SmaSleepInfo alloc]init];
    //        info.user_id=userInfo.userId;
    //        info.sleep_id=@1;
    //        info.sleep_time=@1401;
    //        info.sleep_type=@1;
    //        info.sleep_data=@(20150412+i%7);
    //        [infos addObject:info];
    //    }
    //[dal insertSleepInfo:infos];
    
    
    CGFloat w=(self.view.frame.size.width-40)/7;
    int atTag=newWeek;
    UIButton *myBtn = (UIButton *)[self.view viewWithTag:atTag];
    [myBtn setTitleColor:SmaColor(0, 0, 0) forState:UIControlStateNormal];
    myBtn.frame=CGRectMake(w*3+20, 0, w, 40);
    
    UIButton *weekBtn=nil;
    for (int i=1; i<=3; i++) {
        atTag++;
        if(atTag>7)
        {
            weekBtn = (UIButton *)[self.view viewWithTag:(atTag-7)];
            weekBtn.frame=CGRectMake((w*(3+i))+20, 0, w, 40);
            
        }else
        {
            weekBtn = (UIButton *)[self.view viewWithTag:(atTag)];
            weekBtn.frame=CGRectMake((w*(3+i))+20, 0, w, 40);
        }
        [weekBtn setTitleColor:SmaColor(160,160,160) forState:UIControlStateNormal];
    }
    atTag=newWeek;
    for (int i=1; i<=3; i++) {
        atTag--;
        
        if(atTag<1)
        {
            weekBtn = (UIButton *)[self.view viewWithTag:(7+atTag)];
            weekBtn.frame=CGRectMake((w*(3-i))+20, 0, w, 40);
        }else
        {
            weekBtn = (UIButton *)[self.view viewWithTag:(atTag)];
            weekBtn.frame=CGRectMake((w*(3-i))+20, 0, w, 40);
        }
        [weekBtn setTitleColor:SmaColor(160,160,160) forState:UIControlStateNormal];
    }
    //重新布局好需要刷新数据
    [self refreshData];
    
}
/**
 *  <#Description#> 加载UILable
 */
-(void)loadLables
{
    
    CGFloat margin=14;
    CGFloat marginTop=10;
    
    CGFloat w=(self.view.frame.size.width-margin*6)/3;
    
    CGFloat labH=20;
    CGFloat labBigH=24;
    CGFloat y=self.bodyImgBgView.frame.origin.y+self.bodyImgBgView.frame.size.height;
    
    UIImage *imgRoot=[UIImage imageNamed:@"sleep_detail_down"];
    UIImageView *showImgView=[[UIImageView alloc]init];
    [showImgView setImage:imgRoot];
    showImgView.frame=CGRectMake(0,y,imgRoot.size.width,imgRoot.size.height);
    [self.view addSubview:showImgView];
    
    UILabel *sleep1=[[UILabel alloc]init];
    [sleep1 setText:SmaLocalizedString(@"sleepdetail_asleeptime")];
    
    sleep1.font=[UIFont fontWithName:@"STHeitiSC-Light" size:13];
    sleep1.textColor=SmaColor(100,100,100);
    sleep1.textAlignment=NSTextAlignmentLeft;
    sleep1.frame=CGRectMake(8,marginTop,w+5,labH);
    
    [showImgView addSubview:sleep1];
    
    UILabel *sleepTimeLab=[[UILabel alloc]init];
    [sleepTimeLab setText:[NSString stringWithFormat:@"0 %@",SmaLocalizedString(@"remind_min")]];
    sleepTimeLab.textAlignment=NSTextAlignmentLeft;
    sleepTimeLab.font=[UIFont fontWithName:@"STHeitiSC-Light" size:16];
    sleepTimeLab.textColor=SmaColor(0,0,0);
    sleepTimeLab.frame=CGRectMake(15,marginTop+labH,sleep1.frame.size.width,labBigH);
    [showImgView addSubview:sleepTimeLab];
    _sleephour=sleepTimeLab;///*入睡时间*/
    
    UILabel *wake1=[[UILabel alloc]init];
    [wake1 setText:SmaLocalizedString(@"sleepdetail_waketime")];
    wake1.font=[UIFont fontWithName:@"STHeitiSC-Light" size:13];
    wake1.textColor=SmaColor(100,100,100);
    wake1.textAlignment=NSTextAlignmentCenter;
    wake1.frame=CGRectMake(w+margin*3-20,marginTop,w+25,labH);
    wake1.center = CGPointMake(self.view.frame.size.width/2, wake1.center.y);
    [showImgView addSubview:wake1];
    
    UILabel *sleepWakeLab=[[UILabel alloc]init];
    [sleepWakeLab setText:[NSString stringWithFormat:@"0 %@",SmaLocalizedString(@"remind_min")]];
    sleepWakeLab.textAlignment=NSTextAlignmentCenter;
    sleepWakeLab.font=[UIFont fontWithName:@"STHeitiSC-Light" size:16];
    sleepWakeLab.textColor=SmaColor(0,0,0);
    sleepWakeLab.frame=CGRectMake(w+margin*3-20,marginTop+labH,w+25,labBigH);
    sleepWakeLab.center = CGPointMake(self.view.frame.size.width/2, sleepWakeLab.center.y);
    [showImgView addSubview:sleepWakeLab];
    _wakeupTime=sleepWakeLab;/*醒来时间*/
    
    UILabel *wake2=[[UILabel alloc]init];
    [wake2 setText:SmaLocalizedString(@"sleepdetail_hileleeptimelen")];
    wake2.textAlignment=NSTextAlignmentCenter;
    wake2.font=[UIFont fontWithName:@"STHeitiSC-Light" size:13];
    wake2.textColor=SmaColor(100, 100, 100);
    wake2.frame=CGRectMake(w+margin*3-20,2*marginTop+labH+labBigH,w+25,labH);
    wake2.center = CGPointMake(self.view.frame.size.width/2, wake2.center.y);
    [showImgView addSubview:wake2];
    
    UILabel *wakeDuration=[[UILabel alloc]init];
    [wakeDuration setText:[NSString stringWithFormat:@"0 %@",SmaLocalizedString(@"remind_min")]];
    wakeDuration.font=[UIFont fontWithName:@"STHeitiSC-Light" size:16];
    wakeDuration.textColor=SmaColor(0, 0, 0);
    wakeDuration.textAlignment=NSTextAlignmentCenter;
    wakeDuration.frame=CGRectMake(w+margin*3-20,2*marginTop+2*labH+labBigH,w+25,labH);
    wakeDuration.center = CGPointMake(self.view.frame.size.width/2, wakeDuration.center.y);
    [showImgView addSubview:wakeDuration];
    _deepsleepLen=wakeDuration;//深睡时间
    
    UILabel *sober1=[[UILabel alloc]init];
    [sober1 setText:SmaLocalizedString(@"sleepdetail_sobertime")];
    sober1.textAlignment=NSTextAlignmentRight;
    sober1.frame=CGRectMake(2*w+margin*5-17,marginTop,w+20,labH);
    sober1.font=[UIFont fontWithName:@"STHeitiSC-Light" size:13.0];
    sober1.textColor=SmaColor(100,100,100);
    [showImgView addSubview:sober1];
    
    
    UILabel *sleepSoberLab=[[UILabel alloc]init];
    [sleepSoberLab setText:[NSString stringWithFormat:@"0 %@",SmaLocalizedString(@"remind_min")]];
    sleepSoberLab.textAlignment=NSTextAlignmentRight;
    sleepSoberLab.font=[UIFont fontWithName:@"STHeitiSC-Light" size:16];
    sleepSoberLab.textColor=SmaColor(0, 0, 0);
    sleepSoberLab.frame=CGRectMake(5*margin+2*w,marginTop+labH,w,labBigH);
    [showImgView addSubview:sleepSoberLab];
    _soberTime=sleepSoberLab;/*清醒时间*//*醒来时间*/
    
    
    UILabel *sleep2=[[UILabel alloc]init];
    [sleep2 setText:SmaLocalizedString(@"sleepdetail_sleeptimelen")];
    sleep2.textAlignment=NSTextAlignmentLeft;
    sleep2.font=[UIFont fontWithName:@"STHeitiSC-Light" size:13];
    sleep2.textColor=SmaColor(100, 100, 100);
    sleep2.frame=CGRectMake(8,2*marginTop+labH+labBigH,w+10,labH);
    [showImgView addSubview:sleep2];
    UILabel *sleepDuration=[[UILabel alloc]init];
    [sleepDuration setText:[NSString stringWithFormat:@"0 %@",SmaLocalizedString(@"remind_min")]];
    
    sleepDuration.textAlignment=NSTextAlignmentLeft;
    sleepDuration.font=[UIFont fontWithName:@"STHeitiSC-Light" size:16];
    sleepDuration.textColor=SmaColor(0, 0, 0);
    sleepDuration.frame=CGRectMake(margin,2*marginTop+2*labH+labBigH,sleep1.frame.size.width,labH);
    [showImgView addSubview:sleepDuration];
    _sleepLen=sleepDuration;///*睡眠时长*/
    
    
    
    UILabel *sober3=[[UILabel alloc]init];
    sober3.textAlignment=NSTextAlignmentRight;
    sober3.font=[UIFont fontWithName:@"STHeitiSC-Light" size:13];
    sober3.textColor=SmaColor(100, 100, 100);
    [sober3 setText:SmaLocalizedString(@"sleepdetail_sobertimelen")];
    sober3.frame=CGRectMake(2*w+margin*5-17,2*marginTop+labH+labBigH,w+20,labH);
    [showImgView addSubview:sober3];
    
    
    UILabel *soberDuration=[[UILabel alloc]init];
    soberDuration.font=[UIFont fontWithName:@"STHeitiSC-Light" size:16];
    soberDuration.textAlignment=NSTextAlignmentRight;
    [soberDuration setText:[NSString stringWithFormat:@"0 %@",SmaLocalizedString(@"remind_min")]];
    soberDuration.frame=CGRectMake(2*w+margin*5,2*marginTop+2*labH+labBigH,w,labH);
    [showImgView addSubview:soberDuration];
    
    _simplesleepLen=soberDuration;//浅睡时长
}

- (void)updateUI{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    if (![[fmt stringFromDate:_nowDate] isEqualToString:[fmt stringFromDate:[NSDate date]]]) {
        self.data = [NSDate date];
        _nowDate = self.newdata;
    }
    self.datalable.text=[self dateWithYMD];
    [self refreshData];
}

//加载数据
-(void)refreshData
{
    SmaDataDAL *dal = [[SmaDataDAL alloc]init];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString *selfStr = [fmt stringFromDate:self.data];
    
    //昨天
    NSDate *preDate = [NSDate dateWithTimeInterval:-(24*60*60) sinceDate:self.data];
    NSString *preStr = [fmt stringFromDate:preDate];
    //昨天
    NSNumber *yeday=[NSNumber numberWithInt:[preStr intValue]];
    //今天
    NSNumber *today=[NSNumber numberWithInt:[selfStr intValue]];
    
    
    NSMutableDictionary *dict=[dal getSleepDataDay:today yestday:yeday];
    NSLog(@"sleepDict == %@",dict);
    if (!self.isWear) {
        [dict removeAllObjects];
    }
    NSArray *arr = [dict objectForKey:@"entitys"];
    
    SmaSleepPackageInfo *pInfo= [self dealWithData:dict];//dict[@"entitys"]
    //    }
    //    else{
    //        int hour1=[dict[@"begin"] intValue];
    //         int hour2=[dict[@"end"] intValue];
    //        if (hour1>0 && hour2>0) {
    //            if (hour1>hour2) {
    //                pInfo.sleepAmount = [NSString stringWithFormat:@"%d",1440-hour1+hour2];
    //            }
    //            else{
    //                 pInfo.sleepAmount = [NSString stringWithFormat:@"%d",hour2-hour1];
    //            }
    //            pInfo.wideSleepAmount = pInfo.sleepAmount;
    //        }
    //    }
    self.sleephour.text=[NSString stringWithFormat:@"%@",((!pInfo.sleephour)?@"0:00":([NSString stringWithFormat:@"%d%@%@%@",[pInfo.sleephour intValue]/60,@":",[pInfo.sleephour intValue]%60 < 10 ? [NSString stringWithFormat:@"0%d",[pInfo.sleephour intValue]%60] : [NSString stringWithFormat:@"%d",[pInfo.sleephour intValue]%60],@""]))];
    
    self.soberTime.text= [NSString stringWithFormat:@"%@",((!pInfo.soberAmount)?@"0:00":([NSString stringWithFormat:@"%d%@%@%@",[pInfo.soberAmount intValue]/60,@":",[pInfo.soberAmount intValue]%60 < 10 ? [NSString stringWithFormat:@"0%d",[pInfo.soberAmount intValue]%60] : [NSString stringWithFormat:@"%d",[pInfo.soberAmount intValue]%60],@""]))];
    self.sleepLen.text=[NSString stringWithFormat:@"%@",((!pInfo.sleepAmount)?@"0:00":([NSString stringWithFormat:@"%d%@%@%@",[pInfo.sleepAmount intValue]/60,@":",[pInfo.sleepAmount intValue]%60 < 10 ? [NSString stringWithFormat:@"0%d",[pInfo.sleepAmount intValue]%60] : [NSString stringWithFormat:@"%d",[pInfo.sleepAmount intValue]%60],@""]))];
    self.deepsleepLen.text= [NSString stringWithFormat:@"%@",((!pInfo.wideSleepAmount)?@"0:00":([NSString stringWithFormat:@"%d%@%@%@",[pInfo.wideSleepAmount intValue]/60,@":",[pInfo.wideSleepAmount intValue]%60 < 10 ? [NSString stringWithFormat:@"0%d",[pInfo.wideSleepAmount intValue]%60] : [NSString stringWithFormat:@"%d",[pInfo.wideSleepAmount intValue]%60],@""]))];
    self.simplesleepLen.text= [NSString stringWithFormat:@"%@",((!pInfo.lightSleepAmount)?@"0:00": ([NSString stringWithFormat:@"%d%@%@%@",[pInfo.lightSleepAmount intValue]/60,@":",[pInfo.lightSleepAmount intValue]%60 < 10 ? [NSString stringWithFormat:@"0%d",[pInfo.lightSleepAmount intValue]%60] : [NSString stringWithFormat:@"%d",[pInfo.lightSleepAmount intValue]%60],@""]))];
    
    
    int hour1;
    hour1=[dict[@"begin"] intValue];
    if (hour1 < 1320 &hour1 > 0) {
        hour1 = 1320;
    }
    if(hour1>1440)
        hour1=hour1-1440;
    
    int hour2=[dict[@"end"] intValue];
    
    if(hour2>1440)
        hour2=hour2-1440;
    if (hour2 > 600) {
        hour2 = 600;
    }
    
    int simSleep;
    if (hour2 == 0 && array.count ==0) {
        hour2 = 0;
    }
    if (hour1 >= 1320) {
        simSleep = 1440 - hour1 + hour2;
        
    }
    else{
        simSleep = hour2 - hour1;
    }
    int hour= simSleep/60;
    int min= simSleep%60;
    self.sleepLen.text= [NSString stringWithFormat:@"%@:%@",hour<10?[NSString stringWithFormat:@"%@%d",@"0",hour]:[NSString stringWithFormat:@"%d",hour],min<10?[NSString stringWithFormat:@"%@%d",@"0",min]:[NSString stringWithFormat:@"%d",min]];
    self.sleephour.text=[NSString stringWithFormat:@"%d%@%@",hour1/60,@":",hour1%60 < 10 ? [NSString stringWithFormat:@"0%d",hour1%60] : [NSString stringWithFormat:@"%d",hour1%60]];
    self.wakeupTime.text=[NSString stringWithFormat:@"%d%@%@",hour2/60,@":",hour2%60 < 10 ? [NSString stringWithFormat:@"0%d",hour2%60] : [NSString stringWithFormat:@"%d",hour2%60]];
    //    self.wakeupTime.backgroundColor = [UIColor greenColor];
    //self.sleephour.text=@"2小时30分钟";//[NSString stringWithFormat:@"%d",[dict[@"begin"] intValue]];
    //self.sleephour.text=[NSString stringWithFormat:@"%d",[dict[@"end"] intValue]];
    
    
}
//3 未睡觉  2 浅睡 1 深睡
-(SmaSleepPackageInfo *)dealWithData:(NSMutableDictionary *)dict
{
    float pixel=30;
    float pixelUnit=0.2;
    MyLog(@"范围＝＝＝＝＝＝＝＝%@    %@   %@",dict[@"end"],dict,dict[@"entitys"]);
    
    NSMutableArray *arrays=dict[@"entitys"];
    array = dict[@"entitys"];
    SmaSleepPackageInfo *pInfo= [[SmaSleepPackageInfo alloc]init];
    
    if (arrays.count>2) {
        for (int i = 0; i< arrays.count-1; i++) {
            SmaSleepInfo *obj1 = [arrays objectAtIndex:i];
            SmaSleepInfo *obj2 = [arrays objectAtIndex:i+1];
            NSLog(@"obj1  %@  %@  %d",obj1.sleep_type,obj2.sleep_type,i);
            if (obj1.sleep_type.intValue == obj2.sleep_type.intValue) {
                [arrays removeObject:obj2];
                //                if (i > 0) {
                i--;
                //                }
            }
            for (SmaSleepInfo *type in arrays) {
                NSLog(@"type = %d  %@",[type.sleep_type intValue],type.sleep_time);
            }
        }
    }
    NSArray * arr = [arrays sortedArrayUsingComparator:^NSComparisonResult(SmaSleepInfo *obj1, SmaSleepInfo *obj2) {
        
        if ([obj1.sleep_time intValue]<[obj2.sleep_time intValue]) {
            
            return NSOrderedAscending;
            
        }
        
        else if ([obj1.sleep_time intValue]==[obj2.sleep_time intValue])
            
            return NSOrderedSame;
        
        else
            
            return NSOrderedDescending;
        
    }];
    arrays = [arr mutableCopy];
//    [arrays removeAllObjects];
//    for (SmaSleepInfo *type in arrays) {
//        NSLog(@"typ00 = %d  %@",[type.sleep_type intValue],type.sleep_time);
//    }
    
    int prevTime=0;//上一时间点
    int prevData=0;//上一天数
    int prevType=0;//上一类型
    float soberAmount=0;//清醒时间
    float simpleSleepAmount=0;//浅睡眠时长
    float deepSleepAmount=0;//深睡时长
    int acon =0;
    int acont =0;
    for (int i=0; i<arrays.count; i++) {
        CGFloat h=160;
        CGFloat y=self.bodyImgBgView.frame.size.height-40-h;
        SmaSleepInfo *info=(SmaSleepInfo *)arrays[i];
        UIView *strip=[[UIView alloc]init];
        int beginSleep;
        beginSleep=[dict[@"begin"] intValue];
        if (beginSleep < 1320) {
            beginSleep = 1320;
        }
        if(i>0 && [info.sleep_time intValue] >= beginSleep)
        {
            int atType=[info.sleep_type intValue];
            int atTime=[info.sleep_time intValue];
            int amount=atTime-prevTime;
            acon = amount;
            acont = atTime;
            strip.frame=CGRectMake(pixel, y, amount*0.361, h);
            pixel=pixel+amount*0.361;
            if(prevType==2 && (atType==1 || atType==3))//浅睡进入深睡觉或进未睡＝浅睡
            {
                simpleSleepAmount=simpleSleepAmount+amount;
                [strip setBackgroundColor:SmaColor(200, 126, 238)];
                
            }else if(prevType==1 && (atType==3 || atType==2))
            {
                deepSleepAmount=deepSleepAmount+amount;
                [strip setBackgroundColor:SmaColor(133, 90, 175)];
                
            }else if(prevType==3 &&  (atType==1 || atType==2))
            {
                soberAmount=soberAmount+amount;
                [strip setBackgroundColor:SmaColor(238, 190, 255)];
            }
            //            else if (prevType==1 && atType==2){
            //                deepSleepAmount=deepSleepAmount+amount;
            //                [strip setBackgroundColor:SmaColor(133, 90, 175)];
            //            }
            //            else if (prevType==2 && atType==2){
            //                simpleSleepAmount=simpleSleepAmount+amount;
            //                [strip setBackgroundColor:SmaColor(200, 126, 238)];
            //            }
            //            else if (prevType==3 && atType==3){
            //                soberAmount=soberAmount+amount;
            //                [strip setBackgroundColor:SmaColor(238, 190, 255)];
            //            }
        }else if (i == 0){
            //
            int beginSleep;
            beginSleep=[dict[@"begin"] intValue];
            if (beginSleep < 1320) {
                beginSleep = 1320;
            }
            pixel=30+(beginSleep-1320)*0.248;
            int prevTime=[info.sleep_time intValue];
            int amount1;
            amount1=prevTime-beginSleep;
            if (amount1 < 0) {
                amount1 = 0;
            }
            deepSleepAmount=deepSleepAmount+amount1;
            [strip setBackgroundColor:SmaColor(133, 90, 175)];
            strip.frame=CGRectMake(pixel, y, /*pixel+*/amount1*0.361, h);
            
        }
        [self.bodyImgBgView addSubview:strip];
        prevData=[info.sleep_data intValue];
        prevTime=[info.sleep_time intValue];
        prevType=[info.sleep_type intValue];
    }
    int endSleep1=[dict[@"end"] intValue];
    
    if(arrays.count>0 &&  prevTime != endSleep1)
    {
        
        CGFloat h=160;
        int amount1;
        CGFloat y=self.bodyImgBgView.frame.size.height-40-h;
        UIView *strip1=[[UIView alloc]init];
        if (prevTime > endSleep1) {
            amount1 = prevTime-endSleep1;
        }
        else{
            amount1=endSleep1-prevTime;
        }
        deepSleepAmount=deepSleepAmount+amount1;
        endSleep1 = endSleep1 - (endSleep1/1440)*1440;
        if (endSleep1 > 600) {
            endSleep1 = 600;
        }
        [strip1 setBackgroundColor:SmaColor(133, 90, 175)];
        strip1.frame=CGRectMake(pixel, y, fabs((endSleep1 > 1440? endSleep1-1440 : endSleep1)/60.0*21.5+22*2 - pixel + 30), h);
        [self.bodyImgBgView addSubview:strip1];
    }
    
    int beginSleep;
    beginSleep=[dict[@"begin"] intValue];
    if (beginSleep < 1320 && beginSleep>0) {
        beginSleep = 1320;
    }
    int endSleep=[dict[@"end"] intValue];
    if(arrays.count==0 && beginSleep>0 && endSleep>0)
    {
        UIView *strip1=[[UIView alloc]init];
        endSleep = endSleep - (endSleep/1440)*1440;
        beginSleep = beginSleep - (beginSleep/1440)*1440;
        if ( endSleep>600) {
            endSleep = 600;
        }
        
        int amount;
        if (beginSleep>0 && endSleep>0) {
            if (beginSleep>endSleep) {
                amount = [NSString stringWithFormat:@"%d",1440-beginSleep+endSleep].intValue;
            }
            else{
                amount = [NSString stringWithFormat:@"%d",endSleep-beginSleep].intValue;
            }
            
            pInfo.sleepAmount = [NSString stringWithFormat:@"%d",amount];
            pInfo.wideSleepAmount = pInfo.sleepAmount;
        }
        int hour1;
        hour1=[dict[@"begin"] intValue];
        if (hour1 < 1320 && hour1>0) {
            hour1 = 1320;
        }
        int hour2=[dict[@"end"] intValue];
        hour1 = hour1 - (hour1/1440)*1440;
        hour2 = hour2 - (hour2/1440)*1440;
        int beginHour ;
        beginHour = 0;
        if (hour1>0 && hour2>0) {
            
            if (hour1 > 1320) {
                beginHour = hour1 - 1320;
            }
            if (hour1>hour2) {
                pInfo.sleepAmount = [NSString stringWithFormat:@"%d",1440-hour1+hour2];
            }
            else{
                pInfo.sleepAmount = [NSString stringWithFormat:@"%d",hour2-hour1];
            }
            
        }
        
        CGFloat h=160;
        CGFloat y=self.bodyImgBgView.frame.size.height-40-h;
        deepSleepAmount=amount;
        [strip1 setBackgroundColor:SmaColor(133, 90, 175)];
        strip1.frame=CGRectMake(30+beginHour*0.361, y, /*pixel+*/amount*0.361, h);
        [self.bodyImgBgView addSubview:strip1];
    }
    
    pInfo.sleephour=@"0";
    pInfo.soberAmount=[NSString stringWithFormat:@"%.f",soberAmount];
    pInfo.sleepAmount=[NSString stringWithFormat:@"%.f",(deepSleepAmount+simpleSleepAmount)];
    pInfo.wideSleepAmount=[NSString stringWithFormat:@"%.f",deepSleepAmount];
    pInfo.lightSleepAmount=[NSString stringWithFormat:@"%.f",simpleSleepAmount];
    int hour=deepSleepAmount+simpleSleepAmount+soberAmount;
    self.sumhour.text=[NSString stringWithFormat:@"%d%@%d%@",hour/60,SmaLocalizedString(@"sleep_hour"),hour%60,SmaLocalizedString(@"sport_minute")];
    //    self.sumhour.backgroundColor = [UIColor greenColor];
    UIView *bac = [[UIView alloc ]initWithFrame:CGRectMake(60, 94, 207.214000, 160)];
    bac.backgroundColor = [UIColor greenColor];
//        [self.bodyImgBgView addSubview:bac];
    return pInfo;
}

@end
