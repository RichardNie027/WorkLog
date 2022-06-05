//
//  UIImage+Size.h
//  worklog
//
//  Created by RichardNie on 2022/6/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Size)

- (UIImage *)scaleToSize:(CGSize)newsize;

@end

NS_ASSUME_NONNULL_END
