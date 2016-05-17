//
//  SmaMainRegViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/10.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaMainRegViewController.h"
#import "SmaTabBarViewController.h"//试用
//#import "RegViewController.h"
#import "RegViewController.h"
#import "SmaTextField.h"


#define SmaTextFieldImgRatio 0.5
#define SmaButtonImgRatio 0.5
#define UINavigationBarHeight 64
#define SmaButtonTextWidth 0.7


@interface SmaMainRegViewController ()
{
    UITextField* areaCodeField;
    UILabel *state;
}
@end

@implementation SmaMainRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithName:@"rave_navbar_bg"] forBarMetrics:UIBarMetricsDefault];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:SmaLocalizedString(@"login_navtitle") style:UIBarButtonItemStylePlain target:self action:@selector(loginClick)];
      self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(320, 3)]];
    
    [self loadFrome];
    // 3.监听键盘的通知
    [SmaNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [SmaNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)loadFrome
{
    UIImage *logImg=[UIImage imageNamed:@"sma_logo"];
    
    CGFloat topMag=19;
    if(!fourInch)
        topMag=9;
    
    UIImageView *logoView=[[UIImageView alloc]init];
    logoView.frame=CGRectMake(117,topMag,logImg.size.width,logImg.size.height);
    [self.view addSubview:logoView];
    
    logoView.userInteractionEnabled = YES;
        CGFloat tfw=(self.view.frame.size.width-92);
    //园角图片
    UIImageView *faceImg = [[UIImageView alloc] init];
    faceImg.frame = CGRectMake(0, 0,logImg.size.width,logImg.size.height);
    [faceImg setImage:[UIImage imageNamed:@"sma_logo"]];
    [logoView addSubview:faceImg];
    
    
    SmaTextField *userNameField = [SmaTextField smaTextField];
    // 左边的放大镜图标
    UIImage *headImng=[UIImage imageNamed:@"mobile_img_bg"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:headImng];
    
    iconView.contentMode = UIViewContentModeCenter;
    userNameField.leftView = iconView;
    userNameField.leftViewMode = UITextFieldViewModeAlways;
    
    //区域码
    //区域码
    areaCodeField=[[UITextField alloc] init];
    areaCodeField.frame=CGRectMake(46, logoView.frame.origin.y+logoView.frame.size.height+10, (self.view.frame.size.width - 30)/3.5, 32);
    areaCodeField.enabled = NO;
    areaCodeField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"区号图标"]];
    areaCodeField.leftViewMode = UITextFieldViewModeAlways;
    areaCodeField.textColor = [UIColor whiteColor];
    areaCodeField.borderStyle=UITextBorderStyleNone;
    areaCodeField.text=[NSString stringWithFormat:@"+886"];
    areaCodeField.font=[UIFont fontWithName:@"Helvetica" size:18];
    areaCodeField.keyboardType=UIKeyboardTypePhonePad;
    [self.view addSubview:areaCodeField];
    
    //
    UIView *countryView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(areaCodeField.frame), logoView.frame.origin.y+logoView.frame.size.height+10,tfw-areaCodeField.frame.size.width , 32)];
    [self.view addSubview:countryView];
    
    UIButton *countryBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [countryBut addTarget:self action:@selector(countryBut) forControlEvents:UIControlEventTouchUpInside];
    countryBut.frame = CGRectMake(0, 0, countryView.frame.size.width, countryView.frame.size.height);
    [countryView addSubview:countryBut];
    
    state =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, countryView.frame.size.width, 32)];
    state.textAlignment = NSTextAlignmentRight;
    state.textColor = [UIColor whiteColor];
    state.text = @"中国";
    [countryView addSubview:state];
    
    UIImageView *countryLine=[[UIImageView alloc] init];
    UIImage *countryImg= [UIImage imageNamed:@"textfield_line"];
    [countryLine setImage:countryImg];
    countryLine.frame=CGRectMake(areaCodeField.frame.origin.x, areaCodeField.frame.origin.y+areaCodeField.frame.size.height+2,countryImg.size.width,1);
    [self.view addSubview:countryLine];
    

    userNameField.frame =CGRectMake(46, countryView.frame.origin.y+countryView.frame.size.height+19, tfw, 32);
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    userNameField.placeholder = SmaLocalizedString(@"login_phone");
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    // userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名" attributes:attrs];
    [self.view addSubview:userNameField];
    self.phoneCode=userNameField;
    UIImageView *nameLine=[[UIImageView alloc] init];
    UIImage *lineImg= [UIImage imageNamed:@"textfield_line"];
    [nameLine setImage:lineImg];
    nameLine.frame=CGRectMake(userNameField.frame.origin.x, userNameField.frame.origin.y+userNameField.frame.size.height+2,lineImg.size.width,1);
    [self.view addSubview:nameLine];
    
    SmaTextField *userPwdField = [SmaTextField smaTextField];
    UIImage *img2=[UIImage imageNamed:@"pwd_textfield_ico"];
    UIImageView *iconView1 = [[UIImageView alloc] initWithImage:img2];
    userPwdField.secureTextEntry=YES;
    userPwdField.placeholder = SmaLocalizedString(@"long_password");
    iconView1.contentMode = UIViewContentModeCenter;
    userPwdField.leftView = iconView1;
    userPwdField.delegate = self;
    userPwdField.leftViewMode = UITextFieldViewModeAlways;
    userPwdField.frame = CGRectMake(46,nameLine.frame.origin.y+nameLine.frame.size.height+19, tfw, 32);
    //userPwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:attrs];
    [self.view addSubview:userPwdField];
    _pwdCode=userPwdField;
    
    UIImageView *pwdLine=[[UIImageView alloc] init];
    [pwdLine setImage:[UIImage imageNamed:@"textfield_line"]];
    pwdLine.frame=CGRectMake(userPwdField.frame.origin.x, userPwdField.frame.origin.y+userPwdField.frame.size.height+2,lineImg.size.width,1);
    [self.view addSubview:pwdLine];
    
    SmaTextField * tureUserPwd = [SmaTextField smaTextField];
    UIImage *img22=[UIImage imageNamed:@"pwd_textfield_ico"];
    UIImageView *iconView12 = [[UIImageView alloc] initWithImage:img22];
    tureUserPwd.secureTextEntry=YES;
    tureUserPwd.placeholder = SmaLocalizedString(@"register_conPassword");
    iconView12.contentMode = UIViewContentModeCenter;
    tureUserPwd.leftView = iconView12;
    tureUserPwd.leftViewMode = UITextFieldViewModeAlways;
    tureUserPwd.frame = CGRectMake(46,pwdLine.frame.origin.y+pwdLine.frame.size.height+19, tfw, 32);
    //userPwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:attrs];
    [self.view addSubview:tureUserPwd];
    _turePwdCode = tureUserPwd;
    
    UIImageView *turepwdLine=[[UIImageView alloc] init];
    [turepwdLine setImage:[UIImage imageNamed:@"textfield_line"]];
    turepwdLine.frame=CGRectMake(tureUserPwd.frame.origin.x, tureUserPwd.frame.origin.y+tureUserPwd.frame.size.height+2,lineImg.size.width,1);
    [self.view addSubview:turepwdLine];

    SmaTextField *verifyCode = [SmaTextField smaTextField];
    UIImage *img21=[UIImage imageNamed:@"verifyCode_ico"];
    UIImageView *iconView11 = [[UIImageView alloc] initWithImage:img21];
    //verifyCode.secureTextEntry=YES;
    iconView11.contentMode = UIViewContentModeCenter;
    verifyCode.leftView = iconView11;
    verifyCode.delegate = self;
//    verifyCode.placeholder = SmaLocalizedString(@"register_getcode");
    verifyCode.leftViewMode = UITextFieldViewModeAlways;
    verifyCode.frame = CGRectMake(46,turepwdLine.frame.origin.y+turepwdLine.frame.size.height+19, tfw-80, 32);
    //userPwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:attrs];
    [self.view addSubview:verifyCode];
    _verifyCode=verifyCode;
    
    UIButton *btnCode=[[UIButton alloc]init];
    [btnCode setTitle:SmaLocalizedString(@"register_getcode") forState:UIControlStateNormal];
    btnCode.titleLabel.font=[UIFont systemFontOfSize:10];
    btnCode.frame=CGRectMake(verifyCode.frame.origin.x+verifyCode.frame.size.width+5,verifyCode.frame.origin.y+10,98,16);
    [self.view addSubview:btnCode];
    [btnCode addTarget:self action:@selector(codeClick) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *pwdLine1=[[UIImageView alloc] init];
    [pwdLine1 setImage:[UIImage imageNamed:@"textfield_line"]];
    pwdLine1.frame=CGRectMake(verifyCode.frame.origin.x, verifyCode.frame.origin.y+verifyCode.frame.size.height+2,lineImg.size.width,1);
    [self.view addSubview:pwdLine1];
    
    UIButton *startButton = [[UIButton alloc] init];
    UIImage *logbtnImg=[UIImage imageNamed:@"login_button_background"];
    [startButton setBackgroundImage:logbtnImg forState:UIControlStateNormal];
    [startButton setBackgroundImage:logbtnImg forState:UIControlStateHighlighted];
    
    startButton.frame = CGRectMake(46, pwdLine1.frame.size.height+pwdLine1.frame.origin.y+21, logbtnImg.size.width, logbtnImg.size.height);
    ////    // 3.设置文字
    [startButton setTitle:SmaLocalizedString(@"login_registerbtn") forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(regBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    //设置本地区号
    [self setTheLocalAreaCode];
}
-(void)loginClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
   // [self.navigationController popViewControllerAnimate:YES];
   
//    [self dismissViewControllerAnimated:YES completion:^{
//       
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)regBtnClick {
    @try {
        

        if([self.phoneCode.text isEqualToString:@""])
        {
            
            [MBProgressHUD showError:SmaLocalizedString(@"alert_regphone")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
           return;
        }
        NSString *pwd=self.pwdCode.text;
        if([pwd isEqualToString:@""])
        {
            
            [MBProgressHUD showError: SmaLocalizedString(@"alert_regpwd")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
           return;
        }
//        NSString * turePWd = self.turePwdCode.text;
//        if (![pwd isEqualToString:turePWd]) {
//            [MBProgressHUD showMessage:@"两次密码输入不一致请重新输入"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUD];
//            });
//            return;
//        }
        
        NSString *code=self.verifyCode.text;
        if([code isEqualToString:@""])
        {
            
            [MBProgressHUD showError: SmaLocalizedString(@"alert_regcode")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            return;
        }
//          [SMS_SDK commitVerifyCode:self.verifyCode.text result:^(enum SMS_ResponseState state) {
//            if (1==state)
//            {
                SmaUserInfo *info=[[SmaUserInfo alloc]init];
                info.tel=self.phoneCode.text;
                int uid=[self getRandomNumber:1 to:10000];
                info.userId= [NSString stringWithFormat:@"%d",uid];
                info.userPwd=self.pwdCode.text;
                info.loginName=self.phoneCode.text;
                info.watchName=@"";
                info.watchUID=[[NSUUID alloc]initWithUUIDString:@""];
                
                
                [MBProgressHUD showMessage:SmaLocalizedString(@"alert_beingreg")];

                SmaAnalysisWebServiceTool *webservice=[[SmaAnalysisWebServiceTool alloc]init];
        NSString *mobile=[NSString stringWithFormat:@"%@%@",[[areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@"00"] isEqualToString:@"0086"]?@"":[areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@"00"],_phoneCode.text];
  [webservice acloudRegisterWithPhone:mobile email:@"" password:_pwdCode.text verifyCode:_verifyCode.text success:^(id success) {
      [MBProgressHUD hideHUD];
      [MBProgressHUD showMessage:SmaLocalizedString(@"alert_regsucceed")];
      [SmaAccountTool saveUser:info];
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [MBProgressHUD hideHUD];
          [self loginClick];
      });
  } failure:^(NSError *erro) {
      NSLog(@"====error==%@",[erro.userInfo objectForKey:@"errorInfo"]);
      
      [MBProgressHUD hideHUD];
      if ([erro.userInfo objectForKey:@"errorInfo"]) {
           [MBProgressHUD showError:[NSString stringWithFormat:@"code:%ld %@",(long)erro.code,[erro.userInfo objectForKey:@"errorInfo"]]];
      }
      else if (erro.code == -1001) {
          [MBProgressHUD showError:SmaLocalizedString(@"alert_request_timeout")];
          NSLog(@"超时");
      }
        else if (erro.code == -1009) {
            [MBProgressHUD showError:SmaLocalizedString(@"alert_disconnetcted_net")];
        }
     
  }];
    }
    @catch (NSException *exception) {
        [MBProgressHUD showError: SmaLocalizedString(@"alert_failurereg")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
    }
}
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() %(to-from + 1))); //+1,result is [from to]; else is [from, to)!!!!!!!
}



- (IBAction)qqLoginClick:(id)sender {
}

- (IBAction)weiboClick:(id)sender {
}

- (IBAction)weixinClick:(id)sender {
}

- (IBAction)otherLogin:(id)sender {
}

- (IBAction)tryClick:(id)sender {
    SmaUserInfo *userInfo=[[SmaUserInfo alloc]init];
    userInfo.userName=@"Blinkked";
    userInfo.userId=@"1";
    userInfo.loginName=@"Blinkked";
    userInfo.userPwd=@"123456";
    userInfo.watchName=@"";
    userInfo.OTAwatchName = @"";
    userInfo.watchUID=[[NSUUID alloc]initWithUUIDString:@""];
    [SmaAccountTool saveUser:userInfo];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[SmaTabBarViewController alloc] init];
}

- (void)codeClick {

   
    if([_phoneCode.text isEqualToString:@""])
    {
        [MBProgressHUD showError: SmaLocalizedString(@"alert_regphone")];
        
    }else
    {
        NSString *mobile=[NSString stringWithFormat:@"%@%@",[[areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@"00"] isEqualToString:@"0086"]?@"":[areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@"00"],_phoneCode.text];
        [MBProgressHUD showMessage:SmaLocalizedString(@"send_ing")];
        SmaAnalysisWebServiceTool *webservice=[[SmaAnalysisWebServiceTool alloc]init];
        [webservice acloudCheckExist:mobile success:^(bool exist) {
            
//            if (exist == 1) {
//                 [MBProgressHUD hideHUD];
//                 [MBProgressHUD showError:SmaLocalizedString(@"alera_account_exist")];
//            }
//            else{
                [webservice acloudSendVerifiyCodeWithAccount:mobile template:1 success:^(id success) {
                     [MBProgressHUD hideHUD];
                    [MBProgressHUD showMessage:SmaLocalizedString(@"send_succ")];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUD];
                    });
                } failure:^(NSError *erro) {
                     [MBProgressHUD hideHUD];
                    if ([erro.userInfo objectForKey:@"errorInfo"]) {
                        [MBProgressHUD showError:[NSString stringWithFormat:@"code:%ld %@",(long)erro.code,[erro.userInfo objectForKey:@"errorInfo"]]];
                    }
                    else if (erro.code == -1001) {
                        [MBProgressHUD showError:SmaLocalizedString(@"alert_request_timeout")];
                        NSLog(@"超时");
                    }
                    else if (erro.code == -1009) {
                        [MBProgressHUD showError:SmaLocalizedString(@"alert_disconnetcted_net")];
                    }
                    

                }];
                
//            }
        } failure:^(NSError *erro) {
              [MBProgressHUD hideHUD];
            [MBProgressHUD showError:SmaLocalizedString(@"send_fail")];
        }];
    }
}
- (void)dealloc
{
    [SmaNotificationCenter removeObserver:self];
}
/**
 *  键盘即将显示的时候调用
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    
    // 1.取出键盘的frame
   //zzzzCGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -100);
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

- (void)countryBut{
    SectionsViewController* country2=[[SectionsViewController alloc] init];
    country2.delegate=self;
//    [country2 setAreaArray:_areaArray];
    [self presentViewController:country2 animated:YES completion:^{
        ;
    }];

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

#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==self.verifyCode) {
        if (![self.pwdCode.text isEqualToString:self.turePwdCode.text]) {
            [MBProgressHUD showError:SmaLocalizedString(@"two_pass_no")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            return;
        }
        
    }
}

@end
