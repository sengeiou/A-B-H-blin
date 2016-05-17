//
//  SmaLoverViewController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/9.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SectionsViewController.h"
@interface SmaLoverViewController : SmaNoTabBarViewController<AppCreateUIDelegate,SecondViewControllerDelegate>
{
    UITextField* areaCodeField;
    UILabel *state;
}
@property (weak, nonatomic) IBOutlet UIImageView *animImgView;

@property (weak, nonatomic) IBOutlet UITextField *accountId;
@property (weak, nonatomic) IBOutlet UIButton *btnImgView;

- (IBAction)btnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bodyImg;
@property (weak, nonatomic) IBOutlet UIScrollView *downView;
@property (weak, nonatomic) IBOutlet UIImageView *downlien;
- (void)setFriendView;
@end
