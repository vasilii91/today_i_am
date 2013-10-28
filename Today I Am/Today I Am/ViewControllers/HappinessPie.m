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
    slices = [[NSMutableArray alloc] init];
    emotions = [[NSMutableArray alloc] init];

    [self fetchRecord];
    
    [pieChartRight setDelegate:self];
    [pieChartRight setStartPieAngle:M_PI_2];
    [pieChartRight setDataSource:self];
    [pieChartRight setLabelRadius:125];
    [pieChartRight setPieCenter:CGPointMake(pieChartRight.frame.size.width/2, pieChartRight.frame.size.height/2)];
    [pieChartRight setShowPercentage:NO];
    [pieChartRight setLabelColor:[UIColor blackColor]];
    [pieChartRight setLabelFont:[UIFont fontWithName:[FontManager currentFontName] size:11]];
    [pieChartRight setPieRadius:90];
    
    uploadButton.titleLabel.font = [UIFont fontWithName:[FontManager currentFontName] size:17];
    [uploadButton setTitle:LOC(@"key.button_upload") forState:UIControlStateNormal];
    
    UIFont *currentFont = [UIFont fontWithName:[FontManager currentFontName] size:17];
    labelHappinessHistory.text = LOC(@"key.happiness_history");
    labelHappinessHistory.font = currentFont;
    
    labelTop5Emotions.font = [UIFont fontWithName:[FontManager currentFontName] size:9];
    labelTop5Emotions.text = LOC(@"key.your_top_5_emotions");
    
    happinessType.image = [UIImage imageNamed:[NSString stringWithFormat:@"history-%d",self.type]];
    
    NSString *datePiece = nil;
    if (type == 1) {
        datePiece = LOC(@"key.this_week_i_have_been");
    }
    else if (type == 2) {
        datePiece = LOC(@"key.this_month_i_have_been");
    }
    else {
        datePiece = LOC(@"key.this_year_i_have_been");
    }
    
    labelHappinessType.text = datePiece;
    labelHappinessType.font = [UIFont fontWithName:[FontManager currentFontName] size:12];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    AppDelegate*delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    calibrationNeededLess=[delegate isLessHundred:slices todayEmotions:emotions indexMode:HappinessPieIndex];
    calibrationNeededMore=[delegate isMoreHundred:slices todayEmotions:emotions indexMode:HappinessPieIndex];

    [pieChartRight reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    if([UIScreen mainScreen].bounds.size.height>480)
    {
        
    }
    else {
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
    
	[self setEventArray: mutableFetchResults];
    
    [self refreshArrays];
    
}

-(void)refreshArrays{
    
    for (int i=0; i<eventArray.count; i++) {
        NSDictionary *dict = [eventArray objectAtIndex:i];
        NSLog(@"%@",dict);
        [emotions addObject:[dict objectForKey:@"emotion"]];
        [slices addObject:[dict objectForKey:@"sum"]];
    }
    NSLog(@"SLICES %@",slices);
    float total=0;
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
    page.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
}

- (IBAction)changePage:(id)sender
{
    CGFloat pageWidth = emoContainerScroll.contentSize.width /page.numberOfPages;
    CGFloat x = page.currentPage * pageWidth;
    [emoContainerScroll scrollRectToVisible:CGRectMake(x, 0, pageWidth, emoContainerScroll.frame.size.height) animated:YES];
}

-(IBAction)uploadButtonClicked:(id)sender{
    
    UIGraphicsBeginImageContextWithOptions(pieChartRight.bounds.size, NO, 0.0);
    [pieChartRight.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *pieImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize finalSize = CGSizeMake(pieChartRight.bounds.size.height+ 80, pieChartRight.bounds.size.height+ 80);
    
    UIGraphicsBeginImageContextWithOptions(finalSize, NO, 0.0);
    
    [[UIImage imageNamed:@"exportBG"] drawAsPatternInRect:CGRectMake(0, 0, finalSize.width, finalSize.height)];
    
    
    float x;
    NSString *headerName = [NSString stringWithFormat:@"history-%d",type];
    UIImage *happinessImage = [UIImage imageNamed:@"happinessHeader.png"];
    UIImage *historyImage = [UIImage imageNamed:headerName];
    
    x = (finalSize.width - 350)/2;
    
    [happinessImage drawInRect:CGRectMake(x, 10, 350, 50 )];
    
    x = (finalSize.width - 320)/2;
    
    [historyImage drawInRect:CGRectMake(x, 40, 320, 30 )];
    
    [[UIImage imageNamed:@"dotedLine"] drawInRect:CGRectMake(10, 70, finalSize.width-20, 8 )];
    
    
    x = (finalSize.width - pieChartRight.frame.size.width)/2;
    
    [pieImage drawInRect:CGRectMake(x, 80, [UIScreen mainScreen].bounds.size.width, pieChartRight.frame.size.height)];
    
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
            view.message = @"Happiness History by Mood Sweet…";
            break;
        }
        case 2:
        {
            view.message = @"Happiness History by Mood Sweet…";
            break;
        }
        case 3:
        {
            view.message = @"Happiness History by Mood Sweet…";
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
    return (slices.count > 5) ? 5 : slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [ImageManager colorByTextureIndex:[emotions[index] intValue]];
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    int total=0;
    for (int i=0; i<slices.count; i++) {
        total+=[[slices objectAtIndex:i] intValue];
    }
    
    NSString *labelText;
        float percentage = (total)?[[slices objectAtIndex:index] floatValue]/total:0;
    if(calibrationNeededLess)
    {
        if(index==((AppDelegate*)[[UIApplication sharedApplication]delegate]).calibrationIndexHappinessPie)
        {
            NSString *myCountString=[NSString stringWithFormat:@" %0.0f",percentage*100];
            float myCount=[myCountString floatValue]+1;
            labelText = [NSString stringWithFormat:@" %0.0f%@\n%@",myCount, @"%",[emotions objectAtIndex:index]];
            return labelText;
        }
    }
    if(calibrationNeededMore)
    {
        if(index==((AppDelegate*)[[UIApplication sharedApplication]delegate]).calibrationIndexHappinessPie)
        {
            calibrationNeededLess=NO;
            calibrationNeededMore=NO;
            NSString *myCountString=[NSString stringWithFormat:@" %0.0f",percentage*100];
            float myCount=[myCountString floatValue]-1;
            labelText = [NSString stringWithFormat:@" %0.0f%@\n%@",myCount, @"%",[emotions objectAtIndex:index]];
            return labelText;
        }
    }
        labelText = [NSString stringWithFormat:@" %0.0f%@\n%@",percentage*100, @"%",[emotions objectAtIndex:index]];
    
    NSLog(@"HIF %@",[emotions objectAtIndex:index]);

    return labelText;
}


#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
}


- (void)viewDidUnload {
    uploadButton = nil;
    labelHappinessHistory = nil;
    labelHappinessType = nil;
    labelTop5Emotions = nil;
    [super viewDidUnload];
}
@end
