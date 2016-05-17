//
//  SmaBindWatchViewController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/8.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmaBindWatchViewController : SmaNoTabBarViewController
{
    IBOutlet UILabel *remindLab;
    IBOutlet UIScrollView *scrollview;
}
@property (nonatomic,strong) NSString *smaWatchName;
@property (nonatomic,strong) NSString *orSmaWatchName;
@property (weak, nonatomic) IBOutlet UIImageView *reminImg;
@property (weak, nonatomic) IBOutlet UILabel *reminlab;

@property (weak, nonatomic) IBOutlet UILabel *headremindlab;

@property (weak, nonatomic) IBOutlet UIButton *againSearchBtn;
@property (weak, nonatomic) IBOutlet UIButton *nobangbtn;
@property (weak, nonatomic) IBOutlet UILabel *bindreminderlab;

//重新搜索
- (IBAction)aginSearchClick:(id)sender;
//停止绑定
- (IBAction)stopBindClick:(id)sender;

@end
