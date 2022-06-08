//
//  RecentTableViewController.m
//  worklog
//
//  Created by RichardNie on 2022/6/4.
//

#import "RecentTableViewController.h"
#import "DBHelper.h"
#import "Masonry/Masonry.h"
#import "MJRefresh/MJRefresh.h"
#import "Toast/Toast.h"

@interface RecentTableViewController ()
@property (strong, nonatomic) UIBarButtonItem *multiSelectButtonItem;
@property (strong, nonatomic) UIBarButtonItem *duplicateButtonItem;
@property (strong, nonatomic) UIBarButtonItem *doneButtonItem;
@end

@implementation RecentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetBarItemsWithState:1];
    self.tableView.estimatedRowHeight = 52;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    __unsafe_unretained typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf reloadData];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self reloadData];
}

#pragma mark - 设置BarItems
- (void)resetBarItemsWithState:(NSInteger)state  {
    if (!self.multiSelectButtonItem) {
        //UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右边按钮" style:UIBarButtonItemStylePlain target:self action:@selector(OnRightButton:)];
        self.multiSelectButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"checkmark.circle"] style:UIBarButtonItemStylePlain target:self action:@selector(OnMultiSelectButton:)];
        self.duplicateButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"text.badge.plus"] style:UIBarButtonItemStylePlain target:self action:@selector(OnDuplicateButton:)];
        self.doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(OnDoneButton:)];
    }
    switch(state) {
        case 1:
            self.navigationItem.rightBarButtonItems = @[self.multiSelectButtonItem];
            break;
        case 2:
            self.navigationItem.rightBarButtonItems = @[self.doneButtonItem, self.duplicateButtonItem];
            break;
        default:
            break;
    }
}

-(void)OnMultiSelectButton:(id)sender {
    //设置tableview编辑状态
    BOOL flag = !self.tableView.editing;
    [self.tableView setEditing:flag animated:YES];
    [self resetBarItemsWithState:2];
    [self.tableView.mj_header setUserInteractionEnabled:NO];
}

-(void)OnDuplicateButton:(id)sender {
    if (self.tableView.indexPathsForSelectedRows.count > 0) {
        __unsafe_unretained typeof(self) weakSelf = self;
        //UIAlertControllerStyleAlert, UIAlertControllerStyleActionSheet
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"将选择项复制到…" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *today = [UIAlertAction actionWithTitle:@"今日工作" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf duplicateItemsToKind:@"D"];
            [weakSelf OnDoneButton:nil];
        }];
        UIAlertAction *tomorrow = [UIAlertAction actionWithTitle:@"明日计划" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf duplicateItemsToKind:@"P"];
            [weakSelf OnDoneButton:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf OnDoneButton:nil];
            NSLog(@"点击了取消");
        }];
        [alert addAction:today];
        [alert addAction:tomorrow];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self OnDoneButton:nil];
        [Toast showMessage:@"没有工作日志被复制" duration:2 finishHandler:^{
            
        }];
    }
}

-(void)duplicateItemsToKind:(NSString *)jobKind {
    if (![jobKind isEqualToString:@"P"])
        jobKind = @"D";
    NSInteger count0 = [DBHelper queryWorkLogsCountOn:[NSDate date] withJobKind:jobKind];
    NSInteger dateInt = [NSDate dateToInteger:[NSDate date]];
    for(NSIndexPath *idxPath in self.tableView.indexPathsForSelectedRows) {
        WorkLogPo *po = [self.jobList[idxPath.section][idxPath.row] mutableCopy];
        po.jobDate = dateInt;
        po.jobIdx = (count0++) * 10 + 10;
        po.jobKind = jobKind;
        po.jobId = -1;
        [DBHelper saveWorkLog: po];
        NSLog(@"%ld", po.jobIdx);
    }
    if (self.tableView.indexPathsForSelectedRows.count > 0) {
        G_NEED_RELOAD_DATA = YES;
    }
}

-(void)OnDoneButton:(id)sender {
    [self.tableView setEditing:NO animated:YES];
    [self resetBarItemsWithState:1];

    [self.tableView.mj_header setUserInteractionEnabled:YES];
}

#pragma mark - 每行显示内容
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell01"];
    if(cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: @"cell01"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.tag = self.jobList[indexPath.section][indexPath.row].jobId;
    UILabel *label11 = (UILabel *)[cell.contentView viewWithTag:11];
    label11.text = [NSString stringWithFormat:@"%ld、", (long)indexPath.row+1];
    UILabel *label12 = (UILabel *)[cell.contentView viewWithTag:12];
    label12.text = self.jobList[indexPath.section][indexPath.row].jobContent;
    return cell;
}

#pragma mark 分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.jobList.count;
}

#pragma mark 每组行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jobList[section].count;
}

#pragma mark 组抬头行高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

#pragma mark 自定义组抬头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //1 自定义头部
    UIView * view=[[UIView alloc] init];
    view.backgroundColor=UIColor.clearColor;

    // 2 增加控件
    UILabel * titleLable=[UILabel new];
    [view addSubview:titleLable];
    
    NSInteger jobKindsIdx = [self.jobList[section].accessibilityHint integerValue]; // accessibilityHint: 0 or 1, D/P;    accessibilityLabel:yyyyMMdd
    titleLable.text = G_JobKindsText[jobKindsIdx];
    if (jobKindsIdx == 0) {
        titleLable.text = [NSString stringWithFormat:@"%@ - %@", G_JobKindsText[jobKindsIdx], [NSDate dateToString:[NSDate dateWithString:self.jobList[section].accessibilityLabel withFormat:@"yyyyMMdd"] withFormat:@"yyyy年MM月dd日 EEE"]];
    }
    titleLable.textColor = [UIColor colorWithHexString:G_JobKindsColor[jobKindsIdx]];
    titleLable.font = [UIFont systemFontOfSize:16.0f];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.mas_centerY);
        make.left.mas_equalTo(16.0f);
        make.width.mas_equalTo(view.mas_width);
    }];
    return view;
}

#pragma mark - 选择编辑模式，添加模式很少用,默认是删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - 数据
- (NSMutableArray *) jobList {
    if(!_jobList) {
        _jobList = [NSMutableArray array];
    }
    return _jobList;
}

- (void) reloadData {
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[DBHelper queryWorkLogsOn:[NSDate date:[NSDate date] addYears:0 Month:0 addDays:-1] forDays:7 includeFuture:NO]];
    [self.jobList removeAllObjects];
    NSInteger lastDate = -1;
    NSString *lastKind = @"";
    for(WorkLogPo *po in resultArray) {
        if (lastDate != po.jobDate || ![lastKind isEqualToString:po.jobKind]) {
            lastDate = po.jobDate;
            lastKind = [po.jobKind copy];
            NSMutableArray *array1 = [NSMutableArray array];
            [array1 setAccessibilityHint: [po.jobKind isEqualToString:@"D"]?@"0":@"1"];
            [array1 setAccessibilityLabel:[NSString stringWithFormat:@"%ld", lastDate]];
            [_jobList addObject: array1];
        }
        [self.jobList[self.jobList.count-1] addObject: po];
    }
}

@end
