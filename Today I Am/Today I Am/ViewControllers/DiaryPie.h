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

@interface DiaryPie : UIViewController<UIScrollViewDelegate,XYPieChartDelegate,XYPieChartDataSource>
{

    IBOutlet XYPieChart *pieChartRight;
    
    IBOutlet UILabel *date;
    
    NSMutableArray *todayEmotions;
    NSMutableArray *todayMeasure;
    NSMutableArray *todayReason;
    NSMutableArray *todayEmotitle;
    NSManagedObjectContext *managedObjectContext;
	NSMutableArray *eventArray;
    
    IBOutlet UIScrollView* tray;
    
    __weak IBOutlet UIButton *buttonUpload;
    BOOL calibrationNeededLess;
    BOOL calibrationNeededMore;
}

@property (nonatomic, strong) NSMutableArray *eventArray;
@property (nonatomic, strong) NSString *dateselected;

-(void)fetchRecord;

@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;

@property (nonatomic) int type;


@end
