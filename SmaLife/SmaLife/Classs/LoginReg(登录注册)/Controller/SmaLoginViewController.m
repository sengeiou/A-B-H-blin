//
//  SmaLoginViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/7.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaLoginViewController.h"
#import "SmaTextField.h"
#import "SmaUserInfo.h"
#import "SmaAccountTool.h"
#import "SmaWatchTool.h"
#import "SmaRegViewController.h"
#import "SmaMainRegViewController.h"
#import "SmaTabBarViewController.h"
#import "SmaNavMyInfoController.h"
#import "SmaLosePwdController.h"


#define SmaTextFieldImgRatio 0.5
#define SmaButtonImgRatio 0.5
#define UINavigationBarHeight 0
#define SmaButtonTextWidth 0.7


@interface SmaLoginViewController ()
{
    AppDelegate *appdelegate;
}
/*用户名*/
@property (nonatomic,weak) UITextField *userNameField;
/*密码*/
@property (nonatomic,weak) UITextField *userPwdField;


@end

@implementation SmaLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=SmaLocalizedString(@"login_navtitle");
    appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    
    UIImageView *bodyImg=[[UIImageView alloc]init];
    [bodyImg setImage:[UIImage imageNamed:@"login_background"]];
    
    bodyImg.frame=CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:bodyImg];
    bodyImg.userInteractionEnabled = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithName:@"rave_navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(320, 3)]];
    //初始化控件对象
    [self setAttributeForm];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
/**
 *  <#Description#>构建控件属性对象
 */
-(void)setAttributeForm
{
    UIImage *logImg=[UIImage imageNamed:@"sma_logo"];
    
    UIImageView *logoView=[[UIImageView alloc]init];
    CGFloat topMag=19;
    if(!fourInch)
        topMag=9;
    
    logoView.frame=CGRectMake(117,UINavigationBarHeight+topMag,logImg.size.width,logImg.size.height);
    [self.view addSubview:logoView];
    CGFloat tfw=(self.view.frame.size.width-92);
    logoView.userInteractionEnabled = YES;

    
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
    
    
    //园角图片
    UIImageView *faceImg = [[UIImageView alloc] init];
    faceImg.frame = CGRectMake(0, 0,logImg.size.width,logImg.size.height);
    [faceImg setImage:[UIImage imageNamed:@"sma_logo"]];
    [logoView addSubview:faceImg];
    
    //
    //    //登录名
    SmaTextField *userNameField = [SmaTextField smaTextField];
    // 左边的放大镜图标
    UIImage *headImng=[UIImage imageNamed:@"login_textfield_ico"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:headImng];
    
    iconView.contentMode = UIViewContentModeCenter;
    userNameField.leftView = iconView;
    userNameField.leftViewMode = UITextFieldViewModeAlways;
    userNameField.placeholder = SmaLocalizedString(@"login_phone");

    CGFloat textMap=50;
    if(!fourInch)
        textMap=30;
    
    
    
    userNameField.frame =CGRectMake(46, areaCodeField.frame.origin.y+areaCodeField.frame.size.height+19, tfw, 32);
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    
    [self.view addSubview:userNameField];
    _userNameField=userNameField;
    UIImageView *nameLine=[[UIImageView alloc] init];
    UIImage *lineImg= [UIImage imageNamed:@"textfield_line"];
    [nameLine setImage:lineImg];
    nameLine.frame=CGRectMake(userNameField.frame.origin.x, userNameField.frame.origin.y+userNameField.frame.size.height+2,lineImg.size.width,1);
    [self.view addSubview:nameLine];
    //
    //密码
    SmaTextField *userPwdField = [SmaTextField smaTextField];
    UIImage *img2=[UIImage imageNamed:@"pwd_textfield_ico"];
    UIImageView *iconView1 = [[UIImageView alloc] initWithImage:img2];
    userPwdField.secureTextEntry=YES;
    iconView1.contentMode = UIViewContentModeCenter;
    userPwdField.leftView = iconView1;
    userPwdField.leftViewMode = UITextFieldViewModeAlways;
    userPwdField.placeholder = SmaLocalizedString(@"long_password");
    
    userPwdField.frame = CGRectMake(46,nameLine.frame.origin.y+nameLine.frame.size.height+19, tfw-65, 32);
    //userPwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:attrs];
    [self.view addSubview:userPwdField];
    
    UIButton *forgetBtn = [[UIButton alloc]init];
    [forgetBtn setTitle:SmaLocalizedString(@"long_findPassoword") forState:UIControlStateNormal];
    forgetBtn.titleLabel.font=[UIFont systemFontOfSize:10];
    forgetBtn.frame=CGRectMake(35+userPwdField.frame.size.width,userPwdField.frame.origin.y,85,45);
    [forgetBtn addTarget:self action:@selector(losePwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    
    _userPwdField=userPwdField;
    
    UIImageView *pwdLine=[[UIImageView alloc] init];
    [pwdLine setImage:[UIImage imageNamed:@"textfield_line"]];
    pwdLine.frame=CGRectMake(userPwdField.frame.origin.x, userPwdField.frame.origin.y+userPwdField.frame.size.height+2,lineImg.size.width,1);
    [self.view addSubview:pwdLine];
    
    //    //登录按钮
    UIButton *startButton = [[UIButton alloc] init];
    UIImage *logbtnImg=[UIImage imageNamed:@"login_button_background"];
    [startButton setBackgroundImage:logbtnImg forState:UIControlStateNormal];
    [startButton setBackgroundImage:logbtnImg forState:UIControlStateHighlighted];
    
    startButton.frame = CGRectMake(46, pwdLine.frame.size.height+pwdLine.frame.origin.y+21, logbtnImg.size.width, logbtnImg.size.height);
    ////    // 3.设置文字
    [startButton setTitle:SmaLocalizedString(@"login_loginbtn") forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    //注册按钮
    UIButton *regBtn = [[UIButton alloc] init];
    [regBtn setBackgroundImage:logbtnImg forState:UIControlStateNormal];
    [regBtn setBackgroundImage:logbtnImg forState:UIControlStateHighlighted];
    
    regBtn.frame = CGRectMake(46, startButton.frame.size.height+startButton.frame.origin.y+9, logbtnImg.size.width, logbtnImg.size.height);
    ////    // 3.设置文字
    [regBtn setTitle:SmaLocalizedString(@"login_registerbtn") forState:UIControlStateNormal];
    [regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [regBtn addTarget:self action:@selector(regClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
    
    
    /*第三方登陆*/
    CGFloat authoMag=32;
    if(!fourInch)
        authoMag=15;
    
    UIImageView *autho=[[UIImageView alloc]init];
    autho.frame=CGRectMake(76,regBtn.frame.size.height+regBtn.frame.origin.y+authoMag,(self.view.frame.size.width-152),36);
    
    [self.view addSubview:autho];
    
    
    UIImage *qqImg=[UIImage imageNamed:@"qq_ico"];
    UIButton *qq=[[UIButton alloc]init];
    qq.frame = CGRectMake(0,0,qqImg.size.width,qqImg.size.height);
    [qq setImage:[UIImage imageNamed:@"qq_ico"] forState:UIControlStateNormal];
    [autho addSubview:qq];
    
    UIButton *weibo=[[UIButton alloc]init];
    
    weibo.frame = CGRectMake(qq.frame.origin.x+qq.frame.size.width+30,0,qqImg.size.width,qqImg.size.height);
    [weibo setImage:[UIImage imageNamed:@"weibo_ico"] forState:UIControlStateNormal];
    [autho addSubview:weibo];
    //
    UIButton *weixing=[[UIButton alloc]init];
    weixing.frame = CGRectMake(weibo.frame.origin.x+weibo.frame.size.width+30,0,qqImg.size.width,qqImg.size.height);
    [weixing setImage:[UIImage imageNamed:@"weixing_ico"] forState:UIControlStateNormal];
    [autho addSubview:weixing];
    
    UIButton *otheLab=[[UIButton alloc]init];
    
    
    [otheLab setTitle:SmaLocalizedString(@"login_loginmode") forState:UIControlStateNormal];
    [otheLab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    otheLab.titleLabel.font=[UIFont systemFontOfSize:12];
    CGSize othesize = [otheLab.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    otheLab.frame = CGRectMake((self.view.frame.size.width-othesize.width)/2,autho.frame.origin.y+autho.frame.size.height+6,othesize.width,othesize.height);
    [self.view addSubview:otheLab];
    
    UIButton *shiyong=[[UIButton alloc]init];
    CGFloat shiyongMag=30;
    if(!fourInch)
        shiyongMag=15;
    
    [shiyong setTitle:SmaLocalizedString(@"login_tryout") forState:UIControlStateNormal];
    [shiyong setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shiyong addTarget:self action:@selector(trialClick) forControlEvents:UIControlEventTouchUpInside];
    shiyong.titleLabel.font=[UIFont systemFontOfSize:14.0];
    CGSize shiyongsize = [shiyong.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    shiyong.frame = CGRectMake((self.view.frame.size.width-shiyongsize.width)/2,otheLab.frame.origin.y+otheLab.frame.size.height+shiyongMag,shiyongsize.width,shiyongsize.height);
    [self.view addSubview:shiyong];
    
    //设置本地区号
    [self setTheLocalAreaCode];
    //
}
-(void)losePwd
{
    SmaLosePwdController *reg=[[SmaLosePwdController alloc]init];
    
    [self.navigationController pushViewController:reg animated:YES];
}
//登录操作
-(void)loginClick
{
    
    if([self.userNameField.text isEqual:@""])
    {
        
        [MBProgressHUD showError: SmaLocalizedString(@"alert_loginname")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        
        return;
    }
    
    if([self.userPwdField.text isEqual:@""])
    {
        [MBProgressHUD showError:SmaLocalizedString(@"alert_loginpwd")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return;
    }
    
    [MBProgressHUD showMessage:SmaLocalizedString(@"login_in")];
    NSString *clientID=[SmaUserDefaults objectForKey:@"clientId"];
    NSLog(@"resultID===%@",clientID);
    // userPwd: clientId:@"26c986a07903f8e8e491e127e8531a12"
    NSString *mobile=[NSString stringWithFormat:@"%@%@",[[areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@"00"] isEqualToString:@"0086"]?@"":[areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@"00"],self.userNameField.text];
    SmaAnalysisWebServiceTool *webservice=[[SmaAnalysisWebServiceTool alloc]init];
    [webservice acloudLoginWithAccount:mobile Password:self.userPwdField.text success:^(id dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        [webservice acloudDownLHeadUrlWithAccount:mobile Success:^(id result) {
            
        } failure:^(NSError *error) {
            
        }];
        
        NSDictionary *userDic = dict;
        SmaUserInfo *userInfo=[[SmaUserInfo alloc]init];
        userInfo.userName=mobile;
        userInfo.userId = mobile;
        userInfo.loginName=mobile;
        userInfo.userPwd=mobile;
        userInfo.watchName=@"";
        userInfo.tel=mobile;
        userInfo.watchUID=[[NSUUID alloc]initWithUUIDString:@""];
        userInfo.nickname = [userDic objectForKey:@"nickName"];
        userInfo.sex = [userDic objectForKey:@"sex"];
        userInfo.weight = [userDic objectForKey:@"weight"];
        userInfo.height = [userDic objectForKey:@"hight"];
        userInfo.age = [userDic objectForKey:@"age"];
        userInfo.aim_steps = [userDic objectForKey:@"setps_Aim"];
        userInfo.header_url = [userDic objectForKey:@"header_url"];
        userInfo.friendAccount = [userDic objectForKey:@"friend_account"];
        userInfo.nicknameLove = [userDic objectForKey:@"friend_nickName"];
        [SmaAccountTool saveUser:userInfo];
        [appdelegate registerUMessageRemoteNotification];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:SmaLocalizedString(@"alert_loginsucceed")];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            SmaUserInfo *userInfo=[SmaAccountTool userInfo];
            if(![userInfo.nickname isEqualToString:@""] && userInfo.sex  && ![userInfo.height isEqualToString:@"0"] && ![userInfo.weight isEqualToString:@"0"])
            {
                [UIApplication sharedApplication].keyWindow.rootViewController = [[SmaTabBarViewController alloc] init];
            }else
            {
                SmaNavMyInfoController *settingVc = [[SmaNavMyInfoController alloc] init];
                [self.navigationController pushViewController:settingVc animated:YES];
            }
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
}
//试用
-(void)trialClick
{
    
    SmaUserInfo *userInfo=[[SmaUserInfo alloc]init];
    userInfo.userName=@"Blinkked";
    userInfo.userId=@"1";
    userInfo.loginName=@"Blinkked";
    userInfo.userPwd=@"123456";
    userInfo.watchName=@"";
    userInfo.nickname=@"Blinkked";
    userInfo.age=@"25";
    userInfo.height=@"60";
    userInfo.weight=@"170";
    userInfo.sex=@"1";
    
    userInfo.watchUID=[[NSUUID alloc]initWithUUIDString:@""];
    [SmaAccountTool saveUser:userInfo];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[SmaTabBarViewController alloc] init];
    
}
-(void)regClick
{
    SmaMainRegViewController *reg=[[SmaMainRegViewController alloc]init];
    
    [self.navigationController pushViewController:reg animated:YES];
    
    
    
}
-(void)hidShow
{
    [MBProgressHUD hideHUD];
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
