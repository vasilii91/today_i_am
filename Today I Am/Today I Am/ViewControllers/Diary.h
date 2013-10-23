//
//  HappinessHistory.h
//  Today I Am
//
//  Created by redoan on 3/14/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
#import "Event.h"

@interface Diary : UIViewController<VRGCalendarViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UIView *calendarContainer;
    
    NSMutableArray *datesHaveRecord;
    NSManagedObjectContext *managedObjectContext;
	NSMutableArray *eventArray;
    
    NSDate *dateofEntry;
    
    __weak IBOutlet UIButton *buttonThisMonth;
}
@property (nonatomic, retain) NSMutableArray *eventArray;
-(void)fetchRecord:(int)month :(int)year;
@end
