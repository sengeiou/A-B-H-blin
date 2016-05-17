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

#define SmaTextFieldImgRatio 0.6
#define SmaButtonImgRatio 0.4
#define UINavigationBarHeight 64
#define SmaButtonTextWidth 0.7

@interface SmaRegViewController ()
/*用户名*/
@property (nonatomic,weak) UITextField *userNameField;
/*密码*/
@property (nonatomic,weak) UITextField *userPwdField;
/*验证码*/
@property (nonatomic,weak) UITextField *veriCodeField;

@property (nonatomic,weak) UINavigationBar *navigationBar11;


@end

@implementation SmaRegViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bodyImg=[[UIImageView alloc]init];
    [bodyImg setImage:[UIImage imageNamed:@"login_background"]];
    
    bodyImg.frame=CGRectMake(0,UINavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height-UINavigationBarHeight);
    [self.view addSubview:bodyImg];
    bodyImg.userInteractionEnabled = YES;
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, UINavigationBarHeight)];
    [navigationBar setBackgroundImage:[UIImage imageWithName:@"login_navigationBar_background"] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
   // self.navigation=navigationBar;
    
    UIImageView *logoView=[[UIImageView alloc]init];
    UIImage *img=[UIImage imageNamed:@"sma_logo"];
    CGSize size={img.size.width *0.5,img.size.height*0.5};
    UIImage *logoimg=[UIImage imageByScalingAndCroppingForSize:size imageName:@"sma_logo"];
    [logoView setImage:logoimg];
    logoView.frame=CGRectMake(0, 0,img.size.width *0.5,img.size.height*0.5);
    [navigationItem setTitleView:logoView];
    
    //初始化控件对象
    //[self setAttributeForm];
}

/**
 *  <#Description#>构建控件属性对象
 */
-(void)setAttributeForm
{
    
    CGFloat centerX = self.view.frame.size.width * 0.5;
    
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.frame=CGRectMake(0,UINavigationBarHeight,self.view.frame.size.width,(self.view.frame.size.height-64)*SmaTextFieldImgRatio);
    [self.view addSubview:imageView];
    
    imageView.userInteractionEnabled = YES;
    
    //园角图片
    UIImageView *faceImg = [[UIImageView alloc] init];
    CGFloat centerY = imageView.frame.size.height * 0.20;
    faceImg.center = CGPointMake(centerX, centerY);
    faceImg.bounds = CGRectMake(0, 0, self.view.frame.size.width*0.25, self.view.frame.size.width*0.25);
    CALayer *lay  = faceImg.layer;//获取ImageView的层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:48.0];//值越大，角度越圆
    [faceImg setImage:[UIImage imageNamed:@"login_head_portrait"]];
    faceImg.layer.masksToBounds = YES;
    faceImg.layer.cornerRadius = CGRectGetHeight(faceImg.bounds)/2;
    faceImg.layer.borderWidth = 0.5f;
    faceImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    [imageView addSubview:faceImg];
    
    //
    //    //登录名
    SmaTextField *userNameField = [SmaTextField smaTextField];
    // 左边的放大镜图标
    UIImage *img1=[UIImage imageNamed:@"login_textfield_ico"];
    CGSize size1={img1.size.width*0.5,img1.size.height*0.5};
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageByScalingAndCroppingForSize:size1 imageName:@"login_textfield_ico"]];
    
    iconView.contentMode = UIViewContentModeCenter;
    userNameField.leftView = iconView;
    userNameField.leftViewMode = UITextFieldViewModeAlways;
    
    CGFloat centerY1 = imageView.frame.size.height * 0.50;
    userNameField.center = CGPointMake(centerX, centerY1);
    userNameField.bounds = CGRectMake(0, 0, self.view.frame.size.width*SmaButtonTextWidth, 38);
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:attrs];
    [imageView addSubview:userNameField];
    _userNameField=userNameField;
    UIImageView *nameLine=[[UIImageView alloc] init];
    [nameLine setImage:[UIImage imageNamed:@"textfield_line"]];
    nameLine.frame=CGRectMake(userNameField.frame.origin.x, userNameField.frame.origin.y+userNameField.frame.size.height+2,userNameField.frame.size.width,1);
    [imageView addSubview:nameLine];
    //
    //密码
    SmaTextField *userPwdField = [SmaTextField smaTextField];
    UIImage *img2=[UIImage imageNamed:@"pwd_textfield_ico"];
    CGSize size2={img2.size.width*0.5,img2.size.height*0.5};
    UIImageView *iconView1 = [[UIImageView alloc] initWithImage:[UIImage imageByScalingAndCroppingForSize:size2 imageName:@"pwd_textfield_ico"]];
    
    userPwdField.secureTextEntry=YES;
    iconView1.contentMode = UIViewContentModeCenter;
    userPwdField.leftView = iconView1;
    userPwdField.leftViewMode = UITextFieldViewModeAlways;
    
    CGFloat centerY2 = imageView.frame.size.height * 0.7;
    userPwdField.center = CGPointMake(centerX, centerY2);
    userPwdField.bounds = CGRectMake(0, 0, self.view.frame.size.width*SmaButtonTextWidth, 38);
    userPwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:attrs];
    [imageView addSubview:userPwdField];
    _userPwdField=userPwdField;
    
    UIImageView *pwdLine=[[UIImageView alloc] init];
    [pwdLine setImage:[UIImage imageNamed:@"textfield_line"]];
    pwdLine.frame=CGRectMake(userPwdField.frame.origin.x, userPwdField.frame.origin.y+userPwdField.frame.size.height+2,userPwdField.frame.size.width,1);
    [imageView addSubview:pwdLine];
    

    
    SmaTextField *veriCodeField = [SmaTextField smaTextField];
    // 左边的放大镜图标
   UIImage *img11=[UIImage imageNamed:@"login_textfield_ico"];
    CGSize size11={img11.size.width*0.5,img11.size.height*0.5};
    UIImageView *iconView11 = [[UIImageView alloc] initWithImage:[UIImage imageByScalingAndCroppingForSize:size11 imageName:@"login_textfield_ico"]];
    
    iconView.contentMode = UIViewContentModeCenter;
    veriCodeField.leftView = iconView11;
    veriCodeField.leftViewMode = UITextFieldViewModeAlways;
    
    CGFloat centerY7 = imageView.frame.size.height * 0.9;
    veriCodeField.center = CGPointMake(centerX, centerY7);
    veriCodeField.bounds = CGRectMake(0, 0, self.view.frame.size.width*SmaButtonTextWidth, 38);
    //veriCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:attrs];
    [imageView addSubview:veriCodeField];
    _veriCodeField=veriCodeField;
    
    UIImageView *codeLine=[[UIImageView alloc] init];
    [codeLine setImage:[UIImage imageNamed:@"textfield_line"]];
    codeLine.frame=CGRectMake(veriCodeField.frame.origin.x, veriCodeField.frame.origin.y+veriCodeField.frame.size.height+2,veriCodeField.frame.size.width,1);
    [imageView addSubview:codeLine];
    //
    
    //存放按钮的imgView
    UIImageView *btnView=[[UIImageView alloc]init];
    btnView.frame=CGRectMake(0,imageView.frame.origin.y+imageView.frame.size.height, self.view.frame.size.width,self.view.frame.size.height-64-(self.view.frame.size.height-64)*SmaButtonImgRatio);
    
    [self.view addSubview:btnView];
    btnView.userInteractionEnabled = YES;
    //    //登录按钮
    UIButton *startButton = [[UIButton alloc] init];
    [startButton setBackgroundImage:[UIImage resizedImageWithName:@"login_button_background"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage resizedImageWithName:@"login_button_background"] forState:UIControlStateHighlighted];
    CGFloat centerY3 = startButton.currentBackgroundImage.size.height/2;
    startButton.center = CGPointMake(centerX,centerY3/2);
    startButton.bounds = (CGRect){CGPointZero,self.view.frame.size.width*SmaButtonTextWidth,40};
    ////    // 3.设置文字
    [startButton setTitle:@"注册" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:startButton];
    
    
    /*第三方登陆*/
    UIImageView *autho=[[UIImageView alloc]init];
    autho.center=CGPointMake(centerX,startButton.frame.origin.y+30+startButton.frame.size.height);
    autho.bounds=(CGRect){CGPointZero,self.view.frame.size.width*SmaButtonTextWidth,40};
    [btnView addSubview:autho];
    
    
    CGFloat x=autho.frame.origin.x*0.2;
    CGFloat radi=((self.view.frame.size.width*SmaButtonTextWidth)/7);
    
    UIButton *qq=[[UIButton alloc]init];
    qq.center = CGPointMake(x+radi,20);
    qq.bounds = (CGRect){CGPointZero,40,40};
    [qq setImage:[UIImage imageNamed:@"qq_ico"] forState:UIControlStateNormal];
    [autho addSubview:qq];
    
    UIButton *weibo=[[UIButton alloc]init];
    weibo.center = CGPointMake(x+radi*3,20);
    weibo.bounds = (CGRect){CGPointZero,40,40};
    [weibo setImage:[UIImage imageNamed:@"weibo_ico"] forState:UIControlStateNormal];
    [autho addSubview:weibo];
    //
    UIButton *weixing=[[UIButton alloc]init];
    weixing.center = CGPointMake(x+radi*5,20);
    weixing.bounds = (CGRect){CGPointZero,40,40};
    [weixing setImage:[UIImage imageNamed:@"weixing_ico"] forState:UIControlStateNormal];
    [autho addSubview:weixing];
    
    UIButton *otheLab=[[UIButton alloc]init];
    otheLab.center = CGPointMake(centerX,autho.frame.origin.y+autho.frame.size.height+20);
    otheLab.bounds = (CGRect){CGPointZero,120,20};
    [otheLab setTitle:@"使用其他账号登陆" forState:UIControlStateNormal];
    [otheLab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    otheLab.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [btnView addSubview:otheLab];
    
    UIButton *shiyong=[[UIButton alloc]init];
    shiyong.center = CGPointMake(centerX,autho.frame.origin.y+autho.frame.size.height+50);
    shiyong.bounds = (CGRect){CGPointZero,100,20};
    [shiyong setTitle:@"直接进入试用" forState:UIControlStateNormal];
    [shiyong setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shiyong.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [btnView addSubview:shiyong];
    //
}

//登录操作
-(void)loginClick
{
    SmaUserInfo *info=[SmaAccountTool userInfo];
    if(info==nil)
    {
        [MBProgressHUD showError: SmaLocalizedString(@"register_first")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return;
    }
    
    if([self.userNameField.text isEqual:@""])
    {
        [MBProgressHUD showError: SmaLocalizedString(@"alera_loginName")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });

        return;
    }
    if([self.userPwdField.text isEqual:@""])
    {
        [MBProgressHUD showError: SmaLocalizedString(@"alera_loginName")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });

        return;
    }
    if(![self.userNameField.text isEqual:info.loginName])
    {

        [MBProgressHUD showError: SmaLocalizedString(@"alera_erro")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return;
    }
    if(![self.userPwdField.text isEqual:info.userPwd])
    {
         [MBProgressHUD showError: SmaLocalizedString(@"alera_erro")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return;
    }
    //去首页
    [SmaWatchTool chooseRootController:nil];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


-(void)regClick
{
    
    SmaRegViewController *reg=[[SmaRegViewController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController=reg;
    
}
-(void)hidShow
{
    [MBProgressHUD hideHUD];
}
@end
