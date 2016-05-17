//
//  SmaDataDAL.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/4/17.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaDataDAL.h"
#import "FMDB.h"
#import "SmaSleepInfo.h"
#import "SmaSleepPackageInfo.h"
#import "SmaSportInfo.h"
#import "SmaSportResultInfo.h"
#import "SmaAlarmInfo.h"

@interface SmaDataDAL()
@property (nonatomic, strong) FMDatabaseQueue *queue;
@end

@implementation SmaDataDAL

-(FMDatabaseQueue *)createDataBase
{
    
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"smawatch.sqlite"];
//    if ([SmaUserDefaults integerForKey:@"updateSql"] != SPLITEVERSION) {
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager removeItemAtPath:filename error:nil];
//        
//    }
//    MyLog(@"filenamefilename==%@",filename);
    // 1.创建数据库队列
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filename];
    
    // 2.创表
    if(!_queue)
    {
        [queue inDatabase:^(FMDatabase *db) {
//            if ([SmaUserDefaults integerForKey:@"updateSql"] != SPLITEVERSION) {
//                BOOL updateSpl = [db executeUpdate:@"ALTER TABLE tb_sleep  ADD softly_action varchar(15)"];
//                updateSpl = [db executeUpdate:@"ALTER TABLE tb_sleep  ADD strong_action varchar(15) "];
//                NSLog( @"增加字段 %d",updateSpl);
//            }
            
            //睡眠数据  slelp_type  0 睡眠数据   1 睡眠设定数据  sleep_mode 睡眠模式
            BOOL result = [db executeUpdate:@"create table if not exists tb_sleep (_id integer primary key autoincrement, sleep_id integer,user_id integer,sleep_data integer,sleep_time integer,sleep_mode integer,sleep_type integer,sleep_waer integer,sleep_web integer);"];
            
            //运动
            result = [db executeUpdate:@"create table if not exists tb_sport (_id integer primary key autoincrement, sport_id integer, user_id integer,sport_data integer, sport_time integer,sport_step integer,sport_activetime integer,sport_calory REAL,sport_distance REAL,sport_web integer);"];
            
            //闹钟
            result = [db executeUpdate:@"create table if not exists tb_clock (clock_id integer primary key autoincrement,user_id text,dayFlags text, aid text,minute text,hour text,day text,mounth text,year text,isopen integer,tagname text,clock_web integer);"];
            
            
            if (result) {
                NSLog(@"创表成功");
            } else {
                NSLog(@"创表失败");
            }
            if ([SmaUserDefaults integerForKey:@"updateSql"] != SPLITEVERSION) {
                BOOL updateSpl = [db executeUpdate:@"ALTER TABLE tb_sleep  ADD softly_action varchar(15)"];
                updateSpl = [db executeUpdate:@"ALTER TABLE tb_sleep  ADD strong_action varchar(15) "];
                NSLog( @"增加字段 %d",updateSpl);
            }
             [SmaUserDefaults setInteger:SPLITEVERSION forKey:@"updateSql"];
        }];
    }
    
    return queue;
}

//懒加载
-(FMDatabaseQueue *)queue
{
    if(!_queue)
    {
        _queue= [self createDataBase];
    }
    return _queue;
}

//插入睡眠数据
-(void)insertSleepInfo:(NSMutableArray *)infos
{
    @try {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            
            [self.queue inDatabase:^(FMDatabase *db) {
                [db beginTransaction];
                for (int i=0; i<infos.count; i++) {
                    SmaSleepInfo *info=(SmaSleepInfo *)infos[i];
                    [db executeUpdate:@"delete from tb_sleep where sleep_id=?;",info.sleep_id];
                    //NSLog(@"%@----------------------%@------------------%@",info.sleep_time,info.sleep_mode,info.sleep_type);
                    //MyLog(@"日前：%d",[info.sleep_data intValue]);
                    BOOL result=  [db executeUpdate:@"INSERT INTO tb_sleep (sleep_id,user_id,sleep_data,sleep_time,sleep_mode,sleep_type,sleep_waer,sleep_web,softly_action,strong_action) VALUES (?,?,?,?,?,?,?,?,?,?);",info.sleep_id,info.user_id,info.sleep_data,info.sleep_time,info.sleep_mode,info.sleep_type,info.sleep_wear,info.sleep_web,info.sleep_softly,info.sleep_strong];
                    MyLog(@"插入睡眠数据成功 %d",result);
                }
                [db commit];
                
            }];
        }];
    }
    @catch (NSException *exception) {
        MyLog(@"插入睡眠数据失败-------%@",exception);
    }
}
//更新睡眠数据
- (void)updateSleepInfo:(NSMutableArray *)infos{
    @try {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            [self.queue inDatabase:^(FMDatabase *db) {
                [db beginTransaction];
                //                SmaAlarmInfo *info=clockInfo;
                for (int i=0; i<infos.count; i++) {
                    SmaSleepInfo *info=(SmaSleepInfo *)infos[i];
                    NSString *updatesql=[NSString stringWithFormat:@"update tb_sleep set user_id='%@',sleep_data='%@',sleep_time='%@',sleep_mode='%@',sleep_type='%@',sleep_waer='%@',sleep_web='%@';",info.user_id,info.sleep_data,info.sleep_time,info.sleep_mode,info.sleep_type,info.sleep_wear,info.sleep_web];
                    
                    [db executeUpdate:updatesql];
                }
                MyLog(@"修改成功");
                [db commit];
            }];
        }];
    }
    @catch (NSException *exception) {
        MyLog(@"修改睡眠失败%@",exception);
    }
}

//获取睡眠数据
-(SmaSleepPackageInfo *)getSleepData
{
    SmaSleepPackageInfo *sleepInfo=[[SmaSleepPackageInfo alloc]init];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        // 1.查询数据
        FMResultSet *rs = [db executeQuery:@"select * from tb_sleep where sleep_data>=20150521;"];
        // where sleep_data>?@20150414
        
        // 2.遍历结果集
        while (rs.next) {
            
            NSString *sleep_type =[rs stringForColumn:@"sleep_type"];
            NSString *data =[rs stringForColumn:@"sleep_data"];
            NSString *minutes =[rs stringForColumn:@"sleep_time"];
            NSString *mode = [rs stringForColumn:@"sleep_mode"];
            
            NSLog(@"日期: %@ －－－时间点:%@－－－数据类型：%@－－－睡眠模式: %@",data, minutes,sleep_type,mode);
        }
    }];
    return sleepInfo;
}
//插入运动数据
-(void)insertSmaSport:(NSMutableArray *)infos
{
    
    @try {
        
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            [self.queue inDatabase:^(FMDatabase *db) {
                [db beginTransaction];
                for (int i=0; i<infos.count; i++) {
                    SmaSportInfo *info=(SmaSportInfo *)infos[i];
                    NSString *sportID;
                    FMResultSet *rs = [db executeQuery:@"select * from tb_sport where sport_data=? and sport_time=? and user_id=?;",info.sport_data,info.sport_time,info.user_id];//?data
                    while (rs.next) {
                        sportID= [rs stringForColumn:@"sport_id"];
                    }
                    if (sportID && ![sportID isEqualToString:@""]) {
                        NSString *updatesql=[NSString stringWithFormat:@"update tb_sport set user_id='%@',sport_data='%@',sport_time='%@',sport_step='%@',sport_activetime='%@',sport_calory='%@',sport_distance='%@',sport_web='%@' where sport_data='%@' and sport_time='%@' and user_id='%@';",info.user_id,info.sport_data,info.sport_time,info.sport_step,info.sport_activetime,info.sport_calory,info.sport_distance,info.sport_web,info.sport_data,info.sport_time,info.user_id];
                        
                        BOOL result=  [db executeUpdate:updatesql];
                        MyLog(@"修改运动数据成功 %d",result);
                    }
                    else{
                        //                    [db executeUpdate:@"delete from tb_sport where sport_data=? and sport_time=?;",info.sport_data,info.sport_time];
                        NSString *updatesql=[NSString stringWithFormat:@"INSERT INTO tb_sport (sport_id,user_id,sport_data,sport_time,sport_step,sport_activetime,sport_calory,sport_distance,sport_web) VALUES (%@,%@,%@,%@,%@,%@,%@,%@,%@);",info.sport_id,info.user_id,info.sport_data,info.sport_time,info.sport_step,info.sport_activetime,info.sport_calory,info.sport_distance,info.sport_web];
                        NSLog(@"updatesql--%@",updatesql);
                        BOOL result= [db executeUpdate:updatesql];
                        MyLog(@"插入运动成功  %d",result);
                    }
                }
                
                [db commit];
                
            }];
        }];
        
        
    }
    @catch (NSException *exception) {
        MyLog(@"插入运动失败%@",exception);
    }
}

- (NSString *)selectSportDataWithDate:(NSString *)date Time:(NSString *)time{
    __block NSString *sportID;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        [self.queue inDatabase:^(FMDatabase *db) {
        }];
    }];
    return sportID;
}

//更新活动数据
- (void)updateSportInfo:(NSMutableArray *)infos{
    @try {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            [self.queue inDatabase:^(FMDatabase *db) {
                [db beginTransaction];
                //                SmaAlarmInfo *info=clockInfo;
                for (int i=0; i<infos.count; i++) {
                    SmaSportInfo *info=(SmaSportInfo *)infos[i];
                    NSString *updatesql=[NSString stringWithFormat:@"update tb_sport set user_id='%@',sport_data='%@',sport_time='%@',sport_step='%@',sport_activetime='%@',sport_calory='%@',sport_distance='%@',sport_web='%@';",info.user_id,info.sport_data,info.sport_time,info.sport_step,info.sport_activetime,info.sport_calory,info.sport_distance,info.sport_web];
                    
                    BOOL result=  [db executeUpdate:updatesql];
                    MyLog(@"修改运动数据成功 %d",result);
                }
                [db commit];
            }];
        }];
    }
    @catch (NSException *exception) {
        MyLog(@"修改睡眠失败%@",exception);
    }
}

//获取运动数据
-(SmaSportResultInfo *)getSmaSport:(NSNumber *)data
{
    MyLog(@"——————————sport   %d  %@",[data intValue],[SmaAccountTool userInfo].userId);
    
    SmaSportResultInfo *info=[[SmaSportResultInfo alloc]init];
    @try {
        [self.queue inDatabase:^(FMDatabase *db) {
            
            
            FMResultSet *rs = [db executeQuery:@"select sum(sport_step) as sumStep,sum(sport_calory) as sumCalory ,sum(sport_distance) as sumDistance from tb_sport where sport_data=? and user_id=?;",data,[SmaAccountTool userInfo].userId];//?data
            while (rs.next) {
                NSString *sumStep =[rs stringForColumn:@"sumStep"];
                NSString *sumCalory =[rs stringForColumn:@"sumCalory"];
                NSString *sumDistance = [rs stringForColumn:@"sumDistance"];
                
                info.sumCalory=sumCalory;
                info.sumStep=sumStep;
                info.sumDistance=sumDistance;
                
            }
        }];
        return  info;
    }
    @catch (NSException *exception) {
        return  info;
    }
}

//获取详细运动数据
- (NSMutableArray *)getMinuteSport:(NSString *)userID{
    NSMutableArray *arr = [NSMutableArray array];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyyMMdd"];
    @try {
        [self.queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"select * from tb_sport where sport_web=0 and user_id=?",userID];//?data
            while (rs.next) {
                NSMutableDictionary *sportDict = [NSMutableDictionary dictionary];
                [sportDict setObject:[rs stringForColumn:@"user_id"]?[rs stringForColumn:@"user_id"]:@"" forKey:@"user_account"];
                [sportDict setObject:[rs stringForColumn:@"sport_id"]?[NSNumber numberWithLongLong:[rs stringForColumn:@"sport_id"].longLongValue]:[NSNumber numberWithLongLong:@"".longLongValue] forKey:@"sport_id"];
                [sportDict setObject:[rs stringForColumn:@"sport_step"]?[NSNumber numberWithInteger:[rs stringForColumn:@"sport_step"].integerValue]:[NSNumber numberWithInteger:@"".integerValue] forKey:@"steps"];
                [sportDict setObject:[rs stringForColumn:@"sport_time"]?[NSNumber numberWithInteger:[rs stringForColumn:@"sport_time"].integerValue]:[NSNumber numberWithInteger:@"".integerValue] forKey:@"offset"];
                [sportDict setObject:[rs stringForColumn:@"sport_calory"]?[NSNumber numberWithFloat:[rs stringForColumn:@"sport_calory"].floatValue]:[NSNumber numberWithFloat:@"".floatValue] forKey:@"calorie"];
                [sportDict setObject:[rs stringForColumn:@"sport_distance"]?[NSNumber numberWithFloat:[rs stringForColumn:@"sport_distance"].floatValue]:[NSNumber numberWithFloat:@"".floatValue] forKey:@"distance"];
                [sportDict setObject:[formatter1 stringFromDate:[formatter dateFromString:[rs stringForColumn:@"sport_data"]]]?[formatter1 stringFromDate:[formatter dateFromString:[rs stringForColumn:@"sport_data"]]]:@"" forKey:@"count_date"];
                [arr addObject:sportDict];
            }
        }];
        return  arr;
    }
    @catch (NSException *exception) {
        return  arr;
    }
    
}

//获取详细睡眠数据
- (NSMutableArray *)getMinuteSleep:(NSString *)userID{
    NSMutableArray *arr = [NSMutableArray array];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyyMMddHHmmss"];
    @try {
        [self.queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"select * from tb_sleep where sleep_web=0 and user_id=?",userID];//?data
            while (rs.next) {
                NSMutableDictionary *sleepDict = [NSMutableDictionary dictionary];
                [sleepDict setObject:[rs stringForColumn:@"user_id"]?[rs stringForColumn:@"user_id"]:@"" forKey:@"user_account"];
                [sleepDict setObject:[rs stringForColumn:@"sleep_id"]?[NSNumber numberWithLongLong:[rs stringForColumn:@"sleep_id"].longLongValue]:[NSNumber numberWithLongLong:@"".longLongValue] forKey:@"sleep_id"];
                [sleepDict setObject:[rs stringForColumn:@"sleep_time"]?[NSNumber numberWithInteger:[rs stringForColumn:@"sleep_time"].integerValue]:[NSNumber numberWithInteger:@"".integerValue] forKey:@"action_time"];
                [sleepDict setObject:[formatter1 stringFromDate:[formatter dateFromString:[rs stringForColumn:@"sleep_data"]]]?[formatter1 stringFromDate:[formatter dateFromString:[rs stringForColumn:@"sleep_data"]]]:@"" forKey:@"sleep_date"];
                [sleepDict setObject:[rs stringForColumn:@"sleep_type"]?[NSNumber numberWithInteger:[rs stringForColumn:@"sleep_type"].integerValue]:[NSNumber numberWithInteger:@"".integerValue] forKey:@"sleep_type"];
                [sleepDict setObject:[rs stringForColumn:@"sleep_mode"]?[NSNumber numberWithInteger:[rs stringForColumn:@"sleep_mode"].integerValue]:[NSNumber numberWithInteger:@"".integerValue] forKey:@"time_type"];
                
                [arr addObject:sleepDict];
            }
        }];
        return  arr;
    }
    @catch (NSException *exception) {
        return  arr;
    }
    
}
/**
 *  <#Description#>
 *  @param typeInt 统计类型 0 按天，1 按周，2 按月
 *  @return 返回统计结果，以及返回统计图结果
 */
-(NSMutableArray *)getSportCount:(int)typeInt
{
    NSDate *senddate=[NSDate date];
    int typeValue=0;
    if(typeInt==0)
        typeValue=0;
    else if(typeInt==1)
        typeValue=7;
    else if(typeInt==2)
        typeValue=10;
    
    
    NSDate *nextDate = [NSDate dateWithTimeInterval:(-(24*60*60)*(typeValue)) sinceDate:senddate];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMdd"];
    NSString *locationString=[dateformatter stringFromDate:nextDate];
    int today=[locationString intValue];
    
    
    NSMutableArray *nsMutable=[NSMutableArray array];
    NSNumber *myNumber = [NSNumber numberWithInt:today];
    @try {
        [self.queue inDatabase:^(FMDatabase *db) {
            //            [db beginDeferredTransaction];
            //图表统计
            FMResultSet *rsChart =nil;
            if(typeInt==0)
            {
                MyLog(@"是这里");
                rsChart = [db executeQuery:@"select (timeSegment*2) as timeSegment,sumStep from (select ((sport_time+7)/8) timeSegment,sum(sport_step) as sumStep from tb_sport where sport_data=? and user_id=? group by ((sport_time+7)/8) ) as a order by timeSegment desc;",myNumber,[SmaAccountTool userInfo].userId];
                
            }else if(typeInt==1)
            {
                rsChart = [db executeQuery:@"select sport_data timeSegment,sum(sport_step) as sumStep from tb_sport where sport_data>=? and user_id=? group by sport_data;",myNumber,[SmaAccountTool userInfo].userId];
                
            }else
            {
                rsChart = [db executeQuery:@"select sport_data timeSegment,sum(sport_step) as sumStep from tb_sport where sport_data>=? and user_id=? group by sport_data;",myNumber,[SmaAccountTool userInfo].userId];
            }
            //            [db commit];
            NSMutableDictionary *dict=[NSMutableDictionary dictionary];
            while (rsChart.next) {
                NSString *key =@"";
                if(typeInt==0)
                {
                    key =[rsChart stringForColumn:@"timeSegment"];
                    
                }else{
                    NSString *dateStr = [rsChart stringForColumn:@"timeSegment"];
                    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
                    [dtF setDateFormat:@"yyyyMMdd"];
                    NSDate *d = [dtF dateFromString:dateStr];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"MM-dd"];
                    key = [dateFormat stringFromDate:d];
                }
                NSString *sumStep =[NSString stringWithFormat:@"%@",[rsChart stringForColumn:@"sumStep"]];
                [dict setObject:key forKey:sumStep];
                
            }
            [nsMutable addObject:dict];
            //统计
            
            FMResultSet *rs=[db executeQuery:@"select sum(sport_step) as sumStep,sum(sport_calory) as sumCalory ,sum(sport_distance) as sumDistance from tb_sport  where sport_data>=? and user_id=?;",myNumber,[SmaAccountTool userInfo].userId];
            
            SmaSportResultInfo *info=[[SmaSportResultInfo alloc]init];
            while (rs.next) {
                NSString *sumStep =[rs stringForColumn:@"sumStep"];
                NSString *sumCalory =[rs stringForColumn:@"sumCalory"];
                NSString *sumDistance = [rs stringForColumn:@"sumDistance"];
                
                info.sumCalory=sumCalory;
                info.sumStep=sumStep;
                info.sumDistance=sumDistance;
            }
            [nsMutable addObject:info];
            //            [db commit];
        }];
        return  nsMutable;
    }
    @catch (NSException *exception) {
        return  nsMutable;
    }
    @finally {
        return  nsMutable;
    }
}

- (void)updateSleepData:(NSNumber *)today yestday:(NSNumber *)yestday iswear:(BOOL)wear{
    SmaSleepInfo * info = [self readSleepWear:today yestday:yestday];
    //    FMDatabase/
    @try {
        if (info.sleep_wear ) {
            [self.queue inDatabase:^(FMDatabase *db) {
                
                [db beginTransaction];
                BOOL result= [db executeUpdate:@"update tb_sleep set sleep_waer=? where sleep_id=?;",[NSNumber numberWithInt:wear],info.sleep_id];
                [db commit];
                MyLog(@"更新睡眠数据成功====%d",result);
                //                [db close];
            }];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"更新失败");
    }
    
}
- (SmaSleepInfo *)readSleepWear:(NSNumber *)today yestday:(NSNumber *)yestday
{
    SmaSleepInfo *info=[[SmaSleepInfo alloc]init];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsBegin=[db executeQuery:@"select user_id,sleep_data,sleep_time,sleep_mode,sleep_type,sleep_waer,sleep_id,sleep_web,(case sleep_data when ? then sleep_time+1440 else sleep_time END) as sleep_time from tb_sleep where user_id=? and sleep_mode=1 and sleep_type=1 and ((sleep_data=? and sleep_time>1320) or (sleep_data=? and sleep_time<=360)) order by sleep_data ,sleep_time ASC limit 1;",today,[SmaAccountTool userInfo].userId,yestday,today];
        
        while (rsBegin.next) {
            info.sleep_data=[NSNumber numberWithFloat:[[rsBegin stringForColumn:@"sleep_data"] floatValue]];
            info.sleep_time=[rsBegin stringForColumn:@"sleep_time"];
            info.sleep_type=[NSNumber numberWithFloat:[[rsBegin stringForColumn:@"sleep_type"] floatValue]];
            info.sleep_mode=[NSNumber numberWithFloat:[[rsBegin stringForColumn:@"sleep_mode"] floatValue]];
            info.sleep_wear=[NSNumber numberWithFloat:[[rsBegin stringForColumn:@"sleep_waer"] floatValue]];
            info.sleep_id = [rsBegin stringForColumn:@"sleep_id"];
            info.sleep_web = [NSNumber numberWithFloat:[[rsBegin stringForColumn:@"sleep_web"] floatValue]];
            NSLog(@"===%@",[rsBegin stringForColumn:@"sleep_waer"]);
            [SmaAccountTool saveSleep:info];
        }
        //        [db close];
    }];
    
    return info;
}
//获取一天的数据睡眠数据   0 0 进入睡眠，1 退出睡眠
-(NSMutableDictionary *)getSleepDataDay:(NSNumber *)today yestday:(NSNumber *)yestday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString *selfStr = [fmt stringFromDate:[NSDate date]];
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    //    [self getSleepData];
    NSMutableArray *arr=[NSMutableArray array];
    NSMutableArray *sleepArrs = [NSMutableArray array];
    
    @try {
        
        [self.queue inDatabase:^(FMDatabase *db) {
            NSNumber *isHistory = @0;
            SmaSleepInfo *info=[[SmaSleepInfo alloc]init];
            NSNumber *beginWaer=@1;
            if (today.intValue == selfStr.intValue) {
                beginWaer = @1;
            }
            else{
                FMResultSet *rsBeginWaer=[db executeQuery:@"select user_id,sleep_data,sleep_time,sleep_mode,sleep_type,sleep_web,(case sleep_data when ? then sleep_time+1440 else sleep_time END) as sleep_time from tb_sleep where user_id=? and sleep_mode=1 and sleep_type=1 and sleep_waer=0 and ((sleep_data=? and sleep_time>1320) or (sleep_data=? and sleep_time<=360)) order by sleep_data ,sleep_time ASC limit 1;",today,[SmaAccountTool userInfo].userId,yestday,today];
                //            FMResultSet *rsBegin = [db executeQuery:@"select *from tb_sleep where (sleep_data=? or sleep_data=?) and sleep_type=1 and sleep_mode=1 order by sleep_data ,sleep_time desc limit 1;",today,yestday];
                while (rsBeginWaer.next) {
                    beginWaer=[NSNumber numberWithFloat:[[rsBeginWaer stringForColumn:@"sleep_waer"] floatValue]] ;
                    NSLog(@"beginWaer  %@  today ===%@  yestady ==%@  begin==%@   stypetime===%@",[rsBeginWaer stringForColumn:@"sleep_data"],today,yestday,beginWaer,[rsBeginWaer stringForColumn:@"sleep_time"]);
                    info.sleep_data =[NSNumber numberWithInt:[rsBeginWaer stringForColumn:@"sleep_data"].intValue];
                    info.sleep_mode =[NSNumber numberWithInt:[rsBeginWaer stringForColumn:@"sleep_mode"].intValue];
                    info.sleep_time =[rsBeginWaer stringForColumn:@"sleep_time"];
                    info.user_id =[rsBeginWaer stringForColumn:@"user_id"];
                    info.sleep_type =[NSNumber numberWithInt:[rsBeginWaer stringForColumn:@"sleep_type"].intValue];
                    info.sleep_wear =[NSNumber numberWithInt:[rsBeginWaer stringForColumn:@"sleep_waer"].intValue];
                    info.sleep_web = [NSNumber numberWithFloat:[[rsBeginWaer stringForColumn:@"sleep_web"] floatValue]];
                    [SmaUserDefaults setInteger:beginWaer.intValue forKey:@"sleep_waer"];
                }
            }
            if (beginWaer.intValue == 1) {
                [SmaUserDefaults setInteger:beginWaer.intValue forKey:@"sleep_waer"];
                NSNumber *begin=@0;
                
                //如果睡眠数据大于2760，导致搜索的昨天或之前没有睡眠数据
                FMResultSet *sleepMax = [db executeQuery:@"select *from tb_sleep where sleep_time>2760 and sleep_type=1 sleep_id=?;",[SmaAccountTool userInfo].userId];
                while (sleepMax.next) {
                    NSArray *arr = [NSArray arrayWithObjects:[sleepMax stringForColumn:@"sleep_data"],[sleepMax stringForColumn:@"sleep_time"],[sleepMax stringForColumn:@"sleep_mode"],[sleepMax stringForColumn:@"sleep_type"], nil];
                    [sleepArrs addObject:arr];
                    
                }
                //对比是否昨天开始睡眠数据
                NSLog(@"11111===%lu",(unsigned long)sleepArrs.count);
                for (int i = 0;i<sleepArrs.count; i++) {
                    if ([[[sleepArrs objectAtIndex:i] objectAtIndex:2] isEqualToString:@"1"] && [[[sleepArrs objectAtIndex:i] objectAtIndex:3] isEqualToString:@"1"]) {
                        //睡眠时间
                        NSString *sleep_time = (NSString *)[[sleepArrs objectAtIndex:i] objectAtIndex:1];
                        //睡眠日期
                        NSString *sleep_data = (NSString *)[[sleepArrs objectAtIndex:i] objectAtIndex:0];
                        NSDate *Date = [fmt dateFromString:sleep_data];
                        int yeDate = [fmt stringFromDate:[NSDate dateWithTimeInterval:24 * 60 * 60 * (sleep_time.intValue/1440) sinceDate:Date]].intValue;
                        if (yeDate == yestday.intValue) {
                            begin = [NSNumber numberWithInt:sleep_time.intValue-(sleep_time.intValue/1440)*1440];
                            isHistory = @1;
                            //                            begin = [NSNumber numberWithInt:sleep_time.intValue];
                            NSLog(@"起床时间—-1————%@",begin);
                            break;
                        }
                    }
                }
                
                FMResultSet *rsBegin=[db executeQuery:@"select user_id,sleep_data,sleep_time,sleep_mode,sleep_type,sleep_waer,(case sleep_data when ? then sleep_time+1440 else sleep_time END) as sleep_time from tb_sleep where user_id=? and sleep_mode=1 and sleep_type=1 and ((sleep_data=? and sleep_time>1320) or (sleep_data=? and sleep_time<=360)) order by sleep_data ,sleep_time ASC limit 1;",today,[SmaAccountTool userInfo].userId,yestday,today];
                //            FMResultSet *rsBegin = [db executeQuery:@"select *from tb_sleep where (sleep_data=? or sleep_data=?) and sleep_type=1 and sleep_mode=1 order by sleep_data ,sleep_time desc limit 1;",today,yestday];
                while (rsBegin.next) {
                    begin=[NSNumber numberWithFloat:[[rsBegin stringForColumn:@"sleep_time"] floatValue]] ;
                    NSLog(@"起床时间—-2————%@  %@",begin,[rsBegin stringForColumn:@"sleep_time"]);
                }
                //查询
                NSNumber *end=@0;
                //对比是否昨天结束睡眠数据
                for (int i = 0;i<sleepArrs.count; i++) {
                    if ([[[sleepArrs objectAtIndex:i] objectAtIndex:2] isEqualToString:@"0"] && [[[sleepArrs objectAtIndex:i] objectAtIndex:3] isEqualToString:@"1"]) {
                        //睡眠结束时间
                        NSString *sleep_time = (NSString *)[[sleepArrs objectAtIndex:i] objectAtIndex:1];
                        //睡眠结束日期
                        NSString *sleep_data = (NSString *)[[sleepArrs objectAtIndex:i] objectAtIndex:0];
                        NSDate *Date = [fmt dateFromString:sleep_data];
                        int yeDate = [fmt stringFromDate:[NSDate dateWithTimeInterval:24 * 60 * 60 * (sleep_time.intValue/1440) sinceDate:Date]].intValue;
                        if (yeDate == today.intValue) {
                            end = [NSNumber numberWithInt:sleep_time.intValue-(sleep_time.intValue/1440)*1440];
                            //                            end = [NSNumber numberWithInt:sleep_time.intValue];
                            break;
                        }
                    }
                }
                
                //查询5点钟以后的
                FMResultSet *rsEnd=[db executeQuery:@"select * from (select sleep_data,(case sleep_data when ? then sleep_time+1440 else sleep_time END) as sleep_time from tb_sleep where user_id=? and sleep_mode=0 and sleep_type=1 and (sleep_data=? or sleep_data=?)) as a where  sleep_time>=? and sleep_time<=? order by sleep_data,sleep_time desc limit 3; ",today,[SmaAccountTool userInfo].userId,yestday,today,@1800,@2520];
                
                while (rsEnd.next) {
                    end=[NSNumber numberWithFloat:[[rsEnd stringForColumn:@"sleep_time"] floatValue]] ;
                    MyLog(@"起来时间－－1：%d  %@",[end intValue],[rsEnd stringForColumn:@"sleep_data"]);
                }
                
                //查询5点钟以前的
                if([end intValue]==0)
                {
                    FMResultSet *rsEnd=[db executeQuery:@"select * from (select sleep_data,(case sleep_data when ? then sleep_time+1440 else sleep_time END) as sleep_time from tb_sleep where user_id=? and sleep_mode=0 and sleep_type=1 and (sleep_data=? or sleep_data=?)) as a where  sleep_time>=? and sleep_time<=? order by sleep_data,sleep_time desc limit 1; ",today,[SmaAccountTool userInfo].userId,yestday,today,@1320,@1800];
                    
                    while (rsEnd.next) {
                        end=[NSNumber numberWithFloat:[[rsEnd stringForColumn:@"sleep_time"] floatValue]] ;
                        MyLog(@"起来时间－－2：%d",[end intValue]);
                    }
                    //                    if ([end intValue]==0) {
                    //
                    //                        return ;
                    //                    }
                    //                    if ([end intValue] == 0 && [begin intValue] > 0) {
                    //
                    //                        //                FMResultSet *rsEnd1=[db executeQuery:@"select * from (select sleep_data,(case sleep_data when ? then sleep_time+1440 else sleep_time END) as sleep_time from tb_sleep where sleep_type=0 and sleep_data=?) order by sleep_time desc limit 1; ",today,today,today];
                    //
                    //                        FMResultSet *rsEnd1 = [db executeQuery:@"select * from tb_sleep where sleep_data=? and sleep_type=0 order by sleep_time desc limit 1;",today];
                    //                        while (rsEnd1.next) {
                    //                            end=[NSNumber numberWithFloat:[[rsEnd1 stringForColumn:@"sleep_time"] floatValue] + 1440] ;
                    //                            MyLog(@"起来时间－－3：%d  %@",[end intValue],today );
                    //                        }
                    //                        if ([end intValue] == 0) {
                    //                            FMResultSet *rsEnd2 = [db executeQuery:@"select *from tb_sleep where sleep_data=? and sleep_type=0 and sleep_time>=? order by sleep_time desc limit 1;",yestday,begin];
                    //                            while (rsEnd2.next) {
                    //                                end=[NSNumber numberWithFloat:[[rsEnd2 stringForColumn:@"sleep_time"] floatValue]] ;
                    //                                MyLog(@"起来时间－－4：%d  %@",[end intValue],today );
                    //                            }
                    //
                    //                        }
                    //                    }
                    if([end intValue]==0)
                    {
                        if([begin intValue]>0)
                        {
                            [dict setObject:begin forKey:@"begin"];
                            int beginInt=540;
                            end=[NSNumber numberWithInt:beginInt];
                            [dict setObject:[NSNumber numberWithInt:beginInt]  forKey:@"end"];
                            
                        }else
                        {
                            [dict setObject:@0 forKey:@"begin"];
                            [dict setObject:@0 forKey:@"end"];
                        }
                    }else
                    {
                        [dict setObject:end forKey:@"end"];
                        if([begin intValue]==0)
                        {
                            [dict setObject:@1320 forKey:@"begin"];
                            begin=@1320;
                        }else
                        {
                            [dict setObject:begin forKey:@"begin"];
                        }
                    }
                }
                else
                {
                    
                    if([begin intValue]>0)
                    {
                        if (begin.floatValue > 2880) {
                            //                            begin = @1320;
                            int floa = begin.intValue - 1440*(begin.intValue/1440);
                            NSLog(@"21212===%d  %d",floa,(begin.intValue/1440));
                            begin = [NSNumber numberWithInt:floa];
                        }
                        [dict setObject:begin forKey:@"begin"];
                    }else
                    {
                        begin=@1320;
                        [dict setObject:@1320 forKey:@"begin"];
                    }
                    
                    [dict setObject:end forKey:@"end"];
                }
                
                MyLog(@"入睡时间：%@-------退出睡眠时间：%@",begin,end);
                FMResultSet *rs=[db executeQuery:@"select * from (select user_id,sleep_data,sleep_mode,sleep_type,softly_action,strong_action,(case sleep_data when (?) then sleep_time+1440 else sleep_time END) as sleep_time from tb_sleep where sleep_type=0 and user_id=?) as a where  (a.sleep_data=(?) or a.sleep_data=(?))  and (a.sleep_time>=(?) and a.sleep_time<=(?)) order by a.sleep_data,a.sleep_time; ",today,[SmaAccountTool userInfo].userId,today,yestday,begin,end];
                //                            FMResultSet *rs = [db executeQuery:@"select sleep_data,sleep_time from tb_sleep where sleep_time>=\'%@\' and sleep_time<=\'%@\' order by sleep_time",/*today,yestday,*/begin,end];
                //            FMResultSet *rs = [db executeQuery:@"select *from tb_sleep where (sleep_data=? or sleep_data=?) and sleep_time>=? and sleep_time<=? order by sleep_data",today,yestday,begin,end];
                while (rs.next) {
                    SmaSleepInfo *info=[[SmaSleepInfo alloc]init];
                    
                    info.sleep_data=[rs stringForColumn:@"sleep_data"];
                    info.sleep_time=[rs stringForColumn:@"sleep_time"];
                     float sleep_type;
                    if ([[rs stringForColumn:@"sleep_mode"] floatValue]==1) {
                        if ([[rs stringForColumn:@"strong_action"] floatValue]>2) {
                            sleep_type  = 3;
                        }
                        else{
                            if ([[rs stringForColumn:@"softly_action"] floatValue]>3) {
                                sleep_type = 2;
                            }
                            else{
                                sleep_type = 1;
                            }
                        }
                        info.sleep_type=[NSNumber numberWithFloat:sleep_type];
                    }
                    else{
                    info.sleep_type=[NSNumber numberWithFloat:[[rs stringForColumn:@"sleep_mode"] floatValue]];
                    }
                    [arr addObject:info];
                    
                }
                //                if (arr.count<1) {
                //                    if ([end intValue] > 600 && isHistory.intValue == 1) {
                //                        end = @600;
                //                    }
                //                }
                
                [dict setObject:arr forKey:@"entitys"];
                NSLog(@"DICT ===%@",dict);
            }
        }];
        
    }
    @catch (NSException *exception) {
        return dict;
    }
    @finally {
        return dict;
    }
    return dict;
}


//获取闹钟列表
-(NSMutableArray *)selectClockList
{
    SmaUserInfo *info=[SmaAccountTool userInfo];
    NSMutableArray *arr=[NSMutableArray array];
    NSString *sql=[NSString stringWithFormat:@"select * from tb_clock where user_id=%@",info.userId];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        
        while (rs.next) {
            SmaAlarmInfo *info=[[SmaAlarmInfo alloc]init];
            info.clockid=[rs stringForColumn:@"clock_id"];
            info.aid=[rs stringForColumn:@"aid"];
            info.dayFlags=[rs stringForColumn:@"dayFlags"];
            info.minute=[rs stringForColumn:@"minute"];
            info.hour=[rs stringForColumn:@"hour"];
            info.mounth=[rs stringForColumn:@"mounth"];
            info.day=[rs stringForColumn:@"day"];
            info.year=[rs stringForColumn:@"year"];
            info.userId = [rs stringForColumn:@"user_id"];
            info.tagname=[rs stringForColumn:@"tagname"];
            info.isopen=[rs stringForColumn:@"isopen"];
            
            [arr addObject:info];
        }
    }];
    return arr;
}

//获取闹钟上传服务器列表
-(NSMutableArray *)selectWebClockList:(NSString *)userID
{
    SmaUserInfo *info=[SmaAccountTool userInfo];
    //    ACObject *arr=[[ACObject alloc] init];
    NSMutableArray *arr=[NSMutableArray array];
    NSString *sql=[NSString stringWithFormat:@"select * from tb_clock where user_id=%@",userID];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        //
        while (rs.next) {
            NSArray *dayFlArr = [[rs stringForColumn:@"dayFlags"] componentsSeparatedByString:@","];
            NSMutableDictionary *clAcDic = [NSMutableDictionary dictionary];
            [clAcDic setObject:[rs stringForColumn:@"user_id"]?[rs stringForColumn:@"user_id"]:@"" forKey:@"user_account"];
            [clAcDic setObject:[rs stringForColumn:@"clock_id"]?[NSNumber numberWithInteger:[rs stringForColumn:@"clock_id"].integerValue]:[NSNumber numberWithInteger:@"".integerValue] forKey:@"_id"];
            [clAcDic setObject:[rs stringForColumn:@"tagname"]?[rs stringForColumn:@"tagname"]:@"" forKey:@"name"];
            [clAcDic setObject:[NSString stringWithFormat:@"%@:%@",[rs stringForColumn:@"hour"]?[rs stringForColumn:@"hour"]:@"",[rs stringForColumn:@"minute"]?[rs stringForColumn:@"minute"]:@""] forKey:@"clock_time"];
            [clAcDic setObject:[rs stringForColumn:@"year"]?[NSNumber numberWithInteger:[rs stringForColumn:@"year"].integerValue]:[NSNumber numberWithInteger:@"".integerValue] forKey:@"year"];
            [clAcDic setObject:[rs stringForColumn:@"mounth"]?[NSNumber numberWithInteger:[rs stringForColumn:@"mounth"].integerValue]:[NSNumber numberWithInteger:@"".integerValue] forKey:@"month"];
            [clAcDic setObject:[rs stringForColumn:@"day"]?[NSNumber numberWithInteger:[rs stringForColumn:@"day"].integerValue]:[NSNumber numberWithInteger:@"".integerValue] forKey:@"day"];
            [clAcDic setObject:[rs stringForColumn:@"isopen"]?[NSNumber numberWithInteger:[rs stringForColumn:@"isopen"].integerValue]:[NSNumber numberWithInteger:@"".integerValue] forKey:@"clockOpen"];
            [clAcDic setObject:[NSNumber numberWithInteger:[self clearUpdayFlags:dayFlArr]] forKey:@"repeat"];
            [clAcDic setObject:[NSNumber numberWithInteger:[dayFlArr[0] integerValue]] forKey:@"mon_day"];
            [clAcDic setObject:[NSNumber numberWithInteger:[dayFlArr[1] integerValue]] forKey:@"tues_day"];
            [clAcDic setObject:[NSNumber numberWithInteger:[dayFlArr[2] integerValue]] forKey:@"wes_day"];
            [clAcDic setObject:[NSNumber numberWithInteger:[dayFlArr[3] integerValue]] forKey:@"thur_day"];
            [clAcDic setObject:[NSNumber numberWithInteger:[dayFlArr[4] integerValue]] forKey:@"frid_day"];
            [clAcDic setObject:[NSNumber numberWithInteger:[dayFlArr[5] integerValue]] forKey:@"sta_day"];
            [clAcDic setObject:[NSNumber numberWithInteger:[dayFlArr[6] integerValue]] forKey:@"sun_day"];
            [arr addObject:clAcDic];
        }
    }];
    return arr;
}


//插入闹钟列表
-(void)insertClockInfo:(SmaAlarmInfo *)clockInfo
{
    @try {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            [self.queue inDatabase:^(FMDatabase *db) {
                [db beginTransaction];
                SmaAlarmInfo *info=clockInfo;
                BOOL result = [db executeUpdate:@"INSERT INTO tb_clock (user_id,dayFlags,aid,minute,hour,day ,mounth ,year ,isopen,tagname,clock_web) VALUES (?,?,?,?,?,?,?,?,?,?,?);",info.userId,info.dayFlags,info.aid,info.minute,info.hour,info.day,info.mounth,info.year,info.isopen,info.tagname,info.web];
                NSLog(@"插入闹钟成功  %d",result);
                [db commit];
            }];
        }];
    }
    @catch (NSException *exception) {
        // MyLog(@"插入闹钟失败%@",exception);
    }
}

//修改闹钟
-(void)updateClockInfo:(SmaAlarmInfo *)clockInfo
{
    @try {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            [self.queue inDatabase:^(FMDatabase *db) {
                [db beginTransaction];
                SmaAlarmInfo *info=clockInfo;
                
                NSString *updatesql=[NSString stringWithFormat:@"update tb_clock set dayFlags='%@',aid=%d,isopen=%d,tagname='%@',hour='%@',minute='%@',clock_web=%d where clock_id=%d",info.dayFlags,[info.aid intValue],[info.isopen intValue],info.tagname,info.hour,info.minute,[info.web intValue],[info.clockid intValue]];
                BOOL result = [db executeUpdate:updatesql];
                MyLog(@"修改成功  %d",result);
                [db commit];
            }];
        }];
    }
    @catch (NSException *exception) {
        MyLog(@"修改闹钟失败%@",exception);
    }
}
-(void)deleteClockInfo:(NSString *)clockId
{
    @try {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            [self.queue inDatabase:^(FMDatabase *db) {
                [db beginTransaction];
                NSString *updatesql=[NSString stringWithFormat:@"delete from tb_clock where clock_id=%d",[clockId intValue]];
                [db executeUpdate:updatesql];
                
                MyLog(@"删除 成功");
                [db commit];
                
            }];
        }];
    }
    @catch (NSException *exception) {
        MyLog(@"插入闹钟失败%@",exception);
    }
    
}

-(void)deleteClockUserInfo:(NSString *)userID success:(void (^)(id))success failure:(void (^)(id))failure
{
    __block BOOL result;
    @try {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            [self.queue inDatabase:^(FMDatabase *db) {
                [db beginTransaction];
                NSString *updatesql=[NSString stringWithFormat:@"delete from tb_clock where user_id='%@'",userID];
                result= [db executeUpdate:updatesql];
                MyLog(@"删除所有成功  %d",result);
                [db commit];
                if (result) {
                    if (success) {
                        success(@"1");
                    }
                }
                else{
                    if (failure) {
                        failure(@"0");
                    }
                }
            }];
        }];
        
    }
    @catch (NSException *exception) {
        MyLog(@"插入闹钟失败%@",exception);
        if (failure) {
            failure(@"0");
        }
    }
    
}

-(NSMutableArray *)getSelectClockCount
{
    NSMutableArray *arr=[NSMutableArray array];
    @try {
        [self.queue inDatabase:^(FMDatabase *db) {
            [db beginTransaction];
            NSString *sql=[NSString stringWithFormat:@"select count(*) as sumcount from tb_clock where user_id=%@;",[SmaAccountTool userInfo].userId];
            FMResultSet *rs = [db executeQuery:sql];
            while (rs.next) {
                [arr addObject:[rs stringForColumn:@"sumcount"]];
            }
            [db commit];
        }];
        return arr;
    }
    @catch (NSException *exception) {
        
        return arr;
    }
    
}

//修改闹钟
-(void)updateClockIsOpenOrderById:(NSString *)clockId isOpen:(BOOL)isOpen
{
    @try {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            [self.queue inDatabase:^(FMDatabase *db) {
                [db beginTransaction];
                
                
                NSString *updatesql=[NSString stringWithFormat:@"update tb_clock set isopen=%d where clock_id=%d and user_id=%@",(isOpen)?1:0,[clockId intValue],[SmaAccountTool userInfo].userId];
                
                [db executeUpdate:updatesql];
                
                MyLog(@"修改成功");
                [db commit];
            }];
        }];
    }
    @catch (NSException *exception) {
        MyLog(@"修改闹钟失败%@",exception);
    }
}

//整理闹钟重时间
- (BOOL )clearUpdayFlags:(NSArray *)dayFlags{
    for (NSString *str in dayFlags) {
        if (str.intValue == 1) {
            return YES;
        }
    }
    return NO;
}
@end
