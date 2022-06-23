//
//  Const.m
//  worklog
//
//  Created by RichardNie on 2022/6/1.
//

#import "Const.h"
#import "UIColor+Hex.h"

/// 蓝色深
NSString * const G_LabelColorHex = @"#195cf2";
/// 绿色深
NSString * const G_SecondaryLabelColorHex = @"#7ec700";
/// 三色深
NSString * const G_TertiaryLabelColorHex = @"#ff8d3f";

/// 蓝色背景浅
NSString * const G_BackgroundColorHex = @"#e5ecf9";
/// 绿色背景浅
NSString * const G_SecondaryBackgroundColorHex = @"#f2ffdc";
/// 三色背景浅
NSString * const G_TertiaryBackgroundColorHex = @"#fce6d5";

/// 蓝色背景深
NSString * _Nonnull const G_DarkBackgroundColorHex = @"#252a36";
/// 绿色背景深
NSString * _Nonnull const G_DarkSecondaryBackgroundColorHex = @"#2d3324";
/// 三色背景深
NSString * _Nonnull const G_DarkTertiaryBackgroundColorHex = @"#2f2722";

///工作项类型 Done Plan Future
NSString * const G_JobKinds[3] = {@"D", @"P", @"F"};
///工作项类型文本
NSString * const G_JobKindsText[3] = {@"今日工作", @"明日计划", @"未来事项"};
///工作项类型颜色
NSString * const G_JobKindsColor[3] = {G_LabelColorHex, G_SecondaryLabelColorHex, G_TertiaryLabelColorHex};
NSString * const G_JobKindsColorLight[3] = {G_BackgroundColorHex, G_SecondaryBackgroundColorHex, G_TertiaryBackgroundColorHex};

@implementation Const

//文本前景色1
+ (UIColor *) labelColor {
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
        if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
            return [UIColor colorWithHexString: G_LabelColorHex];
        }
        else {
            return [UIColor colorWithHexString: G_BackgroundColorHex];
        }
    }];
}

//文本前景色2
+ (UIColor *) secondaryLabelColor {
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
        if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
            return [UIColor colorWithHexString: G_SecondaryLabelColorHex];
        }
        else {
            return [UIColor colorWithHexString: G_SecondaryBackgroundColorHex];
        }
    }];
}

//文本前景色3
+ (UIColor *) tertiaryLabelColor {
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
        if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
            return [UIColor colorWithHexString: G_TertiaryLabelColorHex];
        }
        else {
            return [UIColor colorWithHexString: G_TertiaryBackgroundColorHex];
        }
    }];
}

//文本前景色s
+ (NSArray<UIColor *> *)labelColors {
    return @[Const.labelColor, Const.secondaryLabelColor, Const.tertiaryLabelColor];
}

//背景色1
+ (UIColor *) backgroundColor {
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
        if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
            return [UIColor colorWithHexString: G_BackgroundColorHex];
        }
        else {
            return [UIColor colorWithHexString: G_DarkBackgroundColorHex];
        }
    }];
}

//背景色2
+ (UIColor *) secondaryBackgroundColor {
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
        if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
            return [UIColor colorWithHexString: G_SecondaryBackgroundColorHex];
        }
        else {
            return [UIColor colorWithHexString: G_DarkSecondaryBackgroundColorHex];
        }
    }];
}

//背景色3
+ (UIColor *) tertiaryBackgroundColor {
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
        if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
            return [UIColor colorWithHexString: G_TertiaryBackgroundColorHex];
        }
        else {
            return [UIColor colorWithHexString: G_DarkTertiaryBackgroundColorHex];
        }
    }];
}

//背景色s
+ (NSArray<UIColor *> *)backgroundColors {
    return @[Const.backgroundColor, Const.secondaryBackgroundColor, Const.tertiaryBackgroundColor];
}

//TableView背景
+ (UIColor *) tableViewBackgroundColor {
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
        if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
            return [UIColor colorWithPatternImage:[UIImage imageNamed:@"splash01"]];
        }
        else {
            return UIColor.systemGray6Color;
        }
    }];
}

@end
