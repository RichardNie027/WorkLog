//
//  DBHelper.m
//  worklog
//
//  Created by RichardNie on 2022/6/1.
//

#import "DBHelper.h"

static NSString * const dbName = @"xhj_work.db";//数据库名称
static FMDatabase *db;

static NSString * const kTableName = @"WorkLog";
static NSString * const kColumnID = @"jobId";
static NSString * const kColumnJobContent = @"jobContent";
static NSString * const kColumnJobKind = @"jobKind";
static NSString * const kColumnJobDate = @"jobDate";
static NSString * const kColumnJobIdx = @"jobIdx";

@implementation DBHelper

+ (NSString *)dbFilePath {
    return [FCFileManager pathForDocumentsDirectoryWithPath:dbName];
}

+ (BOOL)initDatabase {
    NSLog(@"数据库的存储路径为:%@",[self dbFilePath]);
    db = [FMDatabase databaseWithPath:[self dbFilePath]];
    if (![db open]) {
        NSLog(@"数据库无法开启");
        return NO;
    }
    //创建表
    [self createTable:db];
    return YES;
}

+ (void)closeDatabase {
    [db close];
}

+ (FMDatabase *)getDatabase {
    return db;
}

+ (void)createTable:(FMDatabase *)db {
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ("
                           "%@ INTEGER PRIMARY KEY AUTOINCREMENT,"
                           "%@ TEXT,"
                           "%@ TEXT,"
                           "%@ INTEGER,"
                           "%@ INTEGER)",
                           kTableName,
                           kColumnID,
                           kColumnJobContent,
                           kColumnJobKind,
                           kColumnJobDate,
                           kColumnJobIdx
                           ];
    BOOL success = [db executeUpdate:createSql];
    if (success) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}

+ (void)saveWorkLog:(WorkLogPo *)po {
    //如果原本已经存在了相同的，则应该将其删除
    [self deleteWorkLog:po];
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@(%@,%@,%@,%@) VALUES(?,?,?,?)",kTableName,kColumnJobContent,kColumnJobKind,kColumnJobDate,kColumnJobIdx];
    BOOL success = [db executeUpdate:insertSql,po.jobContent,po.jobKind,@(po.jobDate),@(po.jobIdx)];
    
    if (success) {
        NSLog(@"插入数据成功");
    } else {
        NSLog(@"插入数据失败");
    }
}

+ (void)saveWorkLogs:(NSArray *)array {
    if (array.count <= 0) {
        NSLog(@"保存的数据不能为空");
        return;
    }
    for (int i = 0; i < array.count; i++) {
        WorkLogPo *po = (WorkLogPo *)[array objectAtIndex:i];
        if (po) {
            [self saveWorkLog:po];
        }
    }
}

+ (BOOL)deleteWorkLogById:(NSInteger)jobId {
    BOOL success = YES;
    if(jobId <= 0)
        return success;
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",kTableName,kColumnID];
    BOOL isCan = [db executeUpdate:deleteSql, jobId];
    if (!isCan) {
        success = NO;
        NSLog(@"删除失败");
    } else {
        NSLog(@"删除成功");
    }
    return success;
}

+ (BOOL)deleteWorkLog:(WorkLogPo *)po {
    if(po.jobId <= 0)
        return YES;
    else
        return [self deleteWorkLogById: po.jobId];
}

//todo:unfinished
+ (id)getWorkLogsBefore:(NSDate *)baseDate forDays:(NSInteger) days {
    NSInteger toDate = 20220606;
    NSInteger fromDate = 20220601;
    NSString *searchSql = nil;
    FMResultSet *set = nil;
    searchSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ <= ? AND %@ >= ? ORDER BY %@ DESC, %@",kTableName,kColumnJobDate,kColumnJobDate,kColumnJobDate,kColumnJobIdx];
    set = [db executeQuery:searchSql, fromDate, toDate];
    //执行sql语句，在FMDB中，除了查询语句使用executQuery外，其余的增删改查都使用executeUpdate来实现。
    int i = 0;
    while (set.next) {
        i++;
        NSString *name = [set stringForColumn:@"name"];
        NSLog(@"第%d个名字为:%@",i,name);
    }
    return @[];
}

@end

