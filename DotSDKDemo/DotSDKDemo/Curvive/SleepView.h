//
//  SleepView.h
//  test
//
//
//  
//

#import <UIKit/UIKit.h>
#import "UserObj.h"

#define FALL_ASLEEP 1
#define GET_UP 2
#define LEFT_BED 4
#define BREATH_STOP 8
#define HEART_STOP 16

@class SleepView;

typedef void(^pinChangeBlock)(CGFloat f, CGFloat scale);


@protocol SleepViewDelegate <NSObject>

-(void)SleepViewClickHuxiButton:(SleepView *)sleepView btn:(UIButton *)btn ;

- (void)SleepViewClickHeartStopButton:(SleepView *)sleepView btn:(UIButton *)btn;

@end

@interface SleepView : UIScrollView<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,copy)pinChangeBlock PinBlock;
@property (nonatomic,weak) id <SleepViewDelegate> sleepDelegate;
@property (nonatomic, strong)NSMutableArray *fallasleepPoints;
@property (nonatomic, strong)NSMutableArray *curvePoints;
@property (nonatomic, strong)NSMutableArray *leavePoints;
@property (nonatomic, strong)NSMutableArray *huxiPoints;
@property (nonatomic, strong)NSMutableArray *getUpPoints;

@property (nonatomic)int asleepTime;//入睡时间

@property (nonatomic)CGPoint anchorPoint;//两手触摸屏幕时候，两手的中间点
@property (nonatomic)CGFloat contentOffX;//父亲控件scrollview的contentOffX
@property (nonatomic)CGFloat anchorXchange;//保存两手中间点的X轴变化值
@property (nonatomic)CGFloat originalWidth;//保存自身的原始宽度

//曲线测试
@property (nonatomic,strong)UserObj *currentObj;

//入口
- (void)sampleSleepData:(NSString *)sleepStrings status:(NSString *)statusString;

//
- (void)getAllCurvePoints:(NSMutableArray *)points;

//
- (void)scalePoint:(CGFloat)scale;
@end
