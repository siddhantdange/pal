//
//  APIManager.h
//  Solid
//
//  Created by Siddhant Dange on 5/31/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "Task.h"


@interface APIManager : NSObject

+(void)uploadTask:(Task*)task withCompletion:(void(^)(NSError*))completion;

+(void)pullAllTasks:(void(^)(NSArray*))completion;

@end
