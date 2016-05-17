//
//  SmaRravelViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/14.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaRravelViewController.h"
#import "SmaWeekSelectController.h"
#import "SmaSeatInfo.h"

@interface SmaRravelViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,weak) UIPickerView *pickeView;
@property (nonatomic,strong) NSMutableArray *timeArrary;
@property (nonatomic,strong) NSMutableArray *homeArrary;
@property(nonatomic,assign)int provinceIndex1;
@property(nonatomic,assign)int provinceIndex2;

@property (nonatomic,strong) NSString *weekStr;
@property (nonatomic,strong) NSString *seatValue;
@property (nonatomic,weak) UIButton *delbutton;
@property (nonatomic,strong) SmaSeatInfo *seatInfo;
@property (nonatomic, strong) NSString *RepeatSet;
@end

@implementation SmaRravelViewController

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=SmaLocalizedString(@"burnset_navtitle");
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"alarm_submit_bg" highIcon:@"alarm_submit_bg" target:self action:@selector(addClick)];
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
    [self setDataInfo];
    [self loadBodyView];
    
    SmaSeatInfo *seatinfo=[SmaAccountTool seatInfo];
    if(seatinfo.beginTime)
    {
        [self.pickeView selectRow:([seatinfo.beginTime intValue]-8>=0?[seatinfo.beginTime intValue]-8:0) inComponent:0 animated:YES];
        [self.pickeView selectRow:([seatinfo.endTime intValue]-8>=0?[seatinfo.endTime intValue]-8:0) inComponent:1 animated:YES];
        _provinceIndex1=[seatinfo.beginTime intValue]-8>=0?[seatinfo.beginTime intValue]-8:0;
        _provinceIndex2=[seatinfo.endTime intValue]-8>=0?[seatinfo.endTime intValue]-8:0;
    }
    // Do any additional setup after loading the view.
}
-(NSString *)weekStr
{
    if(!_weekStr)
    {
        _weekStr= @"0,0,0,0,0,0,0";
    }
    return _weekStr;
}
-(void)setDataInfo
{
    SmaSeatInfo *info=[SmaAccountTool seatInfo];
    if(info.pepeatWeek)
    {
        _weekStr=info.pepeatWeek;
        _seatValue=info.seatValue;
        
    }else{
        self.seatValue=@"30";
    }
}

-(NSMutableArray *)homeArrary
{
    NSString *timeStr=@"08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24";
    if(_homeArrary==nil)
    {
        _homeArrary=[NSMutableArray array];
        _homeArrary=(NSMutableArray *)[timeStr componentsSeparatedByString:@","];
    }
    return _homeArrary;
}
-(void)addClick
{
    if ([self.seatValue isEqualToString:@""]) {
        [MBProgressHUD showMessage:SmaLocalizedString(@"set_long_setup")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return;
    }
    if ([self.weekStr isEqualToString:@"0,0,0,0,0,0,0"]) {
        [MBProgressHUD showMessage:SmaLocalizedString(@"setting_time")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return;
    }
    SmaSeatInfo *seatInfo=[[SmaSeatInfo alloc]init];
    seatInfo.beginTime=self.homeArrary[self.provinceIndex1];
    seatInfo.endTime=self.homeArrary[self.provinceIndex2];
    seatInfo.seatValue=self.seatValue;
    seatInfo.stepValue=@"30";
    seatInfo.pepeatWeek=self.weekStr;
    seatInfo.isOpen = @"1";

    if([SmaBleMgr checkBleStatus])
    {
        [MBProgressHUD showSuccess:SmaLocalizedString(@"setting_success")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SmaAccountTool saveSeat:seatInfo];
            [SmaBleMgr seatLongTimeInfo:seatInfo];
//            [MBProgressHUD hideHUD];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

-(NSMutableArray *)timeArrary
{
    NSString *timeStr=@"8:00,9:00,10:00,11:00,12:00,13:00,14:00,15:00,16:00,17:00,18:00,19:00,20:00,21:00,22:00,23:00,24:00";
    if(_timeArrary==nil)
    {
        _timeArrary=[NSMutableArray array];
        _timeArrary=(NSMutableArray *)[timeStr componentsSeparatedByString:@","];
    }
    return _timeArrary;
    
    //arrary
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return self.timeArrary.count;
    }else{
        return self.timeArrary.count;
    }
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = nil;
    
    if (view != nil) {
        label = (UILabel *)view;
        //设置bound
    }else{
        label = [[UILabel alloc] init];
    }
    
    //显示省份
    if (component == 0) {
        
        NSString *dataTime = self.timeArrary[row];
        
        label.text = dataTime;
        label.textAlignment=NSTextAlignmentCenter;
        label.bounds = CGRectMake(0, 0, 160, 40);
    }else{//显示城市
        //默认是第一城市
        
        NSString *dataTime = self.timeArrary[row];
        label.text = dataTime;
        label.bounds = CGRectMake(0, 0, 160, 40);
        label.textAlignment=NSTextAlignmentCenter;
    }
    return label;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //省份选中
    if (component == 0) {
        self.provinceIndex1 = (int)row;
        
        //刷新右边的数据
        //[pickerView reloadComponent:1];
        
        //重新设置右边的数据显示第一行
        // [pickerView selectRow:0 inComponent:1 animated:YES];
    }else{
        self.provinceIndex2 = (int)row;
    }
}

//view的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    //省份的label宽度为150
    if (component == 0) {
        return 160;
    }else{
        //市的labl的宽度为100
        return 160;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

-(void)loadBodyView
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];

    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.userInteractionEnabled=YES;
    [bgView setImage:[UIImage imageNamed:@"rave_background"]];
    bgView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    UIImage *bodyImg=[UIImage imageNamed:@"rave_body_bg"];
    UIImageView *bbodyView = [[UIImageView alloc]init];
    bbodyView.userInteractionEnabled=YES;
    [bbodyView setImage:bodyImg];
    bbodyView.frame=CGRectMake(0, 0, bodyImg.size.width, bodyImg.size.height);
    [bgView addSubview:bbodyView];
    
    
    UILabel *begtitle = [[UILabel alloc]init];
    begtitle.font = [UIFont systemFontOfSize:13];
    begtitle.text = SmaLocalizedString(@"burnset_start");
    CGFloat orghtX;
    if ([[preferredLang substringToIndex:2] isEqualToString:@"zh"]) {
        orghtX =65;
    }
    else if ([[preferredLang substringToIndex:2] isEqualToString:@"fr"]){
        orghtX = 35;
    }
    else{
        orghtX = 60;
    }
   CGSize begtitleSize = [begtitle.text sizeWithAttributes:@{NSFontAttributeName: begtitle.font}];
    begtitle.frame=CGRectMake(orghtX, 7, begtitleSize.width, begtitleSize.height);

    
    [bbodyView addSubview:begtitle];
    
    
    UILabel *endTiltelView = [[UILabel alloc]init];
    endTiltelView.font = [UIFont systemFontOfSize:13];
    endTiltelView.text = SmaLocalizedString(@"burnset_end");

    CGSize endTiltelViewSize = [endTiltelView.text sizeWithAttributes:@{NSFontAttributeName: endTiltelView.font}];
     endTiltelView.frame=CGRectMake((bodyImg.size.width-orghtX-endTiltelViewSize.width), 7, endTiltelViewSize.width, endTiltelViewSize.height);
    [bbodyView addSubview:endTiltelView];
    
    
    UIImage *barBg=[UIImage imageNamed:@"alarmclock_bar_bg"];
    
    CGFloat tableh=barBg.size.height*2+7;
    CGRect rect = CGRectMake(0.0f,bodyImg.size.height+29,320.0f,tableh);
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    _table=tableView;
    [bgView addSubview:tableView];
    
    
    UIPickerView *pickview=[[UIPickerView alloc]init];
    pickview.delegate=self;
    pickview.dataSource=self;
    pickview.frame=CGRectMake(0, 30, bodyImg.size.width, bodyImg.size.height-30);
    _pickeView=pickview;
    [bbodyView addSubview:pickview];
    
    [self.view addSubview:bgView];
    
    UIImage *btnImg=[UIImage imageNamed:@"accomplish_btn_bg"];//关闭
    UIButton *delBtn=[[UIButton alloc]init];
    CGFloat magtop=40;
    if(!fourInch)
    {
        magtop=10;
    }
    delBtn.frame=CGRectMake((self.view.frame.size.width-btnImg.size.width)/2, (tableView.frame.size.height+tableView.frame.origin.y+magtop), btnImg.size.width,  btnImg.size.height);
    _delbutton=delBtn;
    UIImage *btnSelImg=[UIImage imageLocalWithName:@"accomplish_btn_bg"];//关闭
    [delBtn setTitle:SmaLocalizedString(@"burnest_off") forState:UIControlStateNormal];
    [delBtn setBackgroundImage:btnSelImg forState:UIControlStateNormal];
    UIImage *btnImg1=[UIImage imageLocalWithName:@"accomplish_btn_bg"];//开启
    [delBtn setBackgroundImage:btnImg1 forState:UIControlStateSelected];
    [delBtn setTitle:SmaLocalizedString(@"burnset_on") forState:UIControlStateSelected];
    if(self.seatInfo)
    {
        if([self.seatInfo.isOpen intValue]==0)
        {
            delBtn.selected=YES;
        }else{
            
            delBtn.selected=NO;
        }
        
        [self.view addSubview:delBtn];
        [delBtn addTarget:self action:@selector(UpdateClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)UpdateClick:(id)sender
{
    if ([self.seatValue isEqualToString:@""]) {
        [MBProgressHUD showMessage:SmaLocalizedString(@"set_long_setup")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return;
    }
    if ([self.weekStr isEqualToString:@"0,0,0,0,0,0,0"]) {
        [MBProgressHUD showMessage:SmaLocalizedString(@"setting_time")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return;
    }
    UIButton *btn=(UIButton *)sender;
    SmaSeatInfo *info=[SmaAccountTool seatInfo];
    info.isOpen=(btn.selected)?@"1":@"0";
    [SmaAccountTool saveSeat:info];
    [MBProgressHUD showMessage: SmaLocalizedString(@"alert_setprompt")];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
    if([info.isOpen intValue]>0 && info.isOpen)
    {
        //          //开启久座设置
//        if([SmaBleMgr checkBleStatus])
//        {
            MyLog(@"开始");
            [SmaBleMgr seatLongTimeInfo:info];
            btn.selected=!btn.isSelected;
//        }
    }else{
        //            //关闭久座设置
//        if([SmaBleMgr checkBleStatus])
//        {
            MyLog(@"关闭");
            [SmaBleMgr closeLongTimeInfo];
            btn.selected=!btn.isSelected;
//        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSString *str=[self getWeekStr:self.weekStr];
        cell.detailTextLabel.text=([str isEqualToString:@""])?SmaLocalizedString(@"clockadd_setting"):str;
        
    }else if(indexPath.section==1)
    {
        cell.textLabel.text=SmaLocalizedString(@"clockadd_planks");
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",self.seatValue,SmaLocalizedString(@"remind_min")];
    }
    return cell;
}
-(SmaSeatInfo *)seatInfo
{
    if(_seatInfo==nil)
    {
        _seatInfo=[SmaAccountTool seatInfo];
        
        if(_seatInfo==nil)
        {
            _seatInfo = [[SmaSeatInfo alloc]init];
        }
    }
    return _seatInfo;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        SmaWeekSelectController *weekVc = [[SmaWeekSelectController alloc] init];
        weekVc.delegate=self;
        weekVc.weekstr=self.weekStr;
        weekVc.seatInfo=self.seatInfo;
        self.seatInfo.pepeatWeek=self.weekStr;
        [self.navigationController pushViewController:weekVc animated:YES];
        
    }else{
        UIAlertView *customAlertView = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"clockadd_planks") message:nil delegate:self cancelButtonTitle:SmaLocalizedString(@"clockadd_cancel") otherButtonTitles:SmaLocalizedString(@"clockadd_confirm"), nil];
        
        //UIAlertViewStylePlainTextInput
        [customAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UILabel *unitLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
        //        unitLab.backgroundColor = [UIColor greenColor];
        unitLab.font = [UIFont systemFontOfSize:10];
        unitLab.text = SmaLocalizedString(@"remind_min");
        
        UITextField *nameField = [customAlertView textFieldAtIndex:0];
        nameField.keyboardType= UIKeyboardTypePhonePad;
        nameField.rightView = unitLab;
        nameField.rightViewMode = UITextFieldViewModeAlways;
        nameField.placeholder = @"";
        [customAlertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        
        self.seatValue=nameField.text;
        
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",nameField.text,SmaLocalizedString(@"remind_min")];
        [self.table reloadData];
    }
}

-(void)loadViewController
{
    
    [self weekStrConvert:self.seatInfo.pepeatWeek];
    self.weekStr=self.seatInfo.pepeatWeek;
    [self.table reloadData];
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
    cell.detailTextLabel.text=([str isEqualToString:@""])?@"请设置":str;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
