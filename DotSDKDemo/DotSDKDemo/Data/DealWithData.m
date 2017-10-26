//
//  DealWithData.m
//  RestonSDKDemo
//
//  Created by San on 2017/8/31.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "DealWithData.h"

@implementation DealWithData

+(NSArray *)backDataArray:(UserObj *)dataObj
{
    if ([dataObj.reportFlag integerValue]==2)
    {
        return [self backShortDataArray:dataObj];
    }
    else
        return [self backLongDataArray:dataObj];
        
}

+ (NSArray *)backShortDataArray:(UserObj *)dataObj
{
    NSString *date=[NSString stringWithFormat:@"%@",dataObj.date];
    NSString *duration=[NSString stringWithFormat:@"%02d%@%02d%@",[dataObj.duration integerValue]/60,NSLocalizedString(@"unit_h", nil),[dataObj.duration integerValue]%60,NSLocalizedString(@"unit_m", nil)];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    formatter.timeZone=[NSTimeZone localTimeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[dataObj.startTime integerValue]];
    NSString *startTime = [formatter stringFromDate:confromTimesp];
    return @[date,duration,startTime];
}

+(NSArray *)backLongDataArray:(UserObj *)dataObj
{
    NSString *date=[NSString stringWithFormat:@"%@",dataObj.date];
    NSString *score=[NSString stringWithFormat:@"%@",dataObj.score];
    NSString *duration=[NSString stringWithFormat:@"%02d%@%02d%@",[dataObj.duration integerValue]/60,NSLocalizedString(@"unit_h", nil),[dataObj.duration integerValue]%60,NSLocalizedString(@"unit_m", nil)];
    NSString *deepPre=[NSString stringWithFormat:@"%d%%",[dataObj.MdDeepSleepPerc integerValue]];
    NSString *remPre=[NSString stringWithFormat:@"%d%%",[dataObj.MdRemSleepPerc integerValue]];
    NSString *lightPre=[NSString stringWithFormat:@"%d%%",[dataObj.MdLightSleepPerc integerValue]];
    NSString *wakePre=[NSString stringWithFormat:@"%d%%",[dataObj.MdWakeSleepPerc integerValue]];
    NSString *asleepTime=[NSString stringWithFormat:@"%02d%@%02d%@",[dataObj.asleepTime integerValue]/60,NSLocalizedString(@"unit_h", nil),[dataObj.asleepTime integerValue]%60,NSLocalizedString(@"unit_m", nil)];
    NSString *wakes=[NSString stringWithFormat:@"%@ %@",dataObj.wake_times,NSLocalizedString(@"unit_times", nil)];
    NSArray *deArr=@[dataObj.deductionName,dataObj.deductionValue];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    formatter.timeZone=[NSTimeZone localTimeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[dataObj.startTime integerValue]];
    NSString *startTime = [formatter stringFromDate:confromTimesp];
    NSInteger startTimeNum=[[[startTime componentsSeparatedByString:@":"] objectAtIndex:0] integerValue]*60+[[[startTime componentsSeparatedByString:@":"] objectAtIndex:1] integerValue];
    NSInteger startSleepTime=[dataObj.asleepTime integerValue]+startTimeNum;
    NSInteger endSleepTime=[dataObj.duration integerValue]+[dataObj.asleepTime integerValue]+startTimeNum;
    NSString *startTimeStr=[NSString stringWithFormat:@"%02d:%02d",startSleepTime/60>=24?startSleepTime/60-24:startSleepTime/60,startSleepTime%60];
    NSString *endTimeStr =[NSString stringWithFormat:@"%02d:%02d",endSleepTime/60>=24?endSleepTime/60-24:endSleepTime/60,endSleepTime%60];
    NSString *sleepTime=[NSString stringWithFormat:@"%@(%@)~%@(%@)",startTimeStr,NSLocalizedString(@"asleep_point", nil),endTimeStr,NSLocalizedString(@"awake_point", nil)];
    return  @[date,score,deArr,sleepTime,duration,asleepTime,deepPre,remPre,lightPre,wakePre,wakes];
}


@end
