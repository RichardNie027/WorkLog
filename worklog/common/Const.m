//
//  Const.m
//  worklog
//
//  Created by RichardNie on 2022/6/1.
//

#import "Const.h"

/// 蓝色深
NSString * const G_MainColor = @"#195cf2";
/// 绿色深
NSString * const G_SecondColor = @"#7ec700";
/// 三色深
NSString * const G_ThirdColor = @"#ff8d3f";

/// 蓝色浅
NSString * const G_MainColorLight = @"#e5ecf9";
/// 绿色浅
NSString * const G_SecondColorLight = @"#f2ffdc";
/// 三色浅
NSString * const G_ThirdColorLight = @"#fce6d5";

///工作项类型 Done Plan Future
NSString * const G_JobKinds[3] = {@"D", @"P", @"F"};
///工作项类型文本
NSString * const G_JobKindsText[3] = {@"今日工作", @"明日计划", @"未来事项"};
///工作项类型颜色
NSString * const G_JobKindsColor[3] = {G_MainColor, G_SecondColor, G_ThirdColor};
NSString * const G_JobKindsColorLight[3] = {G_MainColorLight, G_SecondColorLight, G_ThirdColorLight};
