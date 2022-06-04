//
//  JobViewController.m
//  worklog
//
//  Created by RichardNie on 2022/5/31.
//

#import "JobViewController.h"
#import "DBHelper.h"
#import "NotedownTableViewController.h"

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
        //todo: 提示填写内容
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
            //todo: 提示无变化
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
    self.view.backgroundColor = [UIColor colorWithHexString:G_JobKindsColorLight[self.uiJobKind.selectedSegmentIndex]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
