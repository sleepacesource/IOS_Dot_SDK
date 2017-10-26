//
//  ControlViewController.m
//  RestonSDKDemo
//
//  Created by San on 2017/8/1.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "ControlViewController.h"
#import "AutoMonitorViewController.h"
#import <Milky/Milky.h>
#import "Tool.h"

@interface ControlViewController ()
@property (weak, nonatomic) IBOutlet UIButton *getDeviceStatusBT;
@property (weak, nonatomic) IBOutlet UIButton *setAutoMonitorBT;
@property (weak, nonatomic) IBOutlet UIButton *stopCollectBT;
@property (weak, nonatomic) IBOutlet UILabel *stautLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label1;

@end

@implementation ControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
   
    [self addLeftItem];
}

- (void)setUI
{
    [Tool configSomeKindOfButtonLikeNomal:self.getDeviceStatusBT];
    [Tool configSomeKindOfButtonLikeNomal:self.setAutoMonitorBT];
    [Tool configSomeKindOfButtonLikeNomal:self.stopCollectBT];
    self.label1.text=NSLocalizedString(@"process", nil);
    [self.getDeviceStatusBT setTitle:NSLocalizedString(@"obtain_working_state", nil) forState:UIControlStateNormal];
    [self.setAutoMonitorBT setTitle:NSLocalizedString(@"set_time_limit", nil) forState:UIControlStateNormal];
    [self.stopCollectBT setTitle:NSLocalizedString(@"off_collection", nil) forState:UIControlStateNormal];
    self.textView.layer.borderWidth=1.0f;
    self.textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textView.layer.cornerRadius=2.0f;
    self.textView.textColor=[FontColor C3];
    self.textView.font=[FontColor T4];
    self.label1.textColor=[FontColor C4];
    self.label1.font=[FontColor T3];
    self.stautLabel.textColor=[FontColor C3];
    self.stautLabel.font=[FontColor T3];
    [Tool configureLabelBorder:self.stautLabel];
}



- (void)addLeftItem
{
    UIButton *listButton=[UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame=CGRectMake(0, 0, 44, 44);
    [listButton setImage:[UIImage imageNamed:@"tab_btn_scenes_home.png"] forState:UIControlStateNormal];
    listButton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [listButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *listItem=[[UIBarButtonItem alloc]initWithCustomView:listButton];
    self.navigationItem.leftBarButtonItem=listItem;
}


- (void)clickBack
{
    BOOL isConnected=self.selectPeripheral.peripheral&&[SLPBLESharedManager peripheralIsConnected:self.selectPeripheral.peripheral];
    if (isConnected) {
        [self disconnectedDevice];
    }
    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    BOOL isConnected=self.selectPeripheral.peripheral&&[SLPBLESharedManager peripheralIsConnected:self.selectPeripheral.peripheral];
    self.getDeviceStatusBT.enabled=isConnected;
    self.setAutoMonitorBT.enabled=isConnected;
    self.stopCollectBT.enabled=isConnected;
    [Tool outputResultWithStr:nil textView:self.textView];
    self.navigationController.tabBarController.tabBar.hidden=NO;
}


- (IBAction)getdeviceWrokStatus:(id)sender{
    
    if (![Tool bleIsOpenShowToTextview:self.textView]) {
        return ;
    }
    if (![Tool deviceIsConnected:self.selectPeripheral.peripheral ShowToTextview:self.textView]) {
        return ;
    }
    [Tool outputResultWithStr:NSLocalizedString(@"getting_device_status", nil) textView:self.textView];
    [SLPBLESharedManager milky:self.selectPeripheral.peripheral getCollectionStatusWithTimeout:10.0 allback:^(SLPDataTransferStatus status, id data) {
        if (status==SLPDataTransferStatus_Succeed) {
            MilkyCollectionStatus *workStatus=(MilkyCollectionStatus *)data;
            if (workStatus.isInCollecting) {
                 self.stautLabel.text=NSLocalizedString(@"working_state_ing", nil);
            }
            else
            {
                self.stautLabel.text=NSLocalizedString(@"working_state_not", nil);
            }
            [Tool outputResultWithStr:[NSString stringWithFormat:NSLocalizedString(@"get_working_status", nil),self.stautLabel.text] textView:self.textView];
        }
        else
        {
            self.stautLabel.text=NSLocalizedString(@"failure", nil);
            [Tool outputResultWithStr:NSLocalizedString(@"failure", nil) textView:self.textView];
        }

    }];
}


- (IBAction)setAutoMonitor:(id)sender {
    if (![Tool bleIsOpenShowToTextview:self.textView]) {
        return ;
    }
    if (![Tool deviceIsConnected:self.selectPeripheral.peripheral ShowToTextview:self.textView]) {
        return ;
    }
    
    [Tool outputResultWithStr:NSLocalizedString(@"set_auto_monitor", nil) textView:self.textView];
    AutoMonitorViewController *autoMonitorVC=[[AutoMonitorViewController alloc]initWithNibName:@"AutoMonitorViewController" bundle:nil];
    autoMonitorVC.selectPeripheral=self.selectPeripheral;
     self.navigationController.tabBarController.tabBar.hidden=YES;
    [self.navigationController pushViewController:autoMonitorVC animated:YES];
    
}


- (IBAction)stopCollect:(id)sender {
    if (![Tool bleIsOpenShowToTextview:self.textView]) {
        return ;
    }
    if (![Tool deviceIsConnected:self.selectPeripheral.peripheral ShowToTextview:self.textView]) {
        return ;
    }
    [Tool outputResultWithStr:NSLocalizedString(@"notified_acquisition_off", nil) textView:self.textView];
    [SLPBLESharedManager milky:self.selectPeripheral.peripheral stopCollectionWithTimeout:10.0 callback:^(SLPDataTransferStatus status, id data) {
        if (status==SLPDataTransferStatus_Succeed) {
            NSLog(@"%@",NSLocalizedString(@"stop collect succeed", nil));
            [Tool outputResultWithStr:NSLocalizedString(@"close_acquisition_success", nil) textView:self.textView];
        }
        else
        {
            NSLog(@"%@",NSLocalizedString(@"stop collect failed", nil));
            [Tool outputResultWithStr:NSLocalizedString(@"failure", nil) textView:self.textView];
        }
    }];
}


- (void)disconnectedDevice
{
    [SLPBLESharedManager disconnectPeripheral:self.selectPeripheral.peripheral timeout:10.0 completion:^(SLPBLEDisconnectReturnCodes code, NSInteger disconnectHandleID) {
        if (code==SLPBLEDisconnectReturnCode_Succeed) {
            NSLog(@"device has disconncted");
            [Tool outputResultWithStr:NSLocalizedString(@"disconnected", nil) textView:self.textView];
            [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
