//
//  WorkLogPo.h
//  worklog
//
//  Created by RichardNie on 2022/6/1.
//

#import <Foundation/Foundation.h>

@interface WorkLogPo: NSObject<NSCopying, NSMutableCopying>

@property (nonatomic, assign) NSInteger jobId;//AUTOINCREMENT
@property (nonatomic, copy) NSString *jobContent;
@property (nonatomic, copy) NSString *jobKind;//D:done;P:plan;F:future
@property (nonatomic, assign) NSInteger jobDate;//20201231
@property (nonatomic, assign) NSInteger jobIdx;//order base 10, step 10

- (instancetype)initWithJobId:(NSInteger)jobId
                   jobContent:(NSString *)jobContent
                      jobKind:(NSString *)jobKind
                      jobDate:(NSInteger)jobDate
                       jobIdx:(NSInteger)jobIdx;
@end
