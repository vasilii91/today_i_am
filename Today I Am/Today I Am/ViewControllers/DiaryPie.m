//
//  HappinessPie.m
//  Today I Am
//
//  Created by redoan on 3/26/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import "DiaryPie.h"
#import <QuartzCore/QuartzCore.h>
#import "XYPieChart.h"
#import "AppDelegate.h"
#import "NSDate+convenience.h"
#import <CoreData/CoreData.h>
#import "UploadView.h"

@interface DiaryPie ()

@end

@implementation DiaryPie
@synthesize slices = _slices;
@synthesize sliceColors = _sliceColors;

@synthesize type;
@synthesize dateselected,eventArray;


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
    
    
    self.slices = [NSMutableArray arrayWithCapacity:10];
    
    
    
    for(int i = 0; i < 10; i ++)
    {
        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
        [_slices addObject:one];
    }
    
    [pieChartRight setDelegate:self];
    [pieChartRight setStartPieAngle:M_PI_2];
    [pieChartRight setDataSource:self];
    [pieChartRight setLabelRadius:125];
    [pieChartRight setPieCenter:CGPointMake(pieChartRight.frame.size.width/2, pieChartRight.frame.size.height/2)];
    [pieChartRight setShowPercentage:NO];
    [pieChartRight setLabelColor:[UIColor blackColor]];
    [pieChartRight setLabelFont:[UIFont fontWithName:[FontManager currentFontName] size:11]];
    
    
    [pieChartRight setPieRadius:90];
    
    buttonUpload.titleLabel.font = [UIFont fontWithName:[FontManager currentFontName] size:17];
    [buttonUpload setTitle:LOC(@"key.button_upload") forState:UIControlStateNormal];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon0"]],
                       [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon3"]],
                       [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon21"]],
                       [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon1"]],
                       [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon13"]],nil];
    

    
    todayEmotions = [[NSMutableArray alloc] init];
    todayMeasure  = [[NSMutableArray alloc] init];
    todayReason   = [[NSMutableArray alloc] init];
    todayEmotitle = [[NSMutableArray alloc] init];
    
    [self fetchRecord];
    
}

-(void)fetchRecord
{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    managedObjectContext = [delegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
	
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    
    //    NSPredicate *p=[NSPredicate predicateWithFormat:@"test = GELLO"];
    //    //    [request setPredicate:p];
    
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"date = %@",self.dateselected]];
    
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	if (!mutableFetchResults) {
		// Handle the error.
		// This is a serious error and should advise the user to restart the application
	}
	
	// Save our fetched data to an array
    
    
	[self setEventArray: mutableFetchResults];
    
    NSString *detailText = @"";
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *emotions = [prefs objectForKey:@"emotions"];
    
    
    float total = 0.0;
    for (int i=0; i<eventArray.count; i++) {
        Event *event = [eventArray objectAtIndex: i];
        total+= [[event measure] intValue];
    }
        
    
    
    float y =5;
    
    for (int i=0; i<eventArray.count; i++) {
        
        
        
        Event *event = [eventArray objectAtIndex: i];
        [todayEmotions addObject:[event emotion]];
        [todayMeasure addObject:[event measure]];
        [todayReason addObject:[event reason]];
        [todayEmotitle addObject:[event emotitle]];
        
        
    }
    
    for (int i = 0; i<todayMeasure.count; i++) {
        for (int j=i+1; j<todayMeasure.count; j++) {
            if ([[todayMeasure objectAtIndex:j] integerValue]>[[todayMeasure objectAtIndex:i]integerValue]) {
                [todayMeasure exchangeObjectAtIndex:i withObjectAtIndex:j];
                [todayEmotions exchangeObjectAtIndex:i withObjectAtIndex:j];
                [todayReason exchangeObjectAtIndex:i withObjectAtIndex:j];
                [todayEmotitle exchangeObjectAtIndex:i withObjectAtIndex:j];
                
            }
        }
    }
    
    
    for (int i=0; i<todayEmotions.count; i++) {
        if ([[todayReason objectAtIndex:i] isEqualToString:@""]) {
            continue;
        }
        
        if ([[todayReason objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"Why are you %@?",[todayEmotitle objectAtIndex:i]]]) {
            
            continue;
        }
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, y, 25, 25)];
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%@",[todayEmotions objectAtIndex:i]]];
        
        [tray addSubview:image];
        UIFont *font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
        
        float percentage = (total)?[[todayMeasure  objectAtIndex:i] floatValue]/total:0;
//        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        ;
        
        NSString *reason;
        if (eventArray.count == 1) {
            reason = [NSString stringWithFormat:@"%0.0f%@ %@... %@",([[todayMeasure objectAtIndex:i] floatValue]/10)*100, @"%",[todayEmotitle objectAtIndex:i],[todayReason objectAtIndex:i]];
        }
        
        else{
            reason = [NSString stringWithFormat:@"%0.0f%@ %@... %@",percentage*100, @"%",[todayEmotitle objectAtIndex:i],[todayReason objectAtIndex:i]];
        }
        
        CGSize boundingSize = CGSizeMake(250, CGFLOAT_MAX);
        CGSize size = [reason sizeWithFont:font
                         constrainedToSize:boundingSize
                             lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = (size.height<25)?25:size.height;
        
        UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(40, y, 260,height)];
        detail.text = reason;
        detail.backgroundColor = [UIColor clearColor];
        detail.font = font;
        detail.numberOfLines = 0;
        detail.lineBreakMode = NSLineBreakByWordWrapping;
        
        [tray addSubview:detail];
        y += height+10;
        
        detailText = [detailText stringByAppendingFormat:@"%@... %@\n",[emotions objectAtIndex:[[todayEmotions objectAtIndex:i] integerValue]],[todayReason objectAtIndex:i]];
    }
 
    tray.contentSize = CGSizeMake(320, y);
//    details.text = detailText;
    
    calibrationNeededLess=[delegate isLessHundred:todayMeasure todayEmotions:todayEmotitle indexMode:DiaryPieIndex];
    calibrationNeededMore=[delegate isMoreHundred:todayMeasure todayEmotions:todayEmotitle indexMode:DiaryPieIndex];
    
    [pieChartRight reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate*delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    calibrationNeededLess=[delegate isLessHundred:todayMeasure todayEmotions:todayEmotions indexMode:DiaryPieIndex];
    calibrationNeededMore=[delegate isMoreHundred:todayMeasure todayEmotions:todayEmotions indexMode:DiaryPieIndex];

    [pieChartRight reloadData];
}

- (IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)menu:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    if ([todayEmotions count]==1) {
        return 2;
    }
    else{
        return [todayEmotions count];
    }
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    if ([todayMeasure count] == 1) {
        if (index == 0) {
            return [[todayMeasure objectAtIndex:index] intValue];
        }
        else{
            return 10-[[todayMeasure objectAtIndex:0] intValue];
        }
    }
    else{
        return [[todayMeasure objectAtIndex:index] intValue];
    }
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    
    if ([todayEmotions count]==1) {
        if (index == 0) {
            return [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"texture%d",[[todayEmotions objectAtIndex:0]intValue]]]];
        }
        else{
            return [UIColor clearColor];
        }
    }
    else{
        return [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"texture%d",[[todayEmotions objectAtIndex:index]intValue]]]];
    }
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    int total=0;
    for (int i=0; i<todayMeasure.count; i++) {
        total+=[[todayMeasure objectAtIndex:i] intValue];
    }
    
    pieChartRight.showingDiaryPie = YES;
    
    NSString *labelText;
    if ([todayEmotions count]==1) {
        
        if (index == 0) {
            float percentage = (10)?[[todayMeasure objectAtIndex:index] floatValue]/10:0;
            labelText = [NSString stringWithFormat:@"%0.0f%@\n%@",percentage*100, @"%",[todayEmotitle objectAtIndex:index]];
        }
        else{
            labelText = @"";
        }
    }
    else{
        float percentage = (total)?[[todayMeasure objectAtIndex:index] floatValue]/total:0;
        if(calibrationNeededLess)
        {
            if(index==((AppDelegate*)[[UIApplication sharedApplication]delegate]).calibrationIndexDiaryPie)
            {
                NSString *myCountString=[NSString stringWithFormat:@" %0.0f",percentage*100];
                float myCount=[myCountString floatValue]+1;
                labelText = [NSString stringWithFormat:@" %0.0f%@\n%@",myCount, @"%",[todayEmotitle objectAtIndex:index]];
                return labelText;
            }
        }
        if(calibrationNeededMore)
        {
            if(index==((AppDelegate*)[[UIApplication sharedApplication]delegate]).calibrationIndexDiaryPie)
            {
                //percentage=percentage-0.01;
                calibrationNeededLess=NO;
                calibrationNeededMore=NO;
                NSString *myCountString=[NSString stringWithFormat:@" %0.0f",percentage*100];
                float myCount=[myCountString floatValue]-1;
                labelText = [NSString stringWithFormat:@" %0.0f%@\n%@",myCount, @"%",[todayEmotitle objectAtIndex:index]];
                return labelText;
            }
        }
        labelText = [NSString stringWithFormat:@" %0.0f%@\n%@",percentage*100, @"%",[todayEmotitle objectAtIndex:index]];
    }
    return labelText;
}

#pragma mark - XYPieChart Delegate

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
    //    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}



#pragma mark - upload

- (IBAction) uploadButtonClicked:(id)sender
{
    UIGraphicsBeginImageContextWithOptions(pieChartRight.bounds.size, NO, 0.0);
    [pieChartRight.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *pieImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize finalSize = CGSizeMake(pieChartRight.bounds.size.height + 80.0f, pieChartRight.bounds.size.height + 80.0f);
    
    UIGraphicsBeginImageContextWithOptions(finalSize, NO, 0.0);

    [[UIImage imageNamed:@"exportBG"] drawAsPatternInRect:CGRectMake(0, 0, finalSize.width, finalSize.height)];
    [[UIImage imageNamed:@"header-1.png"] drawInRect:CGRectMake(10, 10, 95+48, 43 + 22)];
    
    float x = (finalSize.width-pieChartRight.frame.size.width)/2;
    float y = (finalSize.height-pieChartRight.frame.size.height)/2;
    
    [pieImage drawInRect:CGRectMake(x, y, [UIScreen mainScreen].bounds.size.width, pieChartRight.frame.size.height)];
    
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 44/255.0f, 114/255.0f, 162/255.0f, 1.0f);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 20);
    CGContextStrokeRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, finalSize.width, finalSize.height));
    
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UploadView *view = [[UploadView alloc] initWithNibName:@"UploadView" bundle:nil];
    view.imageToUpload = final;
    
    
    NSString *year   = [self.dateselected substringWithRange:NSMakeRange(0, 4)];
    NSString *month  = [self.dateselected substringWithRange:NSMakeRange(4, 2)];
    NSString *day    = [self.dateselected substringWithRange:NSMakeRange(6, 2)];

    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year   = [year intValue];
    dateComponents.month  = [month intValue];
    dateComponents.day    = [day intValue];
    
    NSDate *today = [NSDate date];
    
    NSDateComponents *TodayComponents = [[NSDateComponents alloc] init];
    TodayComponents.year   = [today year];
    TodayComponents.month  = [today month];
    TodayComponents.day    = [today day];
    
    NSDate *recordDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    today  = [[NSCalendar currentCalendar] dateFromComponents:TodayComponents];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    
    NSString *msg = @"";
    
    if ([recordDate isEqualToDate:today]) {
        msg = @"Today I’m…";
    }
    else {
        msg = [NSString stringWithFormat:@"On %@ I was…",[formatter stringFromDate:recordDate]];
    }
    
    view.message=msg;
    [self.navigationController pushViewController:view animated:NO];    
}

- (void) drawRessct:(CGRect)rect
{
    // Create a gradient from white to red
    CGFloat colors [] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 0.0, 0.0, 1.0
    };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    
    CGContextRestoreGState(context);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)viewDidUnload {
    buttonUpload = nil;
    [super viewDidUnload];
}
@end
