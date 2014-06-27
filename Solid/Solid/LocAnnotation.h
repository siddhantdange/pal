//
//  LocAnnotation.h
//  Solid
//
//  Created by Siddhant Dange on 5/26/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class   Task;
@interface LocAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) Task *task;


-(id)initWithCoordinate:(CLLocationCoordinate2D)cl title:(NSString*)title;   

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
-(void)setDescriptionText:(NSString *)descriptionText;

@end
