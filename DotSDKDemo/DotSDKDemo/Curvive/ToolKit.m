//
//  ToolKit.m
//  RestonSDKDemo
//
//  Created by San on 2017/8/9.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "ToolKit.h"

@implementation ToolKit

+(NSString *)dateToNSString:(NSDate*)date withFormat:(NSString*)format timeZone:(NSInteger)timeZone
{
    if (labs(timeZone) < 25)
    {
        timeZone *= 3600;
    }
    else if (labs(timeZone) > 25 * 3600)
    {
        timeZone /= 3600;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:timeZone]];
    [dateFormatter setDateFormat:format];
    NSString *string = [dateFormatter stringFromDate:date];
    
    return string;
}

+(NSDate *)stringToNSDate:(NSString*)str withFormat:(NSString *)format  timeZone:(NSInteger)timeZone
{
    if (labs(timeZone) < 25)
    {
        timeZone *= 3600;
    }
    else if (labs(timeZone) > 25 * 3600)
    {
        timeZone /= 3600;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:timeZone]];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:str];
    return date;
}

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)h
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:h];
    
    return result;
}

+ (UIFont *)fontWithSize:(CGFloat)size{
    return [UIFont systemFontOfSize:size];
}

+ (BOOL)currentLangIsSimplifiedChinese
{
    NSString *currentLang = [self getPreferredLanguage];
    NSString *spstr = @"zh-Hans";
    if ([currentLang rangeOfString:spstr].location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

+ (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

+ (CGSize)sizeOfString:(NSString *)string font:(UIFont *)font{
    CGSize textSize = {CGFLOAT_MAX, CGFLOAT_MAX };
    CGRect rect = [string boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
    return rect.size;
}

@end
