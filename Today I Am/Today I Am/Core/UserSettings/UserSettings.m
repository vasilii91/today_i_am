//
//  UserSettings.m
//  Locker
//
//  Created by Vasilii Kasnitski on 11/23/12.
//  Copyright (c) 2012 OCSICO. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings

static UserSettings *_sharedMySingleton = nil;


#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    if (self) {
    }
    
    return self;
}


#pragma mark - Public methods

+ (UserSettings *)sharedSingleton
{
    @synchronized(self)
    {
        if (!_sharedMySingleton) {
            _sharedMySingleton = [[UserSettings alloc] init];
        }
    }
    
    return _sharedMySingleton;
}


#pragma mark - Public methods

- (BOOL)isFreeVersion
{
    return UDBool(IS_FREE_VERSION);
}

- (void)setIsFreeVersion:(BOOL)isFreeVersion
{
    UDSetBool(IS_FREE_VERSION, isFreeVersion);
    UDSync();
}

@end
