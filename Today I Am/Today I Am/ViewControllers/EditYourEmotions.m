//
//  EditYourEmotions.m
//  Today I Am
//
//  Created by redoan on 3/17/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import "EditYourEmotions.h"
#import "CustomAlertView.h"

@interface EditYourEmotions ()<UITextFieldDelegate>

@end

@implementation EditYourEmotions

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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    emotions = [[NSMutableArray alloc]init];
    emotions = [NSMutableArray arrayWithArray:[prefs objectForKey:@"emotions"]];
    [self initEmos];
    UIView *top = (UIView*)[self.view viewWithTag:901];
    UILabel *label = (UILabel*)[self.view viewWithTag:101];
    label.font = [UIFont fontWithName:[FontManager currentFontName] size:17];
    
    renameField.font = [UIFont fontWithName:[FontManager currentFontName] size:15];
    UIImageView *bg1 = (UIImageView*)[self.view viewWithTag:902];
    
    top.frame = CGRectMake(top.frame.origin.x, 0, top.frame.size.width, top.frame.size.height);
    bg1.frame = CGRectMake(0, bg1.frame.origin.y, bg1.frame.size.width, bg1.frame.size.height);
    
    emoContainerScroll.frame = CGRectMake(0, IS_IPHONE_5 ? 100 : 85, emoContainerScroll.frame.size.width, emoContainerScroll.frame.size.height);
    
    renameView.frame = CGRectMake(160, [[UIScreen mainScreen]bounds].size.height/2, 0, 0);
    [self.view sendSubviewToBack:alertBox];

    UIFont *currentFont = [UIFont fontWithName:[FontManager currentFontName] size:17];
    labelEditYourEmotions.text = LOC(@"key.edit_your_emotions");
    labelEditYourEmotions.font = currentFont;
    
    buttonCancel.titleLabel.font = [UIFont fontWithName:[FontManager currentFontName] size:17];
    buttonSave.titleLabel.font = [UIFont fontWithName:[FontManager currentFontName] size:17];
    
    [buttonCancel setTitle:LOC(@"key.button_cancel") forState:UIControlStateNormal];
    [buttonSave setTitle:LOC(@"key.button_save") forState:UIControlStateNormal];
}

-(void)initEmos
{
    for (UIView *sub in emoContainerScroll.subviews) {
        [sub removeFromSuperview];
    }

    int index = 0;
    float yOffset;
    if ([UIScreen mainScreen].bounds.size.height>480) {
        yOffset = 45;
    }
    else{
        yOffset = 35;
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
            [emoTitle setMinimumFontSize:8.0f];
            [emoTitle setAdjustsFontSizeToFitWidth:YES];
            emoTitle.textColor = [UIColor blackColor];
            emoTitle.lineBreakMode = UILineBreakModeWordWrap;
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

#pragma mark- IBActions
-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)saveOrCancel:(id)sender
{
    
    int tag = ((UIButton*)sender).tag;
    [self.view sendSubviewToBack:alertBox];
    [UIView beginAnimations:@"emoDetail" context:nil];

    renameView.frame = CGRectMake(160, [[UIScreen mainScreen]bounds].size.height/2, 0, 0);
    
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
    
    
    
    if (tag == 1) {
        
//            NSLog(@"TEST %@ %d",renameField.text,currentEmotion);
            if(![renameField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length ==0)
            {
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];                
                [emotions replaceObjectAtIndex:currentEmotion withObject:renameField.text];

                
                [prefs setObject:emotions forKey:@"emotions"];
                [prefs synchronize];
                [self initEmos];
            }
        
    }
    
    [renameField resignFirstResponder];

}

-(void)alertBoxVisible{
//    alertBox.alpha = 1.0;
    [self.view bringSubviewToFront:alertBox];
}

-(IBAction)emoSelected:(id)sender
{
    
    int tag = ((UIButton*)sender).tag;
    currentEmotion = tag;
    
    renameField.text = [emotions objectAtIndex:currentEmotion];
    UILabel *label = (UILabel*)[self.view viewWithTag:101];
    label.text = [NSString stringWithFormat:LOC(@"key.rename_to"),[emotions objectAtIndex:currentEmotion]];
    [UIView beginAnimations:@"emoDetail" context:nil];

    renameView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen]bounds].size.height);
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
    [self performSelector:@selector(alertBoxVisible) withObject:self afterDelay:.15];
    
    indicator.image = [self addImage:[UIImage imageNamed:@"indicator-bg"] toImage:[self maskImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon%d",tag]] withMask:[UIImage imageNamed:@"indicator-fg"]]];
   
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)viewDidUnload {
    labelEditYourEmotions = nil;
    buttonSave = nil;
    buttonCancel = nil;
    [super viewDidUnload];
}
@end
