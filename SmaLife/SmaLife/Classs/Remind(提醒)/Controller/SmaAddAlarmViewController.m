//
//  SmaAddAlarmViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/12.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaAddAlarmViewController.h"
#import "SmaWeekSelectController.h"
#import "SmaAlarmInfo.h"
#import "SmaDataDAL.h"


@interface SmaAddAlarmViewController ()<SmaWeekSelectControllerDelegate>

@property (nonatomic,weak) UIDatePicker *beginTimePicker;


@property (nonatomic,weak) UIImageView *bgView;
@property (nonatomic,weak) UITableView *table;
@property (nonatomic,strong) NSMutableArray *hourArr;
@property (nonatomic,strong) NSMutableArray *minArr;
@property (nonatomic,strong) UIPickerView *pickeView;
@property (nonatomic,strong) NSString *weekStr;
@property (nonatomic,strong) NSString *tagName;
@property (nonatomic,weak) UIButton *delbutton;
@end

@implementation SmaAddAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title=@"添加闹钟";
    self.title=SmaLocalizedString(@"clockadd_navtitle");

     self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"alarm_submit_bg" highIcon:@"alarm_submit_bg" target:self action:@selector(addClick)];
    
    UIImage *bgImg=[UIImage imageNamed:@"add_alarm_bg"];
    UIImageView *bgView=[[UIImageView alloc]init];
    [bgView setImage:bgImg];
    bgView.userInteractionEnabled=YES;
    bgView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _bgView=bgView;
    
    [self.view addSubview:bgView];
    
    [self loadUerHead];
    
    [self setLoadInfo:self.alarmInfo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//添加闹钟
-(void)addClick
{
    NSString *RepeatTime = [self getWeekStr:self.weekStr];
    if (!RepeatTime || [RepeatTime isEqualToString:@""]) {
        [MBProgressHUD showMessage:SmaLocalizedString(@"setting_time")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return;
    }
    SmaUserInfo *userInfo=[SmaAccountTool userInfo];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    self.alarmInfo.year=[NSString stringWithFormat:@"%ld",(long)[dateComponent year]];
    self.alarmInfo.mounth=[NSString stringWithFormat:@"%ld",(long)[dateComponent month]];
    self.alarmInfo.day=[NSString stringWithFormat:@"%ld",(long)[dateComponent day]];
    
    self.alarmInfo.userId=[NSString stringWithFormat:@"%@",userInfo.userId];
    self.alarmInfo.tagname=self.tagName;
    self.alarmInfo.isopen=@"1";
    self.alarmInfo.dayFlags=self.weekStr;
    
    SmaDataDAL *dal=[[SmaDataDAL alloc]init];
    if(!self.alarmInfo.clockid)
    {
      [dal insertClockInfo:self.alarmInfo];
        
    }else{
      [dal updateClockInfo:self.alarmInfo];
    }
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(loadClickView)]) {
        [self.delegate loadClickView];
    }
    

}
-(NSString *)tagName
{
    if(!_tagName)
    {
       _tagName=@"";
    }
    return _tagName;
}
//-(SmaAlarmInfo *)alarmInfo
//{
//    if(!_alarmInfo)
//    {
//        _alarmInfo=[[SmaAlarmInfo alloc]init];
//    }
//    return _alarmInfo;
//}


-(void)setAlarmInfo:(SmaAlarmInfo *)alarmInfo
{
    _alarmInfo=alarmInfo;

}
-(void)setLoadInfo:(SmaAlarmInfo *)info
{
    
    if(_alarmInfo)
    {
        [self.pickeView selectRow:[info.hour intValue] inComponent:0 animated:YES];
        [self.pickeView selectRow:[info.minute intValue]+150*60 inComponent:1 animated:YES];

     _weekStr=self.alarmInfo.dayFlags;
     UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
      self.tagName=self.alarmInfo.tagname;
      cell.detailTextLabel.text=self.alarmInfo.tagname;
    }else
    {
      _alarmInfo=[[SmaAlarmInfo alloc]init];
        [self.pickeView selectRow:0 inComponent:0 animated:YES];
        [self.pickeView selectRow:150*60 inComponent:1 animated:YES];

    }
    

    
}


-(void)loadUerHead
{
    self.minArr = [NSMutableArray array];
    self.hourArr = [NSMutableArray array];
    [self.hourArr removeAllObjects];
    [self.minArr removeAllObjects];
    for (int i = 0; i<24; i++) {
        [self.hourArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    for (int i = 0; i<60; i++) {
        [self.minArr addObject:[NSString stringWithFormat:@"%d",i]];
    }

    UIImageView *beginTime=[[UIImageView alloc]init];
    UIImage *timeImg=[UIImage imageNamed:@"alarm_time_select_bg"];
    [beginTime setImage:timeImg];
    beginTime.frame=CGRectMake(0, 0, timeImg.size.width, timeImg.size.height);
    beginTime.userInteractionEnabled = YES;
    CGRect mainSize = [UIScreen mainScreen].bounds;
//    UIDatePicker *beginDatePicker = [[UIDatePicker alloc] init];
//    beginDatePicker.frame = CGRectMake(0, 0, timeImg.size.width, timeImg.size.height);
//    beginDatePicker.datePickerMode=UIDatePickerModeCountDownTimer;
//    
//    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
//    [beginDatePicker setLocale:locale];
//    
//    [beginTime addSubview:beginDatePicker];
//    _beginTimePicker=beginDatePicker;
     //beginTime.clipsToBounds=YES;
    UILabel *hourLab = [[UILabel alloc] initWithFrame:CGRectMake(mainSize.size.width/2-110, 5, 60, 20)];
    //    hourLab.backgroundColor = [UIColor redColor];
    hourLab.textAlignment = NSTextAlignmentRight;
    hourLab.text = SmaLocalizedString(@"clockadd_hour");
    [beginTime addSubview:hourLab];
    
    UILabel *minLab = [[UILabel alloc] initWithFrame:CGRectMake(mainSize.size.width/2+50, 5, 60, 20)];
    //    minLab.backgroundColor = [UIColor redColor];
    minLab.text = SmaLocalizedString(@"clockadd_min");
    [beginTime addSubview:minLab];
    
    if (!self.pickeView) {
        self.pickeView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 25, timeImg.size.width, timeImg.size.height-25)];
        self.pickeView.delegate = self;
        self.pickeView.dataSource = self;
    }
    [beginTime addSubview:self.pickeView];
    
     [self.bgView addSubview:beginTime];
    UIImage *barBg=[UIImage imageNamed:@"alarmclock_bar_bg"];
    
    CGFloat tableh=barBg.size.height*2+7;
    CGRect rect = CGRectMake(0.0f,timeImg.size.height+29,320.0f,tableh);
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    _table=tableView;
    [self.view addSubview:tableView];
    
    UIButton *delBtn=[[UIButton alloc]init];
    UIImage *btnSelImg=[UIImage imageNamed:@"deletecolck_btn_sel"];
    UIImage *btnImg=[UIImage imageNamed:@"deletecolck_btn"];
    [delBtn setTitle:SmaLocalizedString(@"clockadd_delete") forState:UIControlStateNormal];
    [delBtn setTitle:SmaLocalizedString(@"clockadd_delete") forState:UIControlStateHighlighted];
    [delBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
    [delBtn setBackgroundImage:btnSelImg forState:UIControlStateHighlighted];
    
    
    
    delBtn.frame=CGRectMake((self.view.frame.size.width-btnImg.size.width)/2, (tableView.frame.size.height+tableView.frame.origin.y+40), btnImg.size.width,  btnImg.size.height);
    _delbutton=delBtn;
    if(self.alarmInfo.clockid)
    {
        [self.view addSubview:delBtn];
        delBtn.tag=[self.alarmInfo.clockid intValue];
        MyLog(@"闹钟ID－－%@",self.alarmInfo.clockid);
        [delBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)deleteClick:(id)serden
{
    //UIButton *btn=(UIButton *)serden;
    SmaDataDAL *dal=[[SmaDataDAL alloc]init];
    [dal deleteClockInfo: self.alarmInfo.clockid];
    
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(loadClickView)]) {
        [self.delegate loadClickView];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
    if(indexPath.section==0)
    {
        cell.textLabel.text=SmaLocalizedString(@"clockadd_repeat");
        if(_alarmInfo)
        {
            NSString *str=[self getWeekStr:self.weekStr];
            cell.detailTextLabel.text=([str isEqualToString:@""])?SmaLocalizedString(@"clockadd_setting"):str;
        }
        
    }else if(indexPath.section==1)
    {
        cell.textLabel.text=SmaLocalizedString(@"clockadd_tag");
        if(_alarmInfo)
        {
          
           cell.detailTextLabel.text=self.tagName;
        }
        
    }
    return cell;
}

-(NSString *)weekStr
{
    if(!_weekStr)
    {
       _weekStr= @"0,0,0,0,0,0,0";
    }
    return _weekStr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
      SmaWeekSelectController *weekVc = [[SmaWeekSelectController alloc] init];
      weekVc.delegate=self;
        
      weekVc.weekstr=self.weekStr;
      self.alarmInfo.dayFlags=self.weekStr;
      weekVc.alarmInfo=self.alarmInfo;
        
      [self.navigationController pushViewController:weekVc animated:YES];
        
    }else{
        UIAlertView *customAlertView = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"clockadd_tag") message:nil delegate:self cancelButtonTitle:SmaLocalizedString(@"clockadd_cancel") otherButtonTitles:SmaLocalizedString(@"clockadd_confirm"), nil];
        
        [customAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        UITextField *nameField = [customAlertView textFieldAtIndex:0];
        nameField.placeholder = SmaLocalizedString(@"clockadd_tag");

        [customAlertView show];
    }
}

-(void)weekStrConvert:(NSString *)weekStr
{
    
    NSArray *week=[weekStr componentsSeparatedByString: @","];
    NSString *str=@"";
    int counts=0;
    for (int i=0; i<week.count; i++) {
        if([week[i] intValue]==1)
        {
            counts++;
            str=[NSString stringWithFormat:@"%@  %@",str,[self stringWith:i]];
        }
    }
    if(counts==7)
      str=SmaLocalizedString(@"clockadd_everyday");
    
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text=str;
    [self.table reloadData];
    
}
-(NSString *)getWeekStr:(NSString *)weekStr
{
    
    NSArray *week=[weekStr componentsSeparatedByString: @","];
    NSString *str=@"";
    int counts=0;
    for (int i=0; i<week.count; i++) {
        if([week[i] intValue]==1)
        {
            counts++;
            str=[NSString stringWithFormat:@"%@  %@",str,[self stringWith:i]];
        }
    }
    if(counts==7)
        str=SmaLocalizedString(@"clockadd_everyday");
    
    return str;
    
}


-(NSString *)stringWith:(int)weekInt
{
    NSString *weekStr=@"";
    switch (weekInt) {
        case 0:
            weekStr= SmaLocalizedString(@"clockadd_monday");
            break;
        case 1:
            weekStr= SmaLocalizedString(@"clockadd_tuesday");
            break;
        case 2:
            weekStr= SmaLocalizedString(@"clockadd_wednesday");
            break;
        case 3:
            weekStr= SmaLocalizedString(@"clockadd_thursday");
            break;
        case 4:
            weekStr=SmaLocalizedString(@"clockadd_friday");
            break;
        case 5:
            weekStr= SmaLocalizedString(@"clockadd_saturday");
            break;
        default:
            weekStr= SmaLocalizedString(@"clockadd_sunday");
    }
    return weekStr;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            UITextField *nameField = [alertView textFieldAtIndex:0];
            UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            self.tagName=nameField.text;
            cell.detailTextLabel.text=nameField.text;
            [self.table reloadData];
        }
}
-(void)loadViewController
{
   [self weekStrConvert:self.alarmInfo.dayFlags];
    self.weekStr=self.alarmInfo.dayFlags;
   [self.table reloadData];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 24;
    }
    else{
        return 18000;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return [self.hourArr objectAtIndex:row];
    }
    else{
        return [self.minArr objectAtIndex:(row%60)];
    }
    //    return [strings objectAtIndex:(row%10)];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self pickerViewLoaded:row component:component];
}

-(void)pickerViewLoaded: (NSInteger)blah component:(NSInteger)com {
   
    if (com == 0) {
        self.alarmInfo.hour=[NSString stringWithFormat:@"%ld",blah];
    }
    else{
        self.alarmInfo.minute=[NSString stringWithFormat:@"%ld",blah%60];
    }
    //    NSUInteger max = 18000;
    //    NSUInteger base10 = (max/2)-(max/2)%10;
    //    [self.pickeView selectRow:[self.pickeView selectedRowInComponent:0]%10+base10 inComponent:0 animated:false];
}

//view的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    //省份的label宽度为150
    if (component == 0) {
        return 130;
    }else{
        //市的labl的宽度为100
        return 150;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
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
