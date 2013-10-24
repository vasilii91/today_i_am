//
//  HappinessHistory.m
//  Today I Am
//
//  Created by redoan on 3/14/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import "Diary.h"
#import <QuartzCore/QuartzCore.h>
#import "DiaryPie.h"
#import "NSDate+convenience.h"
#import "CustomAlertView.h"
#import "AppDelegate.h"
#import "HappinessPie.h"
#import "TodayIAm.h"
@interface Diary ()

@end

@implementation Diary
@synthesize eventArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    calendar.delegate=self;
    calendar.layer.cornerRadius = 10;
    calendar.clipsToBounds = YES;
    [calendarContainer addSubview:calendar];
    
    datesHaveRecord = [[NSMutableArray alloc] init];
    
    [buttonThisMonth setTitle:LOC(@"key.this_month_i_am") forState:UIControlStateNormal];
    [buttonThisMonth.titleLabel setFont:[UIFont fontWithName:[FontManager currentFontName] size:17]];
    [buttonThisMonth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    calendarContainer.transform = CGAffineTransformMakeScale(.85, .85);
    calendarContainer.frame = CGRectMake(calendarContainer.frame.origin.x-640, calendarContainer.frame.origin.y, calendarContainer.frame.size.width, calendarContainer.frame.size.height);
}

-(void)viewDidAppear:(BOOL)animated
{
    [UIView beginAnimations:@"calendar" context:nil];
    calendarContainer.frame = CGRectMake(calendarContainer.frame.origin.x+640, calendarContainer.frame.origin.y, calendarContainer.frame.size.width, calendarContainer.frame.size.height);
    [UIView commitAnimations];
}

-(void)fetchRecord:(int)month :(int)year{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    managedObjectContext = [delegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
	
    NSString *startBound;
    NSString *endBound;
	// Setup the fetch request
    if (month<10) {
        startBound = [NSString stringWithFormat:@"%d0%d00",year,month];
        endBound   = [NSString stringWithFormat:@"%d0%d32",year,month];
    }
    
    else{
        startBound = [NSString stringWithFormat:@"%d%d00",year,month];
        endBound   = [NSString stringWithFormat:@"%d%d32",year,month];;
    }
    
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date>= %@ AND date<= %@",startBound,endBound];
    
        NSLog(@"PREDICATE %@",predicate);
    
    [request setPredicate:predicate];
    
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	[self setEventArray: mutableFetchResults];
//
    NSLog(@"THIS IS DATA %@",eventArray);
    
    [datesHaveRecord removeAllObjects];
    for (int i=0; i<eventArray.count; i++) {
        Event *event = [eventArray objectAtIndex:i];
        
        NSLog(@"event Date = %@",event.date);
        NSNumber *day = [NSNumber numberWithInt:[event date].intValue%100];
        
        if ([datesHaveRecord containsObject:day]) {
            continue;
        }
        [datesHaveRecord addObject:day];
    }
}


#pragma CalenderDELEGATES
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month year:(int)year targetHeight:(float)targetHeight animated:(BOOL)animated {
    [self fetchRecord:month :year];
    NSLog(@"MONTH IS NOW %d and year is %d ",month,year);
    
    NSLog(@"DECORDS %@",datesHaveRecord);
    
    [calendarView markDates:datesHaveRecord];
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSLog(@"Selected date = %@",date);
    dateofEntry = date;
    if([datesHaveRecord containsObject:[NSNumber numberWithInt:[date day]]])
    {
        
        
        NSString *dateString;
        dateString = @"";
        dateString = [dateString stringByAppendingFormat:@"%d",[date year]];
        
        if([date month]<10)
        {
            dateString = [dateString stringByAppendingFormat:@"0%d",[date month]];
        }
        else
        {
            dateString = [dateString stringByAppendingFormat:@"%d",[date month]];
        }
        
        if([date day]<10)
        {
            dateString = [dateString stringByAppendingFormat:@"0%d",[date day]];
        }
        else
        {
            dateString = [dateString stringByAppendingFormat:@"%d",[date day]];
        }
        
        DiaryPie *view = [[DiaryPie alloc] initWithNibName:@"DiaryPie" bundle:nil];
        view.dateselected = dateString;
        [self.navigationController pushViewController:view animated:YES];
    }
    
    else if([date compare:[NSDate date]] != NSOrderedDescending)
    {
        CustomAlertView *alert = [[CustomAlertView alloc]initWithTitle:LOC(@"key.do_you_want") message:@"" delegate:self cancelButtonTitle:LOC(@"key.button_yes") otherButtonTitles:LOC(@"key.button_no"),nil];
        
        [alert show];
        return;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
    }
    else if(buttonIndex == 0){
        TodayIAm *view = [[TodayIAm alloc] initWithNibName:@"TodayIAm" bundle:nil];
        view.dateofEntry = dateofEntry;
        [self.navigationController pushViewController:view animated:YES];
    }
}
-(void)hideAlert:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

       
-(IBAction)thisMonthIhaveBeen{
    HappinessPie *view = [[HappinessPie alloc] initWithNibName:@"HappinessPie" bundle:nil];
    view.type = 2;
    [self.navigationController pushViewController:view animated:NO];
}



#pragma mark- IBActions
-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)menu:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    buttonThisMonth = nil;
    [super viewDidUnload];
}
@end
