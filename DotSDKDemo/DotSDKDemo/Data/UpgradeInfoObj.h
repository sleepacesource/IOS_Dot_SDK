//
//  UpgradeInfoObj.h
//  RestonSDKDemo
//
//  Created by San on 2017/9/12.
//  Copyright © 2017年 medica. All rights reserved.
//

#import <Foundation/Foundation.h>
#
@interface UpgradeInfoObj : NSObject

@property (nonatomic,strong)NSData *package;
@property (nonatomic,assign)long crcDes;
@property (nonatomic,assign)long crcBin;

+ (UpgradeInfoObj *)backUpgradeInfoFromDeviceNumber:(NSString *)numberString;

@end
