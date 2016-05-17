//
//  SmaAlarmTableViewCell.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/12.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaAlarmTableViewCell.h"
#import "alarmClockInfo.h"
#import "SmaAlarmInfo.h"
#import "SmaDataDAL.h"

@implementation SmaAlarmTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"alarm";
    SmaAlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SmaAlarmTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1.加载View
        [self loadTableCell];
    }
    return self;
}
-(void)setAlarmInfo:(SmaAlarmInfo *)alarmInfo
{
    NSString *minute=alarmInfo.minute;
    if([alarmInfo.minute intValue]<10)
    {
        minute=[NSString stringWithFormat:@"0%d",[minute intValue]];
    }
    NSString *hour=alarmInfo.hour;
    if([alarmInfo.hour intValue]<10)
    {
        hour=[NSString stringWithFormat:@"0%d",[hour intValue]];
    }
    _alarmInfo=alarmInfo;
    
    self.timeLab.text=[NSString stringWithFormat:@"%@:%@",hour,minute];
    self.alarmSort.text=[NSString stringWithFormat:@"%@",alarmInfo.tagname];
    self.alarmSwitch.selected=([alarmInfo.isopen intValue]>0);
    self.weeklab.text=[self weekStrConvert:alarmInfo.dayFlags];
    
    
    CGSize sortSize = [self.alarmSort.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.alarmSort.frame=CGRectMake(self.alarmSort.frame.origin.x,self.alarmSort.frame.origin.y, sortSize.width, sortSize.height);

}
-(NSString *)weekStrConvert:(NSString *)weekStr
{
    NSArray *week=[weekStr componentsSeparatedByString: @","];
    NSString *str=@"";
    int counts=0;
    for (int i=0; i<week.count; i++) {
        if([week[i] intValue]==1)
        {
            counts++;
            str=[NSString stringWithFormat:@"%@  %@",str,[self stringWith:i]];
        }
    }
    //if(counts==7)
       // str=@"每天";
    

    
    return str;
    
}


-(NSString *)stringWith:(int)weekInt
{
    NSString *weekStr=@"";
    switch (weekInt) {
        case 0:
            weekStr= SmaLocalizedString(@"clockadd_monday");
            break;
        case 1:
            weekStr= SmaLocalizedString(@"clockadd_tuesday");
            break;
        case 2:
            weekStr= SmaLocalizedString(@"clockadd_wednesday");
            break;
        case 3:
            weekStr= SmaLocalizedString(@"clockadd_thursday");
            break;
        case 4:
            weekStr= SmaLocalizedString(@"clockadd_friday");
            break;
        case 5:
            weekStr= SmaLocalizedString(@"clockadd_saturday");
            break;
        default:
            weekStr= SmaLocalizedString(@"clockadd_sunday");
    }
    return weekStr;
}

-(void)loadTableCell
{
    UIImage *bgimg=[UIImage imageNamed:@"alarm_cell_bg"];
    
    UIImageView *view=[[UIImageView alloc]init];
    [view setImage:bgimg];
    view.frame=CGRectMake(0, 0, bgimg.size.width, bgimg.size.height);
    UILabel *timelab=[[UILabel alloc]init];
    view.userInteractionEnabled=YES;
    
    timelab.text=@"00:00";
    timelab.font=[UIFont systemFontOfSize:32];
    CGSize fontsize = [timelab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:32]}];
    timelab.textColor=SmaColor(195, 14, 46);
    timelab.frame=CGRectMake(39, 24, fontsize.width, fontsize.height);
    [view addSubview:timelab];
     _timeLab=timelab;
    
    UIImage *icoImg=[UIImage imageNamed:@"alarmclock_ico"];
    UIImageView *uiimg=[[UIImageView alloc]init];
    [uiimg setImage:icoImg];
    uiimg.frame=CGRectMake(timelab.frame.origin.x+timelab.frame.size.width+10,34, icoImg.size.width, icoImg.size.height);
    [view addSubview:uiimg];
    _timeImg=uiimg;
    
    UILabel *alarmSort=[[UILabel alloc]init];
    alarmSort.text=@"闹钟一";
    alarmSort.font=[UIFont systemFontOfSize:14];
    CGSize sortSize = [alarmSort.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    alarmSort.textColor=SmaColor(30, 30, 30);
    alarmSort.frame=CGRectMake(uiimg.frame.origin.x+icoImg.size.width+10, 37, sortSize.width, sortSize.height);
    [view addSubview:alarmSort];
    _alarmSort=alarmSort;
    
    UIImage *closeImg=[UIImage imageNamed:@"alarm_close_bg"];
    UIImage *openImg=[UIImage imageNamed:@"alarm_open_bg"];
    UIButton *btn=[[UIButton alloc]init];
    [btn setBackgroundImage:closeImg forState:UIControlStateNormal];
    [btn setBackgroundImage:openImg forState:UIControlStateSelected];
     btn.frame=CGRectMake(bgimg.size.width-26-closeImg.size.width, 28, closeImg.size.width, closeImg.size.height);
    btn.tag=10;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    _alarmSwitch=btn;
    
    UILabel *weeklab=[[UILabel alloc]init];
    weeklab.text=@"    七    一    二    三    四    五    六 ";
    weeklab.font=[UIFont systemFontOfSize:16];
    CGSize weekSize = [alarmSort.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    weeklab.frame=CGRectMake(37,bgimg.size.height-16-weekSize.height,bgimg.size.width-74,weekSize.height);
    weeklab.textAlignment=NSTextAlignmentLeft;
    [view addSubview:weeklab];
    _weeklab=weeklab;

   
    _topView=view;
    [self.contentView addSubview:view];
    
}

-(void)btnClick:(id)sender
{
    UIButton *btn=sender;
    btn.selected=!btn.isSelected;
    SmaDataDAL *smaDal=[[SmaDataDAL alloc]init];
    [smaDal updateClockIsOpenOrderById:self.alarmInfo.clockid isOpen:btn.selected];
    if ([self.delegate respondsToSelector:@selector(loadTableViewController)]) {
        [self.delegate loadTableViewController];
    }
}
@end
