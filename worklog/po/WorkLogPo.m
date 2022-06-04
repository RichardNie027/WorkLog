//
//  WorkLogPo.m
//  worklog
//
//  Created by RichardNie on 2022/6/1.
//

#import <Foundation/Foundation.h>
#import "WorkLogPo.h"

@implementation WorkLogPo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.jobId =  -1L;
        self.jobIdx = 99L;
    }
    return self;
}

- (instancetype)initWithJobId:(NSInteger)jobId
                   jobContent:(NSString *)jobContent
                      jobKind:(NSString *)jobKind
                      jobDate:(NSInteger)jobDate
                       jobIdx:(NSInteger)jobIdx
{
    self = [self init];
    if(self) {
        if(jobId > 0)
            self.jobId = jobId;
        if(jobContent)
            self.jobContent = jobContent;
        if(jobKind)
            self.jobKind = jobKind;
        if(jobDate > 0)
            self.jobDate = jobDate;
        if(jobIdx > 0)
            self.jobIdx = jobIdx;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    NSLog(@"===isEqual:self:%@,object:%@",self,object);
//    return [super isEqual:object];
    if(self == object) {
        return YES;
    }
    else {
        if (self.jobId == ((WorkLogPo *)object).jobId &&
            self.jobKind == ((WorkLogPo *)object).jobKind &&
            self.jobIdx == ((WorkLogPo *)object).jobIdx &&
            [self.jobContent isEqualToString:((WorkLogPo *)object).jobContent] &&
            [self.jobKind isEqualToString:((WorkLogPo *)object).jobKind]) {
            return YES;
        }
        return NO;
    }
}

#pragma mark - <NSCopying, NSMutableCopying>
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    WorkLogPo *workLogPo = [[[self class] allocWithZone:zone] init];
    workLogPo.jobContent = self.jobContent;
    workLogPo.jobKind = self.jobKind;
    workLogPo.jobId = self.jobId;
    workLogPo.jobDate = self.jobDate;
    workLogPo.jobIdx = self.jobIdx;
    return workLogPo;
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    WorkLogPo *workLogPo = [[[self class] allocWithZone:zone] init];
    //workLogPo.jobContent = [self.jobContent copy]; // 浅拷贝
    workLogPo.jobContent = [self.jobContent mutableCopy]; // 深拷贝
    workLogPo.jobKind = [self.jobKind mutableCopy]; // 深拷贝
    workLogPo.jobId = self.jobId;
    workLogPo.jobDate = self.jobDate;
    workLogPo.jobIdx = self.jobIdx;
    return workLogPo;
}

@end
