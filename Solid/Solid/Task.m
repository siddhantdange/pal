//
//  Task.m
//  Solid
//
//  Created by Siddhant Dange on 5/31/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "Task.h"
#import "Constants.h"

@implementation Task

+(Task *)taskFromPFObject:(PFObject *)obj{
    Task *task = [[Task alloc] init];
    
    task.obj = obj;
    task.owner = obj[kOwnerKey];
    task.venue = obj[kVenueKey];
    //task.urgency = ((NSNumber*)obj[@""]).intValue;
    task.radius = ((NSNumber*)obj[kRadiusKey]).intValue;
    task.amount = ((NSNumber*)obj[kAmountKey])
    .floatValue;
    task.descriptionText = obj[kDescriptionKey];
    task.geocenter = obj[kGeocenterKey];
    
    return task;
}

@end
