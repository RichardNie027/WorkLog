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

//将数据存储在FMDataBase中
+ (void)saveWorkLog:(WorkLogPo *)po;

//存储多条数据进入表中
+ (void)saveWorkLogs:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
