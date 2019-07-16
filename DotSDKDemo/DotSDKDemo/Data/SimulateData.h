//
//  simulateData.h
//  RestonSDKDemo
//
//  Created by San on 2017/8/9.
//  Copyright © 2017年 medica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserObj.h"
#import <Milky/Milky.h>
#import <Milky/Milky_HistoryData.h>

@interface SimulateData : NSObject

+ (UserObj *)simulateData;

+ (UserObj *)dealwithData:(SLPMilkyHistoryData *)historyData;

@end
