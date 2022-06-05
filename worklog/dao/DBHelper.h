//
//  DBHelper.h
//  worklog
//
//  Created by RichardNie on 2022/6/1.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "WorkLogPo.h"
#import "FCFileManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBHelper : NSObject

+ (BOOL)initDatabase;
+ (void)closeDatabase;
+ (FMDatabase *)getDatabase;

//删除数据
+ (BOOL)deleteWorkLog:(WorkLogPo *)po;
+ (BOOL)deleteWorkLogById:(NSInteger)jobId;

//获取数据
+ (WorkLogPo *)fetchWorkLogById:(NSInteger)jobId;

//将数据存储在FMDataBase中
+ (BOOL)saveWorkLog:(WorkLogPo *)po;

//存储多条数据进入表中
+ (void)saveWorkLogs:(NSArray *)array;

//查询数据
+ (NSArray<WorkLogPo *> *)queryWorkLogsOn:(NSDate *) baseDate forDays:(NSInteger) days includeFuture:(BOOL)includeF;
//查询某天某类数据的记录数
+ (NSInteger)queryWorkLogsCountOn:(NSDate *) baseDate withJobKind:(NSString *) jobKind;
//重建排序索引
+ (void)reIndexWorkLog:(NSDate *) baseDate;

//清除指定天数之前的记录
+ (BOOL)cleanWorkLogsBeforeDays:(NSInteger) days;

@end

NS_ASSUME_NONNULL_END
