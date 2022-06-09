//
//  Const.m
//  worklog
//
//  Created by RichardNie on 2022/6/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 蓝色深
extern NSString * _Nonnull const G_LabelColorHex;
/// 绿色深
extern NSString * _Nonnull const G_SecondaryLabelColorHex;
/// 三色深
extern NSString * _Nonnull const G_TertiaryLabelColorHex;

/// 蓝色浅
extern NSString * _Nonnull const G_BackgroundColorHex;
/// 绿色浅
extern NSString * _Nonnull const G_SecondaryBackgroundColorHex;
/// 三色浅
extern NSString * _Nonnull const G_TertiaryBackgroundColorHex;

///工作项类型 Done Plan Future
extern NSString * _Nonnull const G_JobKinds[3];
///工作项类型文本
extern NSString * _Nonnull const G_JobKindsText[3];
///工作项类型颜色
extern NSString * _Nonnull const G_JobKindsColor[3];
extern NSString * _Nonnull const G_JobKindsColorLight[3];

NS_ASSUME_NONNULL_BEGIN

@interface Const : NSObject

//文本前景色1
+ (UIColor *) labelColor;
//文本前景色2
+ (UIColor *) secondaryLabelColor;
//文本前景色3
+ (UIColor *) tertiaryLabelColor;
//文本前景色s
+ (NSArray<UIColor *> *)labelColors;

//背景色1
+ (UIColor *) backgroundColor;
//背景色2
+ (UIColor *) secondaryBackgroundColor;
//背景色3
+ (UIColor *) tertiaryBackgroundColor;
//背景色s
+ (NSArray<UIColor *> *)backgroundColors;

@end

NS_ASSUME_NONNULL_END
