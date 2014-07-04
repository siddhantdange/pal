//
//  User.m
//  Solid
//
//  Created by Siddhant Dange on 6/1/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "User.h"


static User *gInstance;
@implementation User

-(void)populateFieldsWithPFUser:(PFUser*)user{
    self.user = user;
}


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gInstance = [[User alloc] init];
        gInstance.ownedTasks = [NSMutableArray new];
        gInstance.visibleTasks = [NSMutableArray new];
        gInstance.acceptedTasks = [NSMutableArray new];
        
    });
            
    return gInstance;
}

@end
