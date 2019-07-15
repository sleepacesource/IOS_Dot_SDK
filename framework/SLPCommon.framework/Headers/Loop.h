//
//  Loop.h
//  Test
//
//  Created by Martin on 29/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Loop : NSObject
@property (nonatomic, assign) NSInteger loopCount;

/**
 外部重写这个方法
 
 @param index 循环的index
 @param completion 外部事件处理结束返回
 */
- (void)loopIndex:(NSInteger)index completion:(void(^)(BOOL bContinue))completion;


/**
 开始循环
 
 @param completion 循环结束
 */
- (void)runCompletion:(void(^)(void))completion;
@end
