//
//  EditYourEmotions.h
//  Today I Am
//
//  Created by redoan on 3/17/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditYourEmotions : UIViewController
{
    IBOutlet UIScrollView *emoContainerScroll;
    IBOutlet UIView *renameView;
    IBOutlet UIView *alertBox;
    IBOutlet UITextField *renameField;
    __weak IBOutlet UILabel *labelEditYourEmotions;
    __weak IBOutlet UIButton *buttonSave;
    __weak IBOutlet UIButton *buttonCancel;
    
    int currentEmotion;
    NSMutableArray *emotions;
    
    IBOutlet UIImageView *indicator;
}

@end
