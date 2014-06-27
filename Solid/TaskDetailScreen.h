//
//  TaskDetailScreen.h
//  Solid
//
//  Created by Siddhant Dange on 6/23/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "Screen.h"
#import <MapKit/MapKit.h>

@class Task;
@interface TaskDetailScreen : Screen <MKMapViewDelegate>   


-(void)setup;

@end
