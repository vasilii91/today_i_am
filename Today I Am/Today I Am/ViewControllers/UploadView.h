//
//  UploadView.h
//  Today I Am
//
//  Created by redoan on 4/14/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Twitter/twitter.h"
#import <FacebookSDK/FacebookSDK.h>

@interface UploadView : UIViewController
{
    IBOutlet UIImageView *imageView;
}
@property (nonatomic, strong) UIImage *imageToUpload;
@property (nonatomic, strong) NSString *message;
@end
