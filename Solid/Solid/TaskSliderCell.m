//
//  TaskSliderCell.m
//  Pal
//
//  Created by Siddhant Dange on 7/9/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "TaskSliderCell.h"
#import "LocAnnotation.h"
#import "Task.h"

@interface TaskSliderCell()

@property (nonatomic, weak) IBOutlet UILabel *priceTagLabel;

@end

@implementation TaskSliderCell

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(id)init{
    self = [super init];
    return self;
}

-(void)prepWithLocationAnnotation:(LocAnnotation *)annotation{
    [self.priceTagLabel setText:[NSString stringWithFormat:@"$%0.2f", annotation.task.amount]];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
