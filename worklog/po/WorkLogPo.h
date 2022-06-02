//
//  WorkLogPo.h
//  worklog
//
//  Created by RichardNie on 2022/6/1.
//

#import <Foundation/Foundation.h>

@interface WorkLogPo: NSObject

@property (nonatomic, assign) NSInteger jobId;//AUTOINCREMENT
@property (nonatomic, copy) NSString *jobContent;
@property (nonatomic, copy) NSString *jobKind;//D:done;P:plan
@property (nonatomic, assign) NSInteger jobDate;//20201231
@property (nonatomic, assign) NSInteger jobIdx;//order base 0

@end
