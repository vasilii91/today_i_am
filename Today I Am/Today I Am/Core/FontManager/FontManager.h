//
//  FontManager.h
//  Today I Am
//
//  Created by Vasilii Kasnitski on 10/18/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FONT_NAME_DEFAULT_SIZE 15
#define FONT_NAME_TAHOMA @"Tahoma"

@interface FontManager : NSObject

+ (NSString *)currentFontName;

@end
