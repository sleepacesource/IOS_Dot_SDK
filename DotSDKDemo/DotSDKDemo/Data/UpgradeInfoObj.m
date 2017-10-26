//
//  UpgradeInfoObj.m
//  RestonSDKDemo
//
//  Created by San on 2017/9/12.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "UpgradeInfoObj.h"

@implementation UpgradeInfoObj

+ (UpgradeInfoObj *)backUpgradeInfoFromDeviceNumber:(NSString *)numberString
{
    UpgradeInfoObj *upgradeInfo=[[UpgradeInfoObj alloc]init];
    if ([numberString isEqualToString:@"10-0"]) {
         NSString *filepath=[[NSBundle mainBundle] pathForResource:@"10-0_1.70" ofType:@"des"];
        upgradeInfo.package=[NSData dataWithContentsOfFile:filepath];
        upgradeInfo.crcDes=2079326873;
        upgradeInfo.crcBin=947973372;
    }
    else if ([numberString isEqualToString:@"16-0"])
    {
        NSString *filepath=[[NSBundle mainBundle] pathForResource:@"16-0_1.03" ofType:@"des"];
        upgradeInfo.package=[NSData dataWithContentsOfFile:filepath];
        upgradeInfo.crcDes=3945200007;
        upgradeInfo.crcBin=1183053104;
    }
    else if ([numberString isEqualToString:@"17-0"])
    {
        NSString *filepath=[[NSBundle mainBundle] pathForResource:@"17-0_1.00" ofType:@"des"];
        upgradeInfo.package=[NSData dataWithContentsOfFile:filepath];
        upgradeInfo.crcDes=370577400;
        upgradeInfo.crcBin=770771143;
    }
    else
    {
        
    }
    
    return upgradeInfo;
}

@end
