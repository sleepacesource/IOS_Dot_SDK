//
//  ScanDeviceViewController.m
//  RestonSDKDemo
//
//  Created by San on 2017/7/25.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "ScanDeviceViewController.h"
#import "ConnnectDeviceViewController.h"
#import <BluetoothManager/BluetoothManager.h>
#import "Tool.h"

@interface ScanDeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *deviceArray;
}
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@property (nonatomic,strong) NSMutableArray *deviceList;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@end

@implementation ScanDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUI];
}


- (void)setUI
{
    self.title=NSLocalizedString(@"ble_search", nil);
    self.myTableview.delegate=self;
    self.myTableview.dataSource=self;
    deviceArray =[[NSMutableArray alloc]initWithCapacity:0];
    self.label1.text=NSLocalizedString(@"process", nil);
    self.label2.text=NSLocalizedString(@"select_device_id", nil);
    self.label3.text=NSLocalizedString(@"refresh", nil);
    self.label1.textColor=[FontColor C4];
    self.label1.font=[FontColor T3];
    self.label2.textColor=[FontColor C3];
    self.label2.font=[FontColor T3];
    self.textView.layer.borderWidth=1.0f;
    self.textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textView.layer.cornerRadius=2.0f;
    self.textView.textColor=[FontColor C3];
    self.textView.font=[FontColor T4];
    BOOL isOpen=[SLPBLESharedManager blueToothIsOpen];
    
    [self performSelector:@selector(pressRefresh:) withObject:nil afterDelay:1.0f];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
    [Tool outputResultWithStr:nil textView:self.textView];
}


- (IBAction)pressRefresh:(id)sender
{
    [SLPBLESharedManager stopAllPeripheralScan];
    if (![Tool bleIsOpenShowToTextview:self.textView]) {
        return ;
    }
    if (deviceArray) {
        [deviceArray removeAllObjects];
    }
    [Tool outputResultWithStr:NSLocalizedString(@"loaded_list", nil) textView:self.textView];
    [SLPBLESharedManager scanBluetoothWithTimeoutInterval:10.0 completion:^(SLPBLEScanReturnCodes code, NSInteger handleID, SLPPeripheralInfo *peripheralInfo) {
        NSLog(@"scan device>>:%@",peripheralInfo.name);
        int i=0;
        while (i<deviceArray.count) {
            SLPPeripheralInfo *devInfo=(SLPPeripheralInfo*)[deviceArray objectAtIndex:i++];
            if (devInfo.name&&[devInfo.name isEqualToString:peripheralInfo.name]) {
                return ;
            }
        }
        if (peripheralInfo.name&&peripheralInfo.name.length&& [peripheralInfo.name hasPrefix:@"B502T"]) {
            [deviceArray addObject:peripheralInfo];
            [self.myTableview reloadData];
        }
        if (!peripheralInfo) {
            [Tool outputResultWithStr:NSLocalizedString(@"load_list_complete", nil) textView:self.textView];
        }
    }];
    
}

- (void)selectDevice:(int)index
{
   if (index<deviceArray.count&&deviceArray)
   {
    ConnnectDeviceViewController *connectVC=[[ConnnectDeviceViewController alloc]init];
    connectVC.selectPeripheral=deviceArray[index];
    [self.navigationController pushViewController:connectVC animated:YES];
    [Tool outputResultWithStr:[NSString stringWithFormat:NSLocalizedString(@"select_", nil),connectVC.selectPeripheral.name] textView:self.textView];
   }
}

#pragma mark -UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellWithIdentifier = @"cellWithIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellWithIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    SLPPeripheralInfo *deviceInfo=(SLPPeripheralInfo*)deviceArray[indexPath.row];
    cell.textLabel.text=deviceInfo.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectDevice:indexPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
