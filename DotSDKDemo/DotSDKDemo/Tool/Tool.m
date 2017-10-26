//
//  Tool.m
//  RestonSDKDemo
//
//  Created by San on 2017/8/2.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+ (void)configSomeKindOfButtonLikeNomal:(UIButton *)button{
    [button setBackgroundImage:[self imageFromColor:[FontColor C1]] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageFromColor:[FontColor C2]] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[self imageFromColor:[FontColor C2]] forState:UIControlStateSelected];
    //    [button setBackgroundImage:[SLPUtils imageFromColor:SLPThemeColor.C1Disable] forState:UIControlStateDisabled];
    //    [button setBackgroundColor:SLPThemeColor.C1Disable];
    [button setTitleColor:[FontColor C9] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageFromColor:[FontColor C1Disable]] forState:UIControlStateDisabled];
    [button.titleLabel setFont:[FontColor T1]];
//    button.titleLabel.adjustsFontSizeToFitWidth=YES;
    button.titleLabel.numberOfLines=0;
    button.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:2.0f];
}


+(void)configureLabelBorder:(UILabel *)label
{
    label.layer.borderWidth=1.0f;
    label.layer.borderColor=[FontColor C1Disable].CGColor;
    label.layer.cornerRadius=2.0f;
    label.backgroundColor=[UIColor whiteColor];
}

+ (UIImage *)imageFromColor:(UIColor *)color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat r,g,b,alpha;
    [color getRed:&r green:&g blue:&b alpha:&alpha];
    
    if (alpha == 1.0){
        return theImage;
    }
    
    UIGraphicsBeginImageContextWithOptions(theImage.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, theImage.size.width, theImage.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, theImage.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (void)outputResultWithStr:(NSString *)str textView:(UITextView *)textview
{
    NSString *oldStr=[self readStringFromDocument];
    if (oldStr&&oldStr.length) {
        if (str&&str.length) {
            oldStr=[NSString stringWithFormat:@"%@\n%@",oldStr,str];
        }
    }
    else
        oldStr=[NSString stringWithFormat:@"%@",str.length?str:@""];
    textview.text =[NSString stringWithFormat:@"%@",oldStr];
    [textview scrollRangeToVisible:NSMakeRange(textview.text.length, 1)];
    textview.layoutManager.allowsNonContiguousLayout = NO;
    [self writeStringToDocument:oldStr];
    oldStr=nil;
}

+(void)writeStringToDocument:(NSString *)stirng
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [array lastObject];
    NSString *documentPath = [document stringByAppendingPathComponent:@"file.txt"];
    [stirng writeToFile:documentPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(NSString *)readStringFromDocument
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [array lastObject];
    NSString *documentPath = [document stringByAppendingPathComponent:@"file.txt"];
    NSString *str = [NSString stringWithContentsOfFile:documentPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *recodeArr=[str componentsSeparatedByString:@"\n"];
    if (recodeArr.count>100) {
        NSArray *newArr=[recodeArr subarrayWithRange:NSMakeRange(recodeArr.count-50, 50)];//最后一段数据
        NSLog(@"oldstring====%@,length---%d",str,str.length);
        str=[newArr componentsJoinedByString:@"\n"];
        
        NSLog(@"newstring====%@,length---%d",str,str.length);
    }
    return str;
}

+ (BOOL)bleIsOpenShowToTextview:(UITextView *)textview
{
    BOOL isOpen=[SLPBLESharedManager blueToothIsOpen];
    if (!isOpen) {
        [Tool outputResultWithStr:NSLocalizedString(@"not_bluetooth", nil) textView:textview];
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"not_bluetooth", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil];
        [alertview show];
    }
    
    return isOpen;
}


+ (BOOL)deviceIsConnected:(CBPeripheral *)periphearl ShowToTextview:(UITextView *)textview
{
    BOOL isConnected=periphearl&&[SLPBLESharedManager peripheralIsConnected:periphearl];
    
    if (!isConnected) {
        if (textview) {
            [Tool outputResultWithStr:NSLocalizedString(@"reconnect_device", nil) textView:textview];
        }
    }
    
    return  isConnected;
}


+ (NSInteger)backDeviceTypeFromDeviceNumber:(NSString*)number
{
    NSArray *arr=[number componentsSeparatedByString:@"-"];
    return [arr[0] integerValue];
}

+ (NSInteger)backDeviceMaterialFromDeviceNumber:(NSString*)number
{
    NSArray *arr=[number componentsSeparatedByString:@"-"];
    return  [arr[1] integerValue];
}

+ (SLPHistoryData *)backLatestHistoryData:(NSMutableArray *)dataArray
{
    SLPHistoryData *tempHistory=[dataArray firstObject];
    
    for ( SLPHistoryData *his in dataArray) {
        if (his.summary.startTime>tempHistory.summary.startTime) {
            tempHistory=his;
        }
    }
    return tempHistory;
}

@end
