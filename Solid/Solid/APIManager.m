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
    PFObject *taskObj = [APIManager PFObjectFromTask:task];
    [taskObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //add tasks to user
        [[User sharedInstance].ownedTasks addObject:taskObj];
        [[User sharedInstance].visibleTasks addObject:taskObj];
        
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
            user.visibleTasks = objects.mutableCopy;
            
            //from visible tasks, sort owned tasks
            
            
            completion(user.visibleTasks);
        }];
    }];
}

+(PFObject*)PFObjectFromTask:(Task*)task{
    PFObject *taskObj = [PFObject objectWithClassName:@"Task"];
    taskObj[kUrgencyKey] = @(task.urgency);
    taskObj[kAmountKey] = @(task.amount);
    taskObj[kDescriptionKey] = task.descriptionText;
    taskObj[kOwnerKey] = task.owner;
    taskObj[kGeocenterKey] = task.geocenter;
    taskObj[kRadiusKey] = @(task.radius);
    taskObj[kVenueKey] = task.venue;
    return taskObj;
}

+(void)acceptTask:(Task*)task sent:(void(^)(void))sentBlock completed:(void(^)(NSError*))completionBlock{   
    PFObject *taskObj = [APIManager PFObjectFromTask:task];
    
    //update cloud
    [PFCloud callFunctionInBackground:@"acceptTask"
                       withParameters:@{@"task" : taskObj}
                                block:^(NSArray *results, NSError *error) {
                                    completionBlock(error);
                                }
     ];
    
    //finish
    sentBlock();
}

@end
