//
//  APIManager.m
//  Solid
//
//  Created by Siddhant Dange on 5/31/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "APIManager.h"
#import "Constants.h"
#import "User.h"

@implementation APIManager

+(void)uploadTask:(Task *)task withCompletion:(void (^)(NSError *))completion{   
    PFObject *taskObj = [PFObject objectWithClassName:@"Task"];
    taskObj[kUrgencyKey] = @(task.urgency);
    taskObj[kAmountKey] = @(task.amount);
    taskObj[kDescriptionKey] = task.descriptionText;
    taskObj[kOwnerKey] = task.owner;
    taskObj[kAcceptorKey] = task.acceptor;
    taskObj[kGeocenterKey] = task.geocenter;
    taskObj[kRadiusKey] = @(task.radius);
    taskObj[kVenueKey] = task.venue;
    
    [taskObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFRelation *venueTasksRelation = [task.venue relationforKey:@"tasks"];
        [venueTasksRelation addObject:taskObj];
        
        
        PFRelation *userTasksRelation = [task.owner relationforKey:@"tasksOwned"];
        [userTasksRelation addObject:taskObj];
        
        [PFObject saveAllInBackground:@[task.owner, task.venue] block:^(BOOL succeeded, NSError *error) {
            completion(error);
        }];
    }];
    
    
}

+(void)pullAllTasks:(void (^)(NSArray *))completion{
    
    //pull venue
    __block PFRelation *venue = [[PFUser currentUser] relationForKey:@"venue"];
    [[venue query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        __block User *user = [User sharedInstance];
        user.venue = objects[0];
        
        //pull all tasks associated with venue
        PFRelation *tasksRelationByVenue = [user.venue relationForKey:@"tasks"];
        [[tasksRelationByVenue query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error ) {
            user.allTasks = objects.copy;
            completion(user.allTasks);
        }];
    }];
}

@end
