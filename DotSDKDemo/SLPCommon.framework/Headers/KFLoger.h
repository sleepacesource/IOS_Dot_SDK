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
typedef NS_ENUM(NSInteger, KFLogLevelType) { // 日志等级
    KFLogLevelType_Off = 0, // 日志关
    KFLogLevelType_Log,  //普通log
    KFLogLevelType_Info, //调试log
    KFLogLevelType_Warn, //警告信息log
    KFLogLevelType_Error //错误信息的log
};

extern KFLogLevelType g_logerType;

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
    BOOL            _isWithPrefix;            //是否打印日志的前缀
    BOOL            _isLogFromJs;             // 是否是JS日志
}


@property(nonatomic, assign)char* curSourceFileName;
@property(nonatomic, assign)char* curFuncName;
@property(nonatomic, retain)NSString* logTextContent;
@property(nonatomic, assign)int    curSourceLineNum;
@property(nonatomic, assign)struct tm* logTime;
@property(nonatomic, assign)int    logType;
@property(nonatomic, assign)BOOL   isNeedSaveFile;
@property(nonatomic, assign)BOOL   isWithPrefix;
@property(nonatomic, assign)BOOL   isLogFromJs;


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


- (void)addLog:(NSString*)txtContent sourceName:(const char*)sourceName funcName:(const char*)funcName  lineNum:(int)lineNum logType:(NSInteger)logType isWithPrefix:(BOOL)isWithPrefix isLogFromJs:(BOOL)isLogFromJs isNeedSave:(BOOL)isNeedSave;

- (void)flushLogs;
@end


#define KFSetLogerLevel(level) (g_Loglevel = level)

#define KFSetLogerType(type) (g_logerType = type)

//封装一个宏,  外部不要直接调用这个宏
#define KFLog(type, needSave, withPrefix, logFromJs,logContent,...)                                                    \
            {                                                                                   \
                if( (logContent != nil))                                                        \
                {                                                                               \
                    NSString* logFormat = [NSString stringWithFormat:logContent,##__VA_ARGS__]; \
                    [[KFLoger GetInstance]addLog:logFormat                                      \
                                       sourceName:__FILE__                                      \
                                         funcName:__FUNCTION__                                  \
                                          lineNum:__LINE__                                      \
                                          logType:type                                          \
                                     isWithPrefix:withPrefix                                 \
                                     isLogFromJs:logFromJs                                 \
                                       isNeedSave:needSave];                                    \
                }                                                                               \
            }                                                                                   \





#pragma mark -------------------------------------------------------对外接口宏定义
#pragma mark --- 不同类型的日志宏，外部直接使用
// needSave: 是否需要写文件保存    logContent: 日志文本内容(NSString)
// withPrefix: 是否需要打印前缀    日期，文件名等
// logFromJs:  是否是前端的JS日志


//普通日志
#define KFLog_Normal(needSave, withPrefix, logFromJs, logContent,...)         KFLog(KFLogLevelType_Log, needSave, withPrefix, logFromJs, logContent,##__VA_ARGS__)

//debug日志
#define KFLog_Debug(needSave, withPrefix, logFromJs, logContent,...)          KFLog(KFLogLevelType_Info, needSave, withPrefix, logFromJs, logContent,##__VA_ARGS__)

//警告信息日志
#define KFLog_Warning(needSave, withPrefix, logFromJs, logContent,...)        KFLog(KFLogLevelType_Warn, needSave, withPrefix, logFromJs, logContent,##__VA_ARGS__)

//错误信息日志
#define KFLog_Error(needSave, withPrefix, logFromJs, logContent,...)          KFLog(KFLogLevelType_Error, needSave, withPrefix, logFromJs, logContent,##__VA_ARGS__)

//强制保存日志到文件
#define KFLog_Flush()       [[KFLoger GetInstance] flushLogs]



//这个宏是用来控制日志全部都写到文件里去
#define KFLog_FORCE(type, needSave, withPrefix, logFromJs, logContent,...)                                                    \
        {                                                                                   \
            if( (logContent != nil))                                                        \
            {                                                                               \
                NSString* logFormat = [NSString stringWithFormat:logContent,##__VA_ARGS__]; \
                [[KFLoger GetInstance]addLog:logFormat                                      \
                sourceName:__FILE__                                      \
                funcName:__FUNCTION__                                  \
                lineNum:__LINE__                                      \
                logType:type                                          \
                isWithPrefix:withPrefix                                          \
                isLogFromJs:logFromJs                                          \
                isNeedSave:needSave];                                    \
            }                                                                               \
        }                                                                                   \

#define KFLog_WRITE_FILE(needSave, withPrefix, logFromJs, logContent,...)           KFLog_FORCE(LogType_Dev_Level2, needSave, withPrefix, logFromJs, logContent,##__VA_ARGS__)
