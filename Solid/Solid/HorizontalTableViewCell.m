//
//  HorizontalTableViewCell.m
//  SidUI
//
//  Created by Siddhant Dange on 7/7/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "HorizontalTableViewCell.h"

@implementation HorizontalTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2);
    self.transform = transform;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
