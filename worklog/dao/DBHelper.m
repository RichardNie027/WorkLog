//
//  DBHelper.m
//  worklog
//
//  Created by RichardNie on 2022/6/1.
//

#import "DBHelper.h"
#import "CommonHeaders.h"

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
                           "%@ INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
                           "%@ TEXT NOT NULL,"
                           "%@ CHAR(1) NOT NULL,"
                           "%@ INTEGER NOT NULL,"
                           "%@ INTEGER NOT NULL)",
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

+ (WorkLogPo *)fetchWorkLogById:(NSInteger)jobId {
    if (jobId < 0)
        return nil;
    NSString *searchSql = nil;
    FMResultSet *set = nil;
    searchSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",kTableName,kColumnID];
    set = [db executeQuery:searchSql, @(jobId)];
    //执行sql语句，在FMDB中，除了查询语句使用executQuery外，其余的增删改查都使用executeUpdate来实现。
    if (set.next) {
        NSInteger jobId = [set intForColumn:kColumnID];
        NSString *jobContent = [set stringForColumn:kColumnJobContent];
        NSString *jobKind = [set stringForColumn:kColumnJobKind];
        NSInteger jobDate = [set intForColumn:kColumnJobDate];
        NSInteger jobIdx = [set intForColumn:kColumnJobIdx];
        WorkLogPo *po = [[WorkLogPo alloc]initWithJobId:jobId jobContent:jobContent jobKind:jobKind jobDate:jobDate jobIdx:jobIdx];
        return po;
    } else
        return nil;
}

+ (BOOL)saveWorkLog:(WorkLogPo *)po {
    BOOL success = NO;
    WorkLogPo *workLogPo = po.jobId < 0 ? nil : [self fetchWorkLogById:po.jobId];
    if (workLogPo) {
        if (![workLogPo isEqual:po]) {
            NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@=?,%@=?,%@=?,%@=? WHERE %@=?",kTableName,kColumnJobContent,kColumnJobKind,kColumnJobDate,kColumnJobIdx,kColumnID];
            success = [db executeUpdate:updateSql,po.jobContent,po.jobKind,@(po.jobDate),@(po.jobIdx),@(po.jobId)];
        } else
            success = YES;
    } else {
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@(%@,%@,%@,%@) VALUES(?,?,?,?)",kTableName,kColumnJobContent,kColumnJobKind,kColumnJobDate,kColumnJobIdx];
        success = [db executeUpdate:insertSql,po.jobContent,po.jobKind,@(po.jobDate),@(po.jobIdx)];
    }
    if (success) {
        NSLog(@"保存数据成功");
    } else {
        NSLog(@"保存数据失败");
    }
    return success;
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
    BOOL isCan = [db executeUpdate:deleteSql, @(jobId)];
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

+ (NSArray<WorkLogPo *> *)queryWorkLogsOn:(NSDate *) baseDate forDays:(NSInteger) days includeFuture:(BOOL)includeF {
    NSMutableArray<WorkLogPo *> *result = [[NSMutableArray alloc]init];
    NSInteger toDate = [NSDate dateToInteger: baseDate];
    NSInteger fromDate = [NSDate dateToInteger: [NSDate date:baseDate addYears:0 Month:0 addDays:1-days]];
    NSString *searchSql = nil;
    FMResultSet *set = nil;
    if (includeF) {
        searchSql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM %@ WHERE %@ >= ? AND %@ <= ? AND %@ != ? ORDER BY %@ DESC, %@, %@) "
                     "UNION ALL SELECT * FROM (SELECT * FROM %@ WHERE %@ = ? ORDER BY %@, %@)",
                     kTableName,kColumnJobDate,kColumnJobDate,kColumnJobKind,kColumnJobDate,kColumnJobKind,kColumnJobIdx,
                     kTableName,kColumnJobKind,kColumnJobKind,kColumnJobIdx];
        set = [db executeQuery:searchSql, @(fromDate), @(toDate), @"F", @"F"];
    } else {
        searchSql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM %@ WHERE %@ >= ? AND %@ <= ? AND %@ != ? ORDER BY %@ DESC, %@, %@) ",
                     kTableName,kColumnJobDate,kColumnJobDate,kColumnJobKind,kColumnJobDate,kColumnJobKind,kColumnJobIdx];
        set = [db executeQuery:searchSql, @(fromDate), @(toDate), @"F"];
    }
    //执行sql语句，在FMDB中，除了查询语句使用executQuery外，其余的增删改查都使用executeUpdate来实现。
    while (set.next) {
        NSInteger jobId = [set intForColumn:kColumnID];
        NSString *jobContent = [set stringForColumn:kColumnJobContent];
        NSString *jobKind = [set stringForColumn:kColumnJobKind];
        NSInteger jobDate = [set intForColumn:kColumnJobDate];
        NSInteger jobIdx = [set intForColumn:kColumnJobIdx];
        [result addObject: [[WorkLogPo alloc]initWithJobId:jobId jobContent:jobContent jobKind:jobKind jobDate:jobDate jobIdx:jobIdx]];
    }
    NSLog(@"数据已重新查询");
    return [result copy];
}

+ (NSInteger)queryWorkLogsCountOn:(NSDate *)baseDate withJobKind:(NSString *) jobKind {
    NSInteger toDate = [NSDate dateToInteger: baseDate];
    NSString *searchSql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@ = ? AND %@ = ?", kTableName, kColumnJobDate, kColumnJobKind];
    FMResultSet *set = [db executeQuery:searchSql, @(toDate), jobKind];
    NSInteger totalCount = 0;
    if ([set next]) {
        totalCount = [set intForColumnIndex:0];
    }
    return totalCount;
}

+ (void)reIndexWorkLog:(NSDate *) baseDate {
    NSInteger toDate = [NSDate dateToInteger: baseDate];
    NSString *searchSql = nil;
    FMResultSet *set = nil;
    searchSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? OR %@ = ? ORDER BY %@, %@",kTableName,kColumnJobDate,kColumnJobKind,  kColumnJobKind,kColumnJobIdx];
    set = [db executeQuery:searchSql, @(toDate), @"F"];
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?",kTableName,kColumnJobIdx,kColumnID];
    //执行sql语句，在FMDB中，除了查询语句使用executQuery外，其余的增删改查都使用executeUpdate来实现。
    NSInteger lastIdx = 10;
    NSString *lastKind = nil;
    while (set.next) {
        NSInteger jobId = [set intForColumn:kColumnID];
        NSString *jobKind = [set stringForColumn:kColumnJobKind];
        if(!lastKind)
            lastKind = jobKind;
        if(![lastKind isEqualToString:jobKind]) {
            lastIdx = 10;
            lastKind = jobKind;
        }
        BOOL res = [db executeUpdate:updateSql, @(lastIdx), @(jobId)];
        lastIdx = lastIdx + 10;
        if(!res)
            NSLog(@"数据已重建索引出错");
    }
    NSLog(@"数据已重建索引");
}

@end

