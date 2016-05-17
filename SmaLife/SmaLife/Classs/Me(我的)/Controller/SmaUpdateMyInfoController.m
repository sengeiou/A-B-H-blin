//
//  SmaUpdateMyInfoController.m
//  SmaLife
//
//  Created by chenkq on 15/4/15.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaUpdateMyInfoController.h"

@interface SmaUpdateMyInfoController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property(nonatomic,weak)UIDatePicker *datePicker;//日期选择

@end

@implementation SmaUpdateMyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=SmaLocalizedString(@"setting_myinfo");
   
    [self loadData];

    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    //NSArray *idents = [NSLocale availableLocaleIdentifiers];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
    datePicker.datePickerMode = UIDatePickerModeDate;//只显示日期，不显示时间
//    self.birthfield.inputView=datePicker;
    UIToolbar *toolbar = [[UIToolbar alloc] init];

    toolbar.bounds = CGRectMake(0, 0, 320, 44);
    toolbar.backgroundColor = [UIColor grayColor];

    UIBarButtonItem *tanhuangBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //创建完成按钮
    UIBarButtonItem *finish = [[UIBarButtonItem alloc] initWithTitle:SmaLocalizedString(@"achieve_btn") style:UIBarButtonItemStylePlain target:self action:@selector(finishSelectedDate)];
      UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:SmaLocalizedString(@"close_btn") style:UIBarButtonItemStylePlain target:self action:@selector(closeSelectedDate)];

    toolbar.items = @[close,tanhuangBtn,finish];
//    self.birthfield.inputAccessoryView = toolbar;
    self.datePicker = datePicker;
    
    /*国际化*/
//     [self.accontlab setTitle:SmaLocalizedString(@"myinfo_account") forState:UIControlStateNormal];
//    
//     self.accontlab.frame=CGRectMake(10, 9, 120, 25);
//     self.accontlab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//     self.accontlab.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
//    
//     [self.userpwdlab setTitle:SmaLocalizedString(@"myinfo_accountpwd") forState:UIControlStateNormal];
//     self.userpwdlab.frame=CGRectMake(10, 9, 120, 25);
//    self.userpwdlab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    self.userpwdlab.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
     [self.nicknamelab setTitle:SmaLocalizedString(@"myinfo_nickname") forState:UIControlStateNormal];
    
    
     self.nicknamelab.frame=CGRectMake(10, 9, 120, 25);
    self.nicknamelab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.nicknamelab.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    [self.birthdaylab setTitle:SmaLocalizedString(@"myinfo_age") forState:UIControlStateNormal];
    self.birthdaylab.frame=CGRectMake(10, 9, 120, 25);
    self.birthdaylab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.birthdaylab.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    [self.hightlab setTitle:SmaLocalizedString(@"myinfo_height") forState:UIControlStateNormal];
    self.hightlab.frame=CGRectMake(10, 9, 120, 25);
    self.hightlab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.hightlab.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    [self.weightlab setTitle:SmaLocalizedString(@"myinfo_weight") forState:UIControlStateNormal];
    self.weightlab.frame=CGRectMake(10, 9, 120, 25);
    self.weightlab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.weightlab.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    [self.sexlab setTitle:SmaLocalizedString(@"myinfo_sex") forState:UIControlStateNormal];
     self.sexlab.frame=CGRectMake(10, 9, 120, 25);
    self.sexlab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.sexlab.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    [self.submitBtn setBackgroundImage:[UIImage imageLocalWithName:@"accomplish_btn_bg"] forState:UIControlStateNormal];
    [self.submitBtn setBackgroundImage:[UIImage imageLocalWithName:@"accomplish_btn_bg"] forState:UIControlStateSelected];
    [self.submitBtn setTitle:SmaLocalizedString(@"myinfo_update") forState:UIControlStateNormal];
    [self.submitBtn setTitle:SmaLocalizedString(@"clockadd_confirm") forState:UIControlStateSelected];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}
-(void)closeSelectedDate{
  [self.birthfield resignFirstResponder];
}
-(void)finishSelectedDate{
    //获取时间
    NSDate *selectedDate = self.datePicker.date;
    //格式化日期(2014-08-25)
    //格式化日期类
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    //设置日期格式
    formater.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formater stringFromDate:selectedDate];
    self.birthfield.text = dateStr;
    //隐藏键盘
    [self.birthfield resignFirstResponder];
}

- (IBAction)submitClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if(!sender.selected)//完成
    {
        [self saveInfo];
        

       
    }else{//修改
        [self editMyInfo];
    }
}


- (IBAction)sexManBtnClick:(id)sender {
    self.manSex.selected=true;
    self.wmenSex.selected=!self.manSex.selected;
}

- (IBAction)sexWManBtnClick:(id)sender {
    self.wmenSex.selected=true;
    self.manSex.selected=!self.wmenSex.selected;
}
-(void)saveInfo
{
  
    SmaUserInfo *info = getUserINFO;
    info.loginName=self.acountfield.text;
    info.userPwd=self.pwdfield.text;
    info.nickname=self.nicknfield.text;
    info.height=self.heightfield.text;
    info.sex=(self.wmenSex.selected)?@"0":@"1";
    info.age=self.birthfield.text;

    info.weight=self.weightfield.text;
    info.area=self.areafield.text;

    
    [MBProgressHUD showMessage:SmaLocalizedString(@"alert_setmenberinfo")];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:SmaLocalizedString(@"myinfo_updatesucc")];
    });

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUD];
//    });
//    SmaAnalysisWebServiceTool *webser=[[SmaAnalysisWebServiceTool alloc]init];
//    [webser acloudPutUserifnfo:info success:^(NSString *result) {
//        [MBProgressHUD hideHUD];
                [SmaAccountTool saveUser:info];
//                    [self loadData];
//    } failure:^(NSError *erro) {
//        [MBProgressHUD hideHUD];
//    }];

//    if([SmaBleMgr checkBleStatus])
//    {
    
        
//        [webser updateWebserverUserInfo:info success:^(id object) {
////            [MBProgressHUD hideHUD];
//   
//            
//        } failure:^(NSError *str) {
////            [MBProgressHUD hideHUD];
//            
//        }];
        [SmaBleMgr setUserMnerberInfo:info];
//    }
}

-(void)editMyInfo
{
    self.acountfield.textAlignment=NSTextAlignmentRight;
    self.acountfield.enabled=YES;
    
    self.pwdfield.textAlignment=NSTextAlignmentRight;
    self.pwdfield.secureTextEntry=YES;
    self.pwdfield.enabled=YES;
    
    
    self.nicknfield.textAlignment=NSTextAlignmentRight;
    self.nicknfield.enabled=YES;
    
    
    self.birthfield.textAlignment=NSTextAlignmentRight;
    self.birthfield.enabled=YES;
    
    self.birthfield.keyboardType = UIKeyboardTypeNumberPad;
    self.heightfield.textAlignment=NSTextAlignmentRight;
    self.heightfield.enabled=YES;
    
    
    self.weightfield.textAlignment=NSTextAlignmentRight;
    self.weightfield.enabled=YES;
    
    self.areafield.textAlignment=NSTextAlignmentRight;
    self.areafield.enabled=YES;
}
-(void)loadData
{
    
    SmaUserInfo *info = getUserINFO;
    
    self.acountfield.text=info.loginName;
    self.acountfield.textAlignment=NSTextAlignmentRight;
   self.acountfield.enabled=NO;
    
    self.pwdfield.text=info.userPwd;
    self.pwdfield.textAlignment=NSTextAlignmentRight;
    self.pwdfield.secureTextEntry=YES;
    self.pwdfield.enabled=NO;
    
    self.nicknfield.text=info.nickname;
    self.nicknfield.textAlignment=NSTextAlignmentRight;
   self.nicknfield.enabled=NO;
    
    
    self.birthfield.text=info.age;
    self.birthfield.textAlignment=NSTextAlignmentRight;
    self.birthfield.enabled=NO;
    
    
    self.heightfield.text=info.height;
    self.heightfield.textAlignment=NSTextAlignmentRight;
    self.heightfield.enabled=NO;
    
    
    self.weightfield.text=info.weight;
    self.weightfield.textAlignment=NSTextAlignmentRight;
   self.weightfield.enabled=NO;
    
    
    self.areafield.text=info.area;
    self.areafield.textAlignment=NSTextAlignmentRight;
    self.areafield.enabled=NO;
    
    if([info.sex isEqualToString:@"1"])//0  女 ，1 男
        self.manSex.selected=true;
    else
        self.wmenSex.selected=true;
    
}


@end
