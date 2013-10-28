//
//  AppDelegate.h
//  Today I Am
//
//  Created by redoan on 3/9/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>
#import "FlurryAdDelegate.h"


@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, FlurryAdDelegate>
{
    NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationConteoller;
@property (strong, nonatomic) ViewController *viewController;

-(bool)isLessHundred:(NSMutableArray*)todayMeasures todayEmotions:(NSMutableArray*)todayEmotions indexMode:(int)indexMode;
-(bool)isMoreHundred:(NSMutableArray*)todayMeasures todayEmotions:(NSMutableArray*)todayEmotions indexMode:(int)indexMode;
@property(assign) int calibrationIndexDiaryPie;
@property(assign) int calibrationIndexTodayIam;
@property(assign) int calibrationIndexHappinessPie;

- (void)showAds;

@end
