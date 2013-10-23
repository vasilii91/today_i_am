//
//  Event.h
//  Today I Am
//
//  Created by redoan on 4/1/13.
//  Copyright (c) 2013 AAPBD-REDOAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * emotion;
@property (nonatomic, retain) NSString * emotitle;
@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSNumber * measure;
@property (nonatomic, retain) NSString * reason;

@end
