//
//  SmaNavMyInfoController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/15.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmaNavMyInfoController : UIViewController
{
    IBOutlet UIButton *nextBtu;
}
@property (weak, nonatomic) IBOutlet UIImageView *bodyimgview;
@property (weak, nonatomic) IBOutlet UITextField *nickname;
@property (weak, nonatomic) IBOutlet UITextField *birthday;
@property (weak, nonatomic) IBOutlet UITextField *heightFiele;
@property (weak, nonatomic) IBOutlet UITextField *weightfield;
- (IBAction)nextbtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *headimgview;

@property (weak, nonatomic) IBOutlet UIButton *birthdaybtn;
@property (weak, nonatomic) IBOutlet UIButton *sexbtn;
@property (weak, nonatomic) IBOutlet UIButton *higthbtn;
@property (weak, nonatomic) IBOutlet UIButton *weithbtn;

- (IBAction)msexClick:(id)sender;
- (IBAction)wsexBtnClick:(id)sender;
@end
