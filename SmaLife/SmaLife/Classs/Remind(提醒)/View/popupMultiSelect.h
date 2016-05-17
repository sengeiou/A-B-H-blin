//
//  popup-MultiSelect.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/13.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol popupMultiSelectDelegate <NSObject>
@optional
-(void)submitClick;
-(void)closeClick;
@end

@interface popupMultiSelect : UIView
@property (nonatomic, weak) id<popupMultiSelectDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSNumber *scrolHeight;

@end
