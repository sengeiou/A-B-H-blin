//
//  SmaSportMainViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/10.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaSportMainViewController.h"
#import "SmaSportDetailController.h"
#import "KAProgressLabel.h"
#import "SmaDataDAL.h"
#import "SmaSportInfo.h"
#import "SmaAccountTool.h"
#import "SmaUserInfo.h"
#import "SmaSportResultInfo.h"
#import "SmaSportDetailViewController.h"
#import "SmaSportPlanController.h"
//#import "SmaCommonStudio.h"
@interface SmaSportMainViewController ()<SetSamCoreBlueToolDelegate>
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (weak,nonatomic) KAProgressLabel * pLabel;
@property (nonatomic,strong) NSDate *data;
@property (nonatomic,strong) NSDate *newdata;
@property (nonatomic,strong) NSNumber *datadiffer;
@property (nonatomic,strong) NSDate *nowDate;
@end

@implementation SmaSportMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=SmaLocalizedString(@"sport_navtilte");
    NSLog(@"---%@", self.title );
    self.dataLab.text=[self dateWithYMD];
    _nowDate = self.newdata;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithName:@"sport_navbar_bg"] forBarMetrics:UIBarMetricsDefault];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"UPDATEUI" object:nil];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"sport_share_ico" highIcon:@"sport_share_ico" target:self action:@selector(share)];
    
    //手势
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    
    self.unitlable.text=SmaLocalizedString(@"sport_stepunit");
    self.remarklab.text=SmaLocalizedString(@"sport_plaremark");
    [self relayoutLoad];
    
    [self loadScheduleView];


    [self refreshData];
    
    SmaBleMgr.delegate=self;
    self.footView.userInteractionEnabled=YES;
    self.stepNumberLab.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teleButtonEvent:)];
    [self.stepNumberLab addGestureRecognizer:tapGestureTel];
    
}
-(void) teleButtonEvent:(UITapGestureRecognizer *)recognizer{
    
    SmaSportPlanController *settingVc = [[SmaSportPlanController alloc] init];
    [self.navigationController pushViewController:settingVc animated:YES];

}
//加载界面
-(void)relayoutLoad
{
    CGFloat frameW=self.view.frame.size.width;
    /*head begin*/
    UIImage *btnImg=[UIImage imageNamed:@"sport_rightbtn_bg"];
    CGFloat btnImgh=btnImg.size.height;
    CGFloat headViewY=4;
    CGFloat labSize=12;
    if(!fourInch)
    {
        btnImgh=btnImg.size.height-6;
        headViewY=4;
        labSize=9;
    }
    
    
    self.headView.frame=CGRectMake(0, headViewY,frameW, btnImgh+15);
//    self.lefebtn.center = CGPointMake(self.lefebtn.center.x, self.headView.center.y);
//    self.lefebtn.frame=CGRectMake(62, 2,btnImg.size.width+10,btnImgh+10);
//    self.lefebtn.imageView.image = [UIImage imageNamed:@"sport_leftbtn_bg"];
//    self.rigthbtn.frame=CGRectMake(frameW-(70+btnImg.size.width),2,22,40);
    

    self.dataLab.textAlignment=NSTextAlignmentCenter;
    self.dataLab.font=[UIFont fontWithName:@"MicrosoftYaHei" size:labSize];
    self.dataLab.textColor=SmaColor(255, 255, 255);
    self.dataLab.frame=CGRectMake(52+btnImg.size.width,2,frameW-104-(btnImg.size.width*2),btnImgh+10);
    //[self.imgView addSubview:self.headView];
    self.imgView.userInteractionEnabled=YES;
   
    /*head end*/
    
    /*chart body  begin*/
    UIImage *circe=[UIImage imageNamed:@"sport_circle"];
    UIImage *bodyImg=[UIImage imageNamed:@"sport_backgrond_head"];
    CGFloat circeh=circe.size.height;
    CGFloat circew=circe.size.width;
    CGFloat imgViewh=bodyImg.size.height;
    CGFloat narginTop=25;
    if(!fourInch)
    {
        circeh=circe.size.height-28;
        circew=circe.size.width-28;
        imgViewh=bodyImg.size.height-68;
        narginTop=12;
    }
    self.imgView.frame=CGRectMake(0, 0, frameW, imgViewh);
    CGFloat margin=(frameW-circew)/2;
    self.chartView.frame=CGRectMake(margin,btnImg.size.height+narginTop, circew, circeh);
    if(!fourInch)
    {
        //UIImage *circe4s=[UIImage imageByScalingAndCroppingForSize:<#(CGSize)#> imageName:<#(NSString *)#>:@"sport_circle4s"];
        //[self.chartView setBackgroundColor:[UIColor colorWithPatternImage:circe4s]];
    }else
    {
       //[self.chartView setBackgroundColor:[UIColor colorWithPatternImage:circe]];
    }
    
    self.chartLab.frame=CGRectMake(margin,btnImg.size.height+narginTop, circew, circeh);
    
    [self.imgView addSubview:self.chartView];
    [self.imgView addSubview:self.chartLab];
    /*chart body  end*/
    
    /*foot  begin*/
    UIImage *footImg=[UIImage imageNamed:@"sport_backgrond_down"];
    self.footView.frame=CGRectMake(0, self.imgView.frame.size.height+self.imgView.frame.origin.y, frameW, footImg.size.height);
    
    
    self.remarklab.font=[UIFont systemFontOfSize:15];
    CGSize fontsize1 = [self.remarklab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    self.unitlable.font=[UIFont systemFontOfSize:15];
    CGSize fontsize = [self.unitlable.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    self.remarklab.text=SmaLocalizedString(@"sport_plaremark");
    self.unitlable.text=SmaLocalizedString(@"sport_stepunit");
    
    CGFloat matop=9.5;
    CGFloat magbtTop=8;
    if(!fourInch)
    {
        matop=8;
        magbtTop=6;
    }
    self.planView.frame=CGRectMake(83, matop, frameW-166,fontsize1.height);
    self.remarklab.frame=CGRectMake(0, 0.5, fontsize1.width, fontsize1.height);
    self.remarklab.font=[UIFont fontWithName:@"HelveticaNeue" size:15];
    self.remarklab.textColor=SmaColor(30, 30, 30);


    self.unitlable.frame=CGRectMake(self.planView.frame.size.width-fontsize.width, 0.5, fontsize.width, fontsize.height);
    self.unitlable.font=[UIFont fontWithName:@"HelveticaNeue" size:15];
    self.unitlable.textColor=SmaColor(30, 30, 30);
    
    self.stepNumberLab.frame=CGRectMake(self.remarklab.frame.size.width,0,self.planView.frame.size.width-self.remarklab.frame.size.width-self.unitlable.frame.size.width, fontsize1.height);

    self.stepNumberLab.font=[UIFont fontWithName:@"HelveticaNeue" size:19];
    self.stepNumberLab.textColor=SmaColor(195, 14, 46);
    self.stepNumberLab.text=@"20000";
    self.stepNumberLab.textAlignment=NSTextAlignmentCenter;
    //sport_Cuttingline_bg
    UIImage *lineImg=[UIImage imageNamed:@"sport_Cuttingline_bg"];
    UIImageView *line=[[UIImageView alloc]init];
    [line setImage:lineImg];
    line.frame=CGRectMake(83, 6+self.planView.frame.size.height+self.planView.frame.origin.y, frameW-166,0.5);
    
    [self.footView addSubview:line];
    [self.planView addSubview:self.remarklab];
    [self.planView addSubview:self.unitlable];
    
    [self.footView addSubview:self.planView];
    
    self.bottomView.frame=CGRectMake(80, line.frame.size.height+line.frame.origin.y+12, frameW-167, self.footView.frame.size.height-(self.planView.frame.size.height+self.planView.frame.origin.y+18));
    [self.footView addSubview:self.bottomView];
    
    UILabel *mileageBtn=[[UILabel alloc]init];
    mileageBtn.text = SmaLocalizedString(@"sport_distance");
      mileageBtn.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
     CGSize mileageBtnSize = [mileageBtn.text sizeWithAttributes:@{NSFontAttributeName:mileageBtn.font}];
     mileageBtn.frame=CGRectMake(0,2, mileageBtnSize.width,mileageBtnSize.height);

    
    NSString *mileage=[NSString stringWithFormat:@"0.00 %@",SmaLocalizedString(@"sport_distanceunit")];
    self.mileageLab.text=mileage;
    self.mileageLab.textColor=SmaColor(30, 30, 30);
    self.mileageLab.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize mileageSize = [self.mileageLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    self.mileageLab.frame=CGRectMake(self.bottomView.frame.size.width-mileageSize.width,2,self.bottomView.frame.size.width-(self.bottomView.frame.size.width-mileageSize.width), mileageSize.height);
    
   
    [self.bottomView addSubview:mileageBtn];

    UILabel *stepBtn=[[UILabel alloc]init];
     stepBtn.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    stepBtn.text = SmaLocalizedString(@"sport_steps");
       CGSize stepBtnSize = [stepBtn.text sizeWithAttributes:@{NSFontAttributeName:stepBtn.font}];
    stepBtn.frame=CGRectMake(0, 2*magbtTop+mileageBtn.frame.size.height+mileageBtn.frame.origin.y,stepBtnSize.width, stepBtnSize.height);
        [self.bottomView addSubview:stepBtn];
    
    NSString *steps=[NSString stringWithFormat:@"1000 %@",SmaLocalizedString(@"sport_stepunit")];
    self.stepsLab.text=steps;
    self.stepsLab.textColor=SmaColor(30, 30, 30);
    self.stepsLab.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize stepsSize = [self.mileageLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    
    self.stepsLab.frame=CGRectMake(stepBtn.frame.size.width,2*magbtTop+mileageBtn.frame.size.height+mileageBtn.frame.origin.y,self.bottomView.frame.size.width-stepBtn.frame.size.width, stepsSize.height);

    [self.bottomView addSubview:stepBtn];
  
    UILabel *calorieBtn=[[UILabel alloc]init];
    calorieBtn.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    calorieBtn.text = SmaLocalizedString(@"sport_calor");
    CGSize calorieBtnSize = [calorieBtn.text sizeWithAttributes:@{NSFontAttributeName: calorieBtn.font}];
 
     calorieBtn.frame=CGRectMake(0,2*magbtTop+stepBtn.frame.size.height+stepBtn.frame.origin.y,calorieBtnSize.width, calorieBtnSize.height);
    

    NSString *hot=[NSString stringWithFormat:@"10000 %@",SmaLocalizedString(@"sport_distanceunit")];
    self.hotLab.text=hot;
    self.hotLab.textColor=SmaColor(30, 30, 30);
    self.hotLab.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize hotSize = [self.hotLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    
    self.hotLab.frame=CGRectMake(calorieBtnSize.width,2*magbtTop+stepBtn.frame.origin.y+stepBtn.frame.size.height, self.bottomView.frame.size.width-calorieBtnSize.width, hotSize.height);
    self.hotLab.textAlignment=NSTextAlignmentRight;
    [self.bottomView addSubview:calorieBtn];

    
    /*foot  begin*/
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

-(void)NotificationSportRefresh
{
    SmaBleMgr.delegate=self;
   
    [self refreshData];
}

-(void)viewWillAppear:(BOOL)animated
{
    SmaBleMgr.delegate=self;
    [self refreshData];
}
-(void)refreshData:(NSMutableArray *)arrs
{
    SmaBleMgr.delegate=self;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString *selfStr = [fmt stringFromDate:self.data];
    
    SmaDataDAL *dal = [[SmaDataDAL alloc]init];
    SmaSportResultInfo *info= [dal getSmaSport:[NSNumber numberWithInt:[selfStr intValue]]];
    
    
    float stepSum=0;
    float distanceSum=0;
    float calorySum=0;
    for (int i=0; i<arrs.count; i++) {
        SmaSportInfo *info=arrs[i];
        stepSum=stepSum+[info.sport_step floatValue];
        distanceSum=distanceSum+[info.sport_distance floatValue];
        calorySum=calorySum+[info.sport_calory floatValue];
    }
    info.sumStep=[NSString stringWithFormat:@"%.2f",((!info.sumStep)?0:[info.sumStep floatValue])+stepSum];
    info.sumDistance=[NSString stringWithFormat:@"%.2f",((!info.sumDistance)?0:[info.sumDistance floatValue])+distanceSum];
    info.sumCalory=[NSString stringWithFormat:@"%.2f",((!info.sumCalory)?0:[info.sumCalory floatValue])+stepSum];
    
    NSString *planCount =[SmaUserDefaults objectForKey:@"stepPlan"];
    int planInt=0;
    if([planCount intValue]==0)
    {
        planInt=0;
    }else
    {
        planInt=[planCount intValue]*200;
    }

    if(planCount==nil)
    {
        //[self.pLabel setText:@"未设"];
        [self.stepNumberLab setText:@"7000"];
        planCount=@"35";
    }
    else{
        [self.pLabel setStartDegree:0.0f];
        float valu=(((!info.sumStep)?0:[info.sumStep floatValue])/planInt);
        [self.pLabel setText:[NSString stringWithFormat:@"%.2f%%",(valu*100)]];
        [self.pLabel setEndDegree:valu*360];
    }
    
    self.stepNumberLab.text=[NSString stringWithFormat:@"s%d",[planCount intValue]*200];
    self.stepNumberLab.font=[UIFont systemFontOfSize:14];
    CGSize fontsize1 = [self.stepNumberLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.stepNumberLab.frame=CGRectMake(self.stepNumberLab.frame.origin.x, self.stepNumberLab.frame.origin.y, fontsize1.width, 20);

    
    self.mileageLab.text=(!info.sumDistance)?@"0":[NSString stringWithFormat:@"%.2f",([info.sumDistance floatValue]/1000)];
    self.stepsLab.text=(!info.sumStep)?@"0":info.sumStep;
    self.hotLab.text=(!info.sumCalory)?@"0":[NSString stringWithFormat:@"%.2f",([info.sumCalory floatValue]/1000)];
  
}

- (void)updateUI{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    if (![[fmt stringFromDate:_nowDate] isEqualToString:[fmt stringFromDate:[NSDate date]]]) {
        self.data = [NSDate date];
        _nowDate = self.newdata;
    }
    self.dataLab.text=[self dateWithYMD];
    [self refreshData];
}

-(void)refreshData
{
    SmaBleMgr.delegate=self;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString *selfStr = [fmt stringFromDate:self.data];
    
    SmaDataDAL *dal = [[SmaDataDAL alloc]init];
    SmaSportResultInfo *info= [dal getSmaSport:[NSNumber numberWithInt:[selfStr intValue]]];
    NSString *planCount =[SmaUserDefaults objectForKey:@"stepPlan"];
    NSLog(@"info====%@  %@",info,planCount);
    if (!planCount || [planCount isEqualToString:@""]) {
        planCount = @"35";
    }
    int planInt=0;
    if([planCount intValue]==0)
    {
        planInt=0;
    }else
    {
        planInt=[planCount intValue]*200;
    }
    if(planCount==nil)
    {
//        [self.pLabel setText:SmaLocalizedString(@"sport_plancount")];
        [self.stepNumberLab setText:@"7000"];
        planCount=@"35";
    }
   else{
        [self.pLabel setStartDegree:0.0f];
       NSLog(@"===%@",info.sumStep);
       float value = info.sumStep?[info.sumStep floatValue]/planInt:0;
        [self.pLabel setText:[NSString stringWithFormat:@"%.2f%%",(value*100)]];
        [self.pLabel setEndDegree:value*360];
    }
    self.stepNumberLab.text=[NSString stringWithFormat:@"%d",[planCount intValue]*200];
    self.stepNumberLab.font=[UIFont systemFontOfSize:19];
    self.stepNumberLab.textAlignment=NSTextAlignmentCenter;

    self.mileageLab.text=[NSString stringWithFormat:@"%.2f %@",(((!info.sumDistance)?0:[info.sumDistance floatValue])/1000),SmaLocalizedString(@"sport_distanceunit")];
    
    self.stepsLab.text=[NSString stringWithFormat:@"%@ %@",((!info.sumStep)? @"0":info.sumStep),SmaLocalizedString(@"sport_stepunit")];

    self.hotLab.text=[NSString stringWithFormat:@"%.2f %@",(((!info.sumDistance)?0:[info.sumCalory floatValue])/1000),SmaLocalizedString(@"sport_hotunit")];
    [SmaUserDefaults setObject:[NSString stringWithFormat:@"%.2f",(((!info.sumDistance)?0:[info.sumDistance floatValue])/1000)] forKey:@"KM"];
    [SmaUserDefaults setObject:[NSString stringWithFormat:@"%@",((!info.sumStep)? @"0":info.sumStep)] forKey:@"STEP"];
    [SmaUserDefaults setObject:info.sumCalory forKey:@"KCAL"];
    SmaUserInfo *userinfo = getUserINFO;
    if([userinfo.unit isEqualToString:@"1"]){//0  公 ，1 英
        self.mileageLab.text=[NSString stringWithFormat:@"%.2f%@",[self convertToMile:(((!info.sumDistance)?0:[info.sumDistance floatValue])/1000)],SmaLocalizedString(@"setting_unitmi2")];
    }

    CGSize hotSize = [self.mileageLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.mileageLab.frame=CGRectMake(self.bottomView.frame.size.width-hotSize.width,2,self.bottomView.frame.size.width-(self.bottomView.frame.size.width-hotSize.width), hotSize.height);
}
- (float)convertToMile:(float)km {
    return  km / 1.609;
}
//分享
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
//重新布局
-(void)relayout
{
    CGFloat w=self.view.frame.size.width;
    //CGFloat h=self.view.frame.size.height;
    self.chartView.frame=CGRectMake(0,40,w,260);
    self.chartLab.frame=CGRectMake(50,20,220,220);
    self.pLabel.frame=self.chartLab.frame;
    self.planView.frame=CGRectMake(0,260+50,w,self.planView.frame.size.height);
    self.bottomView.frame=CGRectMake(0,260+60+self.planView.frame.size.height,w,45);
    
}

-(NSNumber *)datadiffer
{
    if(_datadiffer==nil)
    {
        _datadiffer=@10;
    }
    return _datadiffer;
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
   
//    return [self FormatStr:selfStr];
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

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        SmaSportDetailViewController *settingVc = [[SmaSportDetailViewController alloc] init];
        [self.navigationController pushViewController:settingVc animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)loadScheduleView
{
    if(!_pLabel)
    {
        KAProgressLabel *pl=[[KAProgressLabel alloc]init];
        pl.frame=self.chartLab.frame;
        [pl setBackgroundColor:[UIColor clearColor]];
        _pLabel=pl;
        [self.imgView addSubview:pl];
    }
    
    [self.pLabel setStartDegree:0.0f];
    [self.pLabel setEndDegree:0.0f];
    
    float delta =self.pLabel.endDegree-self.pLabel.startDegree;
    [self.pLabel setText:[NSString stringWithFormat:@"%.0f%%",(delta)/3.6]];

    [self.pLabel setRoundedCornersWidth:0.0f];//线条头大小
    [self.pLabel setTrackWidth:7.0f];//轨迹粗细
    [self.pLabel setProgressWidth:7.0f];//进度条粗细
    [self.pLabel setTextColor:SmaColor(255, 255,255)];
    [self.pLabel setFont:[UIFont systemFontOfSize:24]];

    self.pLabel.fillColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
    self.pLabel.trackColor = SmaColor(195, 198, 195);//[UIColor clearColor]; //
    self.pLabel.progressColor = SmaColor(195, 14, 46);
    self.pLabel.isStartDegreeUserInteractive = NO;
    self.pLabel.isEndDegreeUserInteractive = NO;
    
}
int  deffInt=10;
- (IBAction)dataAddClick:(id)sender {
    if(deffInt<10)
    {
        deffInt++;
        NSDate *nextDate = [NSDate dateWithTimeInterval:(24*60*60*(deffInt-10)) sinceDate:self.newdata];
        _data=nextDate;
        self.dataLab.text=[self dateWithYMD];

        [self refreshData];
    }
}


- (IBAction)dataCutClick:(id)sender {
    if(deffInt>1)
    {
        deffInt--;
        NSDate *nextDate = [NSDate dateWithTimeInterval:-(24*60*60*(10-deffInt)) sinceDate:self.newdata];
        _data=nextDate;
        self.dataLab.text=[self dateWithYMD];
        
        [self refreshData];
    }
}




@end
