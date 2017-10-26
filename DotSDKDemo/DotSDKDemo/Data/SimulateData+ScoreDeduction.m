//
//  SimulateData+ScoreDeduction.m
//  DotSDKDemo
//
//  Created by San on 2017/9/15.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "SimulateData+ScoreDeduction.h"

@implementation SimulateData (ScoreDeduction)

+ (NSArray *)backDeductionArrayyFromAnalysis:(HistoryDataAnalysis*)analysis
{
    NSMutableArray * deductionNameArr=[[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray * deductionValueArr=[[NSMutableArray alloc]initWithCapacity:0];
    for (HistoryDataScoreDeduction *scoreObj in analysis.scoreDeductionAry) {
        switch (scoreObj.type) {
            case Milky_ScoreDeductibleType_SleepTooLong:
            {
                [deductionNameArr addObject:@"actual_sleep_long"];
            }
                break;
            case Milky_ScoreDeductibleType_SleepTooShort:
            {
                [deductionNameArr addObject:@"actual_sleep_short"];
            }
                break;
            case Milky_ScoreDeductibleType_DifficultToSleep:
            {
                [deductionNameArr addObject:@"fall_asleep_hard"];
            }
                break;
            case Milky_ScoreDeductibleType_AwakeTooFrequent:
            {
                [deductionNameArr addObject:@"wake_times_too_much"];
            }
                break;
            case Milky_ScoreDeductibleType_sleepEfficiencyTooLow:
            {
                [deductionNameArr addObject:@"sleepace_efficient_low"];////
            }
                break;
            case Milky_ScoreDeductibleType_optimumSleepPercentTooLow:
            {
                [deductionNameArr addObject:@"benign_sleep"];///
            }
                break;
            case Milky_ScoreDeductibleType_bodyMovementTooMuch:
            {
                [deductionNameArr addObject:@"restless"];
            }
                break;
            case Milky_ScoreDeductibleType_SleepTooLate:
            {
                [deductionNameArr addObject:@"start_sleep_time_too_latter"];
            }
                break;
            default:
                break;
        }
        [deductionValueArr addObject:[NSString stringWithFormat:@"-%d",scoreObj.score]];
    }
    
    return @[deductionNameArr,deductionValueArr];
}


@end
