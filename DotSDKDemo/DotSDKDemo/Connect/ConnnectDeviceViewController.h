//
//  ConnnectDeviceViewController.h
//  RestonSDKDemo
//
//  Created by San on 2017/7/25.
//  Copyright © 2017年 medica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BluetoothManager/SLPBLEManager.h>

@interface ConnnectDeviceViewController : UIViewController

@property(nonatomic,strong) SLPPeripheralInfo *selectPeripheral;

@end
