//
//  SmaUpdateMyInfoController.h
//  SmaLife
//
//  Created by chenkq on 15/4/15.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmaUpdateMyInfoController : UITableViewController
//@property (weak, nonatomic) IBOutlet UIButton *accontlab;
//@property (weak, nonatomic) IBOutlet UIButton *userpwdlab;

@property (weak, nonatomic) IBOutlet UIButton *nicknamelab;

@property (weak, nonatomic) IBOutlet UIButton *birthdaylab;
@property (weak, nonatomic) IBOutlet UIButton *hightlab;

@property (weak, nonatomic) IBOutlet UIButton *weightlab;
@property (weak, nonatomic) IBOutlet UIButton *sexlab;

@property (weak, nonatomic) IBOutlet UITextField *acountfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdfield;
@property (weak, nonatomic) IBOutlet UITextField *nicknfield;
@property (weak, nonatomic) IBOutlet UITextField *birthfield;
@property (weak, nonatomic) IBOutlet UITextField *heightfield;
@property (weak, nonatomic) IBOutlet UITextField *weightfield;
@property (weak, nonatomic) IBOutlet UITextField *areafield;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIButton *manSex;

@property (weak, nonatomic) IBOutlet UIButton *wmenSex;


- (IBAction)submitClick:(UIButton *)sender;

- (IBAction)sexManBtnClick:(id)sender;

- (IBAction)sexWManBtnClick:(id)sender;


@end
