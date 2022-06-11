//
//  TodayTableViewController.m
//  worklog
//
//  Created by RichardNie on 2022/5/29.
//

#import "NotedownTableViewController.h"
#import "JobViewController.h"
#import "DBHelper.h"
#import "Masonry/Masonry.h"
#import "MJRefresh/MJRefresh.h"
#import "Toast/Toast.h"

@interface NotedownTableViewController () <DataProviderProtocol>
@property (strong, nonatomic) UIBarButtonItem *addButtonItem;
@property (strong, nonatomic) UIBarButtonItem *editButtonItem;
@property (strong, nonatomic) UIBarButtonItem *doneButtonItem;
@property (strong, nonatomic) UIBarButtonItem *shareButtonItem;
@end

@implementation NotedownTableViewController

BOOL itemMoved = NO;

#pragma mark - ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self resetBarItemsWithState:1];
    self.tableView.estimatedRowHeight = 52;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
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
    
    //监听一个通知，当收到通知时，调用notificationAction方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"shortCut1Notification" object:nil];
}

- (void)viewDidUnload {
    //移除指定的通知，不然会造成内存泄露
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shortCut1Notification" object:nil];
    //对象可以添加多个通知，此处移除该对象的所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) notificationAction:(NSNotification *)notification{
    G_FLAG1 = YES;
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self addNewJob];
    NSLog(@"触发通知");
}

/*
//iOS15状态栏设置白色字 step2/2
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
*/

- (void)viewDidAppear:(BOOL)animated {
    if (G_NEED_RELOAD_DATA) {
        G_NEED_RELOAD_DATA = NO;
        [self reloadData];
        [self.tableView reloadData];
    }
}

#pragma mark - 设置BarItems
- (void)resetBarItemsWithState:(NSInteger)state  {
    if (!self.addButtonItem) {
        //UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右边按钮" style:UIBarButtonItemStylePlain target:self action:@selector(OnRightButton:)];
        self.addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(OnAddButton:)];
        //self.editButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(OnEditButton:)];
        self.editButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.up.arrow.down"] style:UIBarButtonItemStylePlain target:self action:@selector(OnEditButton:)];
        self.doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(OnDoneButton:)];
        self.shareButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrowshape.turn.up.forward"] style:UIBarButtonItemStylePlain target:self action:@selector(OnShareButton:)];
        UIBarButtonItem *logoButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"XHJ"] style:UIBarButtonItemStylePlain target:self action:nil];
        logoButtonItem.enabled = NO;
        self.navigationItem.leftBarButtonItems = @[logoButtonItem];
    }
    switch(state) {
        case 1:
            self.navigationItem.rightBarButtonItems = @[self.addButtonItem, self.editButtonItem, self.shareButtonItem];
            break;
        case 2:
            self.navigationItem.rightBarButtonItems = @[self.doneButtonItem];
            break;
        default:
            break;
    }
}

-(void)OnAddButton:(id)sender {
    /*
    __unsafe_unretained typeof(self) weakSelf = self;
    //UIAlertControllerStyleAlert, UIAlertControllerStyleActionSheet
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加新项，请选择…" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *today = [UIAlertAction actionWithTitle:@"今日工作" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        JobViewController* controller = [main instantiateViewControllerWithIdentifier:@"JobViewController" ];
        if (controller) {
            controller.text = @"";
            controller.jobKindIdx = 0;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
    }];
    UIAlertAction *tomorrow = [UIAlertAction actionWithTitle:@"明日计划" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        JobViewController* controller = [main instantiateViewControllerWithIdentifier:@"JobViewController" ];
        if (controller) {
            controller.text = @"";
            controller.jobKindIdx = 1;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    [alert addAction:today];
    [alert addAction:tomorrow];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
     */
    
    UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JobViewController* controller = [main instantiateViewControllerWithIdentifier:@"JobViewController" ];
    if (controller) {
        controller.jobContent = @"";
        controller.jobKindIdx = 0;
        controller.jobId = -1;
        controller.jobDate = [NSDate dateToInteger:[NSDate date]];
        controller.jobIdx = 300;
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)addNewJob {
    [self OnAddButton:nil];
}

-(void)OnEditButton:(id)sender {
    //设置tableview编辑状态
    BOOL flag = !self.tableView.editing;
    [self.tableView setEditing:flag animated:YES];
    [self resetBarItemsWithState:2];
    [self.tableView.mj_header setUserInteractionEnabled:NO];
    [self.tabBarController.tabBar setHidden:YES];
}

-(void)OnDoneButton:(id)sender {
    [self.tableView setEditing:NO animated:YES];
    [self resetBarItemsWithState:1];
    if (itemMoved) {
        [DBHelper reIndexWorkLog:[NSDate date]];
        itemMoved = NO;
    }
    [self.tableView.mj_header setUserInteractionEnabled:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

-(void)OnShareButton:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:10];
    [str setString: [NSString stringWithFormat:@"%@ 工作日志\n", [NSDate dateToString:[NSDate date] withFormat:@"yyyy.MM.dd"]]];
    for (NSInteger i=0; i<self.jobList[0].count; i++) {
        [str appendFormat:@"%ld、%@", i+1, self.jobList[0][i].jobContent];
        if (i < self.jobList[0].count -1)
            [str appendString:@"\n"];
    }
    if (self.jobList[1].count > 0) {
        [str appendString:@"\n\n明日工作\n"];
    }
    for (NSInteger i=0; i<self.jobList[1].count; i++) {
        [str appendFormat:@"%ld、%@", i+1, self.jobList[1][i].jobContent];
        if (i < self.jobList[1].count -1)
            [str appendString:@"\n"];
    }
    pasteboard.string = str;
    [Toast showMessage:@"工作日志已复制到剪贴板" duration:2 finishHandler:^{
        
    }];
}

#pragma mark - 每行显示内容
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: indexPath.section==2 ? @"cell02" : @"cell01"];
    if(cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: indexPath.section==2 ? @"cell02" : @"cell01"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.tag = self.jobList[indexPath.section][indexPath.row].jobId;
    UILabel *label11 = (UILabel *)[cell.contentView viewWithTag:11];
    label11.text = [NSString stringWithFormat:@"%ld、", (long)indexPath.row+1];
    label11.textColor = Const.labelColors[indexPath.section];
    UILabel *label12 = (UILabel *)[cell.contentView viewWithTag:12];
    label12.text = self.jobList[indexPath.section][indexPath.row].jobContent;
    label12.textColor = label11.textColor;
    if(indexPath.section == 2) {
        UILabel *label13 = (UILabel *)[cell.contentView viewWithTag:13];
        label13.text = [NSDate dateToString:[NSDate dateWithInteger: self.jobList[indexPath.section][indexPath.row].jobDate] withFormat:@"MM月dd日"];
    }
    return cell;
}

#pragma mark 分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
    // //NSString *path = [[NSBundle mainBundle]pathForResource:@"image"ofType:@"jpg"];
    // //UIImage *image = [UIImage imageWithContentsOfFile:path];
    //UIImage *image = [UIImage imageNamed:@"bar_bg_44"];
    //view.layer.contents = (id)image.CGImage;
         
    // 2 增加控件
    UILabel * titleLable=[UILabel new];
    [view addSubview:titleLable];
    
    titleLable.text = G_JobKindsText[section];
    if (section == 0) {
        titleLable.text = [NSString stringWithFormat:@"%@ - %@", G_JobKindsText[section], [NSDate dateToString:[NSDate date] withFormat:@"yyyy年MM月dd日 EEE"]];
    }
    titleLable.textColor = [UIColor colorWithHexString:G_JobKindsColor[section]];
    titleLable.font = [UIFont systemFontOfSize:16.0f];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.mas_centerY);
        make.left.mas_equalTo(16.0f);
        make.width.mas_equalTo(view.mas_width);
    }];
    return view;
}

#pragma mark - UITableView 滑动
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;// 是否允许对cell进行滑动操作
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    __unsafe_unretained typeof(self) weakSelf = self;
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        //删除数据
        [DBHelper deleteWorkLogById: [tableView cellForRowAtIndexPath:indexPath].tag];
        [DBHelper reIndexWorkLog:[NSDate date]];
        [weakSelf reloadData];
        //刷新表格
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf.tableView reloadData];
        completionHandler (YES);
    }];
    deleteRowAction.image = [UIImage systemImageNamed:@"trash"];
    deleteRowAction.backgroundColor = [UIColor redColor];

    //修改
    UIContextualAction *editRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"修改" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        JobViewController* controller = [main instantiateViewControllerWithIdentifier:@"JobViewController" ];
        if (controller) {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            UILabel *label = (UILabel *)[cell.contentView viewWithTag:12];
            controller.jobContent = label.text;
            controller.jobKindIdx = indexPath.section;
            controller.inEdit = YES;
            controller.jobId = weakSelf.jobList[indexPath.section][indexPath.row].jobId;
            controller.jobDate = weakSelf.jobList[indexPath.section][indexPath.row].jobDate;
            controller.jobIdx = weakSelf.jobList[indexPath.section][indexPath.row].jobIdx;
            controller.delegate = weakSelf;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
        completionHandler (YES);
    }];
    editRowAction.image = [UIImage systemImageNamed:@"square.and.pencil"];
    editRowAction.backgroundColor = [UIColor blueColor];

    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[editRowAction, deleteRowAction]];
    return config;
}

#pragma mark - 选择编辑模式，添加模式很少用,默认是删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark 排序 当移动了某一行时候会调用
//编辑状态下，只要实现这个方法，就能实现拖动排序
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSInteger ss = sourceIndexPath.section;
    NSInteger sr = sourceIndexPath.row;
    NSInteger ds = destinationIndexPath.section;
    NSInteger dr = destinationIndexPath.row;
    if (ss == ds && sr != dr) {
        itemMoved = YES;
        NSInteger step = sr < dr ? 1 : -1;
        for (NSInteger i=sr; (i-dr)*step<0; i=i+step) {
            NSInteger swapIdx = self.jobList[ss][i].jobIdx;
            self.jobList[ss][i].jobIdx = self.jobList[ss][i+step].jobIdx;
            self.jobList[ss][i+step].jobIdx = swapIdx;
            [self.jobList[ss] exchangeObjectAtIndex:i withObjectAtIndex:i+step];
            [DBHelper saveWorkLog:self.jobList[ss][i]];
            [DBHelper saveWorkLog:self.jobList[ss][i+step]];
        }
        [tableView reloadData];
    } else if (ss != ds) {
        WorkLogPo *temp = self.jobList[ss][sr];
        [self.jobList[ss] removeObjectAtIndex:sr];
        for (NSInteger i=sr; i<self.jobList[ss].count; i++) {
            self.jobList[ss][i].jobIdx = (i+1)*10;
            [DBHelper saveWorkLog:self.jobList[ss][i]];
        }
        [self.jobList[ds] insertObject:temp atIndex:dr];
        for (NSInteger i=dr; i<self.jobList[ds].count; i++) {
            self.jobList[ds][i].jobIdx = (i+1)*10;
            self.jobList[ds][i].jobKind = G_JobKinds[ds];
            [DBHelper saveWorkLog:self.jobList[ds][i]];
        }
        if (ss == 2) {
            self.jobList[ds][dr].jobDate = [NSDate dateToInteger:[NSDate date]];
            [DBHelper saveWorkLog:self.jobList[ds][dr]];
        }
        [tableView reloadData];
    }
}
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
//    if(proposedDestinationIndexPath.section != sourceIndexPath.section)
//        return sourceIndexPath;
//    else
//        return proposedDestinationIndexPath;
//}

#pragma mark - 数据
- (NSMutableArray *) jobList {
    if(!_jobList) {
        _jobList = [NSMutableArray array];
        [_jobList addObject: [NSMutableArray array]];
        [_jobList addObject: [NSMutableArray array]];
        [_jobList addObject: [NSMutableArray array]];
    }
    return _jobList;
}

- (void) reloadData {
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[DBHelper queryWorkLogsOn:[NSDate date] forDays:1 includeFuture:YES]];
    [self.jobList[0] removeAllObjects];
    [self.jobList[1] removeAllObjects];
    [self.jobList[2] removeAllObjects];
    for(WorkLogPo *po in resultArray) {
        if ([po.jobKind isEqualToString:@"D"]) {
            [self.jobList[0] addObject: po];
        } else if ([po.jobKind isEqualToString:@"P"]) {
            [self.jobList[1] addObject: po];
        } else if ([po.jobKind isEqualToString:@"F"]) {
            [self.jobList[2] addObject: po];
        }
    }
}

#pragma mark - DataProviderProtocol Delegate
- (NSMutableArray<NSMutableArray<WorkLogPo *> *> *)loadDataSource {
    return self.jobList;
}

@end
