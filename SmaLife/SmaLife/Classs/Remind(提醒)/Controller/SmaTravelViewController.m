//
//  SmaTravelViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/13.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaTravelViewController.h"
#import "popupMultiSelect.h"
#import "SmaSeatInfo.h"//久坐对象
#import "SmaAccountTool.h"
#import "SmaSeatInfo.h"

@interface SmaTravelViewController ()<popupMultiSelectDelegate>

@property (nonatomic,weak) UIView *weekView;
@property (nonatomic,strong) popupMultiSelect *pow;
@property (nonatomic,strong) NSMutableArray *weekArray;
@property (nonatomic,weak) UIDatePicker *beginTimePicker;
@property (nonatomic,weak) UIDatePicker *endTimePicker;
//久坐时间
@property (nonatomic,weak) UISlider *seatSlider;
//久坐值
@property (nonatomic,weak) UILabel *seatValue;
//步数阈值
@property (nonatomic,weak) UISlider *stepSlider;
//步数值
@property (nonatomic,weak) UILabel *stepValue;
@end

@implementation SmaTravelViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed=YES;
    [self loadTimeView];
    
}
-(NSMutableArray *)weekArray
{
   if(_weekArray==nil)
   {
       _weekArray=[NSMutableArray array];
   }
    return _weekArray;
}

-(void)loadTimeView
{

    int h=90;
    if(fourInch)
    {
        h=120;
        self.clockView.frame=CGRectMake(self.clockView.frame.origin.x, self.clockView.frame.origin.y, self.clockView.frame.size.width, self.clockView.frame.size.height+(30*2));
    }
    
    SmaSeatInfo *info=[SmaAccountTool seatInfo];
    
    UILabel *beginLab=[[UILabel alloc]init];
    beginLab.frame=CGRectMake(80, 5, 160, 20);
    beginLab.textAlignment=NSTextAlignmentCenter;
    beginLab.text=@"开始时间";
    beginLab.textColor=[UIColor whiteColor];
    [self.view addSubview:beginLab];
    
    UIView *timeView= [[UIView alloc]init];
    timeView.frame=CGRectMake(20, 30, 280,h);
    [self.view addSubview:timeView];
    UIImageView *beginTime=[[UIImageView alloc]init];
    [beginTime setImage:[UIImage imageNamed:@"begintime_bg"]];
    beginTime.frame=CGRectMake(0, 0, 280, h);
    [timeView addSubview:beginTime];
    beginTime.userInteractionEnabled = YES;
    
    UIDatePicker *beginDatePicker = [[UIDatePicker alloc] init];
    beginDatePicker.center=CGPointMake(120, h/2);
    beginDatePicker.bounds = CGRectMake(0, 0, 280, h);
    beginDatePicker.datePickerMode=UIDatePickerModeTime;

    if(info.beginTime)
    {
      NSString* string =info.beginTime;
      NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
      //en_US
      [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"]];
      [inputFormatter setDateFormat:@"HH"];
      // [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
      NSDate* inputDate = [inputFormatter dateFromString:string];
      beginDatePicker.date=inputDate;
    }
    //设置中文显示
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    [beginDatePicker setLocale:locale];

    [beginTime addSubview:beginDatePicker];
    _beginTimePicker=beginDatePicker;
    beginTime.clipsToBounds=YES;
    
    UILabel *endLab=[[UILabel alloc]init];
    endLab.frame=CGRectMake(80, h+35, 160, 20);
    endLab.textAlignment=NSTextAlignmentCenter;
    endLab.text=@"结束时间";
    endLab.textColor=[UIColor whiteColor];
    [self.view addSubview:endLab];
    
    UIView *endView= [[UIView alloc]init];
    endView.frame=CGRectMake(20,h+60, 280, h);
    [self.view addSubview:endView];
    UIImageView *endTime=[[UIImageView alloc]init];
    [endTime setImage:[UIImage imageNamed:@"begintime_bg"]];
    endTime.frame=CGRectMake(0, 0, 280, h);
    [endView addSubview:endTime];
    endTime.userInteractionEnabled = YES;
    
    UIDatePicker *endDatePicker = [[UIDatePicker alloc] init];
    endDatePicker.center=CGPointMake(120, h/2);
    endDatePicker.bounds = CGRectMake(0, 0, 280, h);
    endDatePicker.datePickerMode=UIDatePickerModeTime;
    //设置中文显示
    NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    [endDatePicker setLocale:locale1];
    [endTime addSubview:endDatePicker];
    _endTimePicker=endDatePicker;
    if(info.endTime)
    {
        NSString* string =info.endTime;
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        //en_US
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"]];
        [inputFormatter setDateFormat:@"HH"];
        // [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSDate* inputDate = [inputFormatter dateFromString:string];
        endDatePicker.date=inputDate;
    }
    
    endTime.clipsToBounds=YES;
    
    UIView *week=[[UIView alloc]init];
    
    week.frame=CGRectMake(0,self.clockView.frame.origin.y+self.clockView.frame.size.height-20,self.view.frame.size.width,20);
    [self.view addSubview:week];
    _weekView=week;
    [self loadWeekLab];
    [self showUISlider];
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
    //pow.delegate=self;
    SmaSeatInfo *info=[SmaAccountTool seatInfo];
    if(!info.pepeatWeek || [info.pepeatWeek isEqualToString:@""])
      info.pepeatWeek=@"0,0,0,0,0,0,0";
  
    self.weekArray=nil;
        NSArray *aTest = [NSArray array];
    if(!info)
       aTest =  [@"0,0,0,0,0,0,0" componentsSeparatedByString:@","];
    else
       aTest = [info.pepeatWeek componentsSeparatedByString:@","];
    

    for (int i=0; i<aTest.count; i++) {
        [self.weekArray addObject:aTest[i]];
    }
    pow.dataArray=self.weekArray;
    CGFloat y1=self.clockView.frame.origin.y+self.clockView.frame.size.height;
    pow.frame=CGRectMake(10,y1,300,self.view.frame.size.height-y1-5);
    pow.scrolHeight=@280;
        pow.delegate=self;
    //[pow setContentSize:CGSizeMake(300,420)];
    
    [self.view addSubview:pow];
    }else{
        NSLog(@"对象已经存在");
    }
}

-(void)showUISlider
{
    SmaSeatInfo *info=[SmaAccountTool seatInfo];
    UIImageView *sliderView=[[UIImageView alloc]init];
    sliderView.frame=CGRectMake(10, self.weekView.frame.origin.y+self.weekView.frame.size.height+10, self.view.frame.size.width-20,120);
    [sliderView setImage:[UIImage imageNamed:@"time_seleect_bg"]];
    [self.view addSubview:sliderView];
    sliderView.userInteractionEnabled=YES;
    
    
    UILabel *lable=[[UILabel alloc]init];
    lable.text=@"久坐时间";
    lable.frame=CGRectMake(5, 20, 70, 20);
    [sliderView addSubview:lable];
    
    UISlider *seatTime=[[UISlider alloc]init];
    UIImage *img=[UIImage imageNamed:@"sliderBtn"];
    CGSize size={img.size.width*0.3,img.size.height*0.3};
    
    UIImage *thumbImage = [UIImage imageByScalingAndCroppingForSize:size imageName:@"sliderBtn"];
    [seatTime setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [seatTime setThumbImage:thumbImage forState:UIControlStateNormal];
    
    /*数植*/
    UILabel *valueLab1=[[UILabel alloc]init];
    valueLab1.text=@"0";
    valueLab1.textAlignment=NSTextAlignmentRight;
    valueLab1.frame=CGRectMake((self.view.frame.size.width-20)/2-35,5, 70, 20);
    [sliderView addSubview:valueLab1];
    UILabel *unitLab1=[[UILabel alloc]init];
    unitLab1.text=@"min";
    unitLab1.font=[UIFont systemFontOfSize:8];
    unitLab1.textAlignment=NSTextAlignmentLeft;
    unitLab1.frame=CGRectMake((self.view.frame.size.width-20)/2+35,5, 70, 20);
    [sliderView addSubview:unitLab1];
    _seatValue=valueLab1;


    
    UIImage *img1=[UIImage imageNamed:@"slider_img_bg"];
    CGSize size1={img1.size.width*0.5,img1.size.height*0.5};
    UIImage *thumbImage1 = [UIImage imageByScalingAndCroppingForSize:size1 imageName:@"slider_img_bg"];

    UIColor *bgColor=[UIColor colorWithPatternImage:thumbImage1];
    [seatTime setBackgroundColor:bgColor];
    [seatTime setMaximumTrackTintColor:[UIColor clearColor]];
    [seatTime setMinimumTrackTintColor:[UIColor clearColor]];
    seatTime.center=CGPointMake(self.view.frame.size.width/2,25);
    seatTime.frame=CGRectMake(80,25, 210, 5);
    UIImageView *line1=[[UIImageView alloc]init];
    [line1 setImage:[UIImage imageNamed:@"week_select_line_bg"]];
    line1.frame=CGRectMake(80,32, 210, 1);
    [sliderView addSubview:line1];
    
    [sliderView addSubview:seatTime];
    seatTime.maximumValue=12;
    seatTime.minimumValue=0;
    if(info.seatValue)
    {
        valueLab1.text=info.seatValue;
        seatTime.value=[info.seatValue floatValue]/30;
    }
    _seatSlider=seatTime;
    [seatTime addTarget:self action:@selector(seatChange) forControlEvents:UIControlEventValueChanged];
    
    
    UILabel *steplab=[[UILabel alloc]init];
    steplab.text=@"步数阈值";
    steplab.frame=CGRectMake(5, 80, 70, 20);
    [sliderView addSubview:steplab];
    
    UISlider *endTime=[[UISlider alloc]init];
    [endTime setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [endTime setThumbImage:thumbImage forState:UIControlStateNormal];
    
    
    /*显示*/
    UILabel *valueLab2=[[UILabel alloc]init];
    valueLab2.text=@"0";
    valueLab2.textAlignment=NSTextAlignmentRight;
    valueLab2.frame=CGRectMake((self.view.frame.size.width-20)/2-35,60, 70, 20);
    [sliderView addSubview:valueLab2];
    UILabel *unitLab2=[[UILabel alloc]init];
    unitLab2.text=@"步";
    unitLab2.font=[UIFont systemFontOfSize:8];
    unitLab2.textAlignment=NSTextAlignmentLeft;
    unitLab2.frame=CGRectMake((self.view.frame.size.width-20)/2+35,60, 70, 20);
    [sliderView addSubview:unitLab2];

    _stepValue=valueLab2;
   

    [endTime setBackgroundColor:bgColor];
    [endTime setMaximumTrackTintColor:[UIColor clearColor]];
    [endTime setMinimumTrackTintColor:[UIColor clearColor]];
    endTime.center=CGPointMake(self.view.frame.size.width/2,25);
    endTime.frame=CGRectMake(80,85, 210, 5);
    UIImageView *line2=[[UIImageView alloc]init];
    [line2 setImage:[UIImage imageNamed:@"week_select_line_bg"]];
    line2.frame=CGRectMake(80,92, 210, 1);
    [sliderView addSubview:line2];
    [sliderView addSubview:endTime];
    endTime.maximumValue=12;
    endTime.minimumValue=0;
     [endTime addTarget:self action:@selector(stepChange) forControlEvents:UIControlEventValueChanged];
    if(info.stepValue)
    {
        valueLab2.text=info.stepValue;
        endTime.value=[info.stepValue floatValue]/10;
    }
    _stepSlider=endTime;

}
//阈值变化
-(void)seatChange
{
    NSString *value=[NSString stringWithFormat:@"%d",(int)((self.seatSlider.value+0.5)/1)*30];
    self.seatValue.text=value;
}

//阈值变化
-(void)stepChange
{
    NSString *value=[NSString stringWithFormat:@"%d",(int)((self.stepSlider.value+0.5)/1)*10];
    self.stepValue.text=value;
}

-(void)showPop
{
    [self popSelectView];
}

-(void)closeClick
{
    self.pow=nil;
}
-(void)submitClick
{
    self.pow=nil;
    [self saveSeat];
    
}
-(void)saveSeat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *bTime = [dateFormatter stringFromDate:self.beginTimePicker.date];
    NSString *eTime = [dateFormatter stringFromDate:self.endTimePicker.date];
    
    SmaSeatInfo *seatInfo=[[SmaSeatInfo alloc]init];
    seatInfo.beginTime=bTime;
    seatInfo.endTime=eTime;
    seatInfo.seatValue=self.seatValue.text;
    seatInfo.stepValue=self.stepValue.text;
    seatInfo.isOpen=@"1";
    seatInfo.pepeatWeek=[self jointWeek];
    [SmaAccountTool saveSeat:seatInfo];
    if([SmaBleMgr checkBleStatus])
    {
        [SmaBleMgr seatLongTimeInfo:seatInfo];
    }
}
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
