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
@end
