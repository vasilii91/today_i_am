//
//  FontManager.m
//  Today I Am
//
//  Created by Vasilii Kasnitski on 10/18/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import "FontManager.h"

#define FONT_NAME_CHINESE @"FangSong"
#define FONT_NAME_KOREAN @"Batang"

#warning change it!!!
#define FONT_NAME_JAPANESE @"Batang"

@implementation FontManager

+ (NSString *)currentFontName
{
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if ([language isEqualToString:@"en"]) {
        return FONT_NAME_CHINESE;
    }
    else if ([language isEqualToString:@"ko"]) {
        return FONT_NAME_KOREAN;
    }
    else if ([language isEqualToString:@"ja"]) {
        return FONT_NAME_JAPANESE;
    }
    
    return FONT_NAME_CHINESE;
}

@end
