//
//  SmaSportPlanController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/15.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaSportPlanController.h"
#import "EFCircularSlider.h"
@interface SmaSportPlanController ()
@property (nonatomic,strong) EFCircularSlider* minuteSlider;
@property (nonatomic,strong) UILabel *statelab;
@property (nonatomic,strong) UILabel *unitlab;

@property (nonatomic,retain) NSNumber *seatAmount;
@property (nonatomic,retain) NSNumber *distanceAmount;
@property (nonatomic,retain) NSNumber *calorieAmount;
@property (nonatomic,retain) NSNumber *amountAmount;

@property (nonatomic,strong) NSNumber *distancePoint;//距离换算点

@property (nonatomic,strong) NSNumber *caloriePoint;//卡路里换算点

@property (nonatomic,strong) NSNumber *weight;//体重
@end

@implementation SmaSportPlanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=SmaLocalizedString(@"setplan_navtitle");
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"alarm_submit_bg" highIcon:@"alarm_submit_bg" target:self action:@selector(addClick)];
    
    [self setConversionPoint];
    
    [self loadrolayView];
    
    
    
    NSString *stepPlan = [SmaUserDefaults objectForKey:@"stepPlan"]; //获取计步目标
    if (!stepPlan || [stepPlan isEqualToString:@""]) {
        stepPlan= @"35.4";
    }
    [self setSliderView:stepPlan.intValue];
    
    self.minuteSlider.currentValue=stepPlan.floatValue*2/3;
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)addClick
{

//    if([SmaBleMgr checkBleStatus])
//    {
        if(self.seatAmount!=nil && [self.seatAmount intValue]>0)
        {
        
          SmaUserInfo *userinfo = [SmaAccountTool userInfo];
            userinfo.aim_steps = [NSString stringWithFormat:@"%d",[self.seatAmount intValue]*200];
            [SmaAccountTool saveUser:userinfo];
            [SmaBleMgr setStepNumber:[self.seatAmount intValue]*200];
            [SmaUserDefaults setObject:[NSString stringWithFormat:@"%@",self.seatAmount]  forKey:@"stepPlan"];//设置计步目标
            SmaAnalysisWebServiceTool *dal = [[SmaAnalysisWebServiceTool alloc] init];
               [MBProgressHUD showMessage:SmaLocalizedString(@"alert_setprompt")];
            [dal acloudPutUserifnfo:userinfo success:^(NSString *result) {
                 [MBProgressHUD hideHUD];
            } failure:^(NSError *error) {
                 [MBProgressHUD hideHUD];
            }];
        }
//    }
    //睡觉目标
}


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
-(void)minuteDidChange:(EFCircularSlider*)slider {
    int newVal = (int)slider.currentValue <= 300 ? (int)slider.currentValue : 0;
    NSLog(@"33333==%f",slider.currentValue);
    self.statelab.text=[NSString stringWithFormat:@"%d",newVal*200];
    
    CGSize fontsize = [self.statelab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:38]}];
    CGSize unitsize = [self.unitlab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    UIImage *bodyImg=[UIImage imageNamed:@"plan_slidebar_bg"];
    
    CGFloat x=(bodyImg.size.width-fontsize.width-unitsize.width)/2;
    CGFloat y=(bodyImg.size.height-fontsize.height-unitsize.height)/2;
    
    self.statelab.frame=CGRectMake(x,y, fontsize.width, fontsize.height);
    self.unitlab.frame=CGRectMake(x+fontsize.width,y+unitsize.height,unitsize.width,unitsize.height);
    
    [self setSliderView:newVal];
}


-(NSString *)newFloat:(float)value withNumber:(int)numberOfPlace
{
    NSString *formatStr = @"%0.";
    formatStr = [formatStr stringByAppendingFormat:@"%df", numberOfPlace];
    formatStr = [NSString stringWithFormat:formatStr, value];
    printf("22formatStr %s\n", [formatStr UTF8String]);
    return formatStr;
}


-(void)setSliderView:(int)intAmount
{
    NSLog(@"sgwew==%d",intAmount);
    self.seatAmount=[NSNumber numberWithInt:intAmount];
    
    self.amountAmount=[NSNumber numberWithFloat:intAmount];
    self.steplab.text=[NSString stringWithFormat:@"%d %@",(intAmount*200),SmaLocalizedString(@"sport_stepunit")];
    float destncepoints=intAmount*[self.distancePoint floatValue]/5000;
    self.distancelab.text=[NSString stringWithFormat:@"%@ %@",[self newFloat:destncepoints withNumber:2],SmaLocalizedString(@"sport_distanceunit")];
    
    self.calorielab.text= [NSString stringWithFormat:@"%@ %@",[self newFloat:(([self.caloriePoint floatValue]*[self.weight intValue]*intAmount*100)/200) withNumber:2],SmaLocalizedString(@"sport_hotunit")];
    SmaUserInfo *userinfo = getUserINFO;
    if([userinfo.unit isEqualToString:@"1"]){//0  公 ，1 英
        self.distancelab.text=[NSString stringWithFormat:@"%.2f%@",[self convertToMile:[[self newFloat:destncepoints withNumber:2] floatValue]],SmaLocalizedString(@"setting_unitmi2")];
    }
    CGSize fontsize2 = [self.distancelab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.distancelab.frame=CGRectMake(self.dataView.frame.size.width-fontsize2.width, self.distancelab.frame.origin.y,fontsize2.width, 20);
}

- (float)convertToMile:(float)km {
    return  km / 1.609;
}

-(void)loadrolayView
{
    /*head begin*/
    UIImage *bodyImg=[UIImage imageLocalWithName:@"plan_slidebar_bg"];
    CGFloat imgViewh=bodyImg.size.height;
    CGFloat frameW=bodyImg.size.width;
    CGFloat narginTop=25;
    CGFloat marginY=53;
    if(!fourInch)
    {
        narginTop=12;
        frameW=frameW-20;
        imgViewh=imgViewh-20;
        marginY=26;
    }
    self.slideView.frame=CGRectMake((self.view.frame.size.width-bodyImg.size.width)/2,marginY,frameW, imgViewh);
    self.slideView.userInteractionEnabled=YES;
    [self.view addSubview:self.slideView];
    
    
    CGRect minuteSliderFrame = CGRectMake((self.view.frame.size.width-bodyImg.size.width-14)/2,marginY-7,frameW+14, imgViewh+14);
    
    _minuteSlider = [[EFCircularSlider alloc] initWithFrame:minuteSliderFrame];
    _minuteSlider.unfilledColor =[UIColor clearColor];//SmaColor(220, 220, 220);//
    
    _minuteSlider.filledColor =  SmaColor(195, 14, 46);
    // [_minuteSlider setInnerMarkingLabels:@[@"10", @"20", @"30", @"40", @"50", @"60", @"70", @"80", @"90", @"100"]];
    _minuteSlider.labelFont = [UIFont systemFontOfSize:12.0f];
    _minuteSlider.lineWidth = 10;
    _minuteSlider.minimumValue = 0;
    _minuteSlider.maximumValue = 150;
    _minuteSlider.labelColor = SmaColor(195, 14, 46);
    _minuteSlider.handleType = doubleCircleWithOpenCenter;
    _minuteSlider.handleColor = _minuteSlider.filledColor;
    
    [self.view  addSubview:self.minuteSlider];
    [self.minuteSlider addTarget:self action:@selector(minuteDidChange:) forControlEvents:UIControlEventValueChanged];
    
    //  self.chartView.frame=CGRectMake(0, 8+self.actualTypeValue.frame.size.height+5, self.view.frame.size.width,imgViewh-(8+self.actualTypeValue.frame.size.height+5));
    //SmaColor(242, 148, 24)
    //  [ self.bodyView addSubview:self.chartView];
    NSString *stepPlan = [SmaUserDefaults objectForKey:@"stepPlan"]; //获取计步目标
    
    UILabel *statelab=[[UILabel alloc]init];
    statelab.font=[UIFont systemFontOfSize:38];
    statelab.textColor=SmaColor(195, 14, 46);
    statelab.text=@"0";
    _statelab=statelab;
    if(stepPlan)
    {
        statelab.text=[NSString stringWithFormat:@"%d",stepPlan.intValue*200];
    }
    if (!stepPlan || [stepPlan isEqualToString:@""]) {
        statelab.text = @"7000";
    }
    CGSize fontsize = [statelab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:38]}];
    
    
    
    
    UILabel *unitlab=[[UILabel alloc]init];
    unitlab.font=[UIFont systemFontOfSize:14];
    unitlab.textColor=SmaColor(195, 14, 46);
    unitlab.text=SmaLocalizedString(@"sport_stepunit");
    CGSize unitsize = [unitlab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _unitlab=unitlab;
    
    
    CGFloat x=(bodyImg.size.width-fontsize.width-unitsize.width)/2;
    CGFloat y=(bodyImg.size.height-fontsize.height-unitsize.height)/2;
    
    statelab.frame=CGRectMake(x,y, fontsize.width, fontsize.height);
    unitlab.frame=CGRectMake(x+fontsize.width,y+unitsize.height,unitsize.width,unitsize.height);
    
    [self.slideView addSubview:statelab];
    [self.slideView addSubview:unitlab];
    /*head end*/
    
    /*foot  begin*/
    CGFloat footMargtop=32;
    if(!fourInch)
    {
        footMargtop=16;
    }
    
    UIImage *footImg=[UIImage imageNamed:@"sport_backgrond_down"];
    self.footView.frame=CGRectMake(0,self.slideView.frame.origin.y+imgViewh+footMargtop, frameW, footImg.size.height);
    //
    //
    self.remarklab.font=[UIFont systemFontOfSize:15];
    CGSize fontsize1 = [self.remarklab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    
    CGFloat matop=9.5;
    CGFloat magbtTop=8;
    if(!fourInch)
    {
        matop=8;
        magbtTop=6;
    }
    
    
    
    self.remarkView.frame=CGRectMake((self.view.frame.size.width-fontsize1.width)/2,0,fontsize1.width,fontsize1.height);
    self.remarklab.frame=CGRectMake(0, 0, fontsize1.width, fontsize1.height);
    self.remarklab.font=[UIFont fontWithName:@"HelveticaNeue" size:15];
    self.remarklab.textColor=SmaColor(30, 30, 30);
    self.remarklab.text=SmaLocalizedString(@"setplan_remark");
    
    [self.remarkView addSubview:self.remarklab];
    [self.footView addSubview:self.remarkView];
    
    
    UIImage *lineImg=[UIImage imageNamed:@"sport_Cuttingline_bg"];
    UIImageView *line=[[UIImageView alloc]init];
    [line setImage:lineImg];
    line.frame=CGRectMake(self.remarkView.frame.origin.x, self.remarkView.frame.origin.y+self.remarkView.frame.size.height+6,self.remarkView.frame.size.width,0.5);
    //
    [self.footView addSubview:line];
    
    //
    self.dataView.frame=CGRectMake((self.view.frame.size.width-lineImg.size.width)/2, line.frame.size.height+line.frame.origin.y+12,lineImg.size.width,footImg.size.height-line.frame.origin.y);
    //
    [self.footView addSubview:self.dataView];

    
    

    
    UILabel *mileageBtn=[[UILabel alloc]init];
     mileageBtn.text = SmaLocalizedString(@"sport_distance");
    mileageBtn.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize mileageBtnSize = [mileageBtn.text sizeWithAttributes:@{NSFontAttributeName:mileageBtn.font}];
    mileageBtn.frame=CGRectMake(0,2, mileageBtnSize.width,mileageBtnSize.height);
    
    
    NSString *mileage=[NSString stringWithFormat:@"0.00 %@",SmaLocalizedString(@"sport_distanceunit")];
    self.distancelab.text=mileage;
    self.distancelab.textColor=SmaColor(30, 30, 30);
    self.distancelab.textAlignment=NSTextAlignmentRight;
    self.distancelab.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize mileageSize = [self.distancelab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15]}];
    self.distancelab.frame=CGRectMake(self.dataView.frame.size.width-mileageSize.width,2,self.dataView.frame.size.width-(self.dataView.frame.size.width-mileageSize.width), mileageSize.height);
    [self.dataView addSubview:mileageBtn];
    
    UILabel *stepBtn=[[UILabel alloc]init];
    stepBtn.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    stepBtn.text = SmaLocalizedString(@"sport_steps");
    CGSize stepBtnSize = [stepBtn.text sizeWithAttributes:@{NSFontAttributeName:stepBtn.font}];
    stepBtn.frame=CGRectMake(0, 2*magbtTop+mileageBtn.frame.size.height+mileageBtn.frame.origin.y,stepBtnSize.width, stepBtnSize.height);
    [self.dataView addSubview:stepBtn];
    
    NSString *steps=[NSString stringWithFormat:@"0 %@",SmaLocalizedString(@"sport_stepunit")];
    self.steplab.text=steps;
    self.steplab.textColor=SmaColor(30, 30, 30);
    self.steplab.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize stepsSize = [self.steplab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    
    self.steplab.frame=CGRectMake(stepBtn.frame.size.width,2*magbtTop+mileageBtn.frame.size.height+mileageBtn.frame.origin.y,self.dataView.frame.size.width-stepBtn.frame.size.width, stepsSize.height);
        self.steplab.textAlignment=NSTextAlignmentRight;
    [self.dataView addSubview:stepBtn];


    UILabel *calorieBtn=[[UILabel alloc]init];
    calorieBtn.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    calorieBtn.text = SmaLocalizedString(@"sport_calor");
    CGSize calorieBtnSize = [calorieBtn.text sizeWithAttributes:@{NSFontAttributeName: calorieBtn.font}];
    
    calorieBtn.frame=CGRectMake(0,2*magbtTop+stepBtn.frame.size.height+stepBtn.frame.origin.y,calorieBtnSize.width, calorieBtnSize.height);
    
    
   NSString *hot=[NSString stringWithFormat:@"0 %@",SmaLocalizedString(@"sport_hotunit")];
    self.calorielab.text=hot;
    self.calorielab.textColor=SmaColor(30, 30, 30);
    self.calorielab.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize hotSize = [self.calorielab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    
    self.calorielab.frame=CGRectMake(calorieBtnSize.width,2*magbtTop+stepBtn.frame.origin.y+stepBtn.frame.size.height, self.dataView.frame.size.width-calorieBtnSize.width, hotSize.height);
    self.calorielab.textAlignment=NSTextAlignmentRight;
        self.calorielab.textAlignment=NSTextAlignmentRight;
    [self.dataView addSubview:calorieBtn];

    /*foot  begin*/
}

- (void)viewWillAppear:(BOOL)animated{
    NSString *stepPlan = [SmaUserDefaults objectForKey:@"stepPlan"]; //获取计步目标
    if (!stepPlan || [stepPlan isEqualToString:@""]) {
        stepPlan= @"35.4";
    }
    [self setSliderView:stepPlan.intValue];
    
    self.minuteSlider.currentValue=stepPlan.floatValue*2/3;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
