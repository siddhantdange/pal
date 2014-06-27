//
//  Task.h
//  Solid
//
//  Created by Siddhant Dange on 5/31/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Task : NSObject

@property (nonatomic, strong) PFObject *obj, *venue, *owner;

@property (nonatomic, assign) int urgency, radius;
@property (nonatomic, assign) float amount;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) PFGeoPoint *geocenter;

+(Task*)taskFromPFObject:(PFObject*)obj;

@end
