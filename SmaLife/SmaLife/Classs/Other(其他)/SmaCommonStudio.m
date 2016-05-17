

//
//  SmaCommonStudio.m
//  SmaLife
//
//  Created by chenkq on 15/4/6.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaCommonStudio.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@implementation SmaCommonStudio

#define CURR_LANG                        ([[NSLocale preferredLanguages] objectAtIndex:0])

+(NSString *)DPLocalizedString:(NSString *)translation_key {
    NSString *s = NSLocalizedString(translation_key, nil);
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];

     if (![preferredLang isEqualToString:@"zh"]&&![preferredLang isEqualToString:@"fr"]&&![preferredLang isEqualToString:@"de"]) {
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    
    return s;
}

+(NSString *)weekDayStr
{
    NSString *weekDayStr=nil;
    int week = [[self weekDayInt]intValue];
    switch (week) {
        case 1:
            weekDayStr = @"周 日";
            break;
        case 2:
            weekDayStr = @"周 一";
            break;
        case 3:
            weekDayStr = @"周 二";
            break;
        case 4:
            weekDayStr = @"周 三";
            break;
        case 5:
            weekDayStr = @"周 四";
            break;
        case 6:
            weekDayStr = @"周 五";
            break;
        case 7:
            weekDayStr = @"周 六";
            break;
        default:
            weekDayStr = @"";
            break;
    }
    return weekDayStr;
}

+(NSNumber *)weekDayInt
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    return [NSNumber numberWithInt:[comps weekday]];
}

+(void)share:(UIImage *)shareImage
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"png"];
    NSString *path2 = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Album"] stringByAppendingPathComponent:@"shareimage.png"];
    UIImage* img= [UIImage imageWithContentsOfFile:path2];
    UIImageView *image = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
//  UIImage *shareimage =  [self imageFromView:self.view];
//    创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"要分享的内容"
                                       defaultContent:@"默认内容"
                                                image:[ShareSDK pngImageWithImage:shareImage]
                                                title:@"SMA"
                                                  url:@"http://www.smawatch.com"
                                          description:@"给你分享"
                                            mediaType:SSPublishContentMediaTypeImage];

    //1、构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:@"要分享的内容"
//                                       defaultContent:@"默认内容"
//                                                image:[ShareSDK imageWithPath:imagePath]
//                                                title:@"SMA"
//                                                  url:@"http://www.smawatch.com"
//                                          description:@"给你分享"
//                                            mediaType:SSPublishContentMediaTypeNews];
    //1+创建弹出菜单容器（iPad必要）
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
    
    //2、弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"alera_shareSucc")
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:SmaLocalizedString(@"clockadd_confirm")
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SmaLocalizedString(@"alera_share_failu")
                                                                                    message:[NSString stringWithFormat:@"%@: %@",SmaLocalizedString(@"alert_erro"),[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:SmaLocalizedString(@"clockadd_confirm")
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                            }];
}




@end
