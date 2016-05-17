//
//  SmaSportDetail Controller.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/8.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaSportDetailController.h"
#import "CBChartView.h"


@interface SmaSportDetailController ()

@property (nonatomic,weak) UISegmentedControl *segmentedControl;
@property (weak, nonatomic) CBChartView *chartView;
@end

@implementation SmaSportDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithName:@"sportdetail_navigation_background"] forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_button_share" highIcon:@"nav_button_share_highlight" target:self action:@selector(share)];
    
    [self.view setBackgroundColor:[UIColor redColor]];
    //初始化UISegmentedControl
    UIImageView *backgrouImgView=[[UIImageView alloc]init];
    [backgrouImgView setImage:[UIImage imageWithName:@"sportdetail_background"]];    backgrouImgView.frame=CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [self.view addSubview:backgrouImgView];
    [self loadDateView];
    
    CBChartView *chartView = [CBChartView charView];
    
    chartView.frame=CGRectMake(10,50,280,200);
    [self.view addSubview:chartView];
    chartView.xValues = @[@"1",@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",@"11",@"12"];
    chartView.yValues = @[@"100", @"200", @"150", @"110", @"330", @"10", @"46", @"45", @"9", @"67",@"167",@"27"];
    chartView.yValueCount=12;
    chartView.chartColor = [UIColor whiteColor];
    chartView.chartWidth=0.8;
    self.chartView = chartView;
    
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

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"sport_navigation_background"] forBarMetrics:UIBarMetricsDefault];
    [super viewWillDisappear:animated];
}



/*加载界面*/
-(void)loadDateView
{
    CGFloat w = self.view.frame.size.width;
    UIView *dataView=[[UIView alloc]init];
    dataView.frame=CGRectMake(0,10, self.view.frame.size.width, 20);
    [self.view addSubview:dataView];
    
    dataView.userInteractionEnabled = YES;
    
    
    UISegmentedControl *segmentedControl=[[UISegmentedControl alloc] init];
    segmentedControl.center=CGPointMake(w/2,20);
    segmentedControl.bounds=CGRectMake(0,0,280,30);
    
    [segmentedControl insertSegmentWithTitle:@"天" atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"周" atIndex:1 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"月" atIndex:2 animated:YES];
    
    segmentedControl.momentary = YES;
    segmentedControl.multipleTouchEnabled=NO;
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.tintColor=[UIColor whiteColor];
    
    [dataView addSubview:segmentedControl];
    _segmentedControl=segmentedControl;
    
    
}

-(void)segmentAction:(UISegmentedControl *)Segment{
    NSInteger index = Segment.selectedSegmentIndex;
    
    if (index == 0) {
        //最新上架
        NSLog(@"最新上架");
        Segment.selectedSegmentIndex=0;
        
    }else if (index == 1) {
        //热销商品
        NSLog(@"热销商品");
        Segment.selectedSegmentIndex=1;
        
        
    }else {
        //促销商品
        Segment.selectedSegmentIndex=2;
        NSLog(@"促销商品");
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
