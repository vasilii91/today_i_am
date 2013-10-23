//
//  VRGViewController.m
//  Vurig Calendar
//
//  Created by in 't Veen Tjeerd on 5/29/12.
//  Copyright (c) 2012 Vurig. All rights reserved.
//

#import "VRGViewController.h"



@interface VRGViewController ()

@end

@implementation VRGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    calendar.delegate=self;
//    [calendar autoresizingMask];
//    calendar.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//    
//    calendar.frame = CGRectMake(0, 0, 120, 220);
//    [calendar sizeToFit];
//    calenderV.contentScaleFactor = .5;
    calenderV.transform = CGAffineTransformMakeScale(.85, .85);
    [calenderV addSubview:calendar];
    
//    CGFloat s = .95;
//    CGAffineTransform tr = CGAffineTransformScale(calendar.transform, s, s);
//    CGFloat h = calendar.frame.size.height;
//    CGFloat w = calendar.frame.size.width;
//    [UIView animateWithDuration:2.5 delay:0 options:0 animations:^{
//        calendar.transform = tr;
//        calendar.center = CGPointMake(w-w*s/2,h*s/2);
//    } completion:^(BOOL finished) {}];
//    
//    
    
    
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    if (month==[[NSDate date] month]) {
        NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:5], nil];
        [calendarView markDates:dates];
    }
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSLog(@"Selected date = %@",date);
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
