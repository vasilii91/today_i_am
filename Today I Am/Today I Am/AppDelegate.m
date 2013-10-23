//
//  AppDelegate.m
//  Today I Am
//
//  Created by redoan on 3/9/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <mach/mach.h>

#import "TodayIAm.h"
#import "PasswordScreen.h"
@implementation AppDelegate

@synthesize calibrationIndexDiaryPie,calibrationIndexHappinessPie,calibrationIndexTodayIam;

void getMemoryDetails(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),TASK_BASIC_INFO,(task_info_t)&info,&size);
    if( kerr == KERN_SUCCESS ) {
        NSLog(@" ------   Memory in use: %.5fMB", info.resident_size / 8000000.0);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
}

-(void) memoryCondition
{
    //getMemoryDetails();
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.navigationConteoller = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [self.navigationConteoller setNavigationBarHidden:YES animated:NO];
    self.window.rootViewController = self.navigationConteoller;
    [self.window makeKeyAndVisible];
    self.calibrationIndexDiaryPie=-1;
    self.calibrationIndexHappinessPie=-1;
    self.calibrationIndexTodayIam=-1;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:@"password"]) {
        
        PasswordScreen* view = [[PasswordScreen alloc]initWithNibName:@"PasswordScreen" bundle:nil];
        
        view.mode = 3;
    }

    NSMutableArray *emotions = [[NSMutableArray alloc] initWithObjects:
                                LOC(@"key.Ecstatic"),
                                LOC(@"key.Relaxed"),
                                LOC(@"key.Bored"),
                                LOC(@"key.Excited"),
                                LOC(@"key.Crazy"),
                                LOC(@"key.Grumpy"),
                                LOC(@"key.Happy"),
                                LOC(@"key.Silly"),
                                LOC(@"key.Exhausted"),
                                LOC(@"key.Lovestruck"),
                                LOC(@"key.Shocked"),
                                LOC(@"key.Guilty"),
                                LOC(@"key.Inspired"),
                                LOC(@"key.Confused"),
                                LOC(@"key.Stressed"),
                                LOC(@"key.Proud"),
                                LOC(@"key.Restless"),
                                LOC(@"key.Sick"),
                                LOC(@"key.Confident"),
                                LOC(@"key.Emotional"),
                                LOC(@"key.Heartbroken"),
                                LOC(@"key.Grateful"),
                                LOC(@"key.Nervous"),
                                LOC(@"key.Lonely"),
                                LOC(@"key.Content"),
                                LOC(@"key.Jealous"),
                                LOC(@"key.Sad"),
                                LOC(@"key.Hopeful"),
                                LOC(@"key.Scared"),
                                LOC(@"key.Angry"), nil];
    
    [prefs setObject:emotions forKey:@"emotions"];
    [prefs synchronize];
    
    if ([prefs objectForKey:@"password"]) {
        
        PasswordScreen* view = [[PasswordScreen alloc]initWithNibName:@"PasswordScreen" bundle:nil];
        
        view.mode = 3;
        
        [self.navigationConteoller pushViewController:view animated:NO];
    }
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General"]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self application:application didFinishLaunchingWithOptions:nil];
//    [FBSession.activeSession handleDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        }
    }
    
    [FBSession.activeSession close];
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Model.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}


#pragma mark -
#pragma mark Custom Methods

-(bool)isLessHundred:(NSMutableArray *)todayMeasures todayEmotions:(NSMutableArray *)todayEmotions indexMode:(int)indexMode
{
    BOOL flag=NO;
    int tempValue=0;
    int total=0;
    int totalPercentageCount=0;
    for (int i=0; i<todayMeasures.count; i++) {
        total+=[[todayMeasures objectAtIndex:i] intValue];
    }
    
    if ([todayEmotions count]==1) {
        
        return flag;
    }
    else
    {
        float percentage=0;
        for(int index=0;index<todayMeasures.count;index++)
        {
            percentage = (total)?[[todayMeasures objectAtIndex:index] floatValue]/total:0;
            
            //NSString *percentageString = [NSString stringWithFormat:@" %0.0f%@\n%@",percentage*100, @"%",[todayEmotions objectAtIndex:index]];
            NSString *percentageString = [NSString stringWithFormat:@" %0.0f",percentage*100];
            if([percentageString intValue] >=tempValue)
            {
                tempValue=[percentageString intValue];
                if(indexMode==TodayIamIndex)
                {
                    calibrationIndexTodayIam=index;
                }
                else if(indexMode==DiaryPieIndex)
                {
                    calibrationIndexDiaryPie=index;
                }
                else if(indexMode==HappinessPieIndex)
                {
                    calibrationIndexHappinessPie=index;
                }
            }
            totalPercentageCount=totalPercentageCount+[percentageString intValue];
        }
        /*
        float percentage = (total)?[[todayMeasures objectAtIndex:index] floatValue]/total:0;
        //NSString *percentageString = [NSString stringWithFormat:@" %0.0f%@\n%@",percentage*100, @"%",[todayEmotions objectAtIndex:index]];
        NSString *percentageString = [NSString stringWithFormat:@" %0.0f%@\n%@",percentage*100];*/
    }
    
    if(totalPercentageCount==100)
    {
        flag=NO;
    }
    else if(totalPercentageCount==99)
    {
        flag=YES;
    }
    else
    {
        flag=NO;
    }
    
    return flag;
}

-(bool)isMoreHundred:(NSMutableArray *)todayMeasures todayEmotions:(NSMutableArray *)todayEmotions indexMode:(int)indexMode
{
    BOOL flag=NO;
    
    int tempValue=0;
    int total=0;
    int totalPercentageCount=0;
    for (int i=0; i<todayMeasures.count; i++) {
        total+=[[todayMeasures objectAtIndex:i] intValue];
    }
    
    if ([todayEmotions count]==1) {
        
        return flag;
    }
    else
    {
        float percentage=0;
        for(int index=0;index<todayMeasures.count;index++)
        {
            percentage = (total)?[[todayMeasures objectAtIndex:index] floatValue]/total:0;
            
            //NSString *percentageString = [NSString stringWithFormat:@" %0.0f%@\n%@",percentage*100, @"%",[todayEmotions objectAtIndex:index]];
            NSString *percentageString = [NSString stringWithFormat:@" %0.0f",percentage*100];
            if([percentageString intValue] >=tempValue)
            {
                tempValue=[percentageString intValue];
                if(indexMode==TodayIamIndex)
                {
                    calibrationIndexTodayIam=index;
                }
                else if(indexMode==DiaryPieIndex)
                {
                    calibrationIndexDiaryPie=index;
                }
                else if(indexMode==HappinessPieIndex)
                {
                    calibrationIndexHappinessPie=index;
                }
            }
            totalPercentageCount=totalPercentageCount+[percentageString intValue];
        }
        /*
         float percentage = (total)?[[todayMeasures objectAtIndex:index] floatValue]/total:0;
         //NSString *percentageString = [NSString stringWithFormat:@" %0.0f%@\n%@",percentage*100, @"%",[todayEmotions objectAtIndex:index]];
         NSString *percentageString = [NSString stringWithFormat:@" %0.0f%@\n%@",percentage*100];*/
    }
    
    if(totalPercentageCount==100)
    {
        flag=NO;
    }
    else if(totalPercentageCount==101)
    {
        flag=YES;
    }
    else
    {
        flag=NO;
    }

    
    return flag;
}


@end
