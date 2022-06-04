//
//  RecentTableViewController.h
//  worklog
//
//  Created by RichardNie on 2022/6/4.
//

#import <UIKit/UIKit.h>
#import "CommonHeaders.h"
#import "WorkLogPo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecentTableViewController : UITableViewController

//表格数据源
@property (nonatomic, strong) NSMutableArray<NSMutableArray<WorkLogPo *> *> *jobList;

- (void)resetBarItemsWithState:(NSInteger)state;

@end

NS_ASSUME_NONNULL_END
