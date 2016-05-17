//
//  SmaLosePwdController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/30.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmaLosePwdController : UIViewController
{
    UITextField* areaCodeField;
    UILabel *state;
}
//手机号
@property (weak, nonatomic) UITextField *phoneCode;
//密码
@property (weak, nonatomic)  UITextField *pwdCode;
//验证码
@property (weak, nonatomic) UITextField *verifyCode;

@property (weak, nonatomic) UIImageView *headImage;
//注册
- (void)regBtnClick;
@end
