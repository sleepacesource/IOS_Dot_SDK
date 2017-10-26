//
//  AutoMonitorViewController.m
//  RestonSDKDemo
//
//  Created by San on 2017/7/27.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "AutoMonitorViewController.h"
#import "Tool.h"

@interface AutoMonitorViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *hourArr;
    NSMutableArray *minArr;
    
    NSInteger hour;
    NSInteger min;
    int indexSection;
}

@property (weak, nonatomic) IBOutlet UIPickerView *myPicker;
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (weak, nonatomic) IBOutlet UIButton *saveBT;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@end

#define NIGHT_MINUTE (180)
static const NSInteger kMaxMonitorMinute = 16 *60;

@implementation AutoMonitorViewController

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray=@[NSLocalizedString(@"start_time", nil),NSLocalizedString(@"end_time", nil)];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
}

- (void)setUI
{
    [Tool configSomeKindOfButtonLikeNomal:self.saveBT];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.saveBT setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
    self.mytableView.delegate=self;
    self.mytableView.dataSource=self;
//    self.mytableView.scrollEnabled=NO;
    [self initData];
    _valueArray=[[NSMutableArray alloc]initWithObjects:@"22:00",@"07:00", nil];
    indexSection=0;
    [self indexPickerSection:indexSection];
    self.label1.textColor=[FontColor C4];
    self.label1.font=[FontColor T3];
    self.label1.text=NSLocalizedString(@"remark_1", nil);
}

- (void)indexPickerSection:(int)section
{
    if (section==0) {
        NSString *start_t=[_valueArray firstObject];
        [self.myPicker selectRow:[hourArr indexOfObject:[[start_t componentsSeparatedByString:@":"] firstObject]] inComponent:0 animated:NO];
        [self.myPicker selectRow:[minArr indexOfObject:@"00"] inComponent:1 animated:NO];
    }
    else
    {
        NSString *end_t=[_valueArray lastObject];
        [self.myPicker selectRow:[hourArr indexOfObject:[[end_t componentsSeparatedByString:@":"] firstObject]] inComponent:0 animated:NO];
        [self.myPicker selectRow:[minArr indexOfObject:@"00"] inComponent:1 animated:NO];
    }
}

- (void)initData
{
    hourArr=[[NSMutableArray alloc]initWithCapacity:0];
    minArr=[[NSMutableArray alloc]initWithCapacity:0];
    hour=0;
    min=0;
    
    for (int i=0; i<24; i++) {
        [hourArr addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    for (int i=0; i<60; i++) {
        [minArr addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    self.myPicker.delegate=self;
    self.myPicker.dataSource=self;
    self.myPicker.showsSelectionIndicator=YES;
}

- (IBAction)saveData:(id)sender {
    
    if (![Tool bleIsOpenShowToTextview:nil]) {
        return ;
    }
    if (![Tool deviceIsConnected:self.selectPeripheral.peripheral ShowToTextview:nil]) {
        return ;
    }
    
    NSLog(@"duration strat--%@,end---%@",[_valueArray firstObject],[_valueArray lastObject]);
    
    NSString *start_t=[_valueArray firstObject];
    NSString *end_t=[_valueArray lastObject];
    
    int s_t_h=[[[start_t componentsSeparatedByString:@":"] firstObject] integerValue];
    int s_t_m=[[[start_t componentsSeparatedByString:@":"] lastObject] integerValue];
    
    //    int e_t_h=[[[end_t componentsSeparatedByString:@":"] firstObject] integerValue];
    //    int e_t_m=[[[end_t componentsSeparatedByString:@":"] lastObject] integerValue];
//    NSString *message;
//    BOOL result = YES;
    NSInteger minuteInteral = [self timeIntervalWithStartTime:start_t endTime:end_t];
//    if (minuteInteral < NIGHT_MINUTE) {
//        result = NO;
//        message=NSLocalizedString(@"MonitorTimeLess", nil);
//    } else if (kMaxMonitorMinute < minuteInteral) {
//        result = NO;
//        message=NSLocalizedString(@"MonitorTimeMore", nil);
//    }
//    if (!result) {
//        [Tool outputResultWithStr:message textView:nil];
//        return ;
//    }
    NSString *pStr=[NSString stringWithFormat:NSLocalizedString(@"writing_monitoring_period_device", nil),start_t,end_t];
    [Tool outputResultWithStr:pStr textView:nil];
    [SLPBLESharedManager milky:self.selectPeripheral.peripheral setAutoCollectionWithHour:s_t_h minute:s_t_m timeLength:minuteInteral timeout:10.0 callback:^(SLPDataTransferStatus status, id data) {
        if (status==SLPDataTransferStatus_Succeed) {
            NSLog(@"设置自动监测成功");
            [Tool outputResultWithStr:NSLocalizedString(@"write_success", nil) textView:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [Tool outputResultWithStr:NSLocalizedString(@"failure", nil) textView:nil];
            NSLog(@"设置自动监测失败");
        }
    }];
}

#pragma mark - PickerView delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 24;
        case 1:
            return 60;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return hourArr[row];
            break ;
        case 1:
            return minArr[row];
            break ;
        default:
            return 0;
            break;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
        {
            //            [pickerView selectRow:[pickerView selectedRowInComponent:component]%[compentArray count]+base10 inComponent:component animated:false];
            hour=[[hourArr objectAtIndex:row]integerValue];
        }
            break;
        case 1:
        {
            min=[[minArr objectAtIndex:row] integerValue];
        }
            break;
        default:
            break;
    }
    
    NSLog(@"did select hour->%ld,min->%ld",(long)hour,(long)min);
    
    if (indexSection==0) {
        
        NSString *f_t=[NSString stringWithFormat:@"%02d:%02d",hour,min];
        [self.valueArray replaceObjectAtIndex:0 withObject:f_t];
    }
    else
    {
        NSString *f_t=[NSString stringWithFormat:@"%02d:%02d",hour,min];
        [self.valueArray replaceObjectAtIndex:1 withObject:f_t];
    }
    
    [self.mytableView reloadData];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
{
    return  80;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
{
    return 60.0f;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellWithIdentifier = @"cellWithIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellWithIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.text=self.titleArray[indexPath.row];
    cell.detailTextLabel.text=self.valueArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexSection=indexPath.row;
    [self indexPickerSection:indexSection];
    
    if (indexSection==0) {
        NSString *time=[_valueArray firstObject];
        NSString *f_h=[[time componentsSeparatedByString:@":"] firstObject];
        NSString *f_m=[[time componentsSeparatedByString:@":"] lastObject];
        [self.myPicker selectRow:[hourArr indexOfObject:f_h] inComponent:0 animated:NO];
        [self.myPicker selectRow:[hourArr indexOfObject:f_m] inComponent:1 animated:NO];
    }
    else
    {
        NSString *time=[_valueArray lastObject];
        NSString *f_h=[[time componentsSeparatedByString:@":"] firstObject];
        NSString *f_m=[[time componentsSeparatedByString:@":"] lastObject];
        [self.myPicker selectRow:[hourArr indexOfObject:f_h] inComponent:0 animated:NO];
        [self.myPicker selectRow:[hourArr indexOfObject:f_m] inComponent:1 animated:NO];
    }
}



- (NSInteger)timeIntervalWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    
    int s_t_h=[[[startTime componentsSeparatedByString:@":"] firstObject] integerValue];
    int s_t_m=[[[startTime componentsSeparatedByString:@":"] lastObject] integerValue];
    
    int e_t_h=[[[endTime componentsSeparatedByString:@":"] firstObject] integerValue];
    int e_t_m=[[[endTime componentsSeparatedByString:@":"] lastObject] integerValue];
    
    NSInteger minuteSumBegin = s_t_h *60 + s_t_m;
    NSInteger minuteSumEnd = e_t_h *60 + e_t_m;
    if (minuteSumEnd <= minuteSumBegin){
        minuteSumEnd = 24*60 + minuteSumEnd;
    }
    NSInteger timeInterval = minuteSumEnd - minuteSumBegin;
    return timeInterval;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
