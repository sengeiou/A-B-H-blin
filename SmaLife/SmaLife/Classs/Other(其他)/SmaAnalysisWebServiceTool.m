//
//  SmaAnalysisWebServiceTool.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/7.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaAnalysisWebServiceTool.h"
#import "AFNetworking.h"
#import "SmaDataDAL.h"
#import "ACFileManager.h"
#import "UIImage+Resize.h"
//192.168.0.137
//58.96.179.251
#define NetWorkAddress @"http://58.96.179.251:8080/Smalife/services/userservice?wsdl"
#define NameSpace @"http://webservice.smalife.com/"
#define NetWorkShservice @"http://58.96.179.251:8080/Smalife/services/pushservice?wsdl"
#define NetWorkfriendService @"http://58.96.179.251:8080/Smalife/services/friendService?wsdl"
#define NetWorkSersion @"http://58.96.179.251:8080/Smalife/services/getIOSVersion?wsdl"
#define servicename @"mywatch"
#define service @"watch"
#define sportDict @"sportDict"
#define sleepDict @"sleepDict"
#define clockDict @"clockDict"

//#define NetWorkAddress @"http://192.168.0.137:8080/Smalife/services/userservice?wsdl"
//#define NameSpace @"http://webservice.smalife.com/"
//#define NetWorkShservice @"http://192.168.0.137:8080/Smalife/services/pushservice?wsdl"
//#define NetWorkfriendService @"http://192.168.0.137:8080/Smalife/services/friendService?wsdl"

@implementation SmaAnalysisWebServiceTool
{
    NSMutableDictionary *userInfoDic;
}
static NSString *user_acc = @"account";NSString *user_id = @"_id";NSString *user_nick = @"nickName";NSString *user_token = @"token";NSString *user_hi = @"hight";NSString *user_we= @"weight";NSString *user_sex = @"sex";NSString *user_age = @"age";NSString *user_he = @"header_url";NSString *user_fri = @"friend_account";NSString *user_fName = @"friend_nickName";NSString *user_agree = @"agree";NSString *user_aim = @"steps_Aim";
//****** account 用户账号；_id 蓝牙设备唯一ID；nickName 用户名；token 友盟token；hight 身高；weight 体重；sex 性别；age 年龄；header_url 头像链接；friend_account 好友账号；agree 是否同意好友；aim_steps 运动目标；*****//


-(void)getWebServiceLogin:(NSString *)userName userPwd:(NSString *)userPwd clientId:(NSString *)clientId success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *soapMessage=[NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"%@\">"
                           "<soap:Body>"
                           "<ns1:userLogin>"
                           "<jsonString>{\"password\":\"%@\",\"account\":\"%@\",\"clientId\":\"%@\"}</jsonString>"
                           "</ns1:userLogin>"
                           "</soap:Body>"
                           "</soap:Envelope>",NameSpace,userPwd,userName,clientId];
    NSLog(@"clientId==%@",soapMessage);
    NSURL *url = [NSURL URLWithString:NetWorkAddress];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableString *str = [[NSMutableString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
        
        MyLog(@"-------%@",str);
        [self splitRangeNSStriing:str];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSString *result=[jsonDict objectForKey:@"result"];
        if (success) {
            success(jsonDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [operation start];
}
//注册功能
-(void)getWebServiceRegister:(NSString *)userName userPwd:(NSString *)userPwd clientId:(NSString *)clientId success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *soapMessage=[NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"%@\">"
                           "<soap:Body>"
                           "<ns1:userRegister>"
                           "<jsonString>{\"device\":\"ios\",\"clientId\":\"%@\",\"account\":\"%@\", \"password\":\"%@\"}</jsonString>"
                           "</ns1:userRegister>"
                           "</soap:Body>"
                           "</soap:Envelope>",NameSpace,clientId,userName,userPwd];
    
    NSURL *url = [NSURL URLWithString:NetWorkAddress];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableString *str = [[NSMutableString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
        [self splitRangeNSStriing:str];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSString *result=[jsonDict objectForKey:@"result"];
        if (success) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [operation start];
}
//更新用户名称
-(void)updateWebserverUserInfo:(SmaUserInfo *)userInfo success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *soapMessage=[NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"%@\">"
                           "<soap:Body>"
                           "<ns1:updateUser>"
                           "<jsonString>{\"device\":\"ios\",\"id\":\"%@\",\"account\":\"%@\", \"password\":\"%@\", \"hight\":\"%@\", \"weight\":\"%@\",\"sex\":\"%@\",\"age\":\"25\",\"nickName\":\"%@\"}</jsonString>"
                           "</ns1:updateUser>"
                           "</soap:Body>"
                           "</soap:Envelope>",NameSpace,userInfo.userId,userInfo.tel,userInfo.userPwd,[userInfo.height isEqualToString:@""]?@"0":userInfo.height,[userInfo.weight isEqualToString:@""]?@"0":userInfo.weight,userInfo.sex,userInfo.nickname];
    
    NSURL *url = [NSURL URLWithString:NetWorkAddress];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    NSString *reqStr = [soapMessage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    request.timeoutInterval = 10;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableString *str = [[NSMutableString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
        [self splitRangeNSStriing:str];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSString *result=[jsonDict objectForKey:@"result"];
        if (success) {
            success(result);
        }
        [MBProgressHUD hideHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
        [MBProgressHUD hideHUD];
    }];
    [operation start];
}
//获取好友信息
-(void)getBondFriends:(NSString *)device_type userInfo:(SmaUserInfo *)userInfo success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *str = @"18780248433";
    NSString *bondFriend = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"%@\">"
                            "<soap:Body>"
                            "<ns1:getFriendInfo>"
                            "<jsonString>{\"userAccount\":\"%@\"}</jsonString>"
                            "</ns1:getFriendInfo>"
                            "</soap:Body>"
                            "</soap:Envelope>",@"http://webservice.smalife.com/",userInfo.tel];
    NSURL *url = [NSURL URLWithString:NetWorkfriendService];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[bondFriend length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [bondFriend dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableString *str = [[NSMutableString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
        [self splitRangeNSStriing:str];
        
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"friendDit= %@   %@",jsonDict,bondFriend);
        if (success) {
            success(jsonDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
            NSLog(@"失败");
        }
    }];
    [operation start];
}
//推送
-(void)getWebServiceSendLove:(NSString *)device_type nickName:(NSString *)nickName friendAccount:(NSString *)friendAccount userAccount:(NSString *)userAccount client_id:(NSString *)client_id  success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *soapMessage=[NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"%@\">"
                           "<soap:Body>"
                           "<ns1:matchAsk>"
                           "<jsonString>{\"device_type\":\"%@\",\"friendAccount\":\"%@\",\"userAccount\":\"%@\",\"user_id\":\"%@\",\"nickName\":\"%@\"}</jsonString>"
                           "</ns1:matchAsk>"
                           "</soap:Body>"
                           "</soap:Envelope>",@"http://webservice.smalife.com/",device_type,friendAccount,userAccount,client_id,nickName];
    
    NSURL *url = [NSURL URLWithString:NetWorkShservice];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableString *str = [[NSMutableString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
        
        [self splitRangeNSStriing:str];
        
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSString *result=[jsonDict objectForKey:@"result"];
        MyLog(@"%@",result);
        if (success) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [operation start];
}
//发送配对
-(void)getWebServiceSendIiBound:(NSString *)device_type friendAccount:(NSString *)friendAccount userAccount:(NSString *)userAccount client_id:(NSString *)client_id  success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *soapMessage=[NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"%@\">"
                           "<soap:Body>"
                           "<ns1:matchResponse>"
                           "<jsonString>{\"friendAccount\":\"%@\",\"userAccount\":\"%@\",\"user_id\":\"%@\",\"deviceType\":\"IOS\"}</jsonString>"
                           "</ns1:matchResponse>"
                           "</soap:Body>"
                           "</soap:Envelope>",@"http://webservice.smalife.com/",device_type,friendAccount,userAccount];
    
    NSURL *url = [NSURL URLWithString:NetWorkShservice];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableString *str = [[NSMutableString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
        [self splitRangeNSStriing:str];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSString *result=[jsonDict objectForKey:@"result"];
        if (success) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [operation start];
}
//发送配对结果
-(void)sendBackNatchesResult:(NSString *)device_type friendAccount:(NSString *)friendAccount userAccount:(NSString *)userAccount client_id:(NSString *)client_id friend_id:(NSString *)friend_id  agree:(NSString *)agree nickName:(NSString *)nickName  success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *soapMessage=[NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"%@\">"
                           "<soap:Body>"
                           "<ns1:matchResponse>"
                           "<jsonString>{\"friendAccount\":\"%@\",\"userAccount\":\"%@\",\"user_id\":\"%@\",\"deviceType\":\"%@\",\"friendHeader\":\"""\",\"address\":\"无\",\"deviceName\":\"无\",\"friend_id\":\"%@\",\"deviceMac\":\"无\",\"agree\":\"%@\",\"nickName\":\"%@\"}</jsonString>"
                           "</ns1:matchResponse>"
                           "</soap:Body>"
                           "</soap:Envelope>",@"http://webservice.smalife.com/",friendAccount,userAccount,client_id,device_type,friend_id,agree,nickName];
    
    NSURL *url = [NSURL URLWithString:NetWorkShservice];//@"http://192.168.0.137:8080/Smalife/services/pushservice?wsdl"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableString *str = [[NSMutableString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
        [self splitRangeNSStriing:str];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSString *result=[jsonDict objectForKey:@"result"];
        if (success) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [operation start];
}
//解析字符串
-(void)splitRangeNSStriing:(NSMutableString *)serviceXml
{
    NSRange beginInt=[serviceXml rangeOfString:@"<return>"];
    [serviceXml deleteCharactersInRange:NSMakeRange(0, beginInt.location+8)];
    
    NSRange endInt=[serviceXml rangeOfString:@"</return>"];
    NSRange end=[serviceXml rangeOfString:@"</soap:Envelope>"];
    [serviceXml deleteCharactersInRange:NSMakeRange(endInt.location,end.location-endInt.location+end.length)];
    
}
//发送互动指令
-(void)sendInteraction:(NSString *)device_type friendAccount:(NSString *)friendAccount content:(NSString *)content
{
    NSString *soapMessage=[NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"%@\">"
                           "<soap:Body>"
                           "<ns1:dispatcherMsg>"
                           "<jsonString>{\"deviceType\":\"%@\",\"account\":\"%@\",\"content_key\":\"%@\"}</jsonString>"
                           "</ns1:dispatcherMsg>"
                           "</soap:Body>"
                           "</soap:Envelope>",@"http://webservice.smalife.com/",device_type,friendAccount,content];
    
    NSURL *url = [NSURL URLWithString:NetWorkShservice/*@"http://58.96.179.251:8080/Smalife/services/pushservice?wsdl"*/];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableString *str = [[NSMutableString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
        MyLog(@"%@",str);
        [self splitRangeNSStriing:str];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSString *key=[jsonDict objectForKey:@"content_key"];
        NSString *result=[jsonDict objectForKey:@"result"];
        if([result isEqualToString:@"okay"] || [result isEqualToString:@"1"])
        {
            if([key intValue]==32)
            {
                [SmaBleMgr setInteractone31];
            }else {
                [SmaBleMgr setInteractone33];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [operation start];
}

-(void)sendunBondFriends:(SmaUserInfo *)userInfo success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    [MBProgressHUD showMessage:SmaLocalizedString(@"relieve_assoc")];
    NSString *soapMessage=[NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"%@\">"
                           "<soap:Body>"
                           "<ns1:unBondFriends>"
                           "<jsonString>{\"userAccount\":\"%@\",\"friendAccount\":\"%@\",\"device_type\":\"%@\",\"client_id\":\"%@\",\"nickName\":\"%@\"}</jsonString>"
                           "</ns1:unBondFriends>"
                           "</soap:Body>"
                           "</soap:Envelope>",@"http://webservice.smalife.com/",userInfo.tel,userInfo.friendAccount,@"IOS",@"",userInfo.nickname];
    
    NSURL *url = [NSURL URLWithString:NetWorkfriendService/*@"http://58.96.179.251:8080/Smalife/services/pushservice?wsdl"*/];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUD];
        NSMutableString *str = [[NSMutableString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
        MyLog(@"-------%@",str);
        [self splitRangeNSStriing:str];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        //NSString *key=[jsonDict objectForKey:@"content_key"];
        NSString *result=[jsonDict objectForKey:@"result"];
        if([result isEqualToString:@"okay"])
        {
            MyLog(@"成功");
            [MBProgressHUD showMessage:SmaLocalizedString(@"lift_succ")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            userInfo.nicknameLove=@"";
            userInfo.friendAccount=@"";
            [SmaAccountTool saveUser:userInfo];
            
        }
        else if ([result isEqualToString:@"none"]){
            
            [MBProgressHUD showMessage:SmaLocalizedString(@"lift_succ")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            userInfo.nicknameLove=@"";
            userInfo.friendAccount=@"";
            [SmaAccountTool saveUser:userInfo];
            
        }
        else
        {
            MyLog(@"失败");
            [MBProgressHUD showMessage:SmaLocalizedString(@"lift_fail")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
        }
        if (success) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MyLog(@"失败");
        if (failure) {
            failure(error);
        }
        [MBProgressHUD showMessage:SmaLocalizedString(@"lift_fail")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
    }];
    [operation start];
}

-(void)UpdateUserPwd:(NSString *)tel pwd:(NSString *)pwd success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *soapMessage=[NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"%@\">"
                           "<soap:Body>"
                           "<ns1:ModifyPassword>"
                           "<jsonString>{\"userAccount\":\"%@\",\"password\":\"%@\"}</jsonString>"
                           "</ns1:ModifyPassword>"
                           "</soap:Body>"
                           "</soap:Envelope>",@"http://webservice.smalife.com/",tel,pwd];
    
    NSURL *url = [NSURL URLWithString:NetWorkAddress/*@"http://58.96.179.251:8080/Smalife/services/pushservice?wsdl"*/];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableString *str = [[NSMutableString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
        MyLog(@"%@",str);
        [self splitRangeNSStriing:str];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        //NSString *key=[jsonDict objectForKey:@"content_key"];
        NSString *result=[jsonDict objectForKey:@"result"];
        if (success) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [operation start];
}

- (void)checkUpdate:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSString *soapMessage=[NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"%@\">"
                           "<soap:Body>"
                           "<ns1:getVersion>"
                           "<jsonString>{\"file_type\":\"%@\"}</jsonString>"
                           "</ns1:getVersion>"
                           "</soap:Body>"
                           "</soap:Envelope>",@"http://webservice.smalife.com/",@".pdf"];
    NSURL *url = [NSURL URLWithString:NetWorkSersion/*@"http://58.96.179.251:8080/Smalife/services/pushservice?wsdl"*/];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableString *str = [[NSMutableString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
        MyLog(@"str___%@",str);
        [self splitRangeNSStriing:str];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        //NSString *key=[jsonDict objectForKey:@"content_key"];
        NSLog(@"jsonDict=_-%@",jsonDict);
        //        NSString *result=[jsonDict objectForKey:@"result"];
        if (success) {
            success(jsonDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [operation start];
    
    
}


#pragma mark *******云平台接口*******
//登录
- (void)acloudLoginWithAccount:(NSString *)account Password:(NSString *)passowrd success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [ACAccountManager loginWithUserInfo:account password:passowrd callback:^(ACUserInfo *user, NSError *error) {
        
        if (!error) {
            userInfoDic = [NSMutableDictionary dictionary];
            [userInfoDic setValue:user.nickName forKey:user_nick];
            [userInfoDic setValue:user.phone forKey:user_acc];
            [self acloudGetUserifnfoSuccess:^(NSMutableDictionary *userDict) {
                if (userDict) {
                    [self acloudGetFriendWithAccount:account success:^(id userInfo) {
                        [self acloudDownLDataWithAccount:account success:^(id result) {
                                [self acloudCIDSuccess:^(id result) {
                                   
                                            if (success) {
                                                success(userInfoDic);
                                            }
                                } failure:^(NSError *error) {
                                    if (failure) {
                                        failure(error);
                                    }
                                    
                                }];
                        } failure:^(NSError *error) {
                            if (failure) {
                                failure(error);
                            }
                            
                        }];
                        
                    } failure:^(NSError *error) {
                        if (failure) {
                            failure(error);
                        }
                    }];
                }
                else{
                    if (failure) {
                        failure(error);
                    }
                }
            } failure:^(NSError *error) {
                
            }];
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//检测是否存在该用户
- (void)acloudCheckExist:(NSString *)account success:(void (^)(bool))success failure:(void (^)(NSError *))failure{
    [ACAccountManager checkExist:account callback:^(BOOL exist, NSError *error) {
        if (!error) {
            if (success) {
                success(exist);
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//发送验证码
- (void)acloudSendVerifiyCodeWithAccount:(NSString *)account template:(NSInteger)template success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [ACAccountManager sendVerifyCodeWithAccount:account template:template callback:^(NSError *error) {
        if (!error) {
            if (success) {
                success(error);
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//注册用户
- (void)acloudRegisterWithPhone:(NSString *)phone email:(NSString *)email password:(NSString *)password verifyCode:(NSString *)verifiy success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [ACAccountManager registerWithPhone:phone email:nil password:password verifyCode:verifiy callback:^(NSString *uid, NSError *error) {
        if (!error) {
            if (success) {
                success(uid);
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//修改密码
- (void)acloudResetPasswordWithAccount:(NSString *)account verifyCode:(NSString *)verifyCode password:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [ACAccountManager resetPasswordWithAccount:account verifyCode:verifyCode password:password callback:^(NSString *uid, NSError *error) {
        if (!error) {
            if (success) {
                success(uid);
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
}

//设置个人信息
- (void)acloudPutUserifnfo:(SmaUserInfo *)info success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    [ACAccountManager changeNickName:info.nickname callback:^(NSError *error) {
        
    }];
    ACObject *msg = [[ACObject alloc] init];
    [msg putInteger:@"age" value:info.age.integerValue?info.age.integerValue:@"".integerValue];
    [msg putString:@"client_id" value:[SmaUserDefaults objectForKey:@"clientId"]?[SmaUserDefaults objectForKey:@"clientId"]:@""];
    [msg putString:@"device_type" value:@"ios"];
    [msg putString:@"header_url" value:info.header_url?info.header_url:@""];
    [msg putFloat:@"hight" value:info.height.floatValue?info.height.floatValue:@"".floatValue];
    [msg putInteger:@"sex" value:info.sex.integerValue?info.sex.integerValue:@"".integerValue];
    [msg putInteger:@"steps_Aim" value:[SmaUserDefaults objectForKey:@"stepPlan"]?[[SmaUserDefaults objectForKey:@"stepPlan"] intValue]*300:@"7000".integerValue];
    [msg putFloat:@"weight" value:info.weight.floatValue?info.weight.floatValue:@"".floatValue];
    
    [ACAccountManager setUserProfile:msg callback:^(NSError *error) {
        if (!error) {
            if (success) {
                success(error.debugDescription);
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}


//发送CID
- (void)acloudCIDSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
    ACObject *msg = [[ACObject alloc] init];
    [msg putString:@"client_id" value:[SmaUserDefaults objectForKey:@"clientId"]?[SmaUserDefaults objectForKey:@"clientId"]:@""];
    [ACAccountManager setUserProfile:msg callback:^(NSError *error) {
        if (!error) {
            if (success) {
                success(@"1");
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//发送照片
- (void)acloudHeadUrlSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
    ACFileInfo * fileInfo = [[ACFileInfo alloc] initWithName:[NSString stringWithFormat:@"%@.jpg",[SmaAccountTool userInfo].loginName] bucket:@"/sma/watch/header" Checksum:0];
    //照片路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[SmaAccountTool userInfo].loginName]];
    NSData *data = [NSData dataWithContentsOfFile:uniquePath];
    
    fileInfo.filePath = uniquePath;
    fileInfo.acl = [[ACACL alloc] init];
    ACFileManager *upManager = [[ACFileManager alloc] init];
    [upManager uploadFileWithfileInfo:fileInfo progressCallback:^(NSString *key, float progress) {
        NSLog(@"progressCallback  %@   %f",key,progress);
    } voidCallback:^(ACMsg *responseObject, NSError *error) {
        NSLog(@"error %@",error);
        if (!error) {
            if (success) {
                success(@"1");
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
        
    }];
}

//下载头像照片
- (void)acloudDownLHeadUrlWithAccount:(NSString *)account Success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [NSString stringWithFormat:@"%@/%@.jpg",[paths objectAtIndex:0],account];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:cachesDir error:nil];
    
    ACFileInfo * fileInfo1 = [[ACFileInfo alloc] initWithName:[NSString stringWithFormat:@"%@.jpg",account] bucket:@"/sma/watch/header" Checksum:0];
    ACFileManager *upManager = [[ACFileManager alloc] init];
    [upManager getDownloadUrlWithfile:fileInfo1 ExpireTime:0 payloadCallback:^(NSString *urlString, NSError *error) {
        [upManager downFileWithsession:urlString callBack:^(float progress, NSError *error) {
                    NSLog(@"callBack==%f   error==%@",progress,error);
            if (error) {
                if (failure) {
                    failure(error);
                }
            }
        } CompleteCallback:^(NSString *filePath) {
             NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSLog(@"filePath==%@",filePath);
            if (filePath) {
//                [userInfoDic setValue:filePath forKey:user_he];
                if (success) {
                    success(filePath);
                }
            }
            else{
                if (failure) {
                    failure(error);
                }
            }
        }];
    }];    
}

//获取个人信息
- (void)acloudGetUserifnfoSuccess:(void (^)(NSMutableDictionary *))success failure:(void (^)(NSError *))failure{
    
    [ACAccountManager getUserProfile:^(ACObject *profile, NSError *error) {
        if (!error) {
            userInfoDic = [self userDataWithACmsg:profile];
            if (success) {
                success(userInfoDic);
            }
        }
        if (failure) {
            failure(error);
        }
    }];
}

//好友添加请求
- (void)acloudRequestFriendAccount:(NSString *)fAccount MyAccount:(NSString *)account myName:(NSString *)nickName success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    ACMsg *msg = [[ACMsg alloc]init];
    msg.name = @"askFriend";
    [msg putString:@"fAccount" value:fAccount?fAccount:@""];
    [msg putString:@"uAccount" value:account?account:@""];
    [msg putString:@"nickName" value:nickName?nickName:@""];
    [msg putString:@"device_type" value:@"ios"];
    [ACloudLib sendToService:service serviceName:servicename version:1 msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        NSString *result = [NSString stringWithFormat:@"%ld",[responseMsg getLong:@"rt"]];
        if (!error) {
            if (success) {
                success(result);
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//应答好友
- (void)acloudReplyFriendAccount:(NSString *)fAccount FrName:(NSString *)fName MyAccount:(NSString *)mAccount MyName:(NSString *)mName agree:(BOOL)isAgree success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    ACMsg *mag = [[ACMsg alloc] init];
    mag.name = @"responseAsk";
    [mag putString:@"nickName" value:mName?mName:@""];
    [mag putString:@"uAccount" value:mAccount];
    [mag putString:@"fAccount" value:fAccount];
    [mag putString:@"fnickName" value:fName];
    [mag putInteger:@"agree" value:isAgree];
    [mag putString:@"device_type" value:@"ios"];
    [ACloudLib sendToService:service serviceName:servicename version:1 msg:mag callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            if (success) {
                success(responseMsg);
            }
        }
        else{
            if (error) {
                failure(error);
            }
        }
    }];
}

//获取好友信息
- (void)acloudGetFriendWithAccount:(NSString *)account success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    ACMsg *msg = [[ACMsg alloc] init];
    msg.name = @"scanFriendInfo";
    [msg putString:@"uAccount" value:account?account:@""];
    [ACloudLib sendToService:service serviceName:servicename version:1 msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            if (success) {
                userInfoDic = [self friendDataWithACmsg:responseMsg];
                success(userInfoDic);
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//删除好友
- (void)acloudDeleteFridendAccount:(NSString *)fAccount MyAccount:(NSString *)account myName:(NSString *)nickName success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    ACMsg *msg = [[ACMsg alloc] init];
    msg.name = @"unBondFriends";
    [msg putString:@"uAccount" value:account];
    [msg putString:@"nickName" value:nickName];
    [msg putString:@"fAccount" value:fAccount];
    [ACloudLib sendToService:service serviceName:servicename version:1 msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            if (success) {
                success(responseMsg);
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
}

//互动推送
- (void)acloudDispatcherFriendAccount:(NSString *)fAccount content:(NSString *)content success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    ACMsg *msg = [[ACMsg alloc] init];
    msg.name = @"dispatcherMsg";
    [msg putString:@"dis_account" value:fAccount];
    [msg putInteger:@"content_key" value:content.integerValue];
    [ACloudLib sendToService:service serviceName:servicename version:1 msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            if([content intValue]==32)
            {
                [SmaBleMgr setInteractone31];
            }else {
                [SmaBleMgr setInteractone33];
            }
            
            if (success) {
                success(responseMsg);
            }
        }
        else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

//上传数据
- (void)acloudSyncAllDataWithAccount:(NSString *)account sportDic:(NSMutableArray *)sport sleepDic:(NSMutableArray *)sleep clockDic:(NSMutableArray *)clock success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    __block int i = 0;
    SmaSeatInfo *setInfo = [SmaAccountTool seatInfo];
    
    ACMsg *msg = [[ACMsg alloc] init];
    msg.name = @"sync_all";
    [msg put:@"sport_list" value:sport];
    [msg put:@"sleep_list" value:sleep];
    [msg put:@"clock_list" value:clock];
    [msg putString:@"user_account" value:account?account:@""];
    [ACloudLib sendToService:service serviceName:servicename version:1 msg:msg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            i++;
            if (i==2) {
                [self clearUserSportWithMsg:nil sportData:sport];
                [self clearUserSleeptWithMsg:nil sleepData:sleep Account:account];
                if (success) {
                    success(error);
                }
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
    ACMsg *msg2= [[ACMsg alloc] init];
    msg2.name = @"sync_sma_data";
    [msg2 putInteger:@"lost_open" value:[SmaUserDefaults integerForKey:@"myLoseInt"]?[SmaUserDefaults integerForKey:@"myLoseInt"]:@"".integerValue];
    [msg2 putInteger:@"msg_notic" value:[SmaUserDefaults integerForKey:@"mySmsRemindInt"]?[SmaUserDefaults integerForKey:@"mySmsRemindInt"]:@"".integerValue];
    [msg2 putInteger:@"tel_notic" value:[SmaUserDefaults integerForKey:@"myTelRemindInt"]?[SmaUserDefaults integerForKey:@"myTelRemindInt"]:@"".integerValue];
    [msg2 putInteger:@"long_sit_start" value:setInfo.beginTime.integerValue?setInfo.beginTime.integerValue:@"".integerValue];
    [msg2 putInteger:@"long_sit_end" value:setInfo.endTime.integerValue?setInfo.endTime.integerValue:@"".integerValue];
    [msg2 putInteger:@"long_min" value:setInfo.seatValue.integerValue?setInfo.seatValue.integerValue:@"".integerValue];
    [msg2 putInteger:@"long_sit_open" value:setInfo.isOpen.integerValue?setInfo.isOpen.integerValue:@"0".integerValue];
    [msg2 putString:@"weeks" value:[self getWeekStr:setInfo.pepeatWeek]?[self getWeekStr:setInfo.pepeatWeek]:@""];
    [msg2 putString:@"user_account" value:account?account:@""];
    [ACloudLib sendToService:service serviceName:servicename version:1 msg:msg2 callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            i++;
            if (i == 2) {
                if (success) {
                    [self clearUserSportWithMsg:nil sportData:sport];
                    [self clearUserSleeptWithMsg:nil sleepData:sleep Account:account];
                    success(responseMsg);
                }
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
}

//下载数据
- (void)acloudDownLDataWithAccount:(NSString *)account success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    __block int i = 0;
    ACMsg *Spmsg = [[ACMsg alloc] init];
    Spmsg.name = @"sync_sport";
    [Spmsg putString:@"user_account" value:account?account:@""];
    [ACloudLib sendToService:service serviceName:servicename version:1 msg:Spmsg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            [self clearUserSportWithMsg:responseMsg sportData:nil];
            i++;
            if (i==4) {
                if (success) {
                    success(error);
                }
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
    
    ACMsg *Slmsg = [[ACMsg alloc] init];
    Slmsg.name = @"sync_sleep";
    [Slmsg put:@"user_account" value:account?account:@""];
    [ACloudLib sendToService:service serviceName:servicename version:1 msg:Slmsg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            [self clearUserSleeptWithMsg:responseMsg sleepData:nil Account:account];
            i++;
            if (i==4) {
                if (success) {
                    success(error);
                }
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
    
    ACMsg *Clmsg = [[ACMsg alloc] init];
    Clmsg.name = @"sync_clock";
    [Clmsg put:@"user_account" value:account?account:@""];
    [ACloudLib sendToService:service serviceName:servicename version:1 msg:Clmsg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            [self clearUserClockWithMsg:responseMsg Account:account];
            i++;
            if (i==4) {
                if (success) {
                    success(error);
                }
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
    
    ACMsg *smamsg = [[ACMsg alloc] init];
    smamsg.name = @"sync_sma";
    [smamsg put:@"user_account" value:account?account:@""];
    [ACloudLib sendToService:service serviceName:servicename version:1 msg:smamsg callback:^(ACMsg *responseMsg, NSError *error) {
        if (!error) {
            [self clearUserSatWithMsg:responseMsg];
            i++;
            if (i==4) {
                if (success) {
                    success(error);
                }
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
}

//整理接收用户信息
- (NSMutableDictionary *)userDataWithACmsg:(ACObject *)responseMsg{
    if (![responseMsg isEqual:@"none"]) {
        [userInfoDic setValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_hi]] forKey:user_hi];
        [userInfoDic setValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_we]] forKey:user_we];
        [userInfoDic setValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_sex]] forKey:user_sex];
        [userInfoDic setValue:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_age]] forKey:user_age];
        
        if ([NSString stringWithFormat:@"%ld",[responseMsg getLong:user_aim]].intValue/300==0) {
           [SmaUserDefaults removeObjectForKey:@"stepPlan"];
            NSLog(@"soirt==%@",[SmaUserDefaults objectForKey:@"stepPlan"]);
        }
        else{
            NSLog(@"step==%d",[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_aim]].intValue);
            [SmaUserDefaults setObject:[NSString stringWithFormat:@"%ld",[responseMsg getLong:user_aim]/300] forKey:@"stepPlan"];
        }
    }
    return userInfoDic;
}

//整理接收好友信息
- (NSMutableDictionary *)friendDataWithACmsg:(ACObject *)responseMsg{
    if (![responseMsg isEqual:@"none"]) {
        if ([responseMsg get:@"friend"]) {
            [userInfoDic setValue:[[responseMsg get:@"friend"] getString:@"friend_account"] forKey:user_fri];
            [userInfoDic setValue:[[responseMsg get:@"friend"] getString:@"friendName"] forKey:user_fName];
        }
    }
    return userInfoDic;
}
//整理发送用户信息
- (void)clearUserWithMsg:(ACMsg *)msg userInfo:(SmaUserInfo *)info{
    [msg putString:user_acc value:info.loginName?info.loginName:@""];
    [msg putString:user_nick value:info.nickname?info.nickname:@""];
    [msg putString:user_token value:info.token?info.token:@""];
    [msg putFloat:user_hi value:info.height.floatValue?info.height.floatValue:[NSString stringWithFormat:@""].floatValue];
    [msg putFloat:user_we value:info.weight.floatValue?info.weight.floatValue:@"".floatValue];
    [msg putInteger:user_id value:info.bli_id.integerValue?info.bli_id.integerValue:@"".integerValue];
    [msg putInteger:user_sex value:info.sex.integerValue?info.sex.integerValue:@"".integerValue];
    [msg putInteger:user_age value:info.age.integerValue?info.age.integerValue:@"".integerValue];
    [msg putString:user_he value:info.header_url?info.header_url:@""];
    [msg putString:user_fri value:info.friendAccount?info.friendAccount:@""];
    [msg putString:user_fName value:info.nicknameLove?info.nicknameLove:@""];
    [msg putInteger:user_aim value:info.aim_steps.integerValue?info.aim_steps.integerValue:@"".integerValue];
    [msg putInteger:user_agree value:info.agree.integerValue?info.agree.integerValue:@"".integerValue];
}


// 保存下载运动数据
- (void)clearUserSportWithMsg:(ACMsg *)msg sportData:(NSMutableArray *)sportArr{
    SmaDataDAL *smaDal = [[SmaDataDAL alloc] init];
    NSMutableArray *infos=[NSMutableArray array];

    if (msg) {
        if (![msg isEqual:@"none"]) {
            NSArray *spArr = [msg get:@"sport_sync_rt"];
            if (spArr.count>0) {
                for (int i =0; i<spArr.count; i++) {
                    SmaSportInfo *info=[[SmaSportInfo alloc]init];
                    info.sport_calory = [NSNumber numberWithFloat:[[spArr[i] objectForKey:@"calorie"] floatValue]];
                    info.sport_data = [[NSString stringWithFormat:@"%@",[spArr[i] objectForKey:@"count_date"]]stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    info.sport_distance = [NSNumber numberWithFloat:[[spArr[i] objectForKey:@"distance"] floatValue]];
                    info.sport_time = [NSNumber numberWithFloat:[[spArr[i] objectForKey:@"offset"] floatValue]];
                    
                    info.sport_step = [NSNumber numberWithFloat:[[spArr[i] objectForKey:@"steps"] floatValue]];
                    info.user_id = [NSString stringWithFormat:@"%@",[spArr[i] objectForKey:@"user_account"]];
                    info.sport_id = [NSString stringWithFormat:@"%@",[spArr[i] objectForKey:@"sport_id"]];
                    info.sport_activetime = @0;
                    info.sport_web = @1;
                    [infos addObject:info];
                    NSLog(@"---%@           +++=%@",[NSString stringWithFormat:@"%@",[spArr[i] objectForKey:@"count_date"]],info.sport_data);
                }
                [smaDal insertSmaSport:infos];
            }
        }
    }
    else if (sportArr){
        for (int i =0; i<sportArr.count; i++) {
            SmaSportInfo *info=[[SmaSportInfo alloc]init];
            info.sport_calory = [NSNumber numberWithFloat:[[sportArr[i] objectForKey:@"calorie"] floatValue]];
            info.sport_data = [NSString stringWithFormat:@"%@",[sportArr[i] objectForKey:@"count_date"]];
            info.sport_distance = [NSNumber numberWithFloat:[[sportArr[i] objectForKey:@"distance"] floatValue]];
            info.sport_time = [NSNumber numberWithFloat:[[sportArr[i] objectForKey:@"offset"] floatValue]];
            info.sport_step = [NSNumber numberWithFloat:[[sportArr[i] objectForKey:@"steps"] floatValue]];
            info.user_id = [NSString stringWithFormat:@"%@",[sportArr[i] objectForKey:@"user_account"]];
            info.sport_id = [NSString stringWithFormat:@"%@",[sportArr[i] objectForKey:@"sport_id"]];
            info.sport_activetime = @0;
            info.sport_web = @1;
            [infos addObject:info];
        }
        [smaDal insertSmaSport:infos];
        
    }
}

//保存下载睡眠数据
- (void)clearUserSleeptWithMsg:(ACMsg *)msg sleepData:(NSMutableArray *)sleepArr Account:(NSString *)account{
    SmaDataDAL *smaDal = [[SmaDataDAL alloc] init];
    NSMutableArray *infos=[NSMutableArray array];
    if (msg) {
        if (![msg isEqual:@"none"]) {
            NSArray *slArr = [msg get:@"sleep_sync_rt"];
            if (slArr.count>0) {
                for (int i =0; i<slArr.count; i++) {
                    SmaSleepInfo *info=[[SmaSleepInfo alloc]init];
                    info.user_id = account;
                    info.sleep_id = [NSString stringWithFormat:@"%@",[slArr[i] objectForKey:@"sleep_id"]];
                    info.sleep_data = [NSNumber numberWithInt:[[[slArr[i] objectForKey:@"sleep_date"] stringByReplacingOccurrencesOfString:@"-" withString:@""] intValue]];
                    info.sleep_mode = [NSNumber numberWithInt:[[slArr[i] objectForKey:@"time_type"] intValue]];;
                    info.sleep_time = [NSString stringWithFormat:@"%@",[slArr[i] objectForKey:@"action_time"]];
                    info.sleep_type = [NSNumber numberWithInt:[[slArr[i] objectForKey:@"sleep_type"] intValue]];
                    info.sleep_wear = @1;
                    info.sleep_web = @1;
                    [infos addObject:info];
                }
                [smaDal insertSleepInfo:infos];
            }
        }
    }
    else if (sleepArr){
        for (int i =0; i<sleepArr.count; i++) {
            SmaSleepInfo *info=[[SmaSleepInfo alloc]init];
            info.user_id = account;
            info.sleep_id = [NSString stringWithFormat:@"%@",[sleepArr[i] objectForKey:@"sleep_id"]];
            info.sleep_data = [NSNumber numberWithInt:[[[sleepArr[i] objectForKey:@"sleep_date"] stringByReplacingOccurrencesOfString:@"-" withString:@""] intValue]];
            info.sleep_mode = [NSNumber numberWithInt:[[sleepArr[i] objectForKey:@"time_type"] intValue]];;
            info.sleep_time = [NSString stringWithFormat:@"%@",[sleepArr[i] objectForKey:@"action_time"]];
            info.sleep_type = [NSNumber numberWithInt:[[sleepArr[i] objectForKey:@"sleep_type"] intValue]];
            info.sleep_wear = @1;
            info.sleep_web = @1;
            [infos addObject:info];
        }
        [smaDal insertSleepInfo:infos];
        
    }
}
//保存下载闹钟数据
- (void)clearUserClockWithMsg:(ACMsg *)msg Account:(NSString *)account{
    SmaDataDAL *smaDal = [[SmaDataDAL alloc] init];
    NSMutableArray *infos=[NSMutableArray array];
    
    if (![msg isEqual:@"none"]) {
        NSArray *AlArr = [msg get:@"clock_sync_rt"];
        if (AlArr.count>0) {
            for (int i =0; i<AlArr.count; i++) {
                SmaAlarmInfo *info=[[SmaAlarmInfo alloc]init];
                info.userId = [NSString stringWithFormat:@"%@",[AlArr[i] objectForKey:@"user_account"]];
                info.year = [NSString stringWithFormat:@"%@",[AlArr[i] objectForKey:@"year"]];
                info.mounth = [NSString stringWithFormat:@"%@",[AlArr[i] objectForKey:@"month"]];
                info.day = [NSString stringWithFormat:@"%@",[AlArr[i] objectForKey:@"day"]];
                info.hour = [[NSString stringWithFormat:@"%@",[AlArr[i] objectForKey:@"clock_time"]] substringWithRange:NSMakeRange(0, 2)];
                info.minute = [[NSString stringWithFormat:@"%@",[AlArr[i] objectForKey:@"clock_time"]] substringWithRange:NSMakeRange(3, 2)];
                info.tagname = [NSString stringWithFormat:@"%@",[AlArr[i] objectForKey:@"name"]];
                info.isopen = [NSString stringWithFormat:@"%@",[AlArr[i] objectForKey:@"clockOpen"]];
                info.dayFlags = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",[AlArr[i] objectForKey:@"mon_day"],[AlArr[i] objectForKey:@"tues_day"],[AlArr[i] objectForKey:@"wes_day"],[AlArr[i] objectForKey:@"thur_day"],[AlArr[i] objectForKey:@"frid_day"],[AlArr[i] objectForKey:@"sta_day"],[AlArr[i] objectForKey:@"sun_day"]];
                info.web = @"1";
                [infos addObject:info];
            }
            if (infos>0) {
                [smaDal deleteClockUserInfo:account success:^(id result) {
                    for (int i=0; i<infos.count; i++) {
                        [smaDal insertClockInfo:infos[i]];
                    }
                    
                } failure:^(id result) {
                    
                } ];
                
            }
        }
    }
    
}

//保存下载设置数据
- (void)clearUserSatWithMsg:(ACMsg *)msg{
    SmaSeatInfo *seatInfo=[[SmaSeatInfo alloc]init];
    ACObject *object = [msg get:@"sma_data"];
    if (![msg isEqual:@"none"]) {
        seatInfo.beginTime = [NSString stringWithFormat:@"%ld",[object getLong:@"long_sit_start"]];
        seatInfo.endTime = [NSString stringWithFormat:@"%ld",[object getLong:@"long_sit_end"]];
        seatInfo.seatValue = [NSString stringWithFormat:@"%ld",[object getLong:@"long_min"]];
        seatInfo.isOpen = [NSString stringWithFormat:@"%ld",[object getLong:@"long_sit_open"]];
        seatInfo.pepeatWeek = [self setStringWith:[object getString:@"weeks"]];
        [SmaAccountTool saveSeat:seatInfo];
        [SmaUserDefaults setInteger:[object getLong:@"lost_open"] forKey:@"myLoseInt"];
        [SmaUserDefaults setInteger:[object getLong:@"msg_notic"] forKey:@"mySmsRemindInt"];
        [SmaUserDefaults setInteger:[object getLong:@"tel_notic"] forKey:@"myTelRemindInt"];
    }
}

//整理设置数据
-(NSString *)getWeekStr:(NSString *)weekStr{
    
    NSArray *week=[weekStr componentsSeparatedByString: @","];
    NSString *str=@"";
    int counts=0;
    for (int i=0; i<week.count; i++) {
        if([week[i] intValue]==1)
        {
            counts++;
            if ([str isEqualToString:@""]) {
                str=[NSString stringWithFormat:@"%@",[self stringWith:i]];
                
            }
            else{
                str=[NSString stringWithFormat:@"%@,%@",str,[self stringWith:i]];
            }
        }
    }
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
            weekStr=SmaLocalizedString(@"clockadd_friday");
            break;
        case 5:
            weekStr= SmaLocalizedString(@"clockadd_saturday");
            break;
        default:
            weekStr= SmaLocalizedString(@"clockadd_sunday");
    }
    return weekStr;
}

- (NSString *)setStringWith:(NSString *)WeekStr{
    NSArray *week=[WeekStr componentsSeparatedByString: @","];
    NSString *str = @"";
    NSMutableArray *WeekArr = [[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    for (int i = 0; i<week.count; i++) {
        WeekArr = [self createWeekWith:week[i] WeekArr:WeekArr];
    }
    for (int i = 0; i<7; i++) {
        if ([str isEqualToString:@""]) {
            str=[NSString stringWithFormat:@"%@",WeekArr[i]];
            
        }
        else{
            str=[NSString stringWithFormat:@"%@,%@",str,WeekArr[i]];
        }
        
    }
    
    return str;
}

- (NSMutableArray *)createWeekWith:(NSString *)week WeekArr:(NSMutableArray *)array{
    NSMutableArray *arr = array;
    if ([week isEqualToString:SmaLocalizedString(@"clockadd_monday")]) {
        [arr replaceObjectAtIndex:0 withObject:@"1"];
    }
    else if ([week isEqualToString:SmaLocalizedString(@"clockadd_tuesday")]){
        [arr replaceObjectAtIndex:1 withObject:@"1"];
    }
    else if ([week isEqualToString:SmaLocalizedString(@"clockadd_wednesday")]){
        [arr replaceObjectAtIndex:2 withObject:@"1"];
    }
    else if ([week isEqualToString:SmaLocalizedString(@"clockadd_thursday")]){
        [arr replaceObjectAtIndex:3 withObject:@"1"];
    }
    else if ([week isEqualToString:SmaLocalizedString(@"clockadd_friday")]){
        [arr replaceObjectAtIndex:4 withObject:@"1"];
    }
    else if ([week isEqualToString:SmaLocalizedString(@"clockadd_saturday")]){
        [arr replaceObjectAtIndex:5 withObject:@"1"];
    }
    else if ([week isEqualToString:SmaLocalizedString(@"clockadd_sunday")]){
        [arr replaceObjectAtIndex:6 withObject:@"1"];
    }
    return arr;
}


@end
