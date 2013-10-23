//
//  HappinessPie.h
//  Today I Am
//
//  Created by redoan on 3/26/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "Event.h"
@interface HappinessPie : UIViewController<UIScrollViewDelegate,XYPieChartDelegate,XYPieChartDataSource>
{
    IBOutlet UIScrollView *emoContainerScroll;
    IBOutlet UIPageControl *page;
    IBOutlet UIImageView *happinessType;
    __weak IBOutlet UILabel *labelHappinessType;
    IBOutlet XYPieChart *pieChartRight;
    
    IBOutlet UIView *tray;
    
    __weak IBOutlet UIButton *uploadButton;
    __weak IBOutlet UILabel *labelHappinessHistory;
    __weak IBOutlet UILabel *labelTop5Emotions;
    NSManagedObjectContext *managedObjectContext;
	NSMutableArray *eventArray;
    
    NSMutableArray *slices;
    NSMutableArray *emotions;
    
    BOOL calibrationNeededLess;
    BOOL calibrationNeededMore;
}

@property (nonatomic) int type;


@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *eventArray;

@end
