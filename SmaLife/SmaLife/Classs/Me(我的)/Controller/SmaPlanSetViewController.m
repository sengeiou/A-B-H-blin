//
//  SmaPlanSetViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/13.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaPlanSetViewController.h"

@interface SmaPlanSetViewController ()
@property (nonatomic,retain) NSNumber *seatAmount;
@property (nonatomic,retain) NSNumber *distanceAmount;
@property (nonatomic,retain) NSNumber *calorieAmount;
@property (nonatomic,retain) NSNumber *amountAmount;
@property (nonatomic,retain) NSNumber *sleepAmount;


@property (nonatomic,strong) UILabel *seatlable;
@property (nonatomic,strong) UILabel *distancelable;
@property (nonatomic,strong) UILabel *calorielable;

@property (nonatomic,strong) UILabel *seatunitlable;
@property (nonatomic,strong) UILabel *distanceunitlable;
@property (nonatomic,strong) UILabel *calorielunitable;
@property (nonatomic,strong) UILabel *hoserunitable;
@property (nonatomic,strong) UILabel *minuteunitable;

@property (nonatomic,strong) UILabel *hoserlable;
@property (nonatomic,strong) UILabel *minutelable;

@property (nonatomic,strong) UISlider *seatSlider;
@property (nonatomic,strong) UISlider *distanceSlider;
@property (nonatomic,strong) UISlider *calorielSlider;
@property (nonatomic,strong) UISlider *sleepSlider;

@property (nonatomic,strong) NSNumber *distancePoint;//距离换算点

@property (nonatomic,strong) NSNumber *caloriePoint;//卡路里换算点

@property (nonatomic,strong) NSNumber *weight;//体重

@end

@implementation SmaPlanSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setConversionPoint];
    self.title=@"运动目标";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"plan_navigation_bg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_button_share" highIcon:@"nav_button_share_highlight" target:self action:@selector(submitClick)];
    
    UIImageView *imgView=[[UIImageView alloc]init];
    [imgView setImage:[UIImage imageNamed:@"plan_imgView_bg"]];
    imgView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:imgView];
    
    [self loadSportView];
    
    [self loadSleep];
    
     NSString *stepPlan = [SmaUserDefaults objectForKey:@"stepPlan"]; //获取计步目标
    if (!stepPlan || [stepPlan isEqualToString:@""]) {
        stepPlan = @"7";
    }
    [self setSliderView:stepPlan.intValue];
    int sleeppPlan= [SmaUserDefaults integerForKey:@"sleepPlan"];//获取设置睡眠目标
    [self sleeplayout:sleeppPlan];
  
    
}
//获取换算点
-(void)setConversionPoint
{
    self.distancePoint=@700;
    self.caloriePoint=@0.53;
    self.weight=@55;
    SmaUserInfo *info=[SmaAccountTool userInfo];
    if(info!=nil)
    {
        if([info.sex intValue]==1)
        {
            self.distancePoint=@750;
            self.caloriePoint=@0.55;
        }
        else
        {
           self.distancePoint=@650;
            self.caloriePoint=@0.46;
        }
   
        if([info.weight intValue]>0)
        {
      
           self.weight=[NSNumber numberWithInt:[info.weight intValue]];
        }
    }
}


//记步目标
-(void)submitClick
{
    if([SmaBleMgr checkBleStatus])
    {
        if(self.seatAmount!=nil && [self.seatAmount intValue]>0)
        {
            MyLog(@"%d",[self.seatAmount intValue]);
            [SmaBleMgr setStepNumber:[self.seatAmount intValue]*300];
            [SmaUserDefaults setObject:[NSString stringWithFormat:@"%@",self.seatAmount] forKey:@"stepPlan"];//设置计步目标
            
            [MBProgressHUD showMessage:@"设定成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
        }
    }
    //睡觉目标
    [SmaUserDefaults setInteger:[self.sleepAmount intValue] forKey:@"sleepPlan"];//设置睡眠目标
}


-(void)loadSportView
{
    
    CGFloat marginLeft=5;
    CGFloat center=self.view.frame.size.width/2;
    UILabel *sportLab=[[UILabel alloc]init];
    sportLab.text=@"运动";
    sportLab.center=CGPointMake(center, 20);
    sportLab.bounds=CGRectMake(0, 0, 60, 20);
    sportLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:sportLab];
    
    UIImageView *soprtView=[[UIImageView alloc]init];
    [soprtView setImage:[UIImage imageNamed:@"sport_view_bg"]];
    soprtView.frame=CGRectMake(marginLeft, 40, self.view.frame.size.width-2*marginLeft, self.view.frame.size.height*0.3);
    [self.view addSubview:soprtView];
    soprtView.userInteractionEnabled=YES;
    
    CGFloat y=(self.view.frame.size.height*0.3)/4;
    CGFloat labW=45;
    
    CGFloat leftM=40;
    UILabel *sportLableft=[[UILabel alloc]init];
    sportLableft.text=@"步数";
    
    sportLableft.font=[UIFont systemFontOfSize:14];
    sportLableft.frame=CGRectMake(marginLeft,3*y-10, labW, 20);
    [soprtView addSubview:sportLableft];
    
    UISlider *seatTime=[[UISlider alloc]init];
    UIImage *img=[UIImage imageNamed:@"step_slider_button_bg"];
    CGSize size={img.size.width*0.5,img.size.height*0.5};
    seatTime.minimumValue=0;
    seatTime.maximumValue=100;
    _seatSlider=seatTime;
    [seatTime addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIImage *thumbImage = [UIImage imageByScalingAndCroppingForSize:size imageName:@"step_slider_button_bg"];
    [seatTime setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [seatTime setThumbImage:thumbImage forState:UIControlStateNormal];
    
    UIImage *img1=[UIImage imageNamed:@"step_slider_bg"];
    CGSize size1={img1.size.width*0.5,img.size.height*0.5};
    UIImage *thumbImage1 = [UIImage imageByScalingAndCroppingForSize:size1 imageName:@"step_slider_bg"];
    
    UIColor *bgColor=[UIColor colorWithPatternImage:thumbImage1];
    [seatTime setBackgroundColor:bgColor];
    [seatTime setMaximumTrackTintColor:[UIColor clearColor]];
    [seatTime setMinimumTrackTintColor:[UIColor clearColor]];
    seatTime.center=CGPointMake(self.view.frame.size.width/2,25);
    seatTime.frame=CGRectMake(labW+2*marginLeft,3*y,self.view.frame.size.width-labW-(5*marginLeft), 5);
    [soprtView addSubview:seatTime];
    
    
    UILabel *hoser0=[[UILabel alloc]init];
    hoser0.text=@"0";
    hoser0.textColor=SmaColor(234, 86, 20);
    hoser0.font=[UIFont systemFontOfSize:18];
    [soprtView addSubview:hoser0];
    CGSize fontsize0 = [hoser0.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    hoser0.frame=CGRectMake(soprtView.frame.size.width/2-leftM,seatTime.frame.origin.y-30,fontsize0.width,20);
    
    UILabel *unit1=[[UILabel alloc]init];
    unit1.text=@"步";
    unit1.font=[UIFont systemFontOfSize:14];
    CGSize fontsize1 = [unit1.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    unit1.frame=CGRectMake(hoser0.frame.origin.x+hoser0.frame.size.width+1,seatTime.frame.origin.y-30,fontsize1.width,20);
    [soprtView addSubview:unit1];
    _seatlable=hoser0;
    _seatunitlable=unit1;
    
    
    /**/
    UILabel *distanceLableft=[[UILabel alloc]init];
    distanceLableft.text=@"距离";
     distanceLableft.font=[UIFont systemFontOfSize:14];
    distanceLableft.frame=CGRectMake(self.view.frame.size.width/2+5,y, labW, 20);
    [soprtView addSubview:distanceLableft];
    
//    UISlider *distanceSlider=[[UISlider alloc]init];
//    distanceSlider.minimumValue=0;
//    distanceSlider.maximumValue=100;
//    _distanceSlider=distanceSlider;
//    
//    UIImage *thumbImage2 = [UIImage imageByScalingAndCroppingForSize:size imageName:@"distance_slider_button_bg"];
//    [distanceSlider setThumbImage:thumbImage2 forState:UIControlStateHighlighted];
//    [distanceSlider setThumbImage:thumbImage2 forState:UIControlStateNormal];
//
//    [distanceSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
//    
//    UIImage *distanceImage2 = [UIImage imageByScalingAndCroppingForSize:size1 imageName:@"distance_slider_bg"];
//    UIColor *bgColor1=[UIColor colorWithPatternImage:distanceImage2];
//    [distanceSlider setBackgroundColor:bgColor1];
//    [distanceSlider setMaximumTrackTintColor:[UIColor clearColor]];
//    [distanceSlider setMinimumTrackTintColor:[UIColor clearColor]];
//    distanceSlider.center=CGPointMake(self.view.frame.size.width/2,25);
//    distanceSlider.frame=CGRectMake(labW+2*marginLeft,3*y,self.view.frame.size.width-labW-(5*marginLeft), 5);
//    //[soprtView addSubview:distanceSlider];
    

    UILabel *hoser2=[[UILabel alloc]init];
    hoser2.text=@"0";
    hoser2.textColor=SmaColor(56, 110, 255);
    hoser2.font=[UIFont systemFontOfSize:18];
    [soprtView addSubview:hoser2];
    CGSize fontsize2 = [hoser2.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    hoser2.frame=CGRectMake(self.view.frame.size.width/2+5+40,y,fontsize2.width,20);
    
    
    UILabel *unit2=[[UILabel alloc]init];
    unit2.text=@"米";
    unit2.font=[UIFont systemFontOfSize:14];
    CGSize fontsize3 = [unit2.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    unit2.frame=CGRectMake(hoser2.frame.origin.x+hoser2.frame.size.width+1,y,fontsize3.width,20);
    [soprtView addSubview:unit2];
    _distancelable=hoser2;
    _distanceunitlable=unit2;
    
    /**/
    UILabel *calorieceLableft=[[UILabel alloc]init];
    calorieceLableft.text=@"卡路里";
    calorieceLableft.frame=CGRectMake(marginLeft,y, labW, 20);
    calorieceLableft.font=[UIFont systemFontOfSize:14];
    [soprtView addSubview:calorieceLableft];
    
    UISlider *calorieSlider=[[UISlider alloc]init];
    calorieSlider.minimumValue=0;
    calorieSlider.maximumValue=100;
    _calorielSlider=calorieSlider;
    UIImage *distanceImage = [UIImage imageByScalingAndCroppingForSize:size imageName:@"calorie_slider_button_bg"];
    [calorieSlider setThumbImage:distanceImage forState:UIControlStateHighlighted];
    [calorieSlider setThumbImage:distanceImage forState:UIControlStateNormal];
    
    [calorieSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIImage *calorieImage2 = [UIImage imageByScalingAndCroppingForSize:size1 imageName:@"calorie_slider_bg"];
    UIColor *bgColor2=[UIColor colorWithPatternImage:calorieImage2];
    [calorieSlider setBackgroundColor:bgColor2];
    [calorieSlider setMaximumTrackTintColor:[UIColor clearColor]];
    [calorieSlider setMinimumTrackTintColor:[UIColor clearColor]];
    calorieSlider.center=CGPointMake(self.view.frame.size.width/2,25);
    calorieSlider.frame=CGRectMake(labW+2*marginLeft,y,self.view.frame.size.width-labW-(5*marginLeft), 5);
    //[soprtView addSubview:calorieSlider];
    
    
    
    
    

    UILabel *hoser3=[[UILabel alloc]init];
    hoser3.text=@"0";
    hoser3.textColor=SmaColor(22, 170, 182);
    hoser3.font=[UIFont systemFontOfSize:18];
    [soprtView addSubview:hoser3];
    CGSize fontsize = [hoser3.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    hoser3.frame=CGRectMake(marginLeft+40+10,y,fontsize.width,20);
    
    
    
    UILabel *unit3=[[UILabel alloc]init];
    unit3.text=@"千焦";
    unit3.font=[UIFont systemFontOfSize:14];
    
    CGSize fontsize5 = [unit3.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    unit3.frame=CGRectMake(hoser3.frame.origin.x+hoser3.frame.size.width+5+10,y,fontsize5.width,20);
    [soprtView addSubview:unit3];
    _calorielable=hoser3;
    _calorielunitable=unit3;
}
/*距离改变*/
- (void)distanceValueChanged:(id)sender{
   // UISlider* control = (UISlider*)sender;
    
}
/*步数改变*/
-(void)seatValueChanged:(id)sender{
     UISlider* control = (UISlider*)sender;
    int value=(control.value+0.5/1);
    self.seatAmount=[NSNumber numberWithFloat:value];
    MyLog(@"%d---------",value);
    self.seatlable.text=[NSString stringWithFormat:@"%d",(value*1000)];
    CGSize fontsize = [self.seatlable.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    self.seatlable.frame=CGRectMake(self.seatlable.frame.origin.x, self.seatlable.frame.origin.y,fontsize.width, 20);
    
}

-(void)sliderValueChanged:(id)sender
{
    UISlider* control = (UISlider*)sender;
    int value=(control.value+0.5/1);
    [self setSliderView:value];
    
}
-(void)setSliderView:(int)intAmount
{
    self.seatAmount=[NSNumber numberWithInt:intAmount];
    self.seatSlider.value=intAmount;
    
    self.amountAmount=[NSNumber numberWithFloat:intAmount];
    self.seatlable.text=[NSString stringWithFormat:@"%d",(intAmount*1000)];
    self.distancelable.text=[NSString stringWithFormat:@"%d",(intAmount*[self.distancePoint intValue])];
    //[self.calorielSlider setValue:[self.amountAmount floatValue] animated:YES];
    
   
    self.calorielable.text= [NSString stringWithFormat:@"%@",[self newFloat:([self.caloriePoint floatValue]*[self.weight intValue]*intAmount) withNumber:2]];
     MyLog(@"-----------------------------------%d====%f------------%d",intAmount,[self.caloriePoint floatValue],[self.weight intValue]);
    
    //    [self.seatSlider setValue:[self.amountAmount floatValue] animated:YES];
    //    [self.distanceSlider setValue:[self.amountAmount floatValue] animated:YES];
    
    CGSize fontsize1 = [self.seatlable.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    self.seatlable.frame=CGRectMake(self.seatlable.frame.origin.x, self.seatlable.frame.origin.y,fontsize1.width, 20);
    self.seatunitlable.frame=CGRectMake(self.seatlable.frame.origin.x+self.seatlable.frame.size.width,self.seatlable.frame.origin.y,20, 20);
    
    CGSize fontsize2 = [self.distancelable.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    self.distancelable.frame=CGRectMake(self.distancelable.frame.origin.x, self.distancelable.frame.origin.y,fontsize2.width, 20);
    self.distanceunitlable.frame=CGRectMake(self.distancelable.frame.origin.x+self.distancelable.frame.size.width,self.distancelable.frame.origin.y,20, 20);
    
    CGSize fontsize3 = [self.calorielable.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    self.calorielable.frame=CGRectMake(self.calorielable.frame.origin.x, self.calorielable.frame.origin.y,fontsize3.width, 20);
    self.calorielunitable.frame=CGRectMake(self.calorielable.frame.origin.x+self.calorielable.frame.size.width,self.calorielable.frame.origin.y,60, 20);
}

-(void)sleepValueChanged:(id)sender
{
    UISlider* control = (UISlider*)sender;
    int value=((control.value+0.5)/1);
    
    [self sleeplayout:value];
    
}
-(void)sleeplayout:(int)value
{
    int iminue=0;
    if(value%2!=0)
        iminue=30;
    
    
    self.sleepSlider.value=value;
    _sleepAmount=[NSNumber numberWithInt:value];
    
    self.hoserlable.text=[NSString stringWithFormat:@"%@",[self newFloat:value*0.5 withNumber:0]];
    self.minutelable.text=[NSString stringWithFormat:@"%d",iminue];
    
    CGSize fontsize1 = [self.hoserlable.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    self.hoserlable.frame=CGRectMake(self.hoserlable.frame.origin.x, self.hoserlable.frame.origin.y,fontsize1.width, 20);
    CGSize fontsize2 = [self.hoserunitable.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.hoserunitable.frame=CGRectMake(self.hoserlable.frame.origin.x+self.hoserlable.frame.size.width, self.hoserunitable.frame.origin.y,fontsize2.width, 20);
    
    CGSize fontsize3 = [self.minutelable.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    self.minutelable.frame=CGRectMake(self.hoserunitable.frame.origin.x+self.hoserunitable.frame.size.width,self.minutelable.frame.origin.y,fontsize3.width, 20);
    CGSize fontsize4 = [self.hoserunitable.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.minuteunitable.frame=CGRectMake(self.minutelable.frame.origin.x+self.minutelable.frame.size.width,self.minuteunitable.frame.origin.y,fontsize4.width, 20);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"setting_navgitionbar_background"] forBarMetrics:UIBarMetricsDefault];
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"plan_navigation_bg"] forBarMetrics:UIBarMetricsDefault];
    [super viewWillDisappear:animated];
}

-(NSString *)newFloat:(float)value withNumber:(int)numberOfPlace
{
    NSString *formatStr = @"%0.";
    formatStr = [formatStr stringByAppendingFormat:@"%df", numberOfPlace];
    formatStr = [NSString stringWithFormat:formatStr, value];
    printf("formatStr %s\n", [formatStr UTF8String]);
    return formatStr;
}

-(void)changeUISliderValue:(int)typeInt
{
    if(typeInt==0)//步数发生变化
    {
         self.seatlable.text=[NSString stringWithFormat:@"%d",([self.seatAmount intValue]*1000)];
         CGSize fontsize = [self.seatlable.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
         self.seatlable.frame=CGRectMake(self.seatlable.frame.origin.x, self.seatlable.frame.origin.y,fontsize.width, 20);
         self.seatunitlable.frame=CGRectMake(self.seatlable.frame.origin.x+self.seatlable.frame.size.width,self.seatlable.frame.origin.y,20, 20);
        
         self.distancelable.text=[NSString stringWithFormat:@"%d",([self.seatAmount intValue]*750)];
 
         self.calorielable.text=[NSString stringWithFormat:@"%.f",(0.00055*56*[self.seatAmount intValue]*1000)];
    }
}

-(void)loadSleep
{
    CGFloat marginLeft=10;
    CGFloat center=self.view.frame.size.width/2;
    CGFloat y=self.view.frame.size.height*0.3+60+20;
    UILabel *sleepLab=[[UILabel alloc]init];
    sleepLab.text=@"睡眠";
    sleepLab.center=CGPointMake(center, y);
    sleepLab.bounds=CGRectMake(0, 0, 60, 20);
    sleepLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:sleepLab];
    
    UIImageView *sleepView=[[UIImageView alloc]init];
    [sleepView setImage:[UIImage imageNamed:@"sleep_view_bg"]];
    sleepView.frame=CGRectMake(marginLeft, y+20, self.view.frame.size.width-2*marginLeft, self.view.frame.size.height*0.2);
    [self.view addSubview:sleepView];
    sleepView.userInteractionEnabled=YES;
    CGFloat y1=(self.view.frame.size.height*0.2)/2;
    CGFloat labW=40;

    UILabel *sportLableft=[[UILabel alloc]init];
    sportLableft.text=@"睡眠";
    sportLableft.font=[UIFont systemFontOfSize:14];
    sportLableft.frame=CGRectMake(marginLeft,y1-10, labW, 20);
    [sleepView addSubview:sportLableft];
    
    UISlider *sleepSlider=[[UISlider alloc]init];
    UIImage *img=[UIImage imageNamed:@"sleep_slider_button_bg"];
    CGSize size={img.size.width*0.5,img.size.height*0.5};
    sleepSlider.minimumValue=0;
    sleepSlider.maximumValue=48;
    
    [sleepSlider addTarget:self action:@selector(sleepValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIImage *thumbImage = [UIImage imageByScalingAndCroppingForSize:size imageName:@"sleep_slider_button_bg"];
    [sleepSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [sleepSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    UIImage *img1=[UIImage imageNamed:@"sleep_slider_bg"];
    CGSize size1={img1.size.width*0.5,img.size.height*0.5};
    UIImage *thumbImage1 = [UIImage imageByScalingAndCroppingForSize:size1 imageName:@"sleep_slider_bg"];
    
    UIColor *bgColor=[UIColor colorWithPatternImage:thumbImage1];
    [sleepSlider setBackgroundColor:bgColor];
    [sleepSlider setMaximumTrackTintColor:[UIColor clearColor]];
    [sleepSlider setMinimumTrackTintColor:[UIColor clearColor]];
    //sleepSlider.center=CGPointMake(self.view.frame.size.width/2,25);
    sleepSlider.frame=CGRectMake(labW+2*marginLeft,y1,self.view.frame.size.width-labW-(5*marginLeft), 5);
    [sleepView addSubview:sleepSlider];
    _sleepSlider=sleepSlider;
    
    CGFloat leftM=40;
    UILabel *hoser=[[UILabel alloc]init];
    hoser.text=@"0";
    hoser.font=[UIFont systemFontOfSize:18];
    [sleepView addSubview:hoser];
    CGSize fontsize = [hoser.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    _hoserlable=hoser;
    hoser.frame=CGRectMake(sleepView.frame.size.width/2-leftM,5,fontsize.width,20);

    UILabel *unit1=[[UILabel alloc]init];
    unit1.text=@"小时";
    unit1.font=[UIFont systemFontOfSize:14];
    CGSize fontsize1 = [unit1.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    unit1.frame=CGRectMake(hoser.frame.origin.x+hoser.frame.size.width+1,5,fontsize1.width,20);
     _hoserunitable=unit1;
    [sleepView addSubview:unit1];

    
    
    UILabel *minute=[[UILabel alloc]init];
    minute.text=@"0";
    minute.font=[UIFont systemFontOfSize:18];
   [sleepView addSubview:minute];
    CGSize fontsize2 = [minute.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    minute.frame=CGRectMake(unit1.frame.origin.x+unit1.frame.size.width+1,5,fontsize2.width,20);
    _minutelable=minute;

    UILabel *unit2=[[UILabel alloc]init];
    unit2.font=[UIFont systemFontOfSize:14];
    unit2.text=@"分钟";
    CGSize fontsize3 = [unit2.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    unit2.frame=CGRectMake(minute.frame.origin.x+minute.frame.size.width+1,5,fontsize3.width,20);
    [sleepView addSubview:unit2];
    _minuteunitable=unit2;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
