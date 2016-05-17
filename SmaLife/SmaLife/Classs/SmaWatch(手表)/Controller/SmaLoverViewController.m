//
//  SmaLoverViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/9.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaLoverViewController.h"
#import "SmaAnalysisWebServiceTool.h"

@interface SmaLoverViewController ()<UIActionSheetDelegate>
{
    AppDelegate *app ;
}
@end

@implementation SmaLoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.createUIDelegate = self;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"love_navigation_background"] forBarMetrics:UIBarMetricsDefault];
    
    self.hidesBottomBarWhenPushed=YES;
    self.animImgView.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"watch_animation_1"],
                                      [UIImage imageNamed:@"watch_animation_2"],
                                      [UIImage imageNamed:@"watch_animation_3"],
                                      [UIImage imageNamed:@"watch_animation_4"], nil];
    self.animImgView.animationDuration = 1.2;

    self.animImgView.animationRepeatCount = 0;
    
    
    UIImage *imgbody=[UIImage imageNamed:@"love_body_bg"];
    CGFloat bodyh=imgbody.size.height;
    if(!fourInch)
    {
        bodyh=bodyh-40;
        self.animImgView.frame=CGRectMake(self.animImgView.frame.origin.x-10, self.animImgView.frame.origin.y-10, self.animImgView.frame.size.width-10, self.animImgView.frame.size.height-10);
    }else
    {
          self.animImgView.frame=CGRectMake(self.animImgView.frame.origin.x, self.animImgView.frame.origin.y, self.animImgView.frame.size.width, self.animImgView.frame.size.height);
    }

    self.bodyImg.frame=CGRectMake(0, 0, imgbody.size.width,bodyh);
    
    UIImage *imgdown=[UIImage imageNamed:@"love_down_bg"];
  
    self.downView.frame=CGRectMake(0,bodyh, imgdown.size.width, imgdown.size.height);
    self.downView.userInteractionEnabled=YES;
    [self noFriendView];
    
    
    UIImage *imgbtn=[UIImage imageNamed:@"love_nav_back_button"];
    UIImage *backButtonImage = imgbtn;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = backButtonImage;
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
 
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    
    [self.animImgView startAnimating];
    [self setFriendView];
    // 3.监听键盘的通知
    [SmaNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [SmaNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //设置本地区号
    [self setTheLocalAreaCode];
   // SmaAnalysisWebServiceTool *dal=[[SmaAnalysisWebServiceTool alloc]init];
    //[dal sendunBondFriends:@"12315" friendAccount:@"110"];
 
}
- (void)viewWillAppear:(BOOL)animated{
//    NSLog(@"获取好友信息");
//    SmaAnalysisWebServiceTool *dal=[[SmaAnalysisWebServiceTool alloc]init];
//    SmaUserInfo *userInfo=[SmaAccountTool userInfo];
//    [dal getBondFriends:@"IOS" userInfo:userInfo success:^(id json) {
//        SmaUserInfo *userInfo=[SmaAccountTool userInfo];
//        if ([(NSString *)[json objectForKey:@"result"] isEqualToString:@"okay"]) {
//            if ([[[json objectForKey:@"friend"] objectForKey:@"friendAccount"] isEqualToString:@"(null)"]) {
//                 userInfo.friendAccount = nil;
//            }
//            else{
//                userInfo.friendAccount = [[json objectForKey:@"friend"] objectForKey:@"friendAccount"];
//            }
//                userInfo.nicknameLove = [json objectForKey:@"nickName"];
//            [SmaAccountTool saveUser:userInfo];
//            [self setFriendView];
//        }
//        else if([(NSString *)[json objectForKey:@"result"] isEqualToString:@"none"]){
//             userInfo.friendAccount = nil;
//            [SmaAccountTool saveUser:userInfo];
//        }
//        NSLog(@"成功了");
//
//    } failure:^(NSError *erro) {
//        NSLog(@"失败1111");
//        [self setFriendView];
//    }];
}
- (void)setFriendView{
    SmaUserInfo *userInfo=[SmaAccountTool userInfo];
    if(userInfo && userInfo.friendAccount && ![userInfo.friendAccount isEqualToString:@""])
    {
        [self checkbind:userInfo];
        UIImage *relieveImg=[UIImage imageNamed:@"relieve_nav_back"];
        UIButton *relieveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [relieveBtn setImage:relieveImg forState:UIControlStateNormal];
        [relieveBtn addTarget:self action:@selector(relieveClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:relieveBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
        relieveBtn.frame = CGRectMake(0, 0, relieveImg.size.width, relieveImg.size.height);
    }
}
- (void)noFriendView{
    for (UIView *view in [self.downView subviews]) {
        if (view == self.accountId || view == self.downView || view == self.btnImgView || view == self.downlien || view == self.btnImgView) {
            view.hidden = NO;
        }
        else{
            [view removeFromSuperview];
        }
    }
    self.accountId.hidden = NO;
    areaCodeField.hidden = NO;
    state.hidden = NO;
    self.navigationItem.rightBarButtonItem = nil;
         UIImage *lineImg=[UIImage imageNamed:@"love_downline_bg"];
        CGFloat x=(self.view.frame.size.width-lineImg.size.width)/2;

    //区域码
    areaCodeField=[[UITextField alloc] init];
    areaCodeField.frame=CGRectMake(x, 5, (self.view.frame.size.width - 30)/5, 30);
    areaCodeField.enabled = NO;
    areaCodeField.textColor = [UIColor blackColor];
    areaCodeField.borderStyle=UITextBorderStyleNone;
    areaCodeField.text=[NSString stringWithFormat:@"+86"];
    areaCodeField.textAlignment=NSTextAlignmentCenter;
    areaCodeField.font=[UIFont fontWithName:@"Helvetica" size:18];
    areaCodeField.keyboardType=UIKeyboardTypePhonePad;
    [self.downView addSubview:areaCodeField];
    
    //
    UIView *countryView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(areaCodeField.frame), 5,lineImg.size.width-areaCodeField.frame.size.width, 30)];
    [self.downView addSubview:countryView];
    
    UIButton *countryBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [countryBut addTarget:self action:@selector(countryBut) forControlEvents:UIControlEventTouchUpInside];
    countryBut.frame = CGRectMake(0, 0, countryView.frame.size.width, countryView.frame.size.height);
    [countryView addSubview:countryBut];
    
    state =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, countryView.frame.size.width, 30)];
    state.textAlignment = NSTextAlignmentRight;
    state.textColor = [UIColor blackColor];
    state.text = @"中国";
    [countryView addSubview:state];
    
    UIImageView *countryLine=[[UIImageView alloc] init];
    countryLine.backgroundColor = [UIColor greenColor];
    [countryLine setImage:lineImg];
    countryLine.frame=CGRectMake(areaCodeField.frame.origin.x, areaCodeField.frame.origin.y+areaCodeField.frame.size.height+2,lineImg.size.width,lineImg.size.height);
    [self.downView addSubview:countryLine];

    
   

    self.downlien.frame=CGRectMake(x, 72, lineImg.size.width, lineImg.size.height);
    self.accountId.frame=CGRectMake(x,40, lineImg.size.width, 30);
    UIImage *btnImg=[UIImage imageNamed:@"love_begin"];
    self.btnImgView.frame=CGRectMake(124,self.downlien.frame.size.height+self.downlien.frame.origin.y+15, btnImg.size.width, btnImg.size.height);
    
    [self.downView addSubview:self.accountId];
    [self.downView addSubview:self.downlien];
    [self.downView addSubview:self.btnImgView];
    [self.downView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, self.btnImgView.frame.origin.y + self.btnImgView.frame.size.height +10)];
}
//解除绑定
-(void)relieveClick
{

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:SmaLocalizedString(@"alera_unbond")
                                  delegate:self
                                  cancelButtonTitle:SmaLocalizedString(@"clockadd_cancel")
                                  destructiveButtonTitle:SmaLocalizedString(@"clockadd_confirm")
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
    //sendunBondFriends:(SmaUserInfo *)userInfo
   
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [MBProgressHUD showMessage:SmaLocalizedString(@"relieve_assoc")];
        SmaAnalysisWebServiceTool *dal=[[SmaAnalysisWebServiceTool alloc]init];
        SmaUserInfo *userInfo=[SmaAccountTool userInfo];
        // [dal ];
        [dal acloudDeleteFridendAccount:userInfo.friendAccount MyAccount:userInfo.loginName myName:userInfo.nickname success:^(id result) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showMessage:SmaLocalizedString(@"lift_succ")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            userInfo.nicknameLove=@"";
            userInfo.friendAccount=@"";
            [SmaAccountTool saveUser:userInfo];
            [self noFriendView];

        } failure:^(NSError *erro) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:SmaLocalizedString(@"lift_fail")];
        }];
          }
}

-(void)checkbind:(SmaUserInfo *)userInfo
{
    for(UIView *view1 in [self.downView subviews])
    {
        [view1 setHidden:YES];
    }
    
    UIImageView *imgView=[[UIImageView alloc]init];
    UIImage *loveImg=[UIImage imageNamed:@"love_succeed"];
    [imgView setImage:loveImg];
    CGFloat x=(self.view.frame.size.width-loveImg.size.width)/2;
    imgView.frame=CGRectMake(x,20, loveImg.size.width,loveImg.size.height);
    //wake1.font=[UIFont fontWithName:@"STHeitiSC-Light" size:14];
    
    UILabel *leftlab=[[UILabel alloc]init];
    leftlab.font=[UIFont systemFontOfSize:24];
    leftlab.textColor=SmaColor(95, 42, 122);
    leftlab.text=userInfo.nickname;
    CGSize fontsize1=[leftlab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24]}];
    
    CGFloat x1=(self.view.frame.size.width-loveImg.size.width)/2-12-fontsize1.width;
    leftlab.frame=CGRectMake(x1, 25, fontsize1.width, fontsize1.height);
    
    UILabel *rightlab=[[UILabel alloc]init];
    rightlab.font=[UIFont systemFontOfSize:24];
    rightlab.textColor=SmaColor(95, 42, 122);
    rightlab.text=userInfo.nicknameLove;
    
    CGSize fontsize2=[rightlab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24]}];
    
    CGFloat x2=imgView.frame.origin.x+12+imgView.frame.size.width;
    rightlab.frame=CGRectMake(x2, 25, fontsize2.width, fontsize2.height);
    
    [self.downView addSubview:leftlab];
    [self.downView addSubview:rightlab];
    [self.downView addSubview:imgView];


}

- (void)dealloc
{
    [SmaNotificationCenter removeObserver:self];
}

-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"setting_navgitionbar_background"] forBarMetrics:UIBarMetricsDefault];
    [super viewWillDisappear:animated];
}

-(void)goBackAction
{
   
}
/**
 *  键盘即将显示的时候调用
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.取出键盘的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height+80);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnClick:(id)sender {
   SmaUserInfo *info = [SmaAccountTool userInfo];
    NSLog(@"----%@",info.loginName);
    if(!info || [info.loginName isEqualToString:@""] || [info.loginName isEqualToString:@"Blinkked"])
    {
        [MBProgressHUD showMessage:SmaLocalizedString(@"no_login")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return;
    }
//    SmaUserInfo *userInfo = [[SmaUserInfo alloc]init];


    NSString *account=self.accountId.text;
    if([account isEqualToString:@""])
    {
    
        [MBProgressHUD showMessage:SmaLocalizedString(@"input_number")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return;
    }
    if([account isEqualToString:info.tel])
    {
        [MBProgressHUD showMessage:SmaLocalizedString(@"input_nonumber")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return;
    }

    NSString *clientId= [SmaUserDefaults objectForKey:@"clientId"];
    
    [MBProgressHUD showMessage:SmaLocalizedString(@"ask_friend")];
    SmaAnalysisWebServiceTool *dal=[[SmaAnalysisWebServiceTool alloc]init];
    NSString *mobile=[NSString stringWithFormat:@"%@%@",[[areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@"00"] isEqualToString:@"0086"]?@"":[areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@"00"],self.accountId.text];

    [dal acloudRequestFriendAccount:mobile MyAccount:info.loginName myName:info.nickname success:^(id result) {
         [MBProgressHUD hideHUD];
        if([result integerValue]==1)//等待好友验证
        {
            //            info.friendAccount=self.accountId.text;
            [SmaAccountTool saveUser:info];
            NSLog(@"等待好友验证====%@   %@  ",info.friendAccount,[SmaAccountTool userInfo].friendAccount);
            [MBProgressHUD showMessage:SmaLocalizedString(@"alera_verifing")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.accountId.hidden=YES;
                areaCodeField.hidden = YES;
                state.hidden = YES;
                [self.btnImgView setImage:[UIImage imageNamed:@"love_proceed"] forState:UIControlStateNormal];
                [self.btnImgView setImage:[UIImage imageNamed:@"love_proceed"] forState:UIControlStateHighlighted];
                
                [MBProgressHUD hideHUD];
            });
        }else if([result integerValue]==-1)//账号不存在
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"alert_title") message:SmaLocalizedString(@"alera_notexits") delegate:nil cancelButtonTitle:nil otherButtonTitles:SmaLocalizedString(@"clockadd_confirm"), nil];
            [alertView show];
            
        }else if([result integerValue]==0)//对方已经配对
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"alert_title") message:SmaLocalizedString(@"have_friend") delegate:nil cancelButtonTitle:nil otherButtonTitles:SmaLocalizedString(@"clockadd_confirm"), nil];
            [alertView show];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"alert_title") message:SmaLocalizedString(@"alera_notexits") delegate:nil cancelButtonTitle:nil otherButtonTitles:SmaLocalizedString(@"clockadd_confirm"), nil];
        [alertView show];
        MyLog(@"ERROR==%@",error);
    }];
    
//    [dal getWebServiceSendLove:@"IOS" nickName:info.nickname friendAccount:account userAccount:info.loginName client_id:clientId success:^(id json) {
//         [MBProgressHUD hideHUD];
//
//        if([json integerValue]==200)//等待好友验证
//        {
////            info.friendAccount=self.accountId.text;
//            [SmaAccountTool saveUser:info];
//            NSLog(@"等待好友验证====%@   %@  ",info.friendAccount,[SmaAccountTool userInfo].friendAccount);
//            [MBProgressHUD showMessage:SmaLocalizedString(@"alera_verifing")];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.accountId.hidden=YES;
//                [self.btnImgView setImage:[UIImage imageNamed:@"love_proceed"] forState:UIControlStateNormal];
//                [self.btnImgView setImage:[UIImage imageNamed:@"love_proceed"] forState:UIControlStateHighlighted];
//                
//                [MBProgressHUD hideHUD];
//            });
//        }else if([json integerValue]==101)//账号不存在
//        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"alert_title") message:SmaLocalizedString(@"alera_notexits") delegate:nil cancelButtonTitle:nil otherButtonTitles:SmaLocalizedString(@"clockadd_confirm"), nil];
//            [alertView show];
//            
//        }else if([json integerValue]==100)//对方已经配对
//        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"alert_title") message:SmaLocalizedString(@"have_friend") delegate:nil cancelButtonTitle:nil otherButtonTitles:SmaLocalizedString(@"clockadd_confirm"), nil];
//            [alertView show];
//        }
//    } failure:^(NSError *error) {
//        MyLog(@"%@",error);
//    }];
}

- (void)createLoveUI{

    [self.accountId resignFirstResponder];
    [self noFriendView];
    SmaUserInfo *userInfo=[SmaAccountTool userInfo];
    if(userInfo && userInfo.friendAccount && ![userInfo.friendAccount isEqualToString:@""])
    {
        [self setFriendView];
    }
    //设置本地区号
    [self setTheLocalAreaCode];
}

-(void)setTheLocalAreaCode
{
    NSLocale *locale = [NSLocale currentLocale];
    
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    NSString* tt=[locale objectForKey:NSLocaleCountryCode];
    NSString* defaultCode=[dictCodes objectForKey:tt];
    areaCodeField.text=[NSString stringWithFormat:@"+%@",defaultCode];
    
    state.text=[locale displayNameForKey:NSLocaleCountryCode value:tt];
    
}

- (void)countryBut{
    SectionsViewController* country2=[[SectionsViewController alloc] init];
    country2.delegate=self;
    //    [country2 setAreaArray:_areaArray];
    [self presentViewController:country2 animated:YES completion:^{
        ;
    }];
    
}

#pragma mark - SecondViewControllerDelegate的方法
- (void)setSecondData:(CountryAndAreaCode *)data
{
    //    _data2=data;
    NSLog(@"the area data：%@,%@", data.areaCode,data.countryName);
    areaCodeField.text = [NSString stringWithFormat:@"+%@",data.areaCode];
    state.text = data.countryName;
    //    self.areaCodeField.text=[NSString stringWithFormat:@"+%@",data.areaCode];
    //    [self.tableView reloadData];
}
@end
