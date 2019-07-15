#import <Foundation/Foundation.h>
#include <sys/time.h>

typedef NS_ENUM(NSInteger,KFLogerLevel) {
    KFLogerLevel_Disable = 0x0,
    KFLogerLevel_PrintConsole = 0x01,
    KFLogerLevel_WriteFile = 0x02,
    KFLogerLevel_All = 0x03,
};

extern KFLogerLevel g_Loglevel;

//日志的信息类型
enum KFLoger_Type
{
    LogType_None = -1,
    
    LogType_Normal,       //普通log
    LogType_Debug,        //调试log
    LogType_Warning,      //警告信息log
    LogType_Error,        //错误信息的log
    
    //增加开发使用的log，分为三个级别,0-2, 级别逐渐增加，可以用宏控制是否打印
    LogType_Dev_Level0,
    LogType_Dev_Level1,
    LogType_Dev_Level2,
    
};



//KF日志信息，由调用者创建，传递给KFLoger使用
@interface KFLogInfo : NSObject
{

    char*           _curSourceFileName;         //日志当前的打印代码文件名
    char*           _curFuncName;               //日志当前的模块名
    NSString*       _logTextContent;            //日志的文本内容
    int       _curSourceLineNum;          //当前的行号
    
    struct tm*      _logTime;                   //日志时间
    int       _logType;                   //日志类型
    BOOL            _isNeedSaveFile;            //是否保存文件
}


@property(nonatomic, assign)char* curSourceFileName;
@property(nonatomic, assign)char* curFuncName;
@property(nonatomic, retain)NSString* logTextContent;
@property(nonatomic, assign)int    curSourceLineNum;
@property(nonatomic, assign)struct tm* logTime;
@property(nonatomic, assign)int    logType;
@property(nonatomic, assign)BOOL   isNeedSaveFile;


@end




// KF日志类
@interface KFLoger : NSObject
{

    NSMutableArray*     _logArray;     //按照加入顺序保存日志的队列
    NSFileHandle*       _fileHandle;   //日志的文件句柄
    NSString*           _filePath;     //日志文件路径
    dispatch_queue_t    _logWriteQueue; //日志写对列
}



+(KFLoger*)GetInstance;


- (void)addLog:(NSString*)txtContent sourceName:(const char*)sourceName funcName:(const char*)funcName  lineNum:(int)lineNum logType:(NSInteger)logType isNeedSave:(BOOL)isNeedSave;

- (void)flushLogs;
@end


#define KFSetLogerLevel(level) (g_Loglevel = level)

//封装一个宏,  外部不要直接调用这个宏
#define KFLog(type, needSave,logContent,...)                                                    \
            {                                                                                   \
                if( (logContent != nil))                                                        \
                {                                                                               \
                    NSString* logFormat = [NSString stringWithFormat:logContent,##__VA_ARGS__]; \
                    [[KFLoger GetInstance]addLog:logFormat                                      \
                                       sourceName:__FILE__                                      \
                                         funcName:__FUNCTION__                                  \
                                          lineNum:__LINE__                                      \
                                          logType:type                                          \
                                       isNeedSave:needSave];                                    \
                }                                                                               \
            }                                                                                   \





#pragma mark -------------------------------------------------------对外接口宏定义
#pragma mark --- 不同类型的日志宏，外部直接使用
// needSave: 是否需要写文件保存    logContent: 日志文本内容(NSString)

//普通日志
#define KFLog_Normal(needSave, logContent,...)         KFLog(LogType_Normal, needSave,logContent,##__VA_ARGS__)

//debug日志
#define KFLog_Debug(needSave, logContent,...)          KFLog(LogType_Debug, needSave, logContent,##__VA_ARGS__)

//警告信息日志
#define KFLog_Warning(needSave, logContent,...)        KFLog(LogType_Warning, needSave, logContent,##__VA_ARGS__)

//错误信息日志
#define KFLog_Error(needSave, logContent,...)          KFLog(LogType_Error, needSave, logContent,##__VA_ARGS__)


//开发使用的log, 不同的级别
#define KFLog_Dev0(needSave, logContent,...)           KFLog(LogType_Dev_Level0, needSave, logContent,##__VA_ARGS__)

#define KFLog_Dev1(needSave, logContent,...)           KFLog(LogType_Dev_Level1, needSave, logContent,##__VA_ARGS__)

#define KFLog_Dev2(needSave, logContent,...)           KFLog(LogType_Dev_Level2, needSave, logContent,##__VA_ARGS__)

//强制保存日志到文件
#define KFLog_Flush()       [[KFLoger GetInstance] flushLogs]



//这个宏是用来控制日志全部都写到文件里去
#define KFLog_FORCE(type, needSave,logContent,...)                                                    \
        {                                                                                   \
            if( (logContent != nil))                                                        \
            {                                                                               \
                NSString* logFormat = [NSString stringWithFormat:logContent,##__VA_ARGS__]; \
                [[KFLoger GetInstance]addLog:logFormat                                      \
                sourceName:__FILE__                                      \
                funcName:__FUNCTION__                                  \
                lineNum:__LINE__                                      \
                logType:type                                          \
                isNeedSave:needSave];                                    \
            }                                                                               \
        }                                                                                   \

#define KFLog_WRITE_FILE(needSave, logContent,...)           KFLog_FORCE(LogType_Dev_Level2, needSave, logContent,##__VA_ARGS__)
