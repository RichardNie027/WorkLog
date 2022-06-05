//
//  BaseNavigationController.h
//  worklog
//
//  Created by RichardNie on 2022/6/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseNavigationController : UINavigationController

@property (weak, nonatomic) NSString *navigationBarBackgroundColor;   //导航栏背景色,Hex字符串，子类在[super viewDidLoad]前给其附新值

@end

NS_ASSUME_NONNULL_END
