//
//  SmaSleepViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/12.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaSleepViewController.h"
#import "SmaSleepMainViewController.h"
#import "SmaSleepPackageInfo.h"
#import "SmaDataDAL.h"
#import "SmaSleepInfo.h"

@interface SmaSleepViewController ()
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;

/*昨晚睡了*/
@property (nonatomic,strong) UILabel *showhour;
/*昨晚睡了*/
@property (nonatomic,strong) UILabel *showmins;

@property (nonatomic,strong) NSDate *data;
@property (nonatomic,strong) NSNumber *datadiffer;
@property (nonatomic,strong) NSDate *nowDate;
@property (nonatomic,strong) NSDate *newdata;
@end

@implementation SmaSleepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    wear = YES;
    self.title=SmaLocalizedString(@"sleep_navtilte");
    self.remarkLab.text=SmaLocalizedString(@"sleep_status");
     _nowDate = self.newdata;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithName:@"sleep_detail_nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"UPDATEUI" object:nil];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"sport_share_ico" highIcon:@"sport_share_ico" target:self action:@selector(share)];
    self.datelab.text=SmaLocalizedString(@"sleep_today");
    [self relayoutLoad];
    //    [self refreshData];
    //手势
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    
    NSString *firstSleep = [SmaUserDefaults objectForKey:@"FIRSTSLEEP"];
    if (!firstSleep) {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:nil message:SmaLocalizedString(@"alear_firstSleep") delegate:self cancelButtonTitle:SmaLocalizedString(@"clockadd_confirm") otherButtonTitles:nil, nil];
        [aler show];
        [SmaUserDefaults setObject:@"FIRSTSLEEP" forKey:@"FIRSTSLEEP"];
    }
  //    [defaults setObject:currentVersion forKey:key];
  //    [defaults synchronize];

    
    // 3.监听键盘的通知
    //[SmaNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //[SmaNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)share
{
    CGSize imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);//你要的截图的位置
    
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

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        SmaSleepMainViewController *settingVc = [[SmaSleepMainViewController alloc] init];
        settingVc.data=self.data;
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyyMMdd";
        if ([[fmt stringFromDate:self.data] isEqualToString:[fmt stringFromDate:[NSDate date]]] && wear == NO) {
            settingVc.isWear = wear;
        }
        else{
            settingVc.isWear = YES;
        }
        [self.navigationController pushViewController:settingVc animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc]init];
    [newDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *newDate = [newDateFormatter stringFromDate:[NSDate date]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self refreshData];
}

-(void)NotificationSleepData
{
    [self refreshData];
}

-(void)relayoutLoad
{
    CGFloat frameW=self.view.frame.size.width;
    /*head begin*/
    UIImage *btnImg=[UIImage imageNamed:@"sleep_rightbtn_bg"];
    CGFloat btnImgh=btnImg.size.height;
    CGFloat headViewY=4;
    CGFloat labSize=12;
    if(!fourInch)
    {
        btnImgh=btnImg.size.height-6;
        headViewY=4;
        labSize=9;
    }
    
    self.headView.frame=CGRectMake(0, headViewY-2,frameW, btnImgh+10);
    //    self.leftBtn.frame=CGRectMake(52, 0,btnImg.size.width+5,btnImgh+5);
    //    self.rightBtn.frame=CGRectMake(frameW-(52+btnImg.size.width),0,btnImg.size.width+5,btnImgh+5);
    //    self.rightBtn.backgroundColor = [UIColor redColor];
    
    self.datelab.textAlignment=NSTextAlignmentCenter;
    self.datelab.font=[UIFont fontWithName:@"MicrosoftYaHei" size:labSize];
    self.datelab.textColor=SmaColor(255, 255, 255);
    self.datelab.frame=CGRectMake(52+btnImg.size.width,0,frameW-104-(btnImg.size.width*2),btnImgh+10);
    //[self.imgView addSubview:self.headView];
    self.bodyView.userInteractionEnabled=YES;
    
    /*head end*/
    
    /*chart body  begin*/
    UIImage *circe=[UIImage imageNamed:@"sleep_circle_bg"];
    UIImage *bodyImg=[UIImage imageNamed:@"sleep_body_bg"];
    CGFloat circeh=circe.size.height;
    CGFloat circew=circe.size.width;
    CGFloat imgViewh=bodyImg.size.height;
    CGFloat narginTop=25;
    CGFloat fontf=40;
    if(!fourInch)
    {
        circeh=circe.size.height-28;
        circew=circe.size.width-28;
        imgViewh=bodyImg.size.height-68;
        narginTop=12;
        fontf=32;
    }
    [self.bodyView setImage:bodyImg];
    self.bodyView.frame=CGRectMake(0, 0, frameW, imgViewh);
    CGFloat margin=(frameW-circew)/2;
    
    UIImageView *circlimg=[[UIImageView alloc]init];
    [circlimg setImage:circe];
    circlimg.frame=CGRectMake(0,0, circew, circeh);
    self.circleView.frame=CGRectMake(margin,btnImg.size.height+narginTop, circew, circeh);
    [self.circleView setBackgroundColor:[UIColor clearColor]];
    [self.circleView addSubview:circlimg];
    
    
    
    UILabel *hoerlab=[[UILabel alloc]init];
    hoerlab.font=[UIFont systemFontOfSize:fontf];
    hoerlab.textColor=SmaColor(195, 14, 46);
    hoerlab.text=@"00";
    [self.circleView addSubview:hoerlab];
    CGSize fontsize = [@"00" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontf]}];
    _showhour=hoerlab;
    
    UILabel *unitHour=[[UILabel alloc]init];
    unitHour.text=SmaLocalizedString(@"sleep_hour");
    unitHour.font=[UIFont systemFontOfSize:16];
    CGSize unitHourSize = [unitHour.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    unitHour.textColor=SmaColor(255, 255, 255);
    unitHour.center=CGPointMake(circew/2-10, circeh/2-10);
    unitHour.bounds=CGRectMake(0, 0, unitHourSize.width, unitHourSize.height);
    [self.circleView addSubview:unitHour];
    hoerlab.frame=CGRectMake(unitHour.frame.origin.x-fontsize.width,unitHour.frame.origin.y+(unitHourSize.height)-fontsize.height+10,fontsize.width, fontsize.height);
    
    
    
    UILabel *minslab=[[UILabel alloc]init];
    minslab.font=[UIFont systemFontOfSize:fontf];
    minslab.textColor=SmaColor(195, 14, 46);
    minslab.text=@"00";
    [self.circleView addSubview:minslab];
    minslab.frame=CGRectMake(unitHour.frame.origin.x+unitHourSize.width,unitHour.frame.origin.y+(unitHourSize.height)-fontsize.height+10,fontsize.width, fontsize.height);
    _showmins=minslab;
    
    UILabel *unitmins=[[UILabel alloc]init];
    unitmins.font=[UIFont systemFontOfSize:16];
    unitmins.textColor=SmaColor(255, 255, 255);
    unitmins.text=SmaLocalizedString(@"sport_minute");
     CGSize unitMinuteSize = [unitmins.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [self.circleView addSubview:unitmins];
    unitmins.frame=CGRectMake(minslab.frame.origin.x+minslab.frame.size.width,unitHour.frame.origin.y,unitMinuteSize.width, unitMinuteSize.height);
    
    
    UILabel *showlab=[[UILabel alloc]init];
    showlab.font=[UIFont systemFontOfSize:16];
    showlab.textColor=SmaColor(255, 255, 255);
    showlab.text=SmaLocalizedString(@"sleep_remark");
    CGSize showSize = [showlab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    showlab.center=CGPointMake(circew/2, circeh/2+14+unitHourSize.height*0.5);
    showlab.bounds=CGRectMake(0, 0, showSize.width, showSize.height);
    
    [self.circleView addSubview:showlab];
    
    // self.chartLab.frame=CGRectMake(margin,btnImg.size.height+narginTop, circew, circeh);
    // [self.imgView addSubview:self.chartView];
    // [self.imgView addSubview:self.chartLab];
    [self.bodyView addSubview:self.circleView];
    
    /*chart body  end*/
    /*foot  begin*/
    UIImage *footImg=[UIImage imageNamed:@"sleep_down_bg"];
    self.downIView.frame=CGRectMake(0, self.bodyView.frame.size.height,frameW, footImg.size.height);
    [self.view addSubview:self.downIView];
    
    
    self.remarkLab.font=[UIFont systemFontOfSize:15];
    CGSize fontsize1 = [self.remarkLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    
    
    CGFloat matop=9.5;
    CGFloat magbtTop=8;
    if(!fourInch)
    {
        matop=8;
        magbtTop=6;
    }
    self.planView.frame=CGRectMake(0, matop, frameW,fontsize1.height);
    self.remarkLab.frame=CGRectMake(frameW/2-fontsize1.width, 0.5, fontsize1.width, fontsize1.height);
    self.remarkLab.font=[UIFont fontWithName:@"HelveticaNeue" size:15];
    self.remarkLab.textColor=SmaColor(30, 30, 30);
    
    //    self.unitlable.frame=CGRectMake(self.planView.frame.size.width-fontsize.width, 0.5, fontsize.width, fontsize.height);
    //    self.unitlable.font=[UIFont fontWithName:@"HelveticaNeue" size:15];
    //    self.unitlable.textColor=SmaColor(30, 30, 30);
    
    self.sleepStatu.frame=CGRectMake(frameW/2+10,0,self.planView.frame.size.width-self.remarkLab.frame.size.width, fontsize1.height);
    
    self.sleepStatu.font=[UIFont fontWithName:@"HelveticaNeue" size:19];
    self.sleepStatu.textColor=SmaColor(195, 14, 46);
    self.sleepStatu.text=@"";
    self.sleepStatu.textAlignment=NSTextAlignmentLeft;
    //sport_Cuttingline_bg
    UIImage *lineImg=[UIImage imageNamed:@"sport_Cuttingline_bg"];
    UIImageView *line=[[UIImageView alloc]init];
    [line setImage:lineImg];
    line.frame=CGRectMake(83, 6+self.planView.frame.size.height+self.planView.frame.origin.y, frameW-166,0.5);
    
    [self.downIView addSubview:line];
    [self.planView addSubview:self.remarkLab];
    //[self.planView addSubview:self.unitlable];
    
    [self.downIView addSubview:self.planView];
    
    self.dataView.frame=CGRectMake(80, line.frame.size.height+line.frame.origin.y+12, frameW-167, self.downIView.frame.size.height-(self.planView.frame.size.height+self.planView.frame.origin.y+18));
    
    [self.downIView addSubview:self.dataView];
    
    UILabel *mileageBtn=[[UILabel alloc]init];
    mileageBtn.text = SmaLocalizedString(@"sleep_deep");
    mileageBtn.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize mileageBtnSize = [mileageBtn.text sizeWithAttributes:@{NSFontAttributeName:mileageBtn.font}];
    mileageBtn.frame=CGRectMake(0,2, mileageBtnSize.width,mileageBtnSize.height);

    
    
    NSString *mileage=[NSString stringWithFormat:@"%@ %@ %@ %@",@"0",SmaLocalizedString(@"sleep_hour"),@"0",SmaLocalizedString(@"sport_minute")];
    self.deepSleep.text=mileage;
    self.deepSleep.textColor=SmaColor(30, 30, 30);
    self.deepSleep.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize mileageSize = [self.deepSleep.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    self.deepSleep.frame=CGRectMake(mileageBtn.frame.size.width,mileageBtn.frame.origin.y,self.dataView.frame.size.width-mileageBtn.frame.size.width, mileageSize.height);
    self.deepSleep.textAlignment=NSTextAlignmentRight;
    
    [self.dataView addSubview:mileageBtn];
    
    
    
    UILabel *stepBtn=[[UILabel alloc]init];
    stepBtn.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    stepBtn.text = SmaLocalizedString(@"sleep_light");
    CGSize stepBtnSize = [stepBtn.text sizeWithAttributes:@{NSFontAttributeName:stepBtn.font}];
    stepBtn.frame=CGRectMake(0, 2*magbtTop+mileageBtn.frame.size.height+mileageBtn.frame.origin.y,stepBtnSize.width, stepBtnSize.height);
    [self.dataView addSubview:stepBtn];
    
    NSString *steps=[NSString stringWithFormat:@"%@ %@ %@ %@",@"0",SmaLocalizedString(@"sleep_hour"),@"0",SmaLocalizedString(@"sport_minute")];
    
    self.simpleSleep.text=steps;
    self.simpleSleep.textColor=SmaColor(30, 30, 30);
    self.simpleSleep.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize stepsSize = [self.simpleSleep.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    
    self.simpleSleep.frame=CGRectMake(mileageBtn.frame.size.width,2*magbtTop+mileageBtn.frame.size.height+mileageBtn.frame.origin.y,self.dataView.frame.size.width-mileageBtn.frame.size.width, stepsSize.height);
    
    [self.dataView addSubview:stepBtn];
    
    UILabel *calorieBtn=[[UILabel alloc]init];
    calorieBtn.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    calorieBtn.text = SmaLocalizedString(@"sleep_awake");
    CGSize calorieBtnSize = [calorieBtn.text sizeWithAttributes:@{NSFontAttributeName: calorieBtn.font}];
    
    calorieBtn.frame=CGRectMake(0,2*magbtTop+stepBtn.frame.size.height+stepBtn.frame.origin.y,calorieBtnSize.width, calorieBtnSize.height);

    
    
    NSString *hot=[NSString stringWithFormat:@"%@ %@ %@ %@",@"0",SmaLocalizedString(@"sleep_hour"),@"0",SmaLocalizedString(@"sport_minute")];
    
    self.soberSleep.text=hot;
    self.soberSleep.textColor=SmaColor(30, 30, 30);
    self.soberSleep.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize hotSize = [self.soberSleep.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    
    self.soberSleep.frame=CGRectMake(stepBtn.frame.size.width,2*magbtTop+stepBtn.frame.origin.y+stepBtn.frame.size.height, self.dataView.frame.size.width-stepBtn.frame.size.width, hotSize.height);
    self.soberSleep.textAlignment=NSTextAlignmentRight;
    [self.dataView addSubview:calorieBtn];
    
    
    /*foot  begin*/
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [SmaNotificationCenter removeObserver:self];
}

- (NSString *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MMM dd EEE";
    NSString *selfStr;
    NSString *today = [fmt stringFromDate:[NSDate date]];
    if ([today isEqualToString:[fmt stringFromDate:self.data]]) {
        selfStr = SmaLocalizedString(@"sleep_today");
    }
    else {
        selfStr= [fmt stringFromDate:self.data];
    }
    return selfStr;
    //    selfStr=[selfStr stringByReplacingOccurrencesOfString:@"月" withString:SmaLocalizedString(@"monthunit")];
    //    selfStr=[selfStr stringByReplacingOccurrencesOfString:@"日" withString:SmaLocalizedString(@"dayunit")];
    //    return selfStr;
}

-(NSString *)FormatStr:(NSString *)str
{
    NSString *month=SmaLocalizedString(@"monthunit");
    
    if([month isEqualToString:@""])
    {
        if([str rangeOfString:@"1月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"1月" withString:@"January "];
        }else if([str rangeOfString:@"2月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"2月" withString:@"February "];
        }else if([str rangeOfString:@"3月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"3月" withString:@"March "];
        }else if([str rangeOfString:@"4月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"4月" withString:@"April "];
        }else if([str rangeOfString:@"5月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"5月" withString:@"May "];
        }else if([str rangeOfString:@"6月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"6月" withString:@"June "];
        }else if([str rangeOfString:@"7月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"7月" withString:@"July "];
        }else if([str rangeOfString:@"8月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"8月" withString:@"August "];
        } else if([str rangeOfString:@"9月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"9月" withString:@"September "];
        }
        else if([str rangeOfString:@"10月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"10月" withString:@"October "];
        }
        else if([str rangeOfString:@"11月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"11月" withString:@"November "];
        }
        else if([str rangeOfString:@"12月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"12月" withString:@"December "];
        }
        str=[str stringByReplacingOccurrencesOfString:@"日" withString:SmaLocalizedString(@"dayunit")];
    }
    
    return str;
}


-(NSDate *)data
{
    if(_data==nil)
    {
        _data=[NSDate date];
    }
    return _data;
}
-(NSDate *)newdata
{
    _newdata=[NSDate date];
    return _newdata;
}
-(NSNumber *)datadiffer
{
    if(_datadiffer==nil)
    {
        _datadiffer=@10;
    }
    return _datadiffer;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
static  int  deffInt=10;
- (IBAction)rightBtnClick:(id)sender {
    if(deffInt<10)
    {
        deffInt++;
        NSDate *nextDate = [NSDate dateWithTimeInterval:(24*60*60*(deffInt-10)) sinceDate:self.newdata];
        _data=nextDate;
        self.datelab.text=[self dateWithYMD];
        
        [self refreshData];
    }
}

- (IBAction)leftBtnClick:(id)sender {
    if(deffInt>1)
    {
        deffInt--;
        NSDate *nextDate = [NSDate dateWithTimeInterval:-(24*60*60*(10-deffInt)) sinceDate:self.newdata];
        _data=nextDate;
        self.datelab.text=[self dateWithYMD];
        
        [self refreshData];
    }
}

- (void)updateUI{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    if (![[fmt stringFromDate:_nowDate] isEqualToString:[fmt stringFromDate:[NSDate date]]]) {
        self.data = [NSDate date];
        _nowDate = self.newdata;
    }
    self.datelab.text=[self dateWithYMD];
    [self refreshData];
}

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
    NSString *str=@"102";
    if([today intValue]==20150517)
    {
        str=@"123456";
    }
    NSMutableDictionary *dict=[dal getSleepDataDay:today yestday:yeday];
    if (!wear && [[fmt stringFromDate:self.data] isEqualToString:[fmt stringFromDate:[NSDate date]]]) {
        [dict removeAllObjects];
    }
    
    [self dealWithData:dict];
}
//3 未睡觉  2 浅睡 1 深睡
-(SmaSleepPackageInfo *)dealWithData:(NSMutableDictionary *)dict
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSData *nowDate = [NSData new];
    NSMutableArray *arrays=dict[@"entitys"];
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
    prevTime=0;//上一时间点
    prevData=0;//上一天数
    prevType=0;//上一类型
    soberAmount=0;//清醒时间
    simpleSleepAmount=0;//浅睡眠时长
    deepSleepAmount=0;//深睡时长
    deepTypeNum = 0;
    for (int i=0; i<arrays.count; i++) {
        SmaSleepInfo *info=(SmaSleepInfo *)arrays[i];
        if(i>0)
        {
            atType=[info.sleep_type intValue];
            int atTime=[info.sleep_time intValue];
            int amount=atTime-prevTime;
            if (atType == 3){
                deepTypeNum ++;
            }
            if(prevType==2 && (atType==1 || atType==3))//浅睡进入深睡觉或进未睡＝浅睡
            {
                simpleSleepAmount=simpleSleepAmount+amount;
                
            }else if(prevType==1 && (atType==3 || atType==2))
            {
                deepSleepAmount=deepSleepAmount+amount;
                
            }else if(prevType==3 && (atType==1 || atType==2))
            {
                soberAmount=soberAmount+amount;
            }
            
            
        }else
        {
            int beginSleep;
            beginSleep=[dict[@"begin"] intValue];
            if (beginSleep < 1320) {
                beginSleep = 1320;
            }
            prevTime=[info.sleep_time intValue];
            int amount1=prevTime-beginSleep;
            deepSleepAmount=deepSleepAmount+amount1;
        }
        
        prevData=[info.sleep_data intValue];
        prevTime=[info.sleep_time intValue];
        prevType=[info.sleep_type intValue];
    }
    int endSleep1=[dict[@"end"] intValue];
    NSLog(@"endSleep = %d   %@",endSleep1,nowDate);
    if(arrays.count>0 &&  prevTime!=endSleep1)
    {
        int amount1;
        if (prevTime > endSleep1) {
            amount1 = prevTime-endSleep1;
        }
        else{
            amount1=endSleep1-prevTime;
        }
        
        deepSleepAmount=deepSleepAmount+amount1;
    }
    
    if(arrays.count==0)
    {
        int beginSleep;
        beginSleep=[dict[@"begin"] intValue];
        if (beginSleep < 1320 && beginSleep>0) {
            beginSleep = 1320;
        }
        int endSleep=[dict[@"end"] intValue];
        if (endSleep >0 && endSleep>600) {
//            endSleep = 600;
        }
        deepSleepAmount=endSleep-beginSleep;
        if (beginSleep>0 && endSleep>0) {
            endSleep =endSleep - (endSleep/1440)*1440;
            beginSleep = beginSleep - (beginSleep/1440)*1440;
            if (endSleep > 600) {
                endSleep = 600;
            }
            if (beginSleep>endSleep) {
                deepSleepAmount = [NSString stringWithFormat:@"%d",1440-beginSleep+endSleep].intValue;
            }
            else{
                deepSleepAmount = [NSString stringWithFormat:@"%d",endSleep-beginSleep].intValue;
            }
        }
        
        
    }
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
    if (hour2 == 0 && arrays.count ==0) {
        hour2 = 0;
    }
    slBeTime = hour1;
    slEnTime = hour2;

    NSString *openNum = [SmaUserDefaults stringForKey:@"SetAppNum"];
    int num = [openNum substringFromIndex:8].intValue;
    if (deepTypeNum == 1 && !sleepAler && [[fmt stringFromDate:self.data] isEqualToString:[fmt stringFromDate:[NSDate date]]] && num < 3 ) {
        sleepAler = [[UIAlertView alloc]initWithTitle:SmaLocalizedString(@"alert_title") message:SmaLocalizedString(@"alera_msg") delegate:self cancelButtonTitle:SmaLocalizedString(@"alera_no") otherButtonTitles:SmaLocalizedString(@"alera_yes"), nil];
        sleepAler.delegate = self;
        [sleepAler show];
    }
    else{
        [self updateSleepData:@"0"];
    }
    
    
    return pInfo;
}

- (void)updateSleepData:(NSString *)sleepStye{
     int simSleep;
    if ([sleepStye isEqualToString:@"1"]) {
        
        self.deepSleep.text=[NSString stringWithFormat:@"0 %@ 0 %@",SmaLocalizedString(@"sleep_hour"),SmaLocalizedString(@"sport_minute")];
        self.simpleSleep.text=[NSString stringWithFormat:@"0 %@ 0 %@",SmaLocalizedString(@"sleep_hour"),SmaLocalizedString(@"sport_minute")];
        self.soberSleep.text=[NSString stringWithFormat:@"0 %@ 0 %@",SmaLocalizedString(@"sleep_hour"),SmaLocalizedString(@"sport_minute")];
        
    }
    
    else{
        if (slBeTime >= 1320 && slBeTime<= 1440) {
            simSleep = 1440 - slBeTime + slEnTime;
            
        }
        else{
            simSleep = slEnTime - slBeTime;
        }

        self.deepSleep.text=[NSString stringWithFormat:@"%d %@ %d %@",deepSleepAmount/60,SmaLocalizedString(@"sleep_hour"),deepSleepAmount%60,SmaLocalizedString(@"sport_minute")];
        self.simpleSleep.text=[NSString stringWithFormat:@"%d %@ %d %@",simpleSleepAmount/60,SmaLocalizedString(@"sleep_hour"),simpleSleepAmount%60,SmaLocalizedString(@"sport_minute")];
        self.soberSleep.text=[NSString stringWithFormat:@"%d %@ %d %@",soberAmount/60,SmaLocalizedString(@"sleep_hour"),soberAmount%60,SmaLocalizedString(@"sport_minute")];
    }
    int sleepSum=simSleep;
    int hour=[sleepStye isEqualToString:@"1"]  ? 0 : sleepSum/60;
    if(hour>=10)
    {
        self.showhour.text=[NSString stringWithFormat:@"%d",hour];
    }else{
        self.showhour.text=[NSString stringWithFormat:@"%@%d",@"0",hour];
    }
    
    int mins= [sleepStye isEqualToString:@"1"] ? 0 : sleepSum%60;
    if(mins>=10)
    {
        self.showmins.text=[NSString stringWithFormat:@"%d",mins];
    }else{
        self.showmins.text=[NSString stringWithFormat:@"%@%d",@"0",mins];
    }
    
    int aconst=deepSleepAmount/60;
    NSString *sleepState=@"";
    if(aconst>=0 && aconst<3)
    {
        sleepState=SmaLocalizedString(@"sleep_state_poor");
        
    }else if(aconst>=3 && aconst<=6)
    {
        sleepState=SmaLocalizedString(@"sleep_state_average");
    }else if(aconst>=6 && aconst<9)
    {
        sleepState=SmaLocalizedString(@"sleep_state_comfortable");
        
    }else if(aconst>=9 && aconst<11)
    {
        sleepState=SmaLocalizedString(@"sleep_state_enough");
        
    }else
    {
        sleepState=SmaLocalizedString(@"sleep_state_lazy");
    }
    self.sleepStatu.text=sleepState;
    
    
}

#pragma mark ----------UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
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
    if (buttonIndex == 0) {
        [self updateSleepData:@"1"];
        [dal updateSleepData:today yestday:yeday iswear:NO];
        wear = NO;
    }
    else if (buttonIndex == 1){
        [self updateSleepData:@"0"];
        [dal updateSleepData:today yestday:yeday iswear:YES];
        wear = YES;
    }
    
}



@end
