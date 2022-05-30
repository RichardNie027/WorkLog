//
//  TodayTableViewController.m
//  worklog
//
//  Created by RichardNie on 2022/5/29.
//

#import "TodayTableViewController.h"
#import "UIColor+Hex.h"
#import "Masonry/Masonry.h"

@interface TodayTableViewController ()

@end

@implementation TodayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetBarItemsWithState:1];
}

- (void)resetBarItemsWithState:(NSInteger)state  {
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(OnRightButton:)];
    //UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右边按钮" style:UIBarButtonItemStylePlain target:self action:@selector(OnRightButton:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

-(void)OnRightButton:(id)sender {
    //UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你点击了导航栏右按钮" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //[alter show];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    label.text = [NSString stringWithFormat:@"%ld - %ld", (long)indexPath.section, (long)indexPath.row];
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

@end
