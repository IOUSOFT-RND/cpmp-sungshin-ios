//
//  UIImage+ImageResize.h
//  emdm
//
//  Created by jaewon on 2014. 7. 30..
//
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageResize)

- (UIImage *)resizedImageWithMaximumSize: (CGSize) size;
- (UIImage *)ImageCrop:(CGSize) size;

@end
