//
//  TodayTableViewController.h
//  worklog
//
//  Created by RichardNie on 2022/5/29.
//

#import <UIKit/UIKit.h>
#import "CommonHeaders.h"
#import "WorkLogPo.h"

@interface NotedownTableViewController : UITableViewController

//传值（返回值）
@property (nonatomic, strong) NSMutableDictionary *parameters;

//表格数据源
@property (nonatomic, strong) NSMutableArray<NSMutableArray<WorkLogPo *> *> *jobList;

//新增一笔工作记录;
- (void)addNewJob;

@end

