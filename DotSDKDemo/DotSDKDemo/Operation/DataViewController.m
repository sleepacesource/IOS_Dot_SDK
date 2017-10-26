//
//  DataViewController.m
//  RestonSDKDemo
//
//  Created by San on 2017/8/1.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "DataViewController.h"
#import <Milky/Milky.h>
#import "Tool.h"
#import "FixView.h"
#import "SleepView.h"
#import "UserObj.h"
#import "SimulateData.h"
#import "ToolKit.h"
#import "MBProgressHUD.h"
#import "SLPTitleValueArrowTableViewCell.h"
#import "DealWithData.h"

@interface DataViewController ()<UITableViewDelegate,UITableViewDataSource,SleepViewDelegate>
{
    NSArray *simulateLongTimeTitle;
    NSArray *simulateShortTimetitle;
    NSArray *titleArray;
    NSArray *valueArray;
    
    UIView *myView;
    FixView *fixView;
    SleepView *sleepview;
    
    NSMutableArray *historyArr;
    
    BOOL isLongData;
    int rowHeight;
}

@property (weak, nonatomic) IBOutlet UIButton *analysisBT;
@property (weak, nonatomic) IBOutlet UIButton *simulateDataBT;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *myDataTableview;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIScrollView *myscorollview;
@property (weak, nonatomic) IBOutlet UIView *cView;

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUI];
    [self addLeftItem];
}

- (void)setUI
{
    [self.myscorollview addSubview:self.cView];
    [Tool configSomeKindOfButtonLikeNomal:self.analysisBT];
    [Tool configSomeKindOfButtonLikeNomal:self.simulateDataBT];
    self.myDataTableview.delegate=self;
    self.myDataTableview.dataSource=self;
    self.myDataTableview.scrollEnabled=NO;
    self.myDataTableview.rowHeight=UITableViewAutomaticDimension;
    self.myDataTableview.estimatedRowHeight=55;
    self.myDataTableview.allowsSelection=NO;
    self.myDataTableview.backgroundColor=[UIColor whiteColor];
    
    myView=[[UIView alloc]initWithFrame:CGRectMake(0,0, self.myDataTableview.frame.size.width, 180)];
    myView.backgroundColor=[UIColor whiteColor];
    [self setGraphviewUI];
    
    historyArr=[[NSMutableArray alloc]initWithCapacity:0];
    
    self.label1.text=NSLocalizedString(@"process", nil);
    [self.analysisBT setTitle:NSLocalizedString(@"sleep_analysis", nil) forState:UIControlStateNormal];
    [self.simulateDataBT setTitle:NSLocalizedString(@"imitate_data", nil) forState:UIControlStateNormal];
    self.textView.layer.borderWidth=1.0f;
    self.textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textView.layer.cornerRadius=2.0f;
    self.textView.textColor=[FontColor C3];
    self.textView.font=[FontColor T4];
    self.label1.textColor=[FontColor C4];
    self.label1.font=[FontColor T3];
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
    BOOL isConnected=self.selectPeripheral.peripheral&&[SLPBLESharedManager peripheralIsConnected:self.selectPeripheral.peripheral];
    self.analysisBT.enabled=isConnected;
    [Tool outputResultWithStr:nil textView:self.textView];
}

- (void)setGraphviewUI
{
    fixView = [[FixView alloc] initWithFrame:CGRectMake(30, 10,([[UIScreen mainScreen] bounds].size.width)-50, 140+13)];
    fixView.backgroundColor = [UIColor clearColor];
    [myView addSubview:fixView];
    
    sleepview = [[SleepView alloc] initWithFrame:CGRectMake(30, 13+10,([[UIScreen mainScreen] bounds].size.width)-50, 140)];
    sleepview.backgroundColor = [UIColor clearColor];
    sleepview.sleepDelegate = self;
    fixView.sleepView = sleepview;
    __weak FixView *myfixView = fixView;
    sleepview.PinBlock = ^(CGFloat x, CGFloat scale){
        myfixView.x = x;
        myfixView.scale = scale;
        [myfixView setNeedsDisplay];
    };
    [myView addSubview:sleepview];
    
    CGFloat h =kSleepViewGridHeight;
    NSArray *strings = [NSArray arrayWithObjects:NSLocalizedString(@"wake_", nil),NSLocalizedString(@"light_", nil),NSLocalizedString(@"mid_", nil),NSLocalizedString(@"deep_", nil), nil];
    
    CGSize labelSize = CGSizeMake(kDetailStatusWidth, h);
    UIFont *labelFont = [ToolKit fontWithSize:10.0];
    if ([ToolKit currentLangIsSimplifiedChinese]) {
        labelFont = [ToolKit fontWithSize:10.0];
    }else{
        labelFont = [ToolKit fontWithSize:6.0];
    }
    for (NSString *txt in strings){
        CGSize size = [ToolKit sizeOfString:txt font:labelFont];
        if (size.width > labelSize.width || size.height > labelSize.height){
            labelFont = [ToolKit fontWithSize:8.0];
            break;
        }
    }
    
    for (int i = 0; i<4; i++){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10+kFontHeight + kSleepViewGridHeight /2 + h * i, labelSize.width ,labelSize.height)];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [FontColor C3];
        label.text = strings[i];
        label.tag = 100+i;
        label.font = labelFont;
        [myView addSubview:label];
    }
}


///data
- (void)initData:(UserObj *)obj
{
    [fixView initDateTime:obj.startTime timeInterval:obj.recordCount timeZone:[obj.timezone intValue]];
    [fixView setNeedsDisplay];
    
    sleepview.frame = CGRectMake(30, 13+2+10, fixView.frame.size.width, fixView.frame.size.height);
    sleepview.asleepTime = [obj.asleepTime intValue];
    sleepview.currentObj = obj;
    //呼吸暂停、离床、心跳暂停都在这添加
    [sleepview sampleSleepData:obj.sleepStateStr status:obj.statusString];
    [sleepview setNeedsDisplay];
}

///数据分析
- (IBAction)analysisSleep:(id)sender {
    
    if (![Tool bleIsOpenShowToTextview:self.textView]) {
        return ;
    }
    if (![Tool deviceIsConnected:self.selectPeripheral.peripheral ShowToTextview:self.textView]) {
        return ;
    }
    
    [self downloadSleepData];
}

- (void)downloadSleepData
{
    [Tool outputResultWithStr:NSLocalizedString(@"data_analyzed", nil) textView:self.textView];
    [historyArr removeAllObjects];
    long startTime = 0  ;
    long endTime = [[NSDate date] timeIntervalSince1970];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SLPBLESharedManager milky:self.selectPeripheral.peripheral personType:SLPSleepPersonType_Male historyDownloadWithStartTime:startTime endTime:endTime eachDataCallback:^(SLPDataTransferStatus status, id data) {
        SLPHistoryData *historyData=(SLPHistoryData *)data;
        [historyArr addObject:historyData];
        NSLog(@"download history data:>%@",historyData);
//                [SimulateData dealwithData:historyData];
    } finishCallback:^(SLPDataTransferStatus status, id data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"download history data finished");
        if (!historyArr.count) {
            [Tool outputResultWithStr:NSLocalizedString(@"no_data", nil) textView:self.textView];
            return;
        }
        else///deal with data
        {
            [self showReportwith: [SimulateData dealwithData:[Tool backLatestHistoryData:historyArr]]];
        }
    }];
}

- (IBAction)simulateData:(id)sender {
    
    [Tool outputResultWithStr:NSLocalizedString(@"imitate_data", nil) textView:self.textView];
    [self showReportwith:[SimulateData simulateData]];
}


- (void)initTableviewTitle:(BOOL)longReport
{
    if (longReport) {
        titleArray=@[NSLocalizedString(@"collection_date", nil),
                     NSLocalizedString(@"sleep_scores", nil),
                     NSLocalizedString(@"deduction_points", nil),
                     NSLocalizedString(@"sleeping_time", nil),
                     NSLocalizedString(@"sleep_duration", nil),
                     NSLocalizedString(@"fall_asleep_duration", nil),
                     NSLocalizedString(@"deep_sleep_proportion", nil),
                     NSLocalizedString(@"medium_sleep_proportion", nil),
                     NSLocalizedString(@"light_sleep_proportion", nil),
                     NSLocalizedString(@"sober_proportion", nil),
                     NSLocalizedString(@"wake_times", nil)
                     ];
    }
    else
    {
        titleArray=@[NSLocalizedString(@"collection_date", nil),
                     NSLocalizedString(@"sleep_duration", nil),
                     NSLocalizedString(@"sleeping_time", nil)
                     ];
    }
}


#pragma mark -UITableViewDelegate & UITableViewDataSource
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (isLongData) {
//        if (indexPath.row==2) {
//            return  rowHeight;
//        }
//        else
//            return 55;
//    }
//    else
//        return  55;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return titleArray.count?2:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        return 1;
    }
    else
        return titleArray.count-1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height=0.0001;
    switch (section) {
        case 1:
        {
            if (isLongData)
            {
                height=180.0f;
            }
        }
            break ;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView=nil;
    switch (section) {
        case 1:
        {
            if (isLongData)
            {
                headView=myView;
            }
        }
            break ;
        default:
            break;
    }
    return headView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLPTitleValueArrowTableViewCell *cell = [SLPTitleValueArrowTableViewCell cellWithTableView:tableView];
    switch (indexPath.section) {
        case 0:
        {
            cell.titleLabel.text=titleArray[indexPath.row];
            cell.detailInfoLabel.text=[NSString stringWithFormat:@"%@",valueArray[indexPath.row]];
        }
            break;
        case 1:
        {
            if (isLongData) {
                cell.titleLabel.text=titleArray[indexPath.row+1];
                switch (indexPath.row) {
                    case 1:
                    {
                        cell.detailInfoLabel.text=[NSString stringWithFormat:@"%@",[self backDeductionStringFromName:[valueArray[indexPath.row+1] objectAtIndex:0] value:[valueArray[indexPath.row+1] objectAtIndex:1]]];
                    }
                        break;
                    default:
                    {
                        cell.detailInfoLabel.text=[NSString stringWithFormat:@"%@",valueArray[indexPath.row+1]];
                    }
                        break;
                }
            }
            else
            {
                cell.titleLabel.text=titleArray[indexPath.row+1];
                cell.detailInfoLabel.text=[NSString stringWithFormat:@"%@",valueArray[indexPath.row+1]];
            }
        }
            break ;
        default:
            break;
    }
    
    return cell;
    
}

- (void)showReportwith:(UserObj*)obj
{
    if ([obj.InvalidFlag integerValue]!=0) {
        [Tool outputResultWithStr:NSLocalizedString(@"data_exception", nil) textView:self.textView];
        return ;
    }
    NSString *versionStr=[NSString stringWithFormat:NSLocalizedString(@"generate_sleep_report", nil),obj.arithmeticVer];
    [Tool outputResultWithStr:versionStr textView:self.textView];
    int space=-100;
    if ([obj.reportFlag integerValue]==2) {
        isLongData=NO;
    }
    else
    {
        space=100;
        isLongData=YES;
        [self initData:obj];
    }
    valueArray=[DealWithData backDataArray:obj];
    [self initTableviewTitle:isLongData];
    CGRect rect=self.view.frame;
    int  height=titleArray.count*55+rect.size.height+space;
    rect.size.height=height;
    self.myscorollview.contentSize=rect.size;
    [self.myDataTableview reloadData];
}


- (NSString*)backDeductionStringFromName:(NSArray *)nameArr value:(NSArray *)valueArr
{
    rowHeight=nameArr.count*20;
    NSMutableString *result=[[NSMutableString alloc]initWithCapacity:0];
    for (int i=0; i<nameArr.count; i++) {
        [result appendString:[NSString stringWithFormat:@"%@  %@\n",NSLocalizedString(nameArr[i], nil),valueArr[i]]];
    }
    return result;
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
