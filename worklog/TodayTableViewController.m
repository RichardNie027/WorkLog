//
//  TodayTableViewController.m
//  worklog
//
//  Created by RichardNie on 2022/5/29.
//

#import "TodayTableViewController.h"
#import "JobViewController.h"
#import "Masonry/Masonry.h"

@interface TodayTableViewController ()

@end

@implementation TodayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self resetBarItemsWithState:1];
    self.tableView.estimatedRowHeight = 52;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)resetBarItemsWithState:(NSInteger)state  {
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(OnAddButton:)];
    //UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右边按钮" style:UIBarButtonItemStylePlain target:self action:@selector(OnRightButton:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

-(void)OnAddButton:(id)sender {
    /*
    //UIAlertControllerStyleAlert, UIAlertControllerStyleActionSheet
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加新项，请选择…" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *today = [UIAlertAction actionWithTitle:@"今日工作" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        JobViewController* controller = [main instantiateViewControllerWithIdentifier:@"JobViewController" ];
        if (controller) {
            controller.text = @"";
            controller.jobKindIdx = 0;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
    UIAlertAction *tomorrow = [UIAlertAction actionWithTitle:@"明日计划" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        JobViewController* controller = [main instantiateViewControllerWithIdentifier:@"JobViewController" ];
        if (controller) {
            controller.text = @"";
            controller.jobKindIdx = 1;
            [self.navigationController pushViewController:controller animated:YES];
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
        controller.text = @"";
        controller.jobKindIdx = 0;
        [self.navigationController pushViewController:controller animated:YES];
    }

}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    if(indexPath.row == 1)
        label.text = [NSString stringWithFormat:@"%ld、%@", (long)indexPath.row+1, @"测试工作项测试工作项测试工作项"];
    else
        label.text = [NSString stringWithFormat:@"%ld、%@", (long)indexPath.row+1, @"测试工作项测试工作项"];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section+1) * 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //1 自定义头部
    UIView * view=[[UIView alloc] init];
    view.backgroundColor=[UIColor colorWithHexString:@"#F2F3F7"];
         
    // 2 增加控件
    UILabel * titleLable=[UILabel new];
    [view addSubview:titleLable];
    
    if(section == 0)
        titleLable.text = @"今日工作";
    else
        titleLable.text = @"明日计划";
    titleLable.textColor = [UIColor colorWithHexString:@"666666"];
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
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        //删除收货地址
        
        //刷新表格
        
        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadData];
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
            UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
            controller.text = label.text;
            controller.jobKindIdx = indexPath.section;
            [self.navigationController pushViewController:controller animated:YES];
        }

        completionHandler (YES);
    }];
    editRowAction.image = [UIImage systemImageNamed:@"square.and.pencil"];
    editRowAction.backgroundColor = [UIColor blueColor];

    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[editRowAction, deleteRowAction]];
    return config;
}

@end
