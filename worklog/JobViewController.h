//
//  JobViewController.h
//  worklog
//
//  Created by RichardNie on 2022/5/31.
//

#import <UIKit/UIKit.h>
#import "CommonHeaders.h"
#import "WorkLogPo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DataProviderProtocol<NSObject>
- (NSMutableArray<NSMutableArray<WorkLogPo *> *> *)loadDataSource;
@end

@interface JobViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSInteger jobId;              //传入参数，记录ID
@property (nonatomic) BOOL inEdit;                  //传入参数, default NO
@property (weak, nonatomic) NSString *jobContent;   //传入参数，文字内容
@property (nonatomic) NSInteger jobKindIdx;         //传入参数，类型D（今日完成）类型P（明日计划）类型F（未来事项）
@property (nonatomic) NSInteger jobDate;            //传入参数，事项日期
@property (nonatomic) NSInteger jobIdx;             //传入参数，排序索引

@property (weak, nonatomic) IBOutlet UITextView *uiJobContent;
@property (weak, nonatomic) IBOutlet UISegmentedControl *uiJobKind;
@property (weak, nonatomic) IBOutlet UITableView *uiJobTableView;

@property(nonatomic,weak)id<DataProviderProtocol> delegate;
//表格数据源
@property (nonatomic, weak) NSMutableArray<NSMutableArray<WorkLogPo *> *> *jobList;

@end

NS_ASSUME_NONNULL_END
