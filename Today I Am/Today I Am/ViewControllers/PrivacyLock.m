//
//  PrivacyLock.m
//  Today I Am
//
//  Created by redoan on 3/17/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import "PrivacyLock.h"
#import "PasswordScreen.h"

@interface PrivacyLock ()

@end

@implementation PrivacyLock

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
    if (![prefs objectForKey:@"password"]) {
        changePassword.hidden = YES;
    }
    else{
        enterPassword.hidden = YES;
    }
    
    UIFont *currentFont = [UIFont fontWithName:[FontManager currentFontName] size:17];
    labelPrivacyLock.font = currentFont;
    labelPrivacyLock.text = LOC(@"key.privacy_lock");
    
    [changePassword.titleLabel setFont:currentFont];
    [enterPassword.titleLabel setFont:currentFont];
    
    [changePassword setTitle:LOC(@"key.change_password") forState:UIControlStateNormal];
    [enterPassword setTitle:LOC(@"key.enter_new_password") forState:UIControlStateNormal];
}

#pragma mark- IBActions
-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)menu:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(IBAction)passwordAction:(id)sender{
    PasswordScreen* view = [[PasswordScreen alloc]initWithNibName:@"PasswordScreen" bundle:nil];
    
    view.mode = ((UIButton*)sender).tag;
    
    [self.navigationController pushViewController:view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    labelPrivacyLock = nil;
    [super viewDidUnload];
}
@end
