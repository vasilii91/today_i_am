//
//  ImageUtilities.m
//  Today I Am
//
//  Created by Vasilii Kasnitski on 10/28/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import "ImageManager.h"

@implementation ImageManager

+ (UIImage *)resizeImage:(UIImage *)imageToResize toSize:(CGSize)targetSize
{
    UIImage *sourceImage = imageToResize;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // make image center aligned
        if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    return newImage ;
}

+ (UIColor *)colorByTextureIndex:(NSInteger)textureIndex
{
    UIImage *textureImage = [UIImage imageNamed:[NSString stringWithFormat:@"texture%d", textureIndex]];
    CGSize currentSize = textureImage.size;
    currentSize = CGSizeMake(currentSize.width * 0.6,
                             currentSize.height * 0.6);
    textureImage = [self resizeImage:textureImage toSize:currentSize];
    
    return [UIColor colorWithPatternImage:textureImage];
}

@end
