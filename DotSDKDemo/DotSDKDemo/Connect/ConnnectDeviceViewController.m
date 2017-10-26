//
//  ConnnectDeviceViewController.m
//  RestonSDKDemo
//
//  Created by San on 2017/7/25.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "ConnnectDeviceViewController.h"
#import "Tool.h"
#import "DeviceViewController.h"
#import "ControlViewController.h"
#import "DataViewController.h"
#import "MBProgressHUD.h"
#import <Milky/Milky.h>

@interface ConnnectDeviceViewController ()<UITextFieldDelegate,UIActionSheetDelegate>
{
    NSString *numberStr;
}

@property (weak, nonatomic) IBOutlet UITextField *myTextfield;
@property (weak, nonatomic) IBOutlet UIButton *connectBT;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *numberSelectButton;
@property (weak, nonatomic) IBOutlet UILabel *numberTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberSelectLabel;
@property (strong,nonatomic) NSArray *numArray;

@end

@implementation ConnnectDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
}

- (NSArray *)numArray
{
    if (!_numArray) {
        self.numArray=@[@"10-0",@"16-0",@"17-0"];
    }
    return _numArray;
}


- (void)setUI
{
    self.title=NSLocalizedString(@"connect_device", nil);
    [Tool configSomeKindOfButtonLikeNomal:self.connectBT];
    self.myTextfield.delegate=self;
    
    self.label1.text=NSLocalizedString(@"process", nil);
    self.label2.text=NSLocalizedString(@"sign_device_guide", nil);
    self.label1.textColor=[FontColor C4];
    self.label1.font=[FontColor T3];
    self.label2.textColor=[FontColor C4];
    self.label2.font=[FontColor T3];
    [self.connectBT setTitle:NSLocalizedString(@"connect_device", nil) forState:UIControlStateNormal];
    self.textView.layer.borderWidth=1.0f;
    self.textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textView.layer.cornerRadius=2.0f;
    self.textView.textColor=[FontColor C3];
    self.textView.font=[FontColor T4];
    self.myTextfield.placeholder=NSLocalizedString(@"user_id", nil);
    //    self.myTextfield.text=@"13481";
    self.numberTitleLabel.textColor=[FontColor C4];
    self.numberTitleLabel.font=[FontColor T3];
    self.numberTitleLabel.text=NSLocalizedString(@"device_code", nil);
    [self.connectBT setTitle:NSLocalizedString(@"connect_device", nil) forState:UIControlStateNormal];
    self.numberSelectLabel.textColor=[FontColor C3];
    self.numberSelectLabel.font=[FontColor T4];
    [Tool configureLabelBorder:self.numberSelectLabel];
    
//    numberStr=self.numArray[0];//default value
//    self.numberSelectLabel.text=numberStr;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
    [Tool outputResultWithStr:nil textView:self.textView];
}

- (IBAction)presssConnect:(id)sender {
    
    if (![Tool bleIsOpenShowToTextview:self.textView]) {
        return ;
    }
    
    if (!(self.myTextfield.text&&self.myTextfield.text.length)) {
        [Tool outputResultWithStr:NSLocalizedString(@"userid_judgment", nil) textView:self.textView];
    }
    [Tool outputResultWithStr:NSLocalizedString(@"connecting_device", nil) textView:self.textView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SLPBLESharedManager milky:self.selectPeripheral.peripheral loginWithDeviceName:self.selectPeripheral.name deviceCode:numberStr userId:[self.myTextfield.text integerValue] callback:^(SLPDataTransferStatus status, id data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (status==SLPDataTransferStatus_Succeed) {
            MilkyDeviceInfo *devInfo=(MilkyDeviceInfo*)data;
            NSLog(@"device id--->%@",devInfo.deviceID);
            [Tool outputResultWithStr:NSLocalizedString(@"connect_device_successfully", nil) textView:self.textView];
            [self showMainView];
        }
        else
        {
            NSLog(@"login device failed");
            [Tool outputResultWithStr:NSLocalizedString(@"failure", nil) textView:self.textView];
        }
        
    }];
}

///show to mainView
- (void)showMainView
{
    DeviceViewController *deviceVC=[[DeviceViewController alloc]initWithNibName:@"DeviceViewController" bundle:nil];
    deviceVC.title=NSLocalizedString(@"device", nil);
    deviceVC.tabBarItem.image = [UIImage imageNamed:@"home.png"];
    //        deviceVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_home_selected"];
    deviceVC.selectPeripheral=self.selectPeripheral;
    deviceVC.deviceNumberString=numberStr;
    deviceVC.userID=self.myTextfield.text;
    
    ControlViewController *controlVC=[[ControlViewController alloc]initWithNibName:@"ControlViewController" bundle:nil];
    controlVC.title=NSLocalizedString(@"control", nil);
    controlVC.tabBarItem.image = [UIImage imageNamed:@"control.png"];
    //    controlVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_message_center_selected"];
    controlVC.selectPeripheral=self.selectPeripheral;
    controlVC.userID=self.myTextfield.text;
    
    DataViewController *dataVC=[[DataViewController alloc]initWithNibName:@"DataViewController" bundle:nil];
    dataVC.title=NSLocalizedString(@"report", nil);
    dataVC.tabBarItem.image = [UIImage imageNamed:@"data.png"];
    //    dataVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_discover_selected"];
    dataVC.selectPeripheral=self.selectPeripheral;
    dataVC.userID=self.myTextfield.text;
    
    UINavigationController *un1=[[UINavigationController alloc]initWithRootViewController:deviceVC];
    UINavigationController *un2=[[UINavigationController alloc]initWithRootViewController:controlVC];
    UINavigationController *un3=[[UINavigationController alloc]initWithRootViewController:dataVC];
    
    UITabBarController *tabbarVC=[[UITabBarController alloc]init];
    tabbarVC.viewControllers=[NSArray arrayWithObjects:un1,un2,un3,nil];
    self.navigationController.navigationBar.hidden=YES;
    [self.navigationController pushViewController:tabbarVC animated:YES];
}


- (IBAction)selectDeviceNumber:(id)sender {
    
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:self.numArray[0],self.numArray[1],self.numArray[2], nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex<self.numArray.count) {
        numberStr=self.numArray[buttonIndex];
        self.numberSelectLabel.text=[NSString stringWithFormat:@"%@",numberStr];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect=self.view.frame;
        CGFloat y_value=rect.origin.y-120;
        rect.origin.y=y_value;
        self.view.frame=rect;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect=self.view.frame;
        CGFloat y_value=rect.origin.y+120;
        rect.origin.y=y_value;
        self.view.frame=rect;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.myTextfield resignFirstResponder];
}

@end
