//
//  HappinessHistory.m
//  Today I Am
//
//  Created by redoan on 3/15/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import "HappinessHistory.h"
#import "HappinessPie.h"
@interface HappinessHistory ()

@end

@implementation HappinessHistory

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
    
    UIFont *currentFont = [UIFont fontWithName:[FontManager currentFontName] size:17];
    labelHappinessHistory.text = LOC(@"key.happiness_history");
    labelHappinessHistory.font = currentFont;
    
    [button1.titleLabel setFont:currentFont];
    [button2.titleLabel setFont:currentFont];
    [button3.titleLabel setFont:currentFont];
    
    [button1 setTitle:LOC(@"key.this_week_i_have_been") forState:UIControlStateNormal];
    [button2 setTitle:LOC(@"key.this_month_i_have_been") forState:UIControlStateNormal];
    [button3 setTitle:LOC(@"key.this_year_i_have_been") forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    button1.hidden = NO;
    button2.hidden = NO;
    button3.hidden = NO;
    
    [UIView beginAnimations:@"hudai" context:nil];
    
    button1.center = CGPointMake(160, button1.center.y);
    button2.center = CGPointMake(160, button2.center.y);
    button3.center = CGPointMake(160, button3.center.y);
    
    [UIView commitAnimations];
}


-(IBAction)happinessPie:(id)sender
{
    
    HappinessPie *view = [[HappinessPie alloc] initWithNibName:@"HappinessPie" bundle:nil];
    view.type = ((UIButton*)sender).tag%100;
    [self.navigationController pushViewController:view animated:NO];
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)menu:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    labelHappinessHistory = nil;
    button1 = nil;
    button2 = nil;
    button3 = nil;
    [super viewDidUnload];
}
@end
