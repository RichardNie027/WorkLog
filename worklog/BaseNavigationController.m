//
//  BaseNavigationController.m
//  worklog
//
//  Created by RichardNie on 2022/6/5.
//

#import "BaseNavigationController.h"
#import "common/CommonHeaders.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*设置导航栏的背景图
    UIImage *title_bg = [UIImage imageNamed:@"title01"];  //获取图片
    CGSize titleSize = self.navigationBar.bounds.size;  //获取Navigation Bar的位置和大小
    title_bg = [title_bg scaleToSize: titleSize];//设置图片的大小与Navigation Bar相同
    */
    if (!self.navigationBarBackgroundColor || [self.navigationBarBackgroundColor isEqualToString:@""]) {
        self.navigationBarBackgroundColor = G_LabelColorHex;
    }
    if(@available(iOS 15.0,*)){
        UINavigationBarAppearance * appearance = [[UINavigationBarAppearance alloc] init];
        //[appearance setBackgroundImage:title_bg];
        [appearance setBackgroundColor:[UIColor colorWithHexString:self.navigationBarBackgroundColor]];
        [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:G_SecondaryLabelColorHex],NSFontAttributeName:[UIFont systemFontOfSize:24 weight:UIFontWeightBold]}];
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
    }else{
        //[self.navigationBar setBackgroundImage:title_bg forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setBackgroundColor:[UIColor colorWithHexString:self.navigationBarBackgroundColor]];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:G_SecondaryLabelColorHex],NSFontAttributeName:[UIFont systemFontOfSize:20 weight:UIFontWeightBold]}];
    }
    
    [self.navigationBar setTintColor:[UIColor colorWithHexString:G_SecondaryLabelColorHex]];
}

/*
//iOS15状态栏设置白色字 step1/2
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
