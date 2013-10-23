//
//  PasswordScreen.m
//  Today I Am
//
//  Created by redoan on 3/17/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import "PasswordScreen.h"
#import "CustomAlertView.h"

@interface PasswordScreen ()

@end

@implementation PasswordScreen
@synthesize mode;

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
    labelPrivacyLock.text = LOC(@"key.privacy_lock");
    labelPrivacyLock.font = currentFont;

    labelTitle.font = currentFont;
    labelTitle.text = LOC(@"key.enter_new_password");
    
    [passwordButton.titleLabel setFont:currentFont];
    [passwordButton setTitle:LOC(@"key.button_next") forState:UIControlStateNormal];
    
	// Do any additional setup after loading the view.
    UITextField *digit1 = (UITextField*)[self.view viewWithTag:201];
    [digit1 setText:@""];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(passwordManager)
                                                 name:UITextFieldTextDidChangeNotification object:digit1];
    
//    digit1
    
    UIScrollView *scrollView = (UIScrollView*)[self.view viewWithTag:1000];
    scrollView.contentSize = CGSizeMake(320, 700);
    
    step = 0;
    
    if (self.mode == 2) {
        
        labelTitle.text = LOC(@"key.enter_current_password");
    }
    
    if (self.mode == 3) {
        labelTitle.text = LOC(@"key.enter_current_password");
        backButton.hidden = YES;
        menuButton.hidden = YES;
    }
    
    
}

#pragma mark- IBActions
-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)menu:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(IBAction)startPasswordInput:(id)sender{
    UITextField *digit1 = (UITextField*)[self.view viewWithTag:201];
    [digit1 setText:@""];
    [digit1 becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIImageView *digit1 = (UIImageView*)[self.view viewWithTag:301];
    UIImageView *digit2 = (UIImageView*)[self.view viewWithTag:302];
    UIImageView *digit3 = (UIImageView*)[self.view viewWithTag:303];
    UIImageView *digit4 = (UIImageView*)[self.view viewWithTag:304];
    
    digit1.hidden = YES;
    digit2.hidden = YES;
    digit3.hidden = YES;
    digit4.hidden = YES;
    
    UIScrollView *scrollView = (UIScrollView*)[self.view viewWithTag:1000];
    [scrollView scrollRectToVisible:CGRectMake(0, 85, 320, 439) animated:YES];
    passwordButton.enabled = NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    UIScrollView *scrollView = (UIScrollView*)[self.view viewWithTag:1000];
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 320, 439) animated:YES];
    passwordButton.enabled = YES;
}


-(IBAction)passwordEntered:(id)sender
{
    NSLog(@"? %d",step);
    if (self.mode == 1) {
        UITextField *digit1 = (UITextField*)[self.view viewWithTag:201];
        if (step == 0) {
            password1 = [digit1.text intValue];
            [passwordButton setTitle:LOC(@"key.button_save") forState:UIControlStateNormal];
            labelTitle.text = LOC(@"key.enter_new_password_again");
            [digit1 setText:@""];
            [digit1 becomeFirstResponder];
            step++;
            //        return;
        }
        
        
        else if (step == 1) {
            if(password1 == [digit1.text intValue])
            {
                [[[CustomAlertView alloc]initWithTitle:@"Privacy Lock Activated! Please don't forget your password." message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:password1] forKey:@"password"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            else
            {
                [[[CustomAlertView alloc]initWithTitle:@"Failed" message:@"Passwords Did not Matched!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
                
                [digit1 setText:@""];
                [digit1 becomeFirstResponder];
            }
        }
    }
    
    
//    ///CHANGE PASSWORD
    
    else if (self.mode == 2) {
        UITextField *digit1 = (UITextField*)[self.view viewWithTag:201];
        if (step == 0) {
            password1 = [digit1.text intValue];
            
            if (password1 != [[[NSUserDefaults standardUserDefaults]objectForKey:@"password"] intValue]) {
                [[[CustomAlertView alloc]initWithTitle:@"ERROR" message:@"Wrong Password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
                [digit1 setText:@""];
                [digit1 becomeFirstResponder];
                return;
            }
            
            [passwordButton setTitle:LOC(@"key.button_save") forState:UIControlStateNormal];
            labelTitle.text = LOC(@"key.enter_new_password");
            [digit1 setText:@""];
            [digit1 becomeFirstResponder];
            step++;
            
            
            //        return;
        }
        
        
        else if (step == 1) {
            
            
            
            
            
            password1 = [digit1.text intValue];
            [passwordButton setTitle:LOC(@"key.button_save") forState:UIControlStateNormal];
            labelTitle.text = LOC(@"key.enter_new_password_again");
            [digit1 setText:@""];
            [digit1 becomeFirstResponder];
            step++;
            //        return;
        }
        
        else if (step == 2) {
            if(password1 == [digit1.text intValue])
            {
                [[[CustomAlertView alloc]initWithTitle:@"Success" message:@"Passwords Changed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:password1] forKey:@"password"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            else
            {
                [[[CustomAlertView alloc]initWithTitle:@"Failed" message:@"Passwords Did not Matched!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
                
                [digit1 setText:@""];
                [digit1 becomeFirstResponder];
            }
        }
    }
    
    else if (self.mode == 3) {
        UITextField *digit1 = (UITextField*)[self.view viewWithTag:201];
        if (step == 0) {
            password1 = [digit1.text intValue];
            
            if (password1 != [[[NSUserDefaults standardUserDefaults]objectForKey:@"password"] intValue]) {
                [[[CustomAlertView alloc]initWithTitle:@"ERROR" message:@"Wrong Password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
                [digit1 setText:@""];
                [digit1 becomeFirstResponder];
                return;
            }
            
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
}


-(void)passwordManager
{
    UIImageView *digit1 = (UIImageView*)[self.view viewWithTag:301];
    UIImageView *digit2 = (UIImageView*)[self.view viewWithTag:302];
    UIImageView *digit3 = (UIImageView*)[self.view viewWithTag:303];
    UIImageView *digit4 = (UIImageView*)[self.view viewWithTag:304];
    
    UITextField *textField = (UITextField*)[self.view viewWithTag:201];
//    NSLog(@"CHECKING LENGTH %d",textField.text.length);
    switch ([textField.text length]) {
        
        case 0:
        {
            digit1.hidden = YES;
            digit2.hidden = YES;
            digit3.hidden = YES;
            digit4.hidden = YES;
            break;
        }
            
        case 1:
        {
            digit1.hidden = NO;
            digit2.hidden = YES;
            digit3.hidden = YES;
            digit4.hidden = YES;
            break;
        }
        case 2:
        {
            digit2.hidden = NO;
            digit3.hidden = YES;
            digit4.hidden = YES;
            break;
        }
        case 3:
        {
            digit3.hidden = NO;
            digit4.hidden = YES;
            break;
        }
        case 4:
        {
            digit4.hidden = NO;
            break;
        }
        default:
            break;
    }
    
    if([textField.text length]>=4)
    {
        [textField resignFirstResponder];
    }
}




- (void)viewDidUnload {
    labelPrivacyLock = nil;
    labelTitle = nil;
    [super viewDidUnload];
}
@end
