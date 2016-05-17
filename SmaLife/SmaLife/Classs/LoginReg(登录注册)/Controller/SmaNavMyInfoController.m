//
//  SmaNavMyInfoController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/15.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaNavMyInfoController.h"
#import "SmaTabBarViewController.h"
#import "SmaSelectWatchViewController.h"
#import "SmaAnalysisWebServiceTool.h"

@interface SmaNavMyInfoController ()
@property (weak, nonatomic) IBOutlet UIButton *wsexbnt;
@property (weak, nonatomic) IBOutlet UIButton *mensexbnt;
@property(nonatomic,weak)UIDatePicker *datePicker;//日期选择

@end

@implementation SmaNavMyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=SmaLocalizedString(@"myinfo_navtitle");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithName:@"sport_navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    [nextBtu setTitle:SmaLocalizedString(@"setting_next") forState:UIControlStateNormal];
    
    UIImage *img=[UIImage imageNamed:@"nav_back_button"];
    CGSize size={img.size.width *0.5,img.size.height*0.5};
    UIImage *backButtonImage = [[UIImage imageByScalingAndCroppingForSize:size imageName:@"nav_back_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,30,0,5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    //NSArray *idents = [NSLocale availableLocaleIdentifiers];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    datePicker.datePickerMode = UIDatePickerModeDate;//只显示日期，不显示时间
//    self.birthday.inputView=datePicker;
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    
    toolbar.bounds = CGRectMake(0, 0, 320, 44);
    toolbar.backgroundColor = [UIColor grayColor];
    
    UIBarButtonItem *tanhuangBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //创建完成按钮
    UIBarButtonItem *finish = [[UIBarButtonItem alloc] initWithTitle:SmaLocalizedString(@"achieve_btn") style:UIBarButtonItemStylePlain target:self action:@selector(finishSelectedDate)];
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:SmaLocalizedString(@"close_btn") style:UIBarButtonItemStylePlain target:self action:@selector(closeSelectedDate)];
    
    toolbar.items = @[close,tanhuangBtn,finish];
//    self.birthday.inputAccessoryView = toolbar;
    self.datePicker = datePicker;
    
    self.nickname.placeholder=SmaLocalizedString(@"myinfo_nickname");
    [self.headimgview setImage:[UIImage imageLocalWithName:@"default_head_img"]];
    
    [self.birthdaybtn setTitle:SmaLocalizedString(@"myinfo_age") forState:UIControlStateNormal];
    self.birthdaybtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.birthdaybtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
     [self.sexbtn setTitle:SmaLocalizedString(@"myinfo_sex") forState:UIControlStateNormal];
    self.sexbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.sexbtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
     [self.higthbtn setTitle:SmaLocalizedString(@"myinfo_height") forState:UIControlStateNormal];
    self.higthbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.higthbtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
     [self.weithbtn setTitle:SmaLocalizedString(@"myinfo_weight") forState:UIControlStateNormal];
    self.weithbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.weithbtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);

//
    // 3.监听键盘的通知
    [SmaNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [SmaNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.取出键盘的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height+160);
        // self.btnImgView.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
    }];
}

/**
 *  键盘即将退出的时候调用
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    // 1.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
        //self.btnImgView.transform = CGAffineTransformIdentity;
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)closeSelectedDate{
    [self.birthday resignFirstResponder];
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
    self.birthday.text = dateStr;
    //隐藏键盘
    [self.birthday resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextbtnClick:(id)sender {
    SmaUserInfo *userInfo1=[[SmaUserInfo alloc]init];
    userInfo1.userName=@"Blinkked";
    userInfo1.userId=@"1";
    userInfo1.loginName=@"Blinkked";
    userInfo1.userPwd=@"123456";
    userInfo1.watchName=@"";
    userInfo1.nickname=@"Blinkked";
    userInfo1.age=@"35";
    userInfo1.height=@"170";
    userInfo1.weight=@"77";
    userInfo1.sex=@"1";
    [SmaAccountTool saveUser:userInfo1];
    
    SmaUserInfo *userInfo=[SmaAccountTool userInfo];
    if(![self.nickname.text isEqualToString:@""])
    {
        userInfo.nickname=self.nickname.text;
//        [MBProgressHUD showMessage:SmaLocalizedString(@"alert_nickname")];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUD];
//        });
//        return;
    }
    
    
    if(![self.birthday.text isEqualToString:@""])
    {
         userInfo.age=self.birthday.text;
//        [MBProgressHUD showMessage:SmaLocalizedString(@"alert_dateofbirth")];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUD];
//        });
//        return;
    }
    
   
    
    if(![self.heightFiele.text isEqualToString:@""])
    {
        userInfo.height=self.heightFiele.text;
//        [MBProgressHUD showMessage:SmaLocalizedString(@"alert_height")];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUD];
//        });
//        return;
    }
    
    
    
    if(![self.weightfield.text isEqualToString:@""])
    {
         userInfo.weight=self.weightfield.text;
//        [MBProgressHUD showMessage:SmaLocalizedString(@"alert_weight")];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUD];
//        });
    }
    
    
    
    if(self.mensexbnt.selected)
    {
       userInfo.sex=@"1";
        
    }else {
        
        userInfo.sex=@"0";
    }
//    else{
//        [MBProgressHUD showMessage:SmaLocalizedString(@"alert_sex")];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUD];
//        });
//        return;
//    }
    
//    [MBProgressHUD showMessage:SmaLocalizedString(@"alert_setmenberinfo")];
    
//    SmaAnalysisWebServiceTool *webser=[[SmaAnalysisWebServiceTool alloc]init];
//    
//    [webser acloudPutUserifnfo:userInfo success:^(NSString *result) {
//        [MBProgressHUD hideHUD];
    
              [SmaAccountTool saveUser:userInfo];
            SmaSelectWatchViewController *reg=[[SmaSelectWatchViewController alloc]init];
            [self.navigationController pushViewController:reg animated:YES];

//    } failure:^(NSError *erro) {
//        [MBProgressHUD hideHUD];
//    } ];
}

- (IBAction)msexClick:(id)sender {
    self.mensexbnt.selected=true;
    self.wsexbnt.selected=!self.mensexbnt.selected;
}

- (IBAction)wsexBtnClick:(id)sender {
    self.wsexbnt.selected=true;
    self.mensexbnt.selected=!self.wsexbnt.selected;
}
@end
