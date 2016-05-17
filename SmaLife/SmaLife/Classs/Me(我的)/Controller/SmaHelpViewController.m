//
//  SmaHelpViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/23.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaHelpViewController.h"
#define SmaHelpImageCount 3

@interface SmaHelpViewController ()
{
    NSArray *helpArr;
}
@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation SmaHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    helpArr = @[SmaLocalizedString(@"help_question"),SmaLocalizedString(@"help_band"),@"http://www.smawatchusa.com/help",@"http://www.smawatchusa.com/help2"];
    self.title=SmaLocalizedString(@"set_help_title");
    CGRect size = [UIScreen mainScreen].bounds;
    UITableView *table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.tableFooterView = [[UIView alloc] init];
//    table.backgroundColor = [UIColor blueColor];
    [self.view addSubview:table];
//    // 1.添加UISrollView
//    [self setupScrollView];
//    // 2.添加pageControl
//    [self setupPageControl];
}

/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = SmaHelpImageCount;
    CGFloat centerX = self.view.frame.size.width * 0.5;
    CGFloat centerY = self.view.frame.size.height - 50;
    pageControl.center = CGPointMake(centerX, centerY);
    pageControl.bounds = CGRectMake(0, 0, 100, 30);
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = SmaColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = SmaColor(189, 189, 189);
}
//
///**
// *  添加UISrollView
// */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    for (int index = 0; index<SmaHelpImageCount; index++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 设置图片
        NSString *name = nil;
        
        
        name = [NSString stringWithFormat:@"help_%d", index + 1];
        
        imageView.image = [UIImage imageLocalWithName:name];
        
        
        CGFloat imageX = index * imageW;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH-64);
        
        [scrollView addSubview:imageView];
        
        // 在最后一个图片上面添加按钮
        if (index == SmaHelpImageCount - 1) {
            //[self setupLastImageView:imageView];
        }
    }
    
    // 3.设置滚动的内容尺寸
    scrollView.contentSize = CGSizeMake(imageW * SmaHelpImageCount, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HELPCELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HELPCELL"];
        cell.textLabel.text = helpArr[indexPath.row];
        cell.detailTextLabel.text = helpArr[indexPath.row+2];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:helpArr[indexPath.row + 2]]];

}
//
///**
// *  添加内容到最后一个图片
// */
//- (void)setupLastImageView:(UIImageView *)imageView
//{
//    // 0.让imageView能跟用户交互
//    imageView.userInteractionEnabled = YES;
//    
//    // 1.添加开始按钮
//    UIButton *startButton = [[UIButton alloc] init];
//    [startButton setBackgroundImage:[UIImage imageWithName:@"new_feature_finish_button"] forState:UIControlStateNormal];
//    [startButton setBackgroundImage:[UIImage imageWithName:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
//    
//    // 2.设置frame
//    CGFloat centerX = imageView.frame.size.width * 0.5;
//    CGFloat centerY = imageView.frame.size.height * 0.6;
//    startButton.center = CGPointMake(centerX, centerY);
//    startButton.bounds = (CGRect){CGPointZero, startButton.currentBackgroundImage.size};
//    
//    // 3.设置文字
//    [startButton setTitle:@"开始微博" forState:UIControlStateNormal];
//    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
//    [imageView addSubview:startButton];
//    
//    // 4.添加checkbox
//    UIButton *checkbox = [[UIButton alloc] init];
//    checkbox.selected = YES;
//    [checkbox setTitle:@"分享给大家" forState:UIControlStateNormal];
//    [checkbox setImage:[UIImage imageWithName:@"new_feature_share_false"] forState:UIControlStateNormal];
//    [checkbox setImage:[UIImage imageWithName:@"new_feature_share_true"] forState:UIControlStateSelected];
//    checkbox.bounds = CGRectMake(0, 0, 200, 50);
//    CGFloat checkboxCenterX = centerX;
//    CGFloat checkboxCenterY = imageView.frame.size.height * 0.5;
//    checkbox.center = CGPointMake(checkboxCenterX, checkboxCenterY);
//    [checkbox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    checkbox.titleLabel.font = [UIFont systemFontOfSize:15];
//    [checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
//    //    checkbox.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    checkbox.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
//    //    checkbox.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//    [imageView addSubview:checkbox];
//}
//
///**
// *  开始微博
// */
//- (void)start
//{
//}
//
//- (void)checkboxClick:(UIButton *)checkbox
//{
//    checkbox.selected = !checkbox.isSelected;
//}
//
///**
// *  只要UIScrollView滚动了,就会调用
// *
// */
//double pageCcount=0;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.取出水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 2.求出页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;
//    if(pageCcount!=2)
//        pageCcount=pageInt;
//    
//    if(pageCcount==2)
//    {
//        [self performSelector:@selector(start) withObject:nil afterDelay:2.0];
//    }
}

@end
