//
//  DeviceViewController.m
//  RestonSDKDemo
//
//  Created by San on 2017/8/1.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "DeviceViewController.h"
#import "Tool.h"
#import <Milky/Milky.h>
#import "SLPUnderlineButton.h"
#import "UpgradeInfoObj.h"

@interface DeviceViewController ()
{
    UIView *ugView;
}
@property (weak, nonatomic) IBOutlet UIButton *getDeviceNameBT;
@property (weak, nonatomic) IBOutlet UIButton *getDeviceIDBT;
@property (weak, nonatomic) IBOutlet UIButton *getPowerBT;
@property (weak, nonatomic) IBOutlet UIButton *getVersionBT;
@property (weak, nonatomic) IBOutlet UIButton *upgradeBT;
@property (weak, nonatomic) IBOutlet SLPUnderlineButton *disconnectDeviceBT;

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *upgradeLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *myscorollview;
@property (strong, nonatomic) IBOutlet UIView *cView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *connectTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *devcieInfoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *upgradeTitleLabel;

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUI];
    [self addLeftItem];
}

- (void)setUI
{
    [Tool configSomeKindOfButtonLikeNomal:self.getDeviceNameBT];
    [Tool configSomeKindOfButtonLikeNomal:self.getDeviceIDBT];
    [Tool configSomeKindOfButtonLikeNomal:self.getPowerBT];
    [Tool configSomeKindOfButtonLikeNomal:self.getVersionBT];
    [Tool configSomeKindOfButtonLikeNomal:self.upgradeBT];
//    [Tool configSomeKindOfButtonLikeNomal:self.disconnectDeviceBT];
    [self.disconnectDeviceBT setColor:[FontColor C4]];
    [self.disconnectDeviceBT setLineWidth:1.0];
    
    self.myscorollview.contentSize=self.cView.frame.size;
    [self.myscorollview addSubview:self.cView];
    
    self.label1.text=NSLocalizedString(@"process", nil);
    self.connectTitleLabel.text=NSLocalizedString(@"connect_device", nil);
    self.devcieInfoTitleLabel.text=NSLocalizedString(@"device_info", nil);
    self.upgradeTitleLabel.text=NSLocalizedString(@"fireware_info", nil);
    [self.getDeviceNameBT setTitle:NSLocalizedString(@"obtain_device_name", nil) forState:UIControlStateNormal];
    [self.getDeviceIDBT setTitle:NSLocalizedString(@"obtain_device_id", nil) forState:UIControlStateNormal];
    [self.getPowerBT setTitle:NSLocalizedString(@"obtain_battery", nil) forState:UIControlStateNormal];
    [self.getVersionBT setTitle:NSLocalizedString(@"obtain_fireware_version", nil) forState:UIControlStateNormal];
    [self.upgradeBT setTitle:NSLocalizedString(@"fireware_update", nil) forState:UIControlStateNormal];
    [self.disconnectDeviceBT setTitle:NSLocalizedString(@"disconnect", nil) forState:UIControlStateNormal];
    self.textView.layer.borderWidth=1.0f;
    self.textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textView.layer.cornerRadius=2.0f;
    self.label1.textColor=[FontColor C4];
    self.label1.font=[FontColor T3];
    self.connectTitleLabel.textColor=[FontColor C4];
    self.connectTitleLabel.font=[FontColor T3];
    self.devcieInfoTitleLabel.textColor=[FontColor C4];
    self.devcieInfoTitleLabel.font=[FontColor T3];
    self.upgradeTitleLabel.textColor=[FontColor C4];
    self.upgradeTitleLabel.font=[FontColor T3];
    self.deviceNameLabel.textColor=[FontColor C3];
    self.deviceNameLabel.font=[FontColor T3];
    self.deviceIdLabel.textColor=[FontColor C3];
    self.deviceIdLabel.font=[FontColor T3];
    self.powerLabel.textColor=[FontColor C3];
    self.powerLabel.font=[FontColor T3];
    self.versionLabel.textColor=[FontColor C3];
    self.versionLabel.font=[FontColor T3];
    self.upgradeLabel.textColor=[FontColor C3];
    self.upgradeLabel.font=[FontColor T3];
    [Tool configureLabelBorder:self.deviceNameLabel];
    [Tool configureLabelBorder:self.deviceIdLabel];
    [Tool configureLabelBorder:self.powerLabel];
    [Tool configureLabelBorder:self.versionLabel];
    [Tool configureLabelBorder:self.upgradeLabel];
    self.textView.textColor=[FontColor C3];
    self.textView.font=[FontColor T4];
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
    //
    [self deviceDisconenct];
    [Tool outputResultWithStr:nil textView:self.textView];
}


- (void)deviceDisconenct
{
    BOOL isConnected=self.selectPeripheral.peripheral&&[SLPBLESharedManager peripheralIsConnected:self.selectPeripheral.peripheral];
    self.getDeviceNameBT.enabled=isConnected;
    self.getDeviceIDBT.enabled=isConnected;
    self.getPowerBT.enabled=isConnected;
    self.getVersionBT.enabled=isConnected;
    self.upgradeBT.enabled=isConnected;
    self.disconnectDeviceBT.enabled=isConnected;
}

////device////
- (IBAction)getDeviceName:(id)sender {
    
    if (![Tool bleIsOpenShowToTextview:self.textView]) {
        return ;
    }
    
    if (![Tool deviceIsConnected:self.selectPeripheral.peripheral ShowToTextview:self.textView]) {
        return ;
    }
    
    [Tool outputResultWithStr:NSLocalizedString(@"getting_device_name", nil) textView:self.textView];
    if (self.selectPeripheral.name&&self.selectPeripheral.name.length) {
        self.deviceNameLabel.text=[NSString stringWithFormat:@"%@",self.selectPeripheral.name];
        NSString *receiveStr=[NSString stringWithFormat:NSLocalizedString(@"receive_device_name", nil),self.selectPeripheral.name];
        [Tool outputResultWithStr:receiveStr textView:self.textView];
    }
    else
    {
        self.deviceNameLabel.text=NSLocalizedString(@"failure", nil);
        [Tool outputResultWithStr:NSLocalizedString(@"failure", nil) textView:self.textView];
    }
    
}

- (IBAction)getdeviceID:(id)sender{
    
    if (![Tool bleIsOpenShowToTextview:self.textView]) {
        return ;
    }
    
    if (![Tool deviceIsConnected:self.selectPeripheral.peripheral ShowToTextview:self.textView]) {
        return ;
    }
    [Tool outputResultWithStr:NSLocalizedString(@"getting_device_id", nil) textView:self.textView];
    [SLPBLESharedManager milky:self.selectPeripheral.peripheral getDeviceInfoTimeout:10.0 callback:^(SLPDataTransferStatus status, id data) {
        if (status==SLPDataTransferStatus_Succeed) {
            MilkyDeviceInfo *devInfo=(MilkyDeviceInfo*)data;
            self.deviceIdLabel.text=[NSString stringWithFormat:@"%@",devInfo.deviceID];
            NSString *receiveStr=[NSString stringWithFormat:NSLocalizedString(@"get_device_id", nil),devInfo.deviceID];
            [Tool outputResultWithStr:receiveStr textView:self.textView];
        }
        else
        {
            self.deviceIdLabel.text=NSLocalizedString(@"failure", nil);
            [Tool outputResultWithStr:NSLocalizedString(@"failure", nil) textView:self.textView];
        }
        
    }];
}


- (IBAction)getDevicePower:(id)sender {
    if (![Tool bleIsOpenShowToTextview:self.textView]) {
        return ;
    }
    if (![Tool deviceIsConnected:self.selectPeripheral.peripheral ShowToTextview:self.textView]) {
        return ;
    }
     [Tool outputResultWithStr:NSLocalizedString(@"getting_power", nil) textView:self.textView];
    [SLPBLESharedManager milky:self.selectPeripheral.peripheral getBatteryWithTimeout:10.0 callback:^(SLPDataTransferStatus status, id data) {
        if (status==SLPDataTransferStatus_Succeed) {
            MilkyBatteryInfo *battery=(MilkyBatteryInfo *)data;
            
            NSString *valueStr=[NSString stringWithFormat:@"%d%%",battery.quantity];
            NSString *getSucceedStr=[NSString stringWithFormat:NSLocalizedString(@"get_power", nil),valueStr];
            if (battery.quantity==0xFF) {
                valueStr=NSLocalizedString(@"invalid_value", nil);
                getSucceedStr=NSLocalizedString(@"invalid_value", nil);
            }
            self.powerLabel.text=valueStr;
            [Tool outputResultWithStr:getSucceedStr textView:self.textView];
        }
        else
        {
            self.powerLabel.text= NSLocalizedString(@"failure", nil);
            [Tool outputResultWithStr:NSLocalizedString(@"failure", nil) textView:self.textView];
        }
    }];
}


- (IBAction)getDeviceVersion:(id)sender {
    if (![Tool bleIsOpenShowToTextview:self.textView]) {
        return ;
    }
    if (![Tool deviceIsConnected:self.selectPeripheral.peripheral ShowToTextview:self.textView]) {
        return ;
    }
    [Tool outputResultWithStr:NSLocalizedString(@"getting_current_version", nil) textView:self.textView];
    [SLPBLESharedManager milky:self.selectPeripheral.peripheral getDeviceVersionWithTimeout:10.0 callback:^(SLPDataTransferStatus status, id data) {
        if (status==SLPDataTransferStatus_Succeed) {
            MilkyDeviceVersionInfo *version=(MilkyDeviceVersionInfo*)data;
            self.versionLabel.text=[NSString stringWithFormat:@"%@",version.hardwareVersion];
            NSString *receiveStr=[NSString stringWithFormat:NSLocalizedString(@"get_the_current_version", nil),version.hardwareVersion];
            [Tool outputResultWithStr:receiveStr textView:self.textView];
        }
        else
        {
            self.versionLabel.text= NSLocalizedString(@"failure", nil);
            [Tool outputResultWithStr:NSLocalizedString(@"failure", nil) textView:self.textView];
        }
    }];
}


- (IBAction)deviceUpgrade:(id)sender {
    if (![Tool bleIsOpenShowToTextview:self.textView]) {
        return ;
    }
    if (![Tool deviceIsConnected:self.selectPeripheral.peripheral ShowToTextview:self.textView]) {
        return ;
    }
    UpgradeInfoObj *upgradeInfo=[UpgradeInfoObj backUpgradeInfoFromDeviceNumber:self.deviceNumberString];
    self.upgradeLabel.text= NSLocalizedString(@"fireware_update", nil);
    [Tool outputResultWithStr:NSLocalizedString(@"fireware_update", nil) textView:self.textView];
    [self isShowUpgradeView:YES];
    [SLPBLESharedManager milky:self.selectPeripheral.peripheral upgradeDeviceWithCrcDes:upgradeInfo.crcDes crcBin:upgradeInfo.crcBin upgradePackage:upgradeInfo.package callback:^(SLPDataTransferStatus status, id data) {
        if (status==SLPDataTransferStatus_Succeed) {
            MilkyUpgradeInfo *upgradeInfo=(MilkyUpgradeInfo *)data;
            self.upgradeLabel.text=[NSString stringWithFormat:@"%.1f%%",upgradeInfo.progress*100];
            [Tool outputResultWithStr:[NSString stringWithFormat:NSLocalizedString(@"upgrading_device", nil),self.upgradeLabel.text] textView:self.textView];
            if (upgradeInfo.progress==1) {
                self.upgradeLabel.text=NSLocalizedString(@"update_completed", nil);
                [Tool outputResultWithStr:NSLocalizedString(@"update_completed", nil) textView:self.textView];
                [Tool outputResultWithStr:[NSString stringWithFormat:NSLocalizedString(@"reboot_device", nil),self.selectPeripheral.name] textView:self.textView];
                [self deviceDisconenct];
                [self performSelector:@selector(tryConnectDevice) withObject:nil afterDelay:5.0f];
                [self isShowUpgradeView:NO];
            }
        }
        else
        {
            self.upgradeLabel.text= NSLocalizedString(@"failure", nil);
            [Tool outputResultWithStr:NSLocalizedString(@"failure", nil) textView:self.textView];
            [self isShowUpgradeView:NO];
        }
    }];
}


- (IBAction)disconnectDevice:(id)sender{
    if (![Tool bleIsOpenShowToTextview:self.textView]) {
        return ;
    }
    BOOL isConnected=self.selectPeripheral.peripheral&&[SLPBLESharedManager peripheralIsConnected:self.selectPeripheral.peripheral];
    if (!isConnected) {
         [Tool outputResultWithStr:NSLocalizedString(@"disconnected", nil) textView:self.textView];
        return ;
    }
    [SLPBLESharedManager disconnectPeripheral:self.selectPeripheral.peripheral timeout:10.0 completion:^(SLPBLEDisconnectReturnCodes code, NSInteger disconnectHandleID) {
        if (code==SLPBLEDisconnectReturnCode_Succeed) {
            NSLog(@"device has disconncted");
            [Tool outputResultWithStr:NSLocalizedString(@"disconnected", nil) textView:self.textView];
            [self deviceDisconenct];
            [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)tryConnectDevice
{
    [Tool outputResultWithStr:NSLocalizedString(@"connecting_device", nil) textView:self.textView];
    [SLPBLESharedManager milky:self.selectPeripheral.peripheral loginWithDeviceName:self.selectPeripheral.name deviceCode:self.deviceNumberString userId:[self.userID integerValue] callback:^(SLPDataTransferStatus status, id data) {
        if (status==SLPDataTransferStatus_Succeed) {
            MilkyDeviceInfo *devInfo=(MilkyDeviceInfo*)data;
            NSLog(@"device id--->%@",devInfo.deviceID);
            [Tool outputResultWithStr:NSLocalizedString(@"connect_device_successfully", nil) textView:self.textView];
        }
        else
        {
            NSLog(@"login device failed");
            [Tool outputResultWithStr:NSLocalizedString(@"failure", nil) textView:self.textView];
            [self deviceDisconenct];
        }
    }];
}

- (void)isShowUpgradeView:(BOOL)flag
{
    if (flag) {
        ugView=[[UIView alloc]initWithFrame:self.view.frame];
        ugView.backgroundColor=[UIColor grayColor];
        ugView.alpha=0.7f;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
        label.text=[NSString stringWithFormat:NSLocalizedString(@"fireware_updateing", nil),@"Dot"];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentCenter;
        [ugView addSubview:label];
        [[UIApplication sharedApplication].keyWindow addSubview:ugView];
    }
    else
        [ugView removeFromSuperview];
    
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
