//
//  SmaWeekSelectController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/13.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaWeekSelectController.h"
#import "SmaAlarmInfo.h"
#import "SmaSeatInfo.h"

@interface SmaWeekSelectController ()
@property (nonatomic,weak) UITableView *table;
@property (nonatomic,strong) NSArray *weekArray;
@property (nonatomic,strong) NSMutableArray *weekArrSplit;
@end

@implementation SmaWeekSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem*backButton = [[UIBarButtonItem alloc] initWithTitle:SmaLocalizedString(@"alera_back") style:UIBarButtonItemStyleBordered target:self action:@selector(PopViewController)];
    self.navigationItem.leftBarButtonItem= backButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    
    [self loadTableView];
}
-(void)PopViewController
{
     [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(loadViewController)]) {
        // 更新模型数据
        [self.delegate loadViewController];
    }

}

-(NSArray *)weekArray
{
  if(!_weekArray)
  {
     _weekArray=@[SmaLocalizedString(@"clockadd_monday"),SmaLocalizedString(@"clockadd_tuesday"),SmaLocalizedString(@"clockadd_wednesday"),SmaLocalizedString(@"clockadd_thursday"),SmaLocalizedString(@"clockadd_friday"),SmaLocalizedString(@"clockadd_saturday"),SmaLocalizedString(@"clockadd_sunday")];
  }
    return _weekArray;
}
-(void)setWeekstr:(NSMutableString *)weekstr
{
   _weekArrSplit=(NSMutableArray *)[weekstr componentsSeparatedByString: @","];
    _weekstr=weekstr;
}

-(void)setAlarmInfo:(SmaAlarmInfo *)alarmInfo
{
   _alarmInfo=alarmInfo;
}

-(void)setSeatInfo:(SmaSeatInfo *)seatInfo
{
    _seatInfo=seatInfo;
}


-(void)loadTableView
{
    CGRect rect = CGRectMake(0,0,self.view.frame.size.width,320);
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    self.view.backgroundColor = [UIColor whiteColor];
    _table=tableView;
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=self.weekArray[indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int isCheck=[self.weekArrSplit[indexPath.row] intValue];
    cell.tintColor = [UIColor colorWithRed:195/255.0 green:14/255.0 blue:46/255.0 alpha:1];
    if(isCheck==1){
      cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
      cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    if(cell.accessoryType==UITableViewCellAccessoryCheckmark)
    {
       cell.accessoryType=UITableViewCellAccessoryNone;
       [self.weekArrSplit replaceObjectAtIndex:indexPath.row withObject:@"0"];
        
    }else
    {
      [self.weekArrSplit replaceObjectAtIndex:indexPath.row withObject:@"1"];
       cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    self.weekstr=(NSMutableString *)[self.weekArrSplit componentsJoinedByString:@","];
    
    if(self.seatInfo)
    {
        self.seatInfo.pepeatWeek=self.weekstr;
   
        
    }else if(self.alarmInfo)
    {
      self.alarmInfo.dayFlags=self.weekstr;
    }
 
}

@end
