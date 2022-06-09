//
//  JobViewController.m
//  worklog
//
//  Created by RichardNie on 2022/5/31.
//

#import "JobViewController.h"
#import "DBHelper.h"
#import "NotedownTableViewController.h"
#import "Toast/Toast.h"

@interface JobViewController ()

@end

@implementation JobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.inEdit ? @"修改" : @"新增";
    [self resetBarItemsWithState:1];
    self.uiJobContent.text = self.jobContent;
    [self.uiJobKind setSelectedSegmentIndex: self.jobKindIdx];
    [self OnSegmentValueChanged:self.uiJobKind];
    
    [self.navigationItem.backBarButtonItem setTitle:@"返回"];
    self.view.backgroundColor = Const.backgroundColors[self.uiJobKind.selectedSegmentIndex];
    
    if ([self.delegate respondsToSelector:@selector(loadDataSource)]) {
        self.jobList = [self.delegate loadDataSource];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self.uiJobContent becomeFirstResponder];
}

- (void)resetBarItemsWithState:(NSInteger)state  {
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(OnSaveButton)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

-(void)OnSaveButton {
    if ([self.uiJobContent.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [Toast showMessage:@"内容不能为空" originY:self.uiJobContent.frame.origin.y+_uiJobContent.frame.size.height/2-10 duration:2 finishHandler:^{
            
        }];
        return;
    }
    
    BOOL kindChanged = NO;
    WorkLogPo *po = [[WorkLogPo alloc] init];
    if(self.inEdit) {
        kindChanged = self.uiJobKind.selectedSegmentIndex != self.jobKindIdx;
        if(kindChanged || ![self.jobContent isEqualToString:self.uiJobContent.text]) {
            po.jobId = self.jobId;
            po.jobDate = self.jobDate;
            if (kindChanged) //改变类别了
                po.jobIdx = 9;  //放在新组的第一个
            else
                po.jobIdx = self.jobIdx;
        } else {
            [Toast showMessage:@"没有任何修改" originY:self.uiJobContent.frame.origin.y+_uiJobContent.frame.size.height/2-10 duration:2 finishHandler:^{
                
            }];
            return;
        }
    } else {
        po.jobId = -1;
        po.jobDate = [NSDate dateToInteger:[NSDate date]];
        po.jobIdx = [DBHelper queryWorkLogsCountOn:[NSDate date] withJobKind:G_JobKinds[self.uiJobKind.selectedSegmentIndex]] * 10 + 10;
    }
    po.jobContent = self.uiJobContent.text;
    po.jobKind = G_JobKinds[self.uiJobKind.selectedSegmentIndex];
    [DBHelper saveWorkLog:po];
    if(kindChanged) {
        [DBHelper reIndexWorkLog:[NSDate date]];
    }
    //导航返回，传值
    G_NEED_RELOAD_DATA = TRUE;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Segment
- (IBAction)OnSegmentValueChanged:(id)sender {
    [self.uiJobTableView reloadData];
    //self.view.backgroundColor = [UIColor colorWithHexString:G_JobKindsColorLight[self.uiJobKind.selectedSegmentIndex]];
    self.view.backgroundColor = Const.backgroundColors[self.uiJobKind.selectedSegmentIndex];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - 每行显示内容
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: self.uiJobKind.selectedSegmentIndex==2 ? @"cell02" : @"cell01"];
    if(cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: self.uiJobKind.selectedSegmentIndex==2 ? @"cell02" : @"cell01"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.tag = self.jobList[self.uiJobKind.selectedSegmentIndex][indexPath.row].jobId;
    UILabel *label11 = (UILabel *)[cell.contentView viewWithTag:11];
    label11.text = [NSString stringWithFormat:@"%ld、", (long)indexPath.row+1];
    UILabel *label12 = (UILabel *)[cell.contentView viewWithTag:12];
    label12.text = self.jobList[self.uiJobKind.selectedSegmentIndex][indexPath.row].jobContent;
    if(self.uiJobKind.selectedSegmentIndex==2) {
        UILabel *label13 = (UILabel *)[cell.contentView viewWithTag:13];
        label13.text = [NSDate dateToString:[NSDate dateWithInteger: self.jobList[self.uiJobKind.selectedSegmentIndex][indexPath.row].jobDate] withFormat:@"MM月dd日"];
    }
    return cell;
}

#pragma mark 分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark 每组行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jobList[self.uiJobKind.selectedSegmentIndex].count;
}

@end
