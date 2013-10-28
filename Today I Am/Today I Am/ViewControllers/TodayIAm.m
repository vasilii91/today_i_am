//
//  TodayIAm.m
//  Today I Am
//
//  Created by redoan on 3/10/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import "TodayIAm.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+convenience.h"
#import "ViewController.h"
#import "CustomAlertView.h"
#import "AppDelegate.h"
#import "UploadView.h"
#import "FlurryAds.h"



@interface TodayIAm ()

@end

@implementation TodayIAm

@synthesize doneEmoView;
@synthesize managedObjectContext,eventArray;
@synthesize dateofEntry;

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
	// Do any additional setup after loading the view.
    [self initEmos];

    date.font = [UIFont fontWithName:[FontManager currentFontName] size:15];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    date.text = [NSString stringWithFormat:@"%@  ",[formatter stringFromDate:self.dateofEntry]];
    
    [detailTextView.layer setCornerRadius:5];
    detailTextView.clipsToBounds = YES;
    detailTextView.font = [UIFont fontWithName:[FontManager currentFontName] size:18];
    
    emoDetailScroll.contentSize = CGSizeMake(320, 568);

    UIView *firstViewUIView = [[[NSBundle mainBundle] loadNibNamed:@"doneView" owner:self options:nil] objectAtIndex:0];
    [self.doneEmoView addSubview:firstViewUIView];
    doneEmoView.frame = CGRectMake(0, 568, doneEmoView.frame.size.width, doneEmoView.frame.size.height);
    
    UIView *top = (UIView*)[self.view viewWithTag:901];
    
    top.frame = CGRectMake(top.frame.origin.x, 0, top.frame.size.width, top.frame.size.height);
    emoContainerScroll.frame = CGRectMake(0, IS_IPHONE_5 ? 100 : 85, emoContainerScroll.frame.size.width, emoContainerScroll.frame.size.height);
    
    
    currentEmotionTitle.font = [UIFont fontWithName:[FontManager currentFontName] size:25];
    currentEmotionSlogan.font = [UIFont fontWithName:[FontManager currentFontName] size:11];
    
    uploadButton.titleLabel.font = [UIFont fontWithName:[FontManager currentFontName] size:17];
    saveButton.titleLabel.font = [UIFont fontWithName:[FontManager currentFontName] size:17];
    iAmAlsoButon.titleLabel.font = [UIFont fontWithName:[FontManager currentFontName] size:17];
    doneButton.titleLabel.font = [UIFont fontWithName:[FontManager currentFontName] size:17];

    [uploadButton setTitle:LOC(@"key.button_upload") forState:UIControlStateNormal];
    [saveButton setTitle:LOC(@"key.button_save") forState:UIControlStateNormal];
    [iAmAlsoButon setTitle:LOC(@"key.button_i_am_also") forState:UIControlStateNormal];
    [doneButton setTitle:LOC(@"key.button_done") forState:UIControlStateNormal];
    
    todayEmotions = [[NSMutableArray alloc] init];
    todayMeasure  = [[NSMutableArray alloc] init];
    todayReason   = [[NSMutableArray alloc] init];
    
    
    [pieChartRight setDelegate:self];
    [pieChartRight setStartPieAngle:M_PI_2];
    [pieChartRight setDataSource:self];
    [pieChartRight setLabelRadius:125];
    [pieChartRight setPieCenter:CGPointMake(pieChartRight.frame.size.width/2, pieChartRight.frame.size.height/2)];
    [pieChartRight setShowPercentage:NO];
    [pieChartRight setLabelColor:[UIColor blackColor]];
    [pieChartRight setLabelFont:[UIFont fontWithName:[FontManager currentFontName] size:11]];
    
    
    [pieChartRight setPieRadius:90];
    
    [self fetchRecord];
    
    isUsed = YES;
}

-(void)fetchRecord{

    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
	
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    
    NSDate *today = self.dateofEntry;
    
    NSString *dateString;
    dateString = @"";
    dateString = [dateString stringByAppendingFormat:@"%d",[today year]];
    
    if([today month]<10)
    {
        dateString = [dateString stringByAppendingFormat:@"0%d",[today month]];
    }
    else
    {
        dateString = [dateString stringByAppendingFormat:@"%d",[today month]];
    }
    
    if([today day]<10)
    {
        dateString = [dateString stringByAppendingFormat:@"0%d",[today day]];
    }
    else
    {
        dateString = [dateString stringByAppendingFormat:@"%d",[today day]];
    }
    
    NSNumber *dateToday = [NSNumber numberWithInt:[dateString intValue]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"date = %@",dateToday]];
    
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
	[self setEventArray: mutableFetchResults];
    
    NSLog(@"THIS IS DATA %@",eventArray);
}

-(void)refreshArrays{

    for (int i=0; i<eventArray.count; i++) {
        Event *event = [eventArray objectAtIndex: i];
        [todayEmotions addObject:[event emotion]];
        [todayMeasure addObject:[event measure]];
        [todayReason addObject:[event reason]];
        
        UIImageView *ind = [[UIImageView alloc]initWithFrame:CGRectMake(13+(30*(i)), 12, 21, 23)];
        
        [indicatorScroll addSubview:ind];
        ind.image = [self addImage:[UIImage imageNamed:@"indicator-bg"] toImage:[self maskImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon%@",[event emotion]]] withMask:[UIImage imageNamed:@"indicator-fg"]]];
        
        indicatorScroll.contentSize = CGSizeMake(13+(30*([todayEmotions count])), indicatorScroll.frame.size.height);
        
    }
    
}

- (void)addRecord
{
    NSDate *today = self.dateofEntry;
    NSString *dateString;
    dateString = @"";
    dateString = [dateString stringByAppendingFormat:@"%d",[today year]];
    
    if([today month]<10)
    {
        dateString = [dateString stringByAppendingFormat:@"0%d",[today month]];
    }
    else
    {
        dateString = [dateString stringByAppendingFormat:@"%d",[today month]];
    }
    
    if([today day]<10)
    {
        dateString = [dateString stringByAppendingFormat:@"0%d",[today day]];
    }
    else
    {
        dateString = [dateString stringByAppendingFormat:@"%d",[today day]];
    }
    Event *event;


    
    for (int i = 0; i<eventArray.count; i++) {
        [managedObjectContext deleteObject:[eventArray objectAtIndex:i]];
    }
    
    [eventArray removeAllObjects];
    
    if (todayEmotions.count<=0) {
        return;
    }
    
    

    
	for (int i=0; i<todayEmotions.count; i++) {
        event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjectContext];
        
        NSNumber *emotion = [NSNumber numberWithInt:[[todayEmotions objectAtIndex:i]intValue]];
        NSNumber *measure = [NSNumber numberWithInt:[[todayMeasure objectAtIndex:i]intValue]];
        NSString *reason  = [todayReason objectAtIndex:i];

        
        [event setDate:[NSNumber numberWithInt:[dateString intValue]]];
        
        if ([reason isEqualToString:[NSString stringWithFormat:LOC(@"key.why_are_you"),[[[NSUserDefaults standardUserDefaults] objectForKey:@"emotions"] objectAtIndex:[emotion intValue]]]]) {
            [event setReason:@""];
        }
        else {
            [event setReason:reason];
        }
        NSString*emotitle = [[[NSUserDefaults standardUserDefaults] objectForKey:@"emotions"] objectAtIndex:[emotion intValue]];
        
        [event setMeasure:measure];
        [event setEmotion:emotion];
        [event setEmotitle:emotitle];
    }
        
    
    
	NSError *error;
	if (![managedObjectContext save:&error]) {
	}
	
	[eventArray insertObject:event atIndex:0];
    
    CustomAlertView *alert = [[CustomAlertView alloc]initWithTitle:@" "
                                                           message:LOC(@"key.saved_to_diary")
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles: nil];
    
    [alert show];
    [self performSelector:@selector(hideAlert:) withObject:alert afterDelay:3];
    
    isUsed = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    emoDetailView.frame = CGRectMake(0, 568, emoDetailView.frame.size.width, emoDetailView.frame.size.height);
}

-(void)initEmos
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *emotions = [prefs objectForKey:@"emotions"];
    int index = 0;
    float yOffset;
    if ([UIScreen mainScreen].bounds.size.height>480) {
        yOffset = 40;
    }
    else{
        yOffset = 33;
    }
    for (int i=0; i<10; i++) {
        for (int j=1; j<=3; j++) {
            float x,y,w,h;
            x = 15+95*(j-1);
            y = 0 + yOffset*i;
            w = 29;
            h = 29;
            UIImageView *emoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
            
            emoIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%d",index]];
            [emoIcon setContentMode:UIViewContentModeScaleToFill];
            emoIcon.backgroundColor = [UIColor blackColor];
            [emoContainerScroll addSubview:emoIcon];
            
            w = 65;
            
            UILabel *emoTitle = [[UILabel alloc] initWithFrame:CGRectMake(x+33, y, w-5, h+10)];
            emoTitle.text = [emotions objectAtIndex:index];
            emoTitle.font = [UIFont fontWithName:[FontManager currentFontName] size:12.0];
            emoTitle.textColor = [UIColor blackColor];
            [emoTitle setMinimumFontSize:8.0f];
            [emoTitle setAdjustsFontSizeToFitWidth:YES];
            emoTitle.lineBreakMode = UILineBreakModeTailTruncation;
            [emoTitle setNumberOfLines:1];
            emoTitle.backgroundColor = [UIColor clearColor];
            [emoContainerScroll addSubview:emoTitle];
            
            w = 100;
            UIButton *emoButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
            [emoButton setTag:index];
            [emoButton addTarget:self action:@selector(emoSelected:) forControlEvents:UIControlEventTouchUpInside];
            [emoContainerScroll addSubview:emoButton];
            
            index++;
        }
    }
}

#pragma mark- Methods For DoneView

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertLevel == 2) {
        if (buttonIndex == 0) {
            [self addRecord];
            [self hideDoneView:nil];   
        }
    }
    else if(alertLevel == 1)
    {
        if(buttonIndex == 0)
        {
            [self doneAddingEmo:nil];
        }
        else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
}

- (IBAction)saveToDiary:(id)sender
{
    [self fetchRecord];
    if (eventArray.count > 0) {
        alertLevel = 2;
        [[[CustomAlertView alloc]initWithTitle:LOC(@"key.you_already_have_records")
                                       message:LOC(@"key.want_to_replace_them")
                                      delegate:self
                             cancelButtonTitle:LOC(@"key.button_yes")
                             otherButtonTitles:LOC(@"key.button_no"), nil] show];
        return;
    }
    [self addRecord];
}

- (IBAction)hideDoneView:(id)sender
{
    [UIView beginAnimations:@"emoDetailDone" context:nil];
    doneEmoView.frame = CGRectMake(0, 568, doneEmoView.frame.size.width, doneEmoView.frame.size.height);
    [UIView setAnimationDuration:1.0];
    [UIView commitAnimations];
    backLevel=0;
    backButton.enabled = NO;
}

#pragma mark- IBActions

- (IBAction)back:(id)sender
{
    if (backLevel == 1) {
        [self hideDetail:nil];
    }
    else if(backLevel == 2) {
        [self hideDoneView:nil];
    }
}

- (IBAction)menu:(id)sender
{
    if (isUsed) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        alertLevel = 1;
        [[[CustomAlertView alloc]initWithTitle:nil
                                       message:LOC(@"key.this_entry_has_not_been")
                                      delegate:self
                             cancelButtonTitle:LOC(@"key.button_yes")
                             otherButtonTitles:LOC(@"key.button_no"), nil] show];
    }
}

- (IBAction)hideTextview:(id)sender
{
    [detailTextView resignFirstResponder];
}

-(IBAction)emoSelected:(id)sender
{
    int tag = ((UIButton*)sender).tag;
    
    measurementSlider.value = 0;
    
    currentEmotionIndex = tag;
    
    currentEmotionThumb.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%d",tag]];

    backLevel = 1;
    backButton.enabled = YES;
    currentEmotionTitle.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"emotions"] objectAtIndex:tag];
    
    currentEmotionSlogan.text = [NSString stringWithFormat:LOC(@"key.how_are_you"),[[[NSUserDefaults standardUserDefaults] objectForKey:@"emotions"] objectAtIndex:tag]];
    
    detailTextView.text = [NSString stringWithFormat:LOC(@"key.why_are_you"),[[[NSUserDefaults standardUserDefaults] objectForKey:@"emotions"] objectAtIndex:tag]];
    
    [UIView beginAnimations:@"emoDetail" context:nil];
    emoDetailView.frame = CGRectMake(0, 83, emoDetailView.frame.size.width, emoDetailView.frame.size.height);
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
    
    if ([todayEmotions containsObject:[NSNumber numberWithInt:tag]]) {
        int index = [todayEmotions indexOfObject:[NSNumber numberWithInt:tag]];
        measurementSlider.value = [[todayMeasure objectAtIndex:index]integerValue];
        detailTextView.text = [todayReason objectAtIndex:index];
    }

}

-(IBAction)hideDetail:(id)sender
{
    [UIView beginAnimations:@"emoDetail" context:nil];
    emoDetailView.frame = CGRectMake(0, 568, emoDetailView.frame.size.width, emoDetailView.frame.size.height);
    [UIView setAnimationDuration:5];
    [UIView commitAnimations];

    backLevel=0;
    backButton.enabled = NO;
}

- (void)pushToEmotionStack:(int)measurement:(NSString*)reason:(int)emotion
{
    
    if ([todayEmotions containsObject:[NSNumber numberWithInt:emotion]]) {
        int index = [todayEmotions indexOfObject:[NSNumber numberWithInt:emotion]];
        [todayMeasure replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:measurement]];
        [todayReason replaceObjectAtIndex:index withObject:reason];
    }
    else
    {
        [todayMeasure addObject:[NSNumber numberWithInt:measurement]];
        [todayEmotions addObject:[NSNumber numberWithInt:emotion]];
        [todayReason addObject:reason];
        
        UIImageView *ind = [[UIImageView alloc]initWithFrame:CGRectMake(13+(30*([todayEmotions count]-1)), 12, 21, 23)];
        
        [indicatorScroll addSubview:ind];
        ind.image = [self addImage:[UIImage imageNamed:@"indicator-bg"] toImage:[self maskImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon%d",emotion]] withMask:[UIImage imageNamed:@"indicator-fg"]]];
        
        indicatorScroll.contentSize = CGSizeMake(13+(30*([todayEmotions count])), indicatorScroll.frame.size.height);
    }
}

- (void)hideAlert:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)IamAlso:(id)sender
{
    isUsed = NO;
    if (measurementSlider.value == 0) {
         CustomAlertView *alert = [[CustomAlertView alloc]initWithTitle:@" " message:currentEmotionSlogan.text delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        [self performSelector:@selector(hideAlert:) withObject:alert afterDelay:3];
        return;
    }
    [self pushToEmotionStack:measurementSlider.value :detailTextView.text :currentEmotionIndex];
    [self hideDetail:nil];
}

- (IBAction)doneAddingEmo:(id)sender
{
    [self IamAlso:nil];
    if (measurementSlider.value == 0) {
        return;
    }
    
    for (int i = 0; i<todayMeasure.count; i++) {
        for (int j=i+1; j<todayMeasure.count; j++) {
            if ([[todayMeasure objectAtIndex:j] integerValue]>[[todayMeasure objectAtIndex:i]integerValue]) {
                [todayMeasure exchangeObjectAtIndex:i withObjectAtIndex:j];
                [todayEmotions exchangeObjectAtIndex:i withObjectAtIndex:j];
                [todayReason exchangeObjectAtIndex:i withObjectAtIndex:j];
                
            }
        }
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    float total = 0.0;
    for (int i = 0; i < todayEmotions.count; i++) {
        total+= [[todayMeasure objectAtIndex:i] intValue];
    }
    
    
    float y =5;
    
    for(UIView *subview in tray.subviews)
    {
        [subview removeFromSuperview];
    }
    
    for (int i=0; i<todayEmotions.count; i++) {
        
        if ([[todayReason objectAtIndex:i] isEqualToString:@""]) {
            continue;
        }
        
        if ([[todayReason objectAtIndex:i] isEqualToString:[NSString stringWithFormat:LOC(@"key.why_are_you"),[[prefs objectForKey:@"emotions"] objectAtIndex:[[todayEmotions objectAtIndex:i] intValue]]]]) {

            continue;
        }

        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, y, 25, 25)];
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%@",[todayEmotions objectAtIndex:i]]];
        
        [tray addSubview:image];
        UIFont *font = [UIFont fontWithName:[FontManager currentFontName] size:12];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *reason;
        if (todayEmotions.count == 1) {
            float percentage = (10)?[[todayMeasure objectAtIndex:i] floatValue]/10:0;
            reason = [NSString stringWithFormat:@"%0.0f%@ %@... %@",percentage*100, @"%",[[prefs objectForKey:@"emotions"] objectAtIndex:[[todayEmotions objectAtIndex:i]intValue]],[todayReason objectAtIndex:i]];
        }
        else{
            float percentage = (total)?[[todayMeasure objectAtIndex:i] floatValue]/total:0;
            reason = [NSString stringWithFormat:@"%0.0f%@ %@... %@",percentage*100, @"%",[[prefs objectForKey:@"emotions"] objectAtIndex:[[todayEmotions objectAtIndex:i]intValue]],[todayReason objectAtIndex:i]];
            
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
    }
    
    tray.contentSize = CGSizeMake(320, y);
    
    backLevel = 2;
    backButton.enabled = YES;
    [UIView beginAnimations:@"emoDetailDoneUP" context:nil];
    doneEmoView.frame = CGRectMake(0, 84, doneEmoView.frame.size.width, doneEmoView.frame.size.height);
    [UIView setAnimationDuration:15.0];
    [UIView commitAnimations];
    
    AppDelegate*delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //Test
    calibrationNeededLess=[delegate isLessHundred:todayMeasure todayEmotions:todayEmotions indexMode:TodayIamIndex];
    calibrationNeededMore=[delegate isMoreHundred:todayMeasure todayEmotions:todayEmotions indexMode:TodayIamIndex];
    //End Test
    [pieChartRight reloadData];
    
}

- (IBAction)valueChanged:(UISlider*)sender
{
    int discreteValue = roundl([sender value]); // Rounds float to an integer
    [sender setValue:(float)discreteValue]; // Sets your slider to this value
}


#pragma mark-textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView setText:@""];
    [emoDetailScroll scrollRectToVisible:CGRectMake(0, 160, 320, 300) animated:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [emoDetailScroll scrollRectToVisible:CGRectMake(0, 0, 320, 300) animated:YES];
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
            return [ImageManager colorByTextureIndex:[todayEmotions[0] intValue]];
        }
        else{
            return [UIColor clearColor];
        }
    }
    else{
        return [ImageManager colorByTextureIndex:[todayEmotions[index] intValue]];
    }
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index{

    int total=0;
    for (int i=0; i<todayMeasure.count; i++) {
        total+=[[todayMeasure objectAtIndex:i] intValue];
    }
    
    NSLog(@"Today measure:%@",todayMeasure);
    NSLog(@"Today emotions:%@",todayEmotions);
    NSLog(@"Total: %d",total);
    
    NSString *labelText;
    if ([todayEmotions count]==1) {
        
        if (index == 0) {
            float percentage = (10)?[[todayMeasure objectAtIndex:index] floatValue]/10:0;
            labelText = [NSString stringWithFormat:@"%0.0f%@\n%@",percentage*100, @"%",[todayEmotions objectAtIndex:index]];
        }
        else{
            labelText = @"";
        }
    }
    else{
        float percentage = (total)?[[todayMeasure objectAtIndex:index] floatValue]/total:0;
        if(calibrationNeededLess)
        {
            if(index==((AppDelegate*)[[UIApplication sharedApplication]delegate]).calibrationIndexTodayIam)
            {
                NSString *myCountString=[NSString stringWithFormat:@" %0.0f",percentage*100];
                float myCount=[myCountString floatValue]+1;
                labelText = [NSString stringWithFormat:@" %0.0f%@\n%@",myCount, @"%",[todayEmotions objectAtIndex:index]];
                return labelText;
            }
        }
        if(calibrationNeededMore)
        {
            if(index==((AppDelegate*)[[UIApplication sharedApplication]delegate]).calibrationIndexTodayIam)
            {
                //percentage=percentage-0.01;
                calibrationNeededLess=NO;
                calibrationNeededMore=NO;
                NSString *myCountString=[NSString stringWithFormat:@" %0.0f",percentage*100];
                float myCount=[myCountString floatValue]-1;
                labelText = [NSString stringWithFormat:@" %0.0f%@\n%@",myCount, @"%",[todayEmotions objectAtIndex:index]];
                return labelText;
            }
        }
        labelText = [NSString stringWithFormat:@" %0.0f%@\n%@",percentage*100, @"%",[todayEmotions objectAtIndex:index]];
    }
    return labelText;
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
    //    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}

#pragma mark-imageMethods
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
	CGImageRef maskRef = maskImage.CGImage;
    
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
	CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
	return [UIImage imageWithCGImage:masked];
    
}


- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    int NqualityScale = 1;
    UIGraphicsBeginImageContext(CGSizeMake(image1.size.width*NqualityScale, image1.size.height*NqualityScale));
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width*NqualityScale, image1.size.height*NqualityScale)];
    
    [image2 drawInRect:CGRectMake(0, 0, image1.size.width*NqualityScale, image1.size.height*NqualityScale)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
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
    
    [[UIImage imageNamed:@"mood_sweet.png"] drawInRect:CGRectMake(20, 20, 190, 43)];
    
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
    view.message = LOC(@"key.today_i_am");
    [self.navigationController pushViewController:view animated:NO];
    
    isUsed = YES;
}


- (void)viewDidUnload {
    uploadButton = nil;
    saveButton = nil;
    iAmAlsoButon = nil;
    doneButton = nil;
    [super viewDidUnload];
}
@end
