//
//  User.h
//  Solid
//
//  Created by Siddhant Dange on 6/1/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : NSObject

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) PFObject *venue;
@property (nonatomic, strong) NSArray *myTask, *allTasks;
@property (nonatomic, strong) NSString *emailUserId;




+(instancetype)sharedInstance;

@end
