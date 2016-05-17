//
//  SmaTravelViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/13.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaAlarmClockViewController.h"
#import "popupMultiSelect.h"
#import "SmaSeatInfo.h"//久坐对象
#import "SmaAccountTool.h"
#import "SmaSeatInfo.h"
//闹钟对象
#import "SmaAlarmInfo.h"

@interface SmaAlarmClockViewController ()<popupMultiSelectDelegate,SetSamCoreBlueToolDelegate>

@property (nonatomic,weak) UIView *weekView;
@property (nonatomic,weak) UIScrollView *alarmrScroll;
@property (nonatomic,strong) popupMultiSelect *pow;
@property (nonatomic,strong) NSMutableArray *weekArray;
@property (nonatomic,weak) UIDatePicker *beginTimePicker;
@property (nonatomic,strong) NSMutableArray *alarsInfos;
@property (nonatomic,strong) SmaAlarmInfo *atAlarmInfo;
@end

@implementation SmaAlarmClockViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed=YES;
    
    UIButton *subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [subButton setTitle:@"提交" forState:normal];
    [subButton addTarget:self action:@selector(sumSendAlarm) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *subButtonItem = [[UIBarButtonItem alloc] initWithCustomView:subButton];
    self.navigationItem.rightBarButtonItem = subButtonItem;
    
    [self loadTimeView];
    //请求闹钟列表
    [self getAlars];
    
}
//设置闹钟请求
-(void)sumSendAlarm
{
   //发送闹钟请求
   [SmaBleMgr setCalarmClockInfo:self.alarsInfos];
    
}
-(NSMutableArray *)weekArray
{
    if(_weekArray==nil)
    {
        _weekArray=[NSMutableArray array];
    }
    return _weekArray;
}
//闹钟列表存储对象
-(NSMutableArray *)alarsInfos
{
    if(_alarsInfos==nil)
    {
        _alarsInfos=[NSMutableArray array];
    }
    return _alarsInfos;
}
//从蓝牙中获取闹钟列表
-(void)getAlars{
    if(SmaBleMgr.checkBleStatus)
    {
        SmaBleMgr.delegate=self;
       //请求获取蓝牙列表
        NSLog(@"这里");
       [SmaBleMgr getCalarmClockList];

        
    }else{
        [self showClockList];
    }
}

-(void)dlgReturnAlermList:(NSMutableArray *)alermArray
{
    NSLog(@"到了....................");
    self.alarsInfos=alermArray;
    //加载闹钟列表
    [self showClockList];
}

-(void)loadTimeView
{
    UIView *timeView= [[UIView alloc]init];
    timeView.frame=CGRectMake(20, 30, 280,200);
    [self.view addSubview:timeView];
    UIImageView *beginTime=[[UIImageView alloc]init];
    [beginTime setImage:[UIImage imageNamed:@"begintime_bg"]];
     beginTime.frame=CGRectMake(0, 0, 280, 200);
    [timeView addSubview:beginTime];
    beginTime.userInteractionEnabled = YES;
    
    UIDatePicker *beginDatePicker = [[UIDatePicker alloc] init];
    beginDatePicker.center=CGPointMake(120, 100);
    beginDatePicker.bounds = CGRectMake(0, 0, 280, 200);
    beginDatePicker.datePickerMode=UIDatePickerModeTime;
    
    

    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    [beginDatePicker setLocale:locale];

    [beginTime addSubview:beginDatePicker];
    _beginTimePicker=beginDatePicker;
    beginTime.clipsToBounds=YES;
    
    UIView *week=[[UIView alloc]init];
    week.frame=CGRectMake(0,245,self.view.frame.size.width,20);
    [self.view addSubview:week];
    _weekView=week;
    [self loadWeekLab];
}
-(void)loadWeekLab
{
    UILabel *lab=[[UILabel alloc]init];
    lab.frame=CGRectMake(20,0,40,20);
    lab.text=@"重复";
    [self.weekView addSubview:lab];
    UIButton *weekbtn=[[UIButton alloc]init];
    weekbtn.frame=CGRectMake(self.weekView.frame.size.width-50,0,20,15);
    [weekbtn setBackgroundImage:[UIImage imageNamed:@"show_weekselect_button_bg"] forState:UIControlStateNormal];
    [weekbtn addTarget:self action:@selector(showPop) forControlEvents:UIControlEventTouchUpInside];
    [self.weekView addSubview:weekbtn];
}
-(void)popSelectView
{
    if(!self.pow)
    {
        popupMultiSelect *pow=[[popupMultiSelect alloc] init];
        _pow=pow;
        
        pow.delegate=self;
        SmaAlarmInfo *info=[[SmaAlarmInfo alloc]init];
        if(!info.dayFlags || [info.dayFlags isEqualToString:@""])
            info.dayFlags=@"0,0,0,0,0,0,0";
        
        self.weekArray=nil;
        NSArray *aTest = [info.dayFlags componentsSeparatedByString:@","];
        for (int i=0; i<aTest.count; i++) {
            [self.weekArray addObject:aTest[i]];
        }
        pow.dataArray=self.weekArray;
        CGFloat y1=self.weekView.frame.origin.y+self.weekView.frame.size.height;
        CGFloat h=self.view.frame.size.height-y1-10;
        pow.frame=CGRectMake(10,275,300,h);
        
        pow.scrolHeight=@280;
        [self.view addSubview:pow];
    }else{
        NSLog(@"对象已经存在");
    }
}

-(void)showClockList
{
  
    UIImageView *sliderView=[[UIImageView alloc]init];
    
    sliderView.frame=CGRectMake(10, self.weekView.frame.origin.y+self.weekView.frame.size.height+10, self.view.frame.size.width-20,180);
    [sliderView setImage:[UIImage imageNamed:@"time_seleect_bg"]];
    [self.view addSubview:sliderView];
    sliderView.userInteractionEnabled=YES;

    UIScrollView *colokScroll=[[UIScrollView alloc]init];
   
    colokScroll.frame=CGRectMake(10, self.weekView.frame.origin.y+self.weekView.frame.size.height+10, self.view.frame.size.width-20,180);
    colokScroll.contentSize=CGSizeMake(300.0f,280.0f);
    [self.view addSubview:colokScroll];
    
   // CGFloat labW=sliderView.frame.size.width-40;
    _alarmrScroll=colokScroll;
    if(self.alarsInfos.count==0)
    {
        UILabel *uila=[[UILabel alloc]init];
        uila.text=@"暂无闹钟";
        uila.textAlignment=NSTextAlignmentCenter;
        uila.center=CGPointMake(sliderView.frame.size.width/2, sliderView.frame.size.height/2);
        uila.bounds=CGRectMake(0,0,120,50);
        [colokScroll addSubview:uila];
    }
    else{
        [self createAlarm];
    }
}



-(void)showPop
{
    [self popSelectView];
}

-(void)closeClick
{
    self.pow=nil;
}
//确定重复的
-(void)submitClick
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    for (int i=2; i<self.weekView.subviews.count; i++) {
        [((UILabel *)self.weekView.subviews[i]) removeFromSuperview];
        i--;
    }
    SmaAlarmInfo *info=[[SmaAlarmInfo alloc]init];
    info.year=[NSString stringWithFormat:@"%d",[dateComponent year]];
    info.mounth=[NSString stringWithFormat:@"%d",[dateComponent month]];
    info.day=[NSString stringWithFormat:@"%d",[dateComponent day]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *hosur = [dateFormatter stringFromDate:self.beginTimePicker.date];
    info.hour=hosur;
    NSDateFormatter *dateminuteFormatter = [[NSDateFormatter alloc] init];
    [dateminuteFormatter setDateFormat:@"mm"];
    NSString *minute = [dateminuteFormatter stringFromDate:self.beginTimePicker.date];
    info.minute=minute;
    
    self.pow=nil;
    for (int i=0; i<self.weekArray.count; i++) {
        if([self.weekArray[i] isEqual:@"1"])
        {
            UILabel *lable=[[UILabel alloc]init];
            lable.text=[self stringWith:i];
            lable.font=[UIFont systemFontOfSize:12];
            lable.frame=CGRectMake(30+40*(self.weekView.subviews.count-1),0,40,20);
            [self.weekView addSubview:lable];
        }
    }
    info.dayFlags=[self jointWeek];
    [self.alarsInfos addObject:info];

     NSLog(@"提交了闹钟");
    [self createAlarm];
    [self saveSeat];
    
}


-(void)createAlarm
{
     NSLog(@"设置界面");
    CGFloat labW=self.alarmrScroll.frame.size.width-40;
    for (int i=0; i<self.alarmrScroll.subviews.count; i++) {
        [self.alarmrScroll.subviews[i] removeFromSuperview];
        i--;
    }
   
    for (int i=0; i<self.alarsInfos.count; i++) {
        SmaAlarmInfo *info= (SmaAlarmInfo *)self.alarsInfos[i];
       
        int aid=i;//[NSString stringWithFormat:@"%d",i];
//        if(![info.aid isEqualToString:@""] && info.aid)
//            aid=i;
        
        
        NSString *str=[NSString stringWithFormat:@"%@  %@:%@",[self stringAlarm:aid],info.hour,info.minute];
        UIButton *updateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [updateBtn setTitle:str forState:UIControlStateNormal];
        [updateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        updateBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        updateBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
        updateBtn.frame=CGRectMake(10,i*40, labW, 40);
        [updateBtn addTarget:self action:@selector(updateAlarm:) forControlEvents:UIControlEventTouchUpInside];
        updateBtn.tag=i;
        [self.alarmrScroll addSubview:updateBtn];
        
        UIImageView *line=[[UIImageView alloc]init];
        [line setImage:[UIImage imageNamed:@"week_select_line_bg"]];
        line.frame=CGRectMake(10,(i+1)*40-5, labW+20, 1);
        [self.alarmrScroll addSubview:line];
        
        UIButton *checkbox = [[UIButton alloc] init];
        [checkbox addTarget:self action:@selector(removeAlarm:) forControlEvents:UIControlEventTouchUpInside];
        checkbox.tag=i;
        
        [checkbox setImage:[UIImage imageNamed:@"clock_del_button"] forState:UIControlStateNormal];
        [checkbox setImage:[UIImage imageNamed:@"clock_del_button_h"] forState:UIControlStateHighlighted];
        checkbox.frame=CGRectMake(labW,i*40+10, 20, 20);
        [self.alarmrScroll addSubview:checkbox];
    }
}
//修改闹钟
-(void)removeAlarm:(id)sender{
    
    [self.alarsInfos removeObject:self.alarsInfos[[sender tag]]];
    [self createAlarm];
}
//修改闹钟
-(void)updateAlarm:(id)sender{
    SmaAlarmInfo *info=self.alarsInfos[[sender tag]];
    
    _atAlarmInfo=info;
}
//发送
-(void)saveSeat
{
  [SmaBleMgr setCalarmClockInfo:self.alarsInfos];
}
//周
-(NSString *)stringWith:(int)weekInt
{
    NSString *weekStr=@"";
      switch (weekInt) {
          case 0:
                weekStr= @"一";
                break;
          case 1:
                weekStr= @"二";
                break;
          case 2:
                weekStr= @"三";
                break;
          case 3:
                weekStr= @"四";
                break;
          case 4:
                weekStr= @"五";
                break;
          case 5:
                weekStr= @"六";
                break;
          default:
                weekStr= @"天";
     }
    return weekStr;
}
-(NSString *)stringAlarm:(int)weekInt
{
    NSString *weekStr=@"";
    switch (weekInt) {
        case 0:
            weekStr= @"闹钟一";
            break;
        case 1:
            weekStr= @"闹钟二";
            break;
        case 2:
            weekStr= @"闹钟三";
            break;
        case 3:
            weekStr= @"闹钟四";
            break;
        case 4:
            weekStr= @"闹钟五";
            break;
        case 5:
            weekStr= @"闹钟六";
            break;
        case 6:
            weekStr= @"闹钟七";
            break;
        default:
            weekStr= @"闹钟八";
    }
    return weekStr;
}

//组装周数字符串
-(NSString *)jointWeek
{
    NSString *weekStr=@"";
    for (int i=0; i<self.weekArray.count; i++) {
        if(i==6)
            weekStr=[weekStr stringByAppendingFormat:@"%@",self.weekArray[i]];
        else
            weekStr=[weekStr stringByAppendingFormat:@"%@%@",self.weekArray[i],@","];
        
    }
    return weekStr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
