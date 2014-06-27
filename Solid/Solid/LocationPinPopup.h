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

-(id)initWithTask:(Task*)task annotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString*)identifier popupBlock:(void(^)(void))clickBlock;
-(void)show;
-(void)close;

@end
