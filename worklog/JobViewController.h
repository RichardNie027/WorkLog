//
//  JobViewController.h
//  worklog
//
//  Created by RichardNie on 2022/5/31.
//

#import <UIKit/UIKit.h>
#import "CommonHeaders.h"

NS_ASSUME_NONNULL_BEGIN

@interface JobViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *jobContent;
@property (weak, nonatomic) IBOutlet UISegmentedControl *jobKind;
@property (weak, nonatomic) NSString *text;
@property (nonatomic) NSInteger jobKindIdx;
@end

NS_ASSUME_NONNULL_END
