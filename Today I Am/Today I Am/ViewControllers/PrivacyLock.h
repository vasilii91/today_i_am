//
//  PrivacyLock.h
//  Today I Am
//
//  Created by redoan on 3/17/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyLock : UIViewController
{
    IBOutlet UIButton *enterPassword;
    IBOutlet UIButton *changePassword;
    __weak IBOutlet UILabel *labelPrivacyLock;
}
-(IBAction)passwordAction:(id)sender;
@end
