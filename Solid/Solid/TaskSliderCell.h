//
//  TaskSliderCell.h
//  Pal
//
//  Created by Siddhant Dange on 7/9/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "HorizontalTableViewCell.h"

@class LocationPinPopup;
@class LocAnnotation;
@interface TaskSliderCell : HorizontalTableViewCell

@property (nonatomic, strong) LocationPinPopup *popup;
@property (nonatomic, strong) void(^clickBlock)(void);

-(void)prepWithLocationAnnotation:(LocAnnotation*)annotation;

@end
