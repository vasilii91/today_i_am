//
//  PasswordScreen.h
//  Today I Am
//
//  Created by redoan on 3/17/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordScreen : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIButton *passwordButton;
    
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *menuButton;
    
    IBOutlet UIView *topbar;
    
    __weak IBOutlet UILabel *labelTitle;
    __weak IBOutlet UILabel *labelPrivacyLock;
    int step;
    int password1;
}

@property (nonatomic)int mode;
@end
