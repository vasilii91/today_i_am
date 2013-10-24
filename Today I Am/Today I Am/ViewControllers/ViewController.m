//
//  ViewController.m
//  Today I Am
//
//  Created by redoan on 3/9/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TodayIAm.h"
#import "Diary.h"
#import "HappinessHistory.h"
#import "PrivacyLock.h"
#import "EditYourEmotions.h"
#import "PasswordScreen.h"
#import "UpdateRestoreViewController.h"
#import "FlurryAds.h"
#import "UserSettings.h"
#import "AppDelegate.h"

@interface ViewController ()
{
    IBOutletCollection(UIButton) NSArray *buttons;
    __weak IBOutlet UIImageView *imageViewCircle;
}

@end

@implementation ViewController


#pragma mark - ViewController's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (UIButton *button in buttons) {
        button.titleLabel.font = [UIFont fontWithName:[FontManager currentFontName]
                                                  size:FONT_NAME_DEFAULT_SIZE];
    }
    
    [buttons[0] setTitle:LOC(@"key.today_i_am") forState:UIControlStateNormal];
    [buttons[1] setTitle:LOC(@"key.diary") forState:UIControlStateNormal];
    [buttons[2] setTitle:LOC(@"key.happiness_history") forState:UIControlStateNormal];
    [buttons[3] setTitle:LOC(@"key.edit_your_emotions") forState:UIControlStateNormal];
    [buttons[4] setTitle:LOC(@"key.privacy_lock") forState:UIControlStateNormal];
    [buttons[5] setTitle:LOC(@"key.restore_or_update") forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [UIView beginAnimations:@"quick" context:nil];
    imageViewCircle.frame = CGRectMake(0,
                                       imageViewCircle.frame.origin.y,
                                       imageViewCircle.frame.size.width,
                                       imageViewCircle.frame.size.height);
    [UIView setAnimationDuration:0.1];
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"button" context:nil];
    [UIView setAnimationDuration:.5];

    for (UIButton *button in buttons) {
        button.frame = CGRectMake(-30,
                                  button.frame.origin.y,
                                  button.frame.size.width,
                                  button.frame.size.height);
    }

    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    for (UIButton *button in buttons) {
        button.frame = CGRectMake(-button.frame.size.width,
                                  button.frame.origin.y,
                                  button.frame.size.width,
                                  button.frame.size.height);
    }
    
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pie.png"]];
    NSLog(@"COLOR TEXT : %@",[self stringFromColor:color]);
}

- (void)viewDidUnload
{
    imageViewCircle = nil;
    buttons = nil;
    [super viewDidUnload];
}


#pragma mark - Actions

- (IBAction)navigateToScreens:(id)sender
{
    [UIView beginAnimations:@"quick" context:nil];
    imageViewCircle.frame = CGRectMake(-60,
                                       imageViewCircle.frame.origin.y,
                                       imageViewCircle.frame.size.width,
                                       imageViewCircle.frame.size.height);
    [UIView setAnimationDelay:0.75];
    [UIView setAnimationDuration:0.1];
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:0.5];
    
    for (UIButton *button in buttons) {
        button.frame = CGRectMake(-button.frame.size.width,
                                  button.frame.origin.y,
                                  button.frame.size.width,
                                  button.frame.size.height);
    }
    
    [UIView commitAnimations];
    
    int tag = ((UIButton*)sender).tag;
    switch (tag) {
        case 101:
        {
            TodayIAm *view = [[TodayIAm alloc] initWithNibName:@"TodayIAm" bundle:nil];
            view.dateofEntry = [NSDate date];
            [self performSelector:@selector(navigate:) withObject:view afterDelay:0.25];
            break;
        }
            
        case 102:
        {
            Diary *view = [[Diary alloc] initWithNibName:@"Diary" bundle:nil];
            [self performSelector:@selector(navigate:) withObject:view afterDelay:0.25];
            break;
        }
            
        case 103:
        {
            HappinessHistory *view = [[HappinessHistory alloc] initWithNibName:@"HappinessHistory" bundle:nil];
            [self performSelector:@selector(navigate:) withObject:view afterDelay:0.25];
            break;
        }
            
        case 104:
        {
            EditYourEmotions *view = [[EditYourEmotions alloc] initWithNibName:@"EditYourEmotions" bundle:nil];
            [self performSelector:@selector(navigate:) withObject:view afterDelay:0.25];
            break;
        }
            
        case 105:
        {
            PrivacyLock *view = [[PrivacyLock alloc] initWithNibName:@"PrivacyLock" bundle:nil];
            [self performSelector:@selector(navigate:) withObject:view afterDelay:0.25];
            break;
        }
            
        default:
        {
            TodayIAm *view = [[TodayIAm alloc] initWithNibName:@"TodayIAm" bundle:nil];
            [self performSelector:@selector(navigate:) withObject:view afterDelay:0.15];

            break;
        }
    }
}

- (IBAction)restoreOrUpdateAction:(id)sender
{
    UpdateRestoreViewController *view = [[UpdateRestoreViewController alloc] init];
    [self performSelector:@selector(navigate:) withObject:view afterDelay:0.25];
}


#pragma mark - Private methods

- (NSString *)stringFromColor:(UIColor *)color
{
    const size_t totalComponents = CGColorGetNumberOfComponents(color.CGColor);
    const CGFloat * components = CGColorGetComponents(color.CGColor);
    return [NSString stringWithFormat:@"#%02X%02X%02X",
            (int)(255 * components[MIN(0,totalComponents-2)]),
            (int)(255 * components[MIN(1,totalComponents-2)]),
            (int)(255 * components[MIN(2,totalComponents-2)])];
}

- (void)navigate:(UIViewController *)view
{
    [self.navigationController pushViewController:view animated:YES];
}

@end
