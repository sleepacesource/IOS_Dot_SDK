//
//  UserObj.m
//  MAIDIJIA
//
//  Created by Yajie Deng on 14-9-1.
//  Copyright (c) 2014年 chenchangrong. All rights reserved.
//

#import "UserObj.h"

@implementation UserObj

- (void)dealloc
{
    ;
}

- (void)releaseMe
{
    
}


-(id )init
{
    self = [super init];
    if (self)
    {
        [self initData];
    }
    return self;
}

- (void)setTimezone:(NSNumber *)timezone
{
    if (timezone)
    {
        NSInteger iTimezone = timezone.integerValue;
        if (labs(iTimezone) > 24 * 3600)//矫正时区转化时多乘一次3600导致的bug
        {
            iTimezone /= 3600;
        }
        else if(labs(iTimezone) < 25)//将旧存储的时区(以小时存储)转化为以秒为单位.
        {
            iTimezone *= 3600;
        }
        _timezone = [NSNumber numberWithInteger:iTimezone];
    }
    else//赋空值
    {
        _timezone = timezone;//nil
    }
}

- (SLPSleepScoreGrades)sleepScoreGrades{
    NSInteger score = [self.score integerValue];
    SLPSleepScoreGrades grade = SLPSleepScoreGrades_Bad;
    if (score < 60){
        grade = SLPSleepScoreGrades_Bad;
    }else if (score < 80){
        grade = SLPSleepScoreGrades_General;
    }else if (score < 90){
        grade = SLPSleepScoreGrades_Good;
    }else{
        grade = SLPSleepScoreGrades_VeryGood;
    }
    return grade;
}

- (SLPSleepBodyMovementGrades)bodymovementGrades{
    NSInteger bodymovement = [self.bodyMoveLevel integerValue];
    SLPSleepBodyMovementGrades grades = SLPSleepBodyMovementGrades_Regular;
    switch (bodymovement) {
        case -2:
        case -15:
        case -20:
            grades = SLPSleepBodyMovementGrades_Poor;
            break;
        case -1:
        case -5:
        case -10:
            grades = SLPSleepBodyMovementGrades_Insufficient;
            break;
        case 0:
            grades = SLPSleepBodyMovementGrades_Regular;
            break;
        case 1:
        case 5:
        case 10:
            grades = SLPSleepBodyMovementGrades_Irregular;
            break;
        case 2:
        case 15:
        case 20:
            grades = SLPSleepBodyMovementGrades_Restless;
            break;
        default:
            break;
    }
    return grades;
}

-(void)initData
{
    self.farmlyID = [NSNumber numberWithInt:0];
    self.memID = [NSNumber numberWithInt:0];
    self.date = @"2014-09-05";
    self.timezone= [NSNumber numberWithInt:0];  //时区
    self.duration= [NSNumber numberWithInt:0];  //睡眠总时长
    self.startTime= [NSNumber numberWithInt:0];
    
    self.score= [NSNumber numberWithInt:0];   //睡眠评分
    self.wake= [NSNumber numberWithInt:0];
    self.light= [NSNumber numberWithInt:0];  //轻睡眠
    self.rem= [NSNumber numberWithInt:0];   //中睡眠
    self.deep= [NSNumber numberWithInt:0];  //深睡眠
    
    self.wake_times = [NSNumber numberWithInt:0];
    
    self.hxztcs= [NSNumber numberWithInt:0];  //呼吸暂停总次数
    self.hxztsc= [NSNumber numberWithInt:0]; //呼吸暂停时长
    self.xtztcs= [NSNumber numberWithInt:0]; //心跳暂停总次数
    self.xtztsc= [NSNumber numberWithInt:0]; //心跳暂停时长
    self.lccs= [NSNumber numberWithInt:0];   //离床次数
    
    self.lcsc= [NSNumber numberWithInt:0]; //离床时间长
    self.tdcs= [NSNumber numberWithInt:0]; // 体动次数
    self.fscs= [NSNumber numberWithInt:0]; //翻身次数
    self.pjxl= [NSNumber numberWithInt:0];
    self.pjhxl= [NSNumber numberWithInt:0];
    
    self.zgxl= [NSNumber numberWithInt:0];   //最高心率
    self.zghxl= [NSNumber numberWithInt:0];   //最高呼吸率
    self.zdxl= [NSNumber numberWithInt:0];
    self.zdhxl= [NSNumber numberWithInt:0];    //最低呼吸率
    self.xtgssc= [NSNumber numberWithInt:0];
    
    self.xtghsc= [NSNumber numberWithInt:0];  //心跳过缓时长
    self.hxgssc= [NSNumber numberWithInt:0];
    self.hxghsc= [NSNumber numberWithInt:0];  //呼吸过缓时长
    
    self.stopMode = [NSNumber numberWithInt:1];
    self.timeStep = [NSNumber numberWithInt:60];
    self.recordCount = [NSNumber numberWithInt:0];
    self.isupload = [NSNumber numberWithInt:2]; // 1 代表已经上传 2代表未上传
    self.breathRateString = @"[0,0,0,0,]";
    self.heartRateString = @"[0,0,0,0]";
    self.statusString = @"[0,0,0,0,0,0,0]";
    self.statusValueString = @"[0,0,0,0,0,0]";
    self.sleepStateStr = @"[0,1,1,1,3,2]";
    
    self.week = @"1";
    self.month =@"1";
    self.year = @"2014";
    self.asleepTime = [NSNumber numberWithInt:20];//入睡时间
    self.source = [NSNumber numberWithInt:1];
    self.arithmeticVer = @"2.7";
    
    self.SleepEfficient = [NSNumber numberWithInt:0];
    self.bodyMoveLevel  = [NSNumber numberWithInt:0];
    
    self.co2Array = [NSMutableArray array];
    self.eHumidityArray = [NSMutableArray array];
    self.eLightArray = [NSMutableArray array];
    self.eNoiseArray = [NSMutableArray array];
    self.eTempArray = [NSMutableArray array];
    self.mHumidityArray = [NSMutableArray array];
    self.mTempArray = [NSMutableArray array];
    self.originStartTime = [NSNumber numberWithInt:0];
}

- (BOOL)isNotRestOnSource
{
//    //手机监测/枕扣监测
//    if (SLPDeviceType_Phone == self.source.intValue ||
//        (SLPDeviceType_Milky == self.source.intValue || self.source.intValue == SLPDeviceType_Milky2 || self.source.intValue == SLPDeviceType_Milky2T))
//    {
//        return YES;
//    }
//    else
    return YES;
}


//
//- (NSDictionary *)getUpLoadParm
//{
//    NSDictionary *analysisDic = @{
//                                  @"advice":self.adviceStr,
//                                  @"apneaCount":self.hxztcs,
//                                  @"apneaDuration":self.hxztsc,
//                                  @"asleepTime":self.asleepTime,
//                                  @"avgBreathRate":self.pjhxl,
//                                  @"avgHeartRate":self.pjxl,
//                                  @"bodyMoveCount":self.tdcs,
//                                  @"bradycardiaDuration":self.xtghsc,
//                                  @"bradypneaDuration":self.hxghsc,
//                                  @"date":self.date,
//                                  @"deepSleepDuration":self.deep,
//                                  @"duration":self.duration,
//                                  @"heartbeatPauseCount":self.xtztcs,
//                                  @"heartbeatPauseDuration":self.xtztsc,
//                                  @"lightSleepDuration":self.light,
//                                  @"maxBreathRate":self.zghxl,
//                                  @"maxHeartRate":self.zgxl,
//                                  @"memberId":self.memID,
//                                  @"minBreathRate":self.zdhxl,
//                                  @"minHeartRate":self.zdxl,
//                                  @"outOfBedCount":self.lccs,
//                                  @"outOfBedDuration":self.lcsc,
//                                  @"remSleepDuration":self.rem,
//                                  @"scale":self.score,
//                                  @"sleepStateStr":self.sleepStateStr,
//                                  @"startTime":self.startTime,
//                                  @"tachycardiaDuration":self.xtgssc,
//                                  @"tachypneaDuration":self.hxgssc,
//                                  @"turningOverCount":self.fscs,
//                                  @"wake":self.wake,
//                                  @"wakeTimes":self.wake_times,
//                                  @"mdDeepSleepPerc":self.MdDeepSleepPerc,
//                                  @"mdRemSleepPerc":self.MdRemSleepPerc,
//                                  @"mdLightSleepPerc":self.MdLightSleepPerc,
//                                  @"mdWakeSleepPerc":self.MdWakeSleepPerc,
//                                  @"mdWakeUpTime":self.MdWakeUpTime
//                                  };
//    return analysisDic;
//}

@end
