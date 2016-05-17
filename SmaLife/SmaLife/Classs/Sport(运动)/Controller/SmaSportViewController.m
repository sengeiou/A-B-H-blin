//
//  SmaSportMianViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/3.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaSportViewController.h"
#import "KAProgressLabel.h"
#import "SmaSportDetailController.h"

@interface SmaSportViewController ()

 @property (weak,nonatomic) KAProgressLabel * pLabel;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;

@end

@implementation SmaSportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithName:@"sport_navigation_background"] forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_button_share" highIcon:@"nav_button_share_highlight" target:self action:@selector(share)];
    
    UIImageView *backgroundView=[[UIImageView alloc]init];
    [backgroundView setImage:[UIImage imageNamed:@"sport_background"]];
    backgroundView.frame=CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:backgroundView];

    backgroundView.userInteractionEnabled = YES;

    //手势
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    
    //加载日期界面
    [self loadDateView];
}
//请求运动数据
-(void)getSportDataShow
{
  
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
   if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
       SmaSportDetailController *settingVc = [[SmaSportDetailController alloc] init];
       [self.navigationController pushViewController:settingVc animated:YES];
    }
}


/*加载界面*/
-(void)loadDateView
{
    CGFloat w = self.view.frame.size.width;
    UIView *dataView=[[UIView alloc]init];
    dataView.frame=CGRectMake(0, 20, self.view.frame.size.width, 20);
    [self.view addSubview:dataView];
    
     dataView.userInteractionEnabled = YES;
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"button_left"] forState:UIControlStateNormal];
    leftBtn.frame=CGRectMake(w*0.25-12,4,12,12);
    [leftBtn addTarget:self action:@selector(dataSwitchLeft) forControlEvents:UIControlEventTouchUpInside];
    [dataView addSubview:leftBtn];
    
    UILabel *lab=[[UILabel alloc]init];
    lab.text=@"3月25日";
    lab.center=CGPointMake(w/2,10);
    [lab setTextColor:[UIColor whiteColor]];
    lab.bounds=CGRectMake(0,0,66, 20);
    lab.textAlignment=NSTextAlignmentCenter;
    [dataView addSubview:lab];
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"button_right"] forState:UIControlStateNormal];
    rightBtn.frame=CGRectMake(w*0.75,4,12,12);
    [rightBtn addTarget:self action:@selector(dataSwitchRigth) forControlEvents:UIControlEventTouchUpInside];
    [dataView addSubview:rightBtn];
    
    [self loadScheduleView];
    [self loadLabView];
}

/*事件处理  begin*/
//日期往前翻页
-(void)dataSwitchLeft
{
    
}
//日期往后翻
-(void)dataSwitchRigth
{
    
}
//分享
-(void)share
{

}
-(void)loadScheduleView
{
    
    if(!_pLabel)
    {
        KAProgressLabel *pl=[[KAProgressLabel alloc]init];
        pl.frame=CGRectMake(60,60,180,180);
        [pl setBackgroundColor:[UIColor clearColor]];
        _pLabel=pl;
        [self.view addSubview:pl];
    }
    
    //self.pLabel.backgroundColor = [UIColor redColor];
    
    [self.pLabel setStartDegree:0.0f];
    [self.pLabel setEndDegree:180.0f];
    [self.pLabel setText:@"0%已经完成"];
    //__unsafe_unretained SmaSportViewController * weakSelf = self;
    self.pLabel.labelVCBlock = ^(KAProgressLabel *label) {
        //        weakSelf.pLabel.startLabel.text = [NSString stringWithFormat:@"%.f",weakSelf.pLabel.startDegree];
        //        weakSelf.pLabel.endLabel.text = [NSString stringWithFormat:@"%.f",weakSelf.pLabel.endDegree];
        
        float delta =label.endDegree-label.startDegree;
        
        if( delta<0){
            [label setText:[NSString stringWithFormat:@"%.0f%%已经完成",(delta+360)/3.6]];
        }else{
            [label setText:[NSString stringWithFormat:@"%.0f%%已经完成",(delta)/3.6]];
        }
        //        weakSelf.startSlider.value = label.startDegree;
        //        weakSelf.endSlider.value = label.endDegree;
    };
    [self.pLabel setRoundedCornersWidth:0.0f];//线条头大小
    [self.pLabel setTrackWidth:7.0f];//轨迹粗细
    [self.pLabel setProgressWidth:5.0f];//进度条粗细
    //    [self.pLabel setTrackWidth: 2.0];
    //    [self.pLabel setProgressWidth: 4];
    self.pLabel.fillColor = [[UIColor clearColor] colorWithAlphaComponent:0.1];
    self.pLabel.trackColor = [UIColor clearColor]; //self.startSlider.tintColor;
    self.pLabel.progressColor = [UIColor orangeColor];
    self.pLabel.isStartDegreeUserInteractive = NO;
    self.pLabel.isEndDegreeUserInteractive = NO;
    
}

-(void)loadLabView
{
    /*步数 begin*/
    CGFloat center=self.view.frame.size.width/2;
    
    UIImageView *labView=[[UIImageView alloc]init];
    labView.center=CGPointMake(center,self.pLabel.frame.origin.y+self.pLabel.frame.size.height+30);
    labView.bounds=CGRectMake(0,0,self.view.frame.size.width*0.5,30);
    [self.view addSubview:labView];
     labView.userInteractionEnabled = YES;
    
    UILabel *lable1= [[UILabel alloc]init];
    [lable1 setText:@"运动目标"];
    [lable1 setTextColor:[UIColor whiteColor]];
    [lable1 setFont:[UIFont systemFontOfSize: 18]];
    lable1.frame=CGRectMake(0, 0,80, 30);
    [labView addSubview:lable1];
    
    
    UILabel *lable3= [[UILabel alloc]init];
    [lable3 setText:@"步"];
    [lable3 setTextColor:[UIColor whiteColor]];
    [lable3 setFont:[UIFont systemFontOfSize: 18]];
    lable3.frame=CGRectMake(labView.frame.origin.x+labView.frame.size.width/2-20,0,20, 30);
    [labView addSubview:lable3];
    
    
    UILabel *stepNumberLab= [[UILabel alloc]init];
    [stepNumberLab setText:@"1000"];
    [stepNumberLab setTextColor:[UIColor whiteColor]];;
    [stepNumberLab setFont:[UIFont systemFontOfSize: 20]];
    stepNumberLab.frame=CGRectMake(lable1.frame.size.width,0,labView.frame.size.width-100,28);
    [labView addSubview:stepNumberLab];
    
    /*下划线*/
    UIImageView *pwdLine=[[UIImageView alloc] init];
    [pwdLine setImage:[UIImage imageNamed:@"textfield_line"]];
    pwdLine.frame=CGRectMake(lable1.frame.size.width,28,labView.frame.size.width-100,1);
    [labView addSubview:pwdLine];
    /*步数 end*/
    
    /*title tool begin*/
    UIImageView *titleToolImg=[[UIImageView alloc]init];
    titleToolImg.center=CGPointMake(center,labView.frame.origin.y+labView.frame.size.height+30);
    titleToolImg.bounds=CGRectMake(0, 0, self.view.frame.size.width*0.7,40);
    [self.view addSubview:titleToolImg];
    titleToolImg.userInteractionEnabled = YES;
    

    CGFloat x=self.view.frame.origin.x*0.15;
    CGFloat radi=((self.view.frame.size.width*0.8)/7);
    
    UILabel *lab1 = [[UILabel alloc]init];
    lab1.textAlignment=NSTextAlignmentCenter;
    lab1.text=@"里程";
    lab1.font=[UIFont systemFontOfSize:18];
    lab1.textColor=[UIColor whiteColor];
    lab1.center = CGPointMake(x+radi*1,10);
    lab1.bounds = (CGRect){CGPointZero,40,30};
    [titleToolImg addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc]init];
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2.text=@"里程";
    lab2.font=[UIFont systemFontOfSize:18];
    lab2.textColor=[UIColor whiteColor];
    lab2.center = CGPointMake(x+radi*3,10);
    lab2.bounds = (CGRect){CGPointZero,40,30};
    [titleToolImg addSubview:lab2];
    
    UILabel *lab3 = [[UILabel alloc]init];
    lab3.text=@"里程里程";
    lab3.textAlignment=NSTextAlignmentCenter;
    lab3.font=[UIFont systemFontOfSize:18];
    lab3.textColor=[UIColor whiteColor];
    lab3.center = CGPointMake(x+radi*5,10);
    lab3.bounds = (CGRect){CGPointZero,80,30};
    [titleToolImg addSubview:lab3];
    
    UILabel *lab11 = [[UILabel alloc]init];
    lab11.textAlignment=NSTextAlignmentCenter;
    lab11.text=@"1000km";
    lab11.font=[UIFont systemFontOfSize:18];
    lab11.textColor=[UIColor whiteColor];
    lab11.center = CGPointMake(x+radi*1,30);
    lab11.bounds = (CGRect){CGPointZero,80,30};
    [titleToolImg addSubview:lab11];
    
    
    UILabel *lab22 = [[UILabel alloc]init];
    lab22.textAlignment=NSTextAlignmentCenter;
    lab22.text=@"100步";
    lab22.font=[UIFont systemFontOfSize:18];
    lab22.textColor=[UIColor whiteColor];
    lab22.center = CGPointMake(x+radi*3,30);
    lab22.bounds = (CGRect){CGPointZero,80,30};
    [titleToolImg addSubview:lab22];
    
    UILabel *lab33 = [[UILabel alloc]init];
    lab33.text=@"1000k";
    lab33.textAlignment=NSTextAlignmentCenter;
    lab33.font=[UIFont systemFontOfSize:18];
    lab33.textColor=[UIColor whiteColor];
    lab33.center = CGPointMake(x+radi*5,30);
    lab33.bounds = (CGRect){CGPointZero,80,30};
    [titleToolImg addSubview:lab33];
    
    
     /*title tool end*/
    
    
}


/*事件处理  end*/


@end
