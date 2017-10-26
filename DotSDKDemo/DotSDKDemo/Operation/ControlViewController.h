//
//  ControlViewController.h
//  RestonSDKDemo
//
//  Created by San on 2017/8/1.
//  Copyright © 2017年 medica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BluetoothManager/SLPBLEManager.h>

@interface ControlViewController : UIViewController

@property(nonatomic,strong) SLPPeripheralInfo *selectPeripheral;
@property(nonatomic,strong) NSString *userID;

@end
