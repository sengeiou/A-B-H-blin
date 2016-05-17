//
//  popup-MultiSelect.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/13.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "popupMultiSelect.h"


@interface popupMultiSelect()




@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *lableArray;
@property (nonatomic,strong) NSMutableArray *checkArray;
@property (nonatomic,strong) UIImageView *mainView;
@property (nonatomic,strong) UIScrollView *mainScrol;


@property (nonatomic,strong) NSNumber *frameH;
@end

@implementation popupMultiSelect

-(id)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self) {
   
        
        UIImageView *mianView=[[UIImageView alloc]init];
        [mianView setImage:[UIImage imageNamed:@"time_seleect_bg"]];
        [self addSubview:mianView];
        mianView.userInteractionEnabled=YES;
        _mainView=mianView;
        UIScrollView *mianScrol=[[UIScrollView alloc]init];
        [mianView addSubview:mianScrol];
        _mainScrol=mianScrol;

    }
    return self;
}
-(NSMutableArray *)lableArray
{
   if(_lableArray==nil)
   {
       _lableArray=[NSMutableArray array];
   }
    return _lableArray;
}

-(NSMutableArray *)checkArray
{
    if(_checkArray==nil)
    {
        _checkArray=[NSMutableArray array];
    }
    return _checkArray;
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray=dataArray;
    for (int i=0; i<7; i++) {
        UILabel *lable=[[UILabel alloc]init];
       
        lable.textAlignment=NSTextAlignmentLeft;
        lable.text=[self weekInt:i];
        [self.lableArray addObject:lable];
        [self.mainScrol addSubview:lable];
        
        UIButton *checkbox = [[UIButton alloc] init];
        checkbox.tag=i;
        if([dataArray[i] isEqualToString:@"1"])
           checkbox.selected=YES;
         else
            checkbox.selected = NO;
        
        [checkbox setImage:[UIImage imageNamed:@"checked_false"] forState:UIControlStateNormal];
        [checkbox setImage:[UIImage imageNamed:@"checked_true"] forState:UIControlStateSelected];
        [self.mainScrol addSubview:checkbox];
        [self.checkArray addObject:checkbox];
    }
}

-(NSString *)weekInt:(int)tagInt
{
    NSString *weekStr=@"";
    switch (tagInt) {
        case 0:
            weekStr= @"周 一";
            break;
        case 1:
            weekStr= @"周 二";
            break;
        case 2:
            weekStr= @"周 三";
            break;
        case 3:
            weekStr= @"周 四";
            break;
        case 4:
            weekStr= @"周 五";
            break;
        case 5:
            weekStr= @"周 六";
            break;
        default:
            weekStr= @"周 天";
    }
    return weekStr;
}

-(void)layoutSubviews
{

    [super layoutSubviews];
    self.mainView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.mainScrol.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-30);
    self.mainScrol.contentSize=CGSizeMake(self.frame.size.width,[self.scrolHeight floatValue]);
    CGFloat h=([self.scrolHeight floatValue])/7;
    CGFloat w=self.frame.size.width;
    CGFloat x=0;
    for (int i=0; i<self.lableArray.count; i++) {
        UIImageView *lineBg=[[UIImageView alloc]init];
        if(i<6)
        {
        [lineBg setImage:[UIImage imageNamed:@"week_select_line_bg"]];
        lineBg.frame=CGRectMake(x, h*(i+1),w,1);
            [self.mainScrol addSubview:lineBg];
        }
        
        UILabel *lable=(UILabel *)self.lableArray[i];
        CGRect rect = CGRectMake(x+5, h*i, w,h);
        
        lable.frame=rect;
    }
    CGFloat xb=self.frame.size.width-40;
    for (int i=0; i<self.checkArray.count; i++) {
        UIButton *btn=(UIButton *)self.checkArray[i];
        [btn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];

        btn.frame=CGRectMake(xb,h*i+10,20,20);
    }
    
    UIButton *submitBtn=[[UIButton alloc] init];

    [submitBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
     [submitBtn setBackgroundImage:[UIImage imageNamed:@"submit_button_bg"] forState:UIControlStateNormal];
   
     submitBtn.frame=CGRectMake(self.frame.size.width/2,self.frame.size.height-30,self.frame.size.width/2,30);
    [self addSubview:submitBtn];
    
    
    UIButton *closeBtn=[[UIButton alloc] init];

    [closeBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close_button_bg"] forState:UIControlStateNormal];

 
    
    closeBtn.frame=CGRectMake(0,self.frame.size.height-30,self.frame.size.width/2-1,30);
    [self addSubview:closeBtn];
    
}
- (void)checkboxClick:(UIButton *)checkbox
{
    
    checkbox.selected = !checkbox.isSelected;
    if(checkbox.selected)
        self.dataArray[checkbox.tag]=@"1";
     else
        self.dataArray[checkbox.tag]=@"0";
    
}
-(void)submitClick
{
    if ([self.delegate respondsToSelector:@selector(submitClick)]) {
        [self.delegate submitClick];
    }
    [self removeFromSuperview];
}

-(void)closeClick
{
    if ([self.delegate respondsToSelector:@selector(closeClick)]) {
        [self.delegate closeClick];
    }
    [self removeFromSuperview];
}




@end
