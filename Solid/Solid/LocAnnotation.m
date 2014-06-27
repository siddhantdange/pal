//
//  LocAnnotation.m
//  Solid
//
//  Created by Siddhant Dange on 5/26/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "LocAnnotation.h"

@interface LocAnnotation ()

@property (nonatomic, assign) CLLocationCoordinate2D coordinatePoint;
@property (nonatomic, strong) NSString *title, *descriptionText;


@end

@implementation LocAnnotation

-(id)initWithCoordinate:(CLLocationCoordinate2D)cl title:(NSString*)title{   
    
    if(!self){
        self = [self init];
    }
    
    self.coordinatePoint = cl;
    self.title = title;
    return self;
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    self.coordinatePoint = newCoordinate;
}

-(void)setDescriptionText:(NSString *)descriptionText{
    _descriptionText = descriptionText;
}

-(CLLocationCoordinate2D)coordinate{
    return self.coordinatePoint;
}

-(NSString *)subtitle{
    return self.title;
}

-(NSString *)description{
    return self.descriptionText;
}

@end
