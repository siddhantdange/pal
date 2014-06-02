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


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gInstance = [[User alloc] init];
        
        
    });
            
    return gInstance;
}

@end
