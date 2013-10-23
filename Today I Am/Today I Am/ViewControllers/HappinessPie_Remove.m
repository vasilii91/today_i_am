//
//  HappinessPie.m
//  Today I Am
//
//  Created by redoan on 3/26/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import "HappinessPie.h"
#import <QuartzCore/QuartzCore.h>
#import "XYPieChart.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "NSDate+convenience.h"
#import "UploadView.h"
@interface HappinessPie ()

@end

@implementation HappinessPie
//@synthesize pieChartRight = _pieChart;
//@synthesize pieChartLeft = _pieChartCopy;
//@synthesize percentageLabel = _percentageLabel;
//@synthesize selectedSliceLabel = _selectedSlice;
//@synthesize numOfSlices = _numOfSlices;
//@synthesize indexOfSlices = _indexOfSlices;
//@synthesize downArrow = _downArrow;
//@synthesize slices = _slices;
@synthesize sliceColors = _sliceColors;

@synthesize type;

@synthesize managedObjectContext,eventArray;


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
    // Do any additional setup after loading the view from its nib.

//    emoContainerScroll.frame = CGRectMake(0, 295, emoContainerScroll.frame.size.width, emoContainerScroll.frame.size.height);
    slices = [[NSMutableArray alloc] init];
    emotions = [[NSMutableArray alloc] init];

//    [self initEmos];
    
    [self fetchRecord];
    
    [pieChartRight setDelegate:self];
    [pieChartRight setStartPieAngle:M_PI_2];
    [pieChartRight setDataSource:self];
    [pieChartRight setLabelRadius:125];
    [pieChartRight setPieCenter:CGPointMake(pieChartRight.frame.size.width/2, pieChartRight.frame.size.height/2)];
    [pieChartRight setShowPercentage:NO];
    [pieChartRight setLabelColor:[UIColor blackColor]];
    [pieChartRight setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:11]];
    
    
    [pieChartRight setPieRadius:90];
    
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon0"]],
                       [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon3"]],
                       [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon21"]],
                       [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon1"]],
                       [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon13"]],nil];
    
    //rotate up arrow
//    self.downArrow.transform = CGAffineTransformMakeRotation(M_PI);
    happinessType.image = [UIImage imageNamed:[NSString stringWithFormat:@"history-%d",self.type]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.pieChartLeft reloadData];
    [pieChartRight reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    if([UIScreen mainScreen].bounds.size.height>480)
    {
        
    }

    else{
        CGRect frame = emoContainerScroll.frame;
        frame.size.height = frame.size.height/2;
        emoContainerScroll.frame = frame;
        emoContainerScroll.contentSize = CGSizeMake(frame.size.width, 80);
        
        
        
    }
}

-(void)fetchRecord{
    
    
    NSDate *today = [NSDate date];
    NSString *start = @"", *end = @"";
    start = [start stringByAppendingFormat:@"%d",[today year]];
    end = [end stringByAppendingFormat:@"%d",[today year]];
    if (self.type == 2) {
        
        if([today month]<10)
        {
            start = [start stringByAppendingFormat:@"0%d00",[today month]];
            end = [end stringByAppendingFormat:@"0%d32",[today month]];
        }
        else
        {
            start = [start stringByAppendingFormat:@"%d00",[today month]];
            end = [end stringByAppendingFormat:@"%d32",[today month]];
        }
        
        
    }
    
    else if (self.type == 1)
    {
        NSDate *weekStart = [NSDate dateStartOfWeek];
            int daysToAdd = 6;
        NSDate *weekEnd = [weekStart dateByAddingTimeInterval:60*60*24*daysToAdd];
        
        
        if ([today day]<[weekStart day]) {
            NSLog(@"START LASTMONTH");
            start = ([today month]-1<10)?[start stringByAppendingFormat:@"0%d",[today month]-1]:[start stringByAppendingFormat:@"%d",[today month]-1];
            
            start = ([weekStart day]<10)?[start stringByAppendingFormat:@"0%d",[weekStart day]]:[start stringByAppendingFormat:@"%d",[weekStart day]];
            
        }
        else  {
            NSLog(@"START THIS MONTH");
            start = ([today month]<10)?[start stringByAppendingFormat:@"0%d",[today month]]:[start stringByAppendingFormat:@"%d",[today month]];
            
            start = ([[NSDate dateStartOfWeek] day]<10)?[start stringByAppendingFormat:@"0%d",[weekStart day]]:[start stringByAppendingFormat:@"%d",[weekStart day]];
            
        }
        
        
        
        if ([today day]>[weekEnd day]) {
            NSLog(@"END NextMONTH");
            end = ([today month]+1<10)?[end stringByAppendingFormat:@"0%d",[today month]+1]:[end stringByAppendingFormat:@"%d",[today month]+1];
            
            end = ([weekEnd day]<10)?[end stringByAppendingFormat:@"0%d",[weekEnd day]]:[end stringByAppendingFormat:@"%d",[weekEnd day]];
            
        }
        else  {
            NSLog(@"END THIS MONTH");
            end = ([today month]<10)?[end stringByAppendingFormat:@"0%d",[today month]]:[end stringByAppendingFormat:@"%d",[today month]];
            
            end = ([weekEnd day]<10)?[end stringByAppendingFormat:@"0%d",[weekEnd day]]:[end stringByAppendingFormat:@"%d",[weekEnd day]];
            
        }
        
NSLog(@"WEEK STRT %d END %d",[weekStart day],[weekEnd day]);
    }

    else if (self.type == 3)
    {
        start = [start stringByAppendingFormat:@"0100"];
        end = [end stringByAppendingFormat:@"1232"];
    }
    
    NSLog(@"TYPE - %d START %@ AND END %@",self.type,start,end);
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    //
    
    NSAttributeDescription* statusDesc = [entity.attributesByName objectForKey:@"emotion"];
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath: @"measure"]; // Does not really matter
    NSExpression *countExpression = [NSExpression expressionForFunction: @"sum:"
                                                              arguments: [NSArray arrayWithObject:keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName: @"sum"];
    [expressionDescription setExpression: countExpression];
    [expressionDescription setExpressionResultType: NSFloatAttributeType];
    
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    [request setPropertiesToFetch:[NSArray arrayWithObjects:statusDesc, expressionDescription, nil]];
    [request setPropertiesToGroupBy:[NSArray arrayWithObject:statusDesc]];
    
    [request setResultType:NSDictionaryResultType];
    //    NSError* error = nil;
    //    NSArray *results = [myManagedObjectContext executeFetchRequest:fetch
    //                                                             error:&error];
    
    //    NSPredicate *p=[NSPredicate predicateWithFormat:@"test = GELLO"];
    //    //    [request setPredicate:p];
    
    
    
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@",start,end]];
    
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"measure" ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	[request setSortDescriptors:sortDescriptors];
    
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	if (!mutableFetchResults) {
		// Handle the error.
		// This is a serious error and should advise the user to restart the application
	}
	
	// Save our fetched data to an array
    
    
	[self setEventArray: mutableFetchResults];
    
    //    NSLog(@"THIS IS DATA %@ - %d",eventArray,eventArray.count);
    
    [self refreshArrays];
    
}

-(void)refreshArrays{
    
    for (int i=0; i<eventArray.count; i++) {
        NSDictionary *dict = [eventArray objectAtIndex:i];
        [emotions addObject:[dict objectForKey:@"emotion"]];
        [slices addObject:[dict objectForKey:@"sum"]];
    }
    NSLog(@"SLICES %@",slices);
    float total;
    for (int i=0; i<slices.count; i++) {
        total+= [[slices objectAtIndex:i] intValue];
    }
    
    
    for (int i=0; i<emotions.count; i++) {
        UIImageView *imageView = (UIImageView*)[self.view viewWithTag:i+1];
        if (imageView.class == [UIImageView class]) {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%@",[emotions objectAtIndex:i]]];
        }
        
        
        float percentage = (total)?[[slices objectAtIndex:i] floatValue]/total:0;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        ;
        UILabel *percentLabel = (UILabel*)[self.view viewWithTag:i+1+5];
        
        percentLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:10];
        
        percentLabel.text = [NSString stringWithFormat:@"%0.0f%@ %@",percentage*100, @"%",[[prefs objectForKey:@"emotions"] objectAtIndex:[[emotions objectAtIndex:i]intValue]]];
    }
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"checking %f",scrollView.contentOffset.x);
    page.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
}

- (IBAction)changePage:(id)sender {
//    _pageControlUsed = YES;
    CGFloat pageWidth = emoContainerScroll.contentSize.width /page.numberOfPages;
    CGFloat x = page.currentPage * pageWidth;
    [emoContainerScroll scrollRectToVisible:CGRectMake(x, 0, pageWidth, emoContainerScroll.frame.size.height) animated:YES];
}

-(IBAction)uploadButtonClicked:(id)sender{
    
    UIGraphicsBeginImageContextWithOptions(pieChartRight.bounds.size, NO, 0.0);
    [pieChartRight.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *pieImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
//    UIGraphicsBeginImageContextWithOptions(tray.frame.size, NO, 0.0);
//    
////    CGPoint savedContentOffset = tray.contentOffset;
////    CGRect savedFrame = tray.frame;
//    
////    tray.contentOffset = CGPointZero;
////    tray.frame = CGRectMake(0, 0, tray.contentSize.width, tray.contentSize.height);
//    
//    [tray.layer renderInContext: UIGraphicsGetCurrentContext()];
//    UIImage *trayImage = UIGraphicsGetImageFromCurrentImageContext();
//    
////    tray.contentOffset = savedContentOffset;
////    tray.frame = savedFrame;
//    
//    UIGraphicsEndImageContext();
    
    CGSize finalSize = CGSizeMake(pieChartRight.bounds.size.height+ 80, pieChartRight.bounds.size.height+ 80);
    
    UIGraphicsBeginImageContextWithOptions(finalSize, NO, 0.0);
    
    // Create a gradient from white to red
//    CGFloat colors [] = {
//        1.0, 1.0, 1.0, 1.0,
//        .0, .0, .0, .25
//    };
//    
//    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
//    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGRect rect = CGRectMake(0, 0, finalSize.width, finalSize.height);
//    
//    CGContextSaveGState(context);
//    //    CGContextAddEllipseInRect(context, rect);
//    CGContextClip(context);
//    
//    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
//    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
//    
//    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
//    CGGradientRelease(gradient), gradient = NULL;
//    
//    CGContextRestoreGState(context);
//    
    //    CGContextAddEllipseInRect(context, rect);
    //    CGContextDrawPath(context, kCGPathStroke);
    [[UIImage imageNamed:@"exportBG"] drawAsPatternInRect:CGRectMake(0, 0, finalSize.width, finalSize.height)];
    
    
    float x;
    NSString *headerName = [NSString stringWithFormat:@"history-%d",type];
    UIImage *happinessImage = [UIImage imageNamed:@"happinessHeader.png"];
    UIImage *historyImage = [UIImage imageNamed:headerName];
    
//    x = (finalSize.width-happinessImage.size.width)/2;
    x = (finalSize.width - 350)/2;
    
    [happinessImage drawInRect:CGRectMake(x, 10, 350, 50 )];
    
    x = (finalSize.width - 320)/2;
    
    [historyImage drawInRect:CGRectMake(x, 40, 320, 30 )];
    
    [[UIImage imageNamed:@"dotedLine"] drawInRect:CGRectMake(10, 70, finalSize.width-20, 8 )];
    
    
    x = (finalSize.width - pieChartRight.frame.size.width)/2;
    
    [pieImage drawInRect:CGRectMake(x, 80, [UIScreen mainScreen].bounds.size.width, pieChartRight.frame.size.height)];
    
//    [[UIImage imageNamed:@"backgraund.png"] drawInRect:CGRectMake(10, pieChartRight.frame.size.height+53, [UIScreen mainScreen].bounds.size.width, tray.frame.size.height)];
    
//    [trayImage drawInRect:CGRectMake(10, pieChartRight.frame.size.height+60, [UIScreen mainScreen].bounds.size.width, tray.frame.size.height)];
    
    
    
    
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 44/255.0f, 114/255.0f, 162/255.0f, 1.0f);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 20);
    CGContextStrokeRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, finalSize.width, finalSize.height));
    
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    UploadView *view = [[UploadView alloc] initWithNibName:@"UploadView" bundle:nil];
    view.imageToUpload = final;
    switch (type) {
        case 1:
        {
            view.message = @"Happiness History by Today I’m…";
            break;
        }
        case 2:
        {
            view.message = @"Happiness History by Today I’m…";
            break;
        }
        case 3:
        {
            view.message = @"Happiness History by Today I’m…";
            break;
        }
        default:
            break;
    }
    [self.navigationController pushViewController:view animated:NO];
    
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)menu:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{

    return (slices.count>5)?5:slices.count;
    return slices.count;
//    return 5;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[slices objectAtIndex:index] intValue];
//    return 20;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
//    if(pieChart == self.pieChartRight) return nil;
    
    return [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"texture%d",[[emotions objectAtIndex:index] intValue]]]];
//    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index{
    //    return [pieLabel objectAtIndex:index];
    
    //    return @"H";
    int total=0;
    for (int i=0; i<slices.count; i++) {
        total+=[[slices objectAtIndex:i] intValue];
    }
    
    
    
    NSString *labelText;
        float percentage = (total)?[[slices objectAtIndex:index] floatValue]/total:0;
        labelText = [NSString stringWithFormat:@"%0.0f%@\n%@",percentage*100, @"%",[emotions objectAtIndex:index]];
    
    NSLog(@"HIF %@",[emotions objectAtIndex:index]);
    
//    if ([emotions count]==1) {
//        
//        if (index == 0) {
//            float percentage = (10)?[[emotions objectAtIndex:index] floatValue]/10:0;
//            labelText = [NSString stringWithFormat:@"%0.0f%@\n%@",percentage*100, @"%",[emotions objectAtIndex:index]];
//        }
//        else{
//            labelText = @"";
//        }
//    }
//    else{
//        float percentage = (total)?[[emotions objectAtIndex:index] floatValue]/total:0;
//        labelText = [NSString stringWithFormat:@" %0.0f%@\n%@",percentage*100, @"%",[emotions objectAtIndex:index]];
//    }
//    return labelText;


    return labelText;
}


#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
//    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}


@end
