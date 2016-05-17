//
//  SmaMainRegViewController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/10.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionsViewController.h"
@interface SmaMainRegViewController : UIViewController<UITextFieldDelegate,SecondViewControllerDelegate>
//手机号
@property (weak, nonatomic) UITextField *phoneCode;
//密码
@property (weak, nonatomic)  UITextField *pwdCode;
// 确定密码
@property (weak,nonatomic) UITextField * turePwdCode;
//验证码
@property (weak, nonatomic) UITextField *verifyCode;

@property (weak, nonatomic) UIImageView *headImage;
//注册
- (void)regBtnClick;


@end
