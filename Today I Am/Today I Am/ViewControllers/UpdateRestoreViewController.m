//
//  UpdateRestoreViewController.m
//  Today I Am
//
//  Created by Vasilii Kasnitski on 10/24/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import "UpdateRestoreViewController.h"
#import "MKStoreManager.h"
#import "AppDelegate.h"

@interface UpdateRestoreViewController ()

@end

@implementation UpdateRestoreViewController

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
    
    [updateButton.titleLabel setFont:currentFont];
    [restoreButton.titleLabel setFont:currentFont];
    
    [updateButton setTitle:LOC(@"key.button_update") forState:UIControlStateNormal];
    [restoreButton setTitle:LOC(@"key.button_restore") forState:UIControlStateNormal];
}


#pragma mark - Actions

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)removeAdsAction:(id)sender
{
    [[MKStoreManager sharedManager] buyFeature:IN_APP_PURCHASE_ID_REMOVE_ADS onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
        
    } onCancelled:^{
        [AppDelegate(AppDelegate) showAds];
    } onFailed:^(NSError *error) {
        [AppDelegate(AppDelegate) showAds];
    }];
}

- (IBAction)restoreAction:(id)sender
{
    [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^{
        
    } onError:^(NSError *error) {
        
    }];
}

- (void)viewDidUnload {
    updateButton = nil;
    restoreButton = nil;
    [super viewDidUnload];
}
@end
