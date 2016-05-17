//
//  SmaSportDetailViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/20.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaSportDetailViewController.h"
#import "CBChartView.h"
#import "SmaDataDAL.h"
#import "SmaSportResultInfo.h"

@interface SmaSportDetailViewController ()

{
        SmaDataDAL *dal;
}

@end

@implementation SmaSportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"sport_share_ico" highIcon:@"sport_share_ico" target:self action:@selector(share)];
    self.title=SmaLocalizedString(@"sport_navtilte");
    [self.actualTypeValue setTitle:SmaLocalizedString(@"sportdetail_day") forSegmentAtIndex:0];
    [self.actualTypeValue setTitle:SmaLocalizedString(@"portdetail_week") forSegmentAtIndex:1];
    [self.actualTypeValue setTitle:SmaLocalizedString(@"sportdetail_tendat") forSegmentAtIndex:2];
    self.unitlable.text=SmaLocalizedString(@"sport_stepunit");
    self.remarklab.text=SmaLocalizedString(@"sport_plaremark");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"UPDATEUI" object:nil];

    [self relayoutLoad];
    //默认为天的数据
    
    self.actualTypeValue.selectedSegmentIndex=0;
    [self refreshData:0];//天
    NSString *planCount =[SmaUserDefaults objectForKey:@"stepPlan"];
    if (!planCount || [planCount isEqualToString:@""]) {
        planCount = @"35";
    }

    if(planCount && [planCount intValue]>0)
    {
        self.stepNumberLab.text=[NSString stringWithFormat:@"%d",[planCount intValue]*200];
    }else{
        self.stepNumberLab.text=@"0";
    }
    
}

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
    
    self.actualTypeValue.frame=CGRectMake(28, 8,320-56, 28);
    [self.bodyView addSubview:self.actualTypeValue];
    self.bodyView.userInteractionEnabled=YES;
    UIImage *bodyImg=[UIImage imageNamed:@"sport_backgrond_head"];
    CGFloat imgViewh=bodyImg.size.height;
    CGFloat narginTop=25;
    if(!fourInch)
    {
        imgViewh=bodyImg.size.height-68;
        narginTop=12;
    }
    self.bodyView.frame=CGRectMake(0,0,frameW, imgViewh);
    [self.view addSubview:self.bodyView];
    self.chartView.frame=CGRectMake(0, 8+self.actualTypeValue.frame.size.height+5, self.view.frame.size.width,imgViewh-(8+self.actualTypeValue.frame.size.height+5));
    
    [ self.bodyView addSubview:self.chartView];
    /*head end*/
    
    
    /*foot  begin*/
    UIImage *footImg=[UIImage imageLocalWithName:@"sport_backgrond_down"];
    self.footView.frame=CGRectMake(0, self.imgView.frame.size.height+self.imgView.frame.origin.y, frameW, footImg.size.height);
    
    
    self.remarklab.font=[UIFont systemFontOfSize:15];
    CGSize fontsize1 = [self.remarklab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    self.unitlable.font=[UIFont systemFontOfSize:15];
    CGSize fontsize = [self.unitlable.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
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
    
    UIImage *lineImg=[UIImage imageNamed:@"sport_Cuttingline_bg"];
    UIImageView *line=[[UIImageView alloc]init];
    [line setImage:lineImg];
    line.frame=CGRectMake(83, 6+self.planView.frame.size.height+self.planView.frame.origin.y, frameW-166,0.5);
    
    [self.footView addSubview:line];
    [self.view addSubview:self.footView];
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

-(void)viewWillDisappear:(BOOL)animated
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self refreshData:selectIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI{
    [self refreshData:selectIndex];
}

- (IBAction)ValueChange:(UISegmentedControl *)sender {
    selectIndex = (int)sender.selectedSegmentIndex;
    if (selectIndex == 0) {
        [self refreshData:0];//天
        
    }else if (selectIndex == 1) {
        [self refreshData:1];//周
        
    }else {
        [self refreshData:2];//月
        
        
    }
}

/**
 *  <#Description#>
 *
 *  @param intType 查询类型 0:天 、1:周 、2:月
 *  @param timeDay 传入的时间
 */
-(void)refreshData:(int)intType
{
    if (!dal) {
        dal = [[SmaDataDAL alloc]init];
    }

    NSMutableArray *array = [dal getSportCount:intType];
    NSMutableDictionary *dict=array[0];
    NSLog(@"array == %@\n dict[0] == %@\n",array,dict);
    NSArray *sortArray = [[NSArray alloc] initWithObjects:@"0",@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24",nil];
    

    if(intType>0)
    {
        int intCount=(intType==1)?7:10;
        MyLog(@"这里哦－－－");
        NSDate *senddate=[NSDate date];
        NSMutableArray *MutableArray =[[NSMutableArray alloc] init];
        for (int i=intCount; i>0; i--) {
            NSDate *nextDate = [NSDate dateWithTimeInterval:(-(24*60*60)*(i)) sinceDate:senddate];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"MM-dd"];
            NSString *locationString=[dateformatter stringFromDate:nextDate];
            [MutableArray addObject:locationString];
        }
        sortArray= [NSArray arrayWithArray:MutableArray];
    }
    
    NSArray *arrayy=[[NSArray alloc]initWithArray:[dict allKeys]];
    NSArray *arrayx=[[NSArray alloc]initWithArray:[dict allValues]];
    NSMutableArray *mArray1 = [NSMutableArray arrayWithCapacity:sortArray.count];
    for (int i=0; i<sortArray.count; i++) {
        int s=arrayy.count;
        if(s==0)
        {
            int sum=(10+i*4);
            NSString *stt=[NSString stringWithFormat:@"%d",sum];
            [mArray1 insertObject:stt atIndex:i];
            
        }else{
            if ([arrayx containsObject:sortArray[i]]) {
                int s= [arrayx indexOfObject:sortArray[i]];
                [mArray1 insertObject:arrayy[s] atIndex:i];
            }else{
                int sum=1;
                NSString *stt=[NSString stringWithFormat:@"%d",sum];
                [mArray1 insertObject:stt atIndex:i];
            }
        }
    }
    
    
    if(self.chart)
    {
        [self.chart removeFromSuperview];
    }
    
    CBChartView *chartView=[CBChartView charView];
    self.chart=chartView;
    self.chart.frame=self.chartView.frame;
    self.chart.chartColor = [UIColor whiteColor];
    
    self.chart.chartWidth=0.8;
    [self.view addSubview:self.chart];
    
    self.chart.xValues=sortArray;
//    self.chart.yValues=@[@"0",@"0",@"0",@"5",@"0",@"0",@"40",@"0",@"0",@"0",@"0",@"0",@"0"];
    self.chart.yValues=mArray1;
    self.chart.yValueCount=mArray1.count;
    
    
    SmaSportResultInfo *info=(SmaSportResultInfo *)array[1];
    
    self.stepsLab.text=[NSString stringWithFormat:@"%@ %@",(!info.sumStep)?@"0":info.sumStep,SmaLocalizedString(@"sport_stepunit")];
    self.mileageLab.text=[NSString stringWithFormat:@"%@ %@",((!info.sumDistance)?@"0":[NSString stringWithFormat:@"%.2f",([info.sumDistance floatValue]/1000)]),SmaLocalizedString(@"sport_distanceunit")];
    self.hotLab.text=[NSString stringWithFormat:@"%@ %@",((!info.sumCalory)?@"0":[NSString stringWithFormat:@"%.2f",([info.sumCalory floatValue]/1000)]),SmaLocalizedString(@"sport_hotunit")];
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

@end
