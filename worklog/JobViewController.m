//
//  JobViewController.m
//  worklog
//
//  Created by RichardNie on 2022/5/31.
//

#import "JobViewController.h"

@interface JobViewController ()

@end

@implementation JobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"ABC";
    [self resetBarItemsWithState:1];
    self.jobContent.text = self.text;
    [self.jobKind setSelectedSegmentIndex: self.jobKindIdx];
    [self OnSegmentValueChanged:self.jobKind];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)resetBarItemsWithState:(NSInteger)state  {
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(OnSaveButton)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

-(void)OnSaveButton {
    
}

#pragma mark - Segment
- (IBAction)OnSegmentValueChanged:(id)sender {
    if(self.jobKind.selectedSegmentIndex == 0)
        self.view.backgroundColor = [UIColor colorWithHexString:G_MainColorLight];
    else
        self.view.backgroundColor = [UIColor colorWithHexString:G_SecondColorLight];
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
