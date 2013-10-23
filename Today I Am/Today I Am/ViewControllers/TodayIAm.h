//
//  TodayIAm.h
//  Today I Am
//
//  Created by redoan on 3/10/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

#import "Event.h"

@interface TodayIAm : UIViewController<UITextViewDelegate,XYPieChartDataSource,XYPieChartDelegate,UIAlertViewDelegate>
{
    IBOutlet UIScrollView *emoContainerScroll;
    IBOutlet UILabel *currentEmotionTitle;
    IBOutlet UILabel *currentEmotionSlogan;
    IBOutlet UIImageView *currentEmotionThumb;
    IBOutlet UIView *emoDetailView;
    IBOutlet UILabel *date;
    
    IBOutlet UIButton*backButton;
    
    IBOutlet UITextView *detailTextView;
    IBOutlet UIScrollView *emoDetailScroll;
    IBOutlet UIScrollView *indicatorScroll;
    
    IBOutlet UITextView *doneDescriptionText;

    IBOutlet UISlider *measurementSlider;
    
    __weak IBOutlet UIButton *uploadButton;
    __weak IBOutlet UIButton *saveButton;
    __weak IBOutlet UIButton *iAmAlsoButon;
    __weak IBOutlet UIButton *doneButton;
    
    int currentEmotionIndex;
    
    int backLevel;
    
    NSMutableArray *todayEmotions;
    NSMutableArray *todayMeasure;
    NSMutableArray *todayReason;
    
    IBOutlet XYPieChart *pieChartRight;
    
    NSManagedObjectContext *managedObjectContext;
	NSMutableArray *eventArray;
    
    IBOutlet UIScrollView *tray;
    
    BOOL isUsed;
    int alertLevel;
    
    BOOL calibrationNeededLess;
    BOOL calibrationNeededMore;
}

- (void)fetchRecords;
- (void)addRecord;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *eventArray;
@property (nonatomic, retain) NSDate *dateofEntry;
- (IBAction)hideTextview:(id)sender;

-(IBAction)emoSelected:(id)sender;
-(IBAction)show:(id)sender;
@property(strong,nonatomic)IBOutlet UIView *doneEmoView;

@end
