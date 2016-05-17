//
//  SmaRelieveBoundViewController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/8.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmaRelieveBoundViewController : SmaNoTabBarViewController<UIAlertViewDelegate>
- (IBAction)backClick:(id)sender;
- (IBAction)againBound:(id)sender;
@property (strong, nonatomic) NSString *systemLab;
@property (weak, nonatomic) IBOutlet UIButton *succeedbtn;
@property (weak, nonatomic) IBOutlet UIButton *againbtn;
@property (weak, nonatomic) IBOutlet UILabel *attenLab;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
