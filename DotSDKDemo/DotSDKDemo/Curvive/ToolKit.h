//
//  ToolKit.h
//  RestonSDKDemo
//
//  Created by San on 2017/8/9.
//  Copyright © 2017年 medica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ToolKit : NSObject

+(NSString *)dateToNSString:(NSDate*)date withFormat:(NSString*)format timeZone:(NSInteger)timeZone;

+(NSDate *)stringToNSDate:(NSString*)str withFormat:(NSString *)format  timeZone:(NSInteger)timeZone;

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)h;

+ (UIFont *)fontWithSize:(CGFloat)size;

+ (BOOL)currentLangIsSimplifiedChinese;

+ (CGSize)sizeOfString:(NSString *)string font:(UIFont *)font;

@end
