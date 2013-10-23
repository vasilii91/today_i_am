//
//  UploadView.m
//  Today I Am
//
//  Created by redoan on 4/14/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import "UploadView.h"
#import "CustomAlertView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface UploadView ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIActionSheetDelegate>

@end

@implementation UploadView
@synthesize imageToUpload,message;

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
    imageView.image = self.imageToUpload; 
}

-(void)viewDidAppear:(BOOL)animated{
    UIActionSheet*sheet = [[UIActionSheet alloc] initWithTitle:nil
                                        delegate:self
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"Facebook", @"Twitter", @"Email", @"Save to Camera Roll", nil];
    
    // Show the sheet
    [sheet showInView:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"HI HI");
}

-(void)hideAlert:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark -

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {
        action();
    }
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %d", buttonIndex);
    switch (buttonIndex) {
            
        case 0:{
                        
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    
                    
                } else
                    
                {
                    CustomAlertView*alert = [[CustomAlertView alloc]initWithTitle:@"Alert" message:@"Facebook post successful" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                    [alert show];
                    [self performSelector:@selector(hideAlert:) withObject:alert afterDelay:3];
                    
                    
                }
                
                
                [self.navigationController popViewControllerAnimated:NO];
                [controller dismissModalViewControllerAnimated:YES];
                
            };
            
            controller.completionHandler =myBlock;
            
            [controller setInitialText:self.message];
            [controller addImage:self.imageToUpload];
            
//            [self presentViewController:controller animated:YES completion:Nil];
            
            [self presentModalViewController:controller animated:YES];
            
            break;
        }
           
        case 1:{
            if (NSClassFromString(@"TWTweetComposeViewController")) {
                
                NSLog(@"Twitter framework is available on the device");
                //code goes here
                //create the object of the TWTweetComposeViewController
                TWTweetComposeViewController *twitterComposer = [[TWTweetComposeViewController alloc]init];
                //set the text that you want to post
                //  [twitterComposer setInitialText:tweetTextField.text];
                [twitterComposer setInitialText:self.message];
                //add Image
                [twitterComposer addImage:self.imageToUpload];
                
                //add Link
                // [twitterComposer addURL:[NSURL URLWithString:@"http://iphonebyradix.blogspot.in"]];
                
                //display the twitter composer modal view controller
                [self presentModalViewController:twitterComposer animated:YES];
                
                
                
                //check to update the user regarding his tweet
                twitterComposer.completionHandler = ^(TWTweetComposeViewControllerResult res){
                    //if the posting is done successfully
                    if (res == TWTweetComposeViewControllerResultDone){
                        CustomAlertView *alert = [[CustomAlertView alloc]initWithTitle:@"Alert" message:@"Tweet successful" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                        [alert show];
                        [self performSelector:@selector(hideAlert:) withObject:alert afterDelay:3];
                        
                    }
                    //if posting is done unsuccessfully
                    else if(res==TWTweetComposeViewControllerResultCancelled){
//                        CustomAlertView *alert = [[CustomAlertView alloc]initWithTitle:@"Alert" message:@"Tweet unsuccessful" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//                        [alert show];
//                        [self performSelector:@selector(hideAlert:) withObject:alert afterDelay:3];
                    }
                    //dismiss the twitter modal view controller.
                    [self dismissModalViewControllerAnimated:YES];
                    [self.navigationController popViewControllerAnimated:NO];
                    //[tweetTextField resignFirstResponder];
                };
                
                
                
                //releasing the twiter composer object.
                
            }else{
                NSLog(@"Twitter framework is not available on the device");
                
                CustomAlertView *alert = [[CustomAlertView alloc]initWithTitle:@"Alert" message:@"Your device cannot send the tweet now, kindly check the internet connection or make a check whether your device has atleast one twitter account setup" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                [alert show];
                [self performSelector:@selector(hideAlert:) withObject:alert afterDelay:3];
            }
            
           
            break;
        }
            
        case 2:{
            
            if ([MFMailComposeViewController canSendMail])
            {
                UIImage *image = self.imageToUpload;
                //NSString *dowhat = recipeFromDetail;
                
                NSData *imageData = UIImageJPEGRepresentation(image, 1);
//                NSData *imageData = UIImagePNGRepresentation(image);
                
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                
                mailer.mailComposeDelegate = self;
                
                [mailer setSubject:self.message];
                
                [mailer addAttachmentData:imageData mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"Today I'm.jpg"]];

//                NSString *emailBody = self.message;
                
//                [mailer setMessageBody:emailBody isHTML:YES];
                
                [self presentModalViewController:mailer animated:YES];
                
                //        [mailer release];
                
                //[MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            else
            {
                NSString *myDevice = [[UIDevice currentDevice] model];
                NSString *message = [NSString stringWithFormat:@"Your %@ doesn't support the email composer sheet", myDevice];
                CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Failure"
                                                                        message:message
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                [alert show];
                //        [alert release];
            }
            break;
        }
            
        case 3:
        {
            ALAuthorizationStatus stat = [ALAssetsLibrary authorizationStatus];
            if (stat == ALAuthorizationStatusDenied ||
                stat == ALAuthorizationStatusRestricted) {
                // in real life, we could put up interface asking for access
                NSLog(@"%@", @"No access");
                //return;
                UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"\"Today I'm...\" would like to access your photos" message:@"Please set permission to access your Photo library in Settings" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                //[self performSelector:@selector(hideAlert:) withObject:alert afterDelay:5];
            }
            else
            {
                
                UIImageWriteToSavedPhotosAlbum(self.imageToUpload, nil, nil, nil);
                if (stat != ALAuthorizationStatusDenied ||
                    stat != ALAuthorizationStatusRestricted)
                {
                    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Photo saved to Camera Roll." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                    [alert show];
                    [self performSelector:@selector(hideAlert:) withObject:alert afterDelay:3];
                }
                /*CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Photo saved to Camera Roll." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                [alert show];
                [self performSelector:@selector(hideAlert:) withObject:alert afterDelay:3];*/
                [self.navigationController popViewControllerAnimated:NO];
                break;
            }
            
        }

        case 4:
        {
            [self.navigationController popViewControllerAnimated:NO];
            break;
        }
        default:
            break;
    }
    
    
}



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)menu:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
