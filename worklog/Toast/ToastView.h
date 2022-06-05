//
//  ToastView.h
//  Toast
//
//  Created by wuhao on 2018/11/15.
//  Copyright © 2018 wuhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ToastType) {
    ToastTypeWords = 0,
    ToastTypeImage,
};

@interface ToastView : UIView

+ (instancetype _Nullable)toastWithMessage:(NSString * _Nullable)message
                                      type:(ToastType)type
                                   originY:(CGFloat)originY
                                  tipImage:(UIImage * _Nullable)image;

@end
