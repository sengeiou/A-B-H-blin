//
//  SmaAlarMainController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/12.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaAlarMainController.h"
#import "SmaAddAlarmViewController.h"
#import "SmaAlarmTableViewCell.h"
#import "SmaAlarmInfo.h"
#import "SmaDataDAL.h"

@interface SmaAlarMainController ()<SmaWeekClickControllerDelegate,SmaAlarmTableViewCellDelegate>
@property (nonatomic,strong) NSMutableArray *alarmArry;
@property (nonatomic,strong) NSMutableArray *colockArry;
@property (nonatomic,strong) UILabel *backgL;
@end

@implementation SmaAlarMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=SmaLocalizedString(@"clock_navtitle");
    
     self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"alarm_addttn_ico" highIcon:@"alarm_addttn_ico" target:self action:@selector(addClick)];
    UIImage *img=[UIImage imageNamed:@"nav_back_button"];
    CGSize size={img.size.width *0.5,img.size.height*0.5};
     UIImage *backButtonImage = [[UIImage imageByScalingAndCroppingForSize:size imageName:@"nav_back_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,30,0,5)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 30);
    button.imageEdgeInsets =UIEdgeInsetsMake(0, -28, 0, 0);
    [button setImage:backButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    if (!self.backgL) {
        self.backgL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-114)];
        self.backgL.textAlignment = NSTextAlignmentCenter;
        self.backgL.textColor = [UIColor redColor];
        self.backgL.text = SmaLocalizedString(@"clockadd_no_alarm");
        [self.view addSubview:self.backgL];
        self.backgL.hidden = YES;
    }
    [self getclock];
    
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getclock
{
    SmaDataDAL *dal=[[SmaDataDAL alloc]init];
    _alarmArry=[dal selectClockList];
    //[MBProgressHUD showMessage:SmaLocalizedString(@"alert_refresh")];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[MBProgressHUD hideHUD];
        [self.tableView reloadData];
        if (_alarmArry.count == 0 || !_alarmArry) {
            self.backgL.hidden = NO;
        }
        else{
            self.backgL.hidden = YES;
        }
    });
    
    
}

-(void)addClick
{
    if(!SmaBleMgr.peripheral || SmaBleMgr.peripheral.state==CBPeripheralStateDisconnected)
    {
        [MBProgressHUD showMessage:SmaLocalizedString(@"connect_blue")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [self.tableView reloadData];
        });

    }else{
        
    SmaAddAlarmViewController *alarmAddVc=[[SmaAddAlarmViewController alloc]init];
    alarmAddVc.delegate=self;
    [self.navigationController pushViewController:alarmAddVc animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.alarmArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    SmaAlarmTableViewCell *cell = [SmaAlarmTableViewCell cellWithTableView:tableView];

//    if(indexPath.row==(self.alarmArry.count))
//    {
//        cell.timeLab.hidden=YES;
//        cell.timeImg.hidden=YES;
//        cell.alarmSort.hidden=YES;
//        cell.alarmSwitch.hidden=YES;
//        cell.weeklab.hidden=YES;
//        UIButton *btn=[[UIButton alloc]init];
//        UIImage *imgName=[UIImage imageNamed:@"submit_clock_btn_bg"];
//         UIImage *imgselName=[UIImage imageNamed:@"submit_clock_btn_bg_sel"];
//        [btn setImage:imgName forState:UIControlStateNormal];
//        [btn setImage:imgName forState:UIControlStateHighlighted];
//        btn.frame=CGRectMake((cell.frame.size.width-imgName.size.width)/2,(50-imgName.size.height/2), imgName.size.width, imgName.size.height);
//        [cell.contentView addSubview:btn];
//        [btn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
//        
//    }else
//    {
        cell.alarmInfo=(SmaAlarmInfo *)self.alarmArry[indexPath.row];
    cell.delegate = self;
        
   // }
    return cell;
}
-(void)submitClick
{
   [self saveSeat];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

      SmaAddAlarmViewController *alarmAddVc=[[SmaAddAlarmViewController alloc]init];
      alarmAddVc.delegate=self;

      alarmAddVc.alarmInfo=self.alarmArry[indexPath.row];
      alarmAddVc.alarmInfo.aid=[NSString stringWithFormat:@"%d",indexPath.row];
      [self.navigationController pushViewController:alarmAddVc animated:YES];
    
}
-(void)saveSeat
{
    _colockArry=[NSMutableArray array];
    SmaDataDAL *dal=[[SmaDataDAL alloc]init];
    self.alarmArry=[dal selectClockList];
    int aid=0;
    for (int i=0; i<self.alarmArry.count; i++) {
        SmaAlarmInfo *info=(SmaAlarmInfo *)self.alarmArry[i];
        if([info.isopen intValue]>0)
        {
          info.aid=[NSString stringWithFormat:@"%d",aid];
          [self.colockArry addObject:info];
           aid++;
        }
    }
    
    if(SmaBleMgr.checkBleStatus)
    {
    
       [SmaBleMgr setCalarmClockInfo:self.colockArry];
    }
}

-(void)loadClickView
{
    [self getclock];
    [self saveSeat];
    
    
    [self viewDidLoad];
}
-(void)loadTableViewController
{
    [self getclock];
    [self saveSeat];
    
    
    [self viewDidLoad];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:

*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
