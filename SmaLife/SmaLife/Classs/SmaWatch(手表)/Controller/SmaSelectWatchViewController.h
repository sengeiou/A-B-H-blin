//
//  SmaSelectWatchViewController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/8.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmaSelectWatchViewController : SmaNoTabBarViewController
{
    IBOutlet UIButton *leftBut, *righeBut, *watchBut;
    NSArray *watchArr,*watchSelArr;
    int selectIntex;
}
- (IBAction)womenWatch:(id)sender;
- (IBAction)manWatch:(id)sender;
- (IBAction)shopWatch:(id)sender;
- (IBAction)backNoBind:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *toptitle;
@property (weak, nonatomic) IBOutlet UILabel *formenlab;
@property (weak, nonatomic) IBOutlet UILabel *forwmenlab;
@property (weak, nonatomic) IBOutlet UIButton *shopbtn;
@property (weak, nonatomic) IBOutlet UIButton *nobandbtn;

@end
