//
//  LocationPinPopup.h
//  Solid
//
//  Created by Siddhant Dange on 6/23/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Task;
@interface LocationPinPopup : MKAnnotationView <UIGestureRecognizerDelegate>
@property (nonatomic, strong) Task *task;

-(id)initWithTask:(Task*)task annotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString*)identifier popupBlock:(void(^)(NSDictionary*))clickBlock;
-(void)show;
-(void)setAnnotation:(id<MKAnnotation>)annotation andTask:(Task*)task;
-(void)close;

@end
