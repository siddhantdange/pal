//
//  HorizontalTableView.m
//  SidUI
//
//  Created by Siddhant Dange on 7/5/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "HorizontalTableView.h"
#import "HorizontalTableViewCell.h"

@implementation HorizontalTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCellNibNames:(NSArray*)cellClassNameArr andFrame:(CGRect)rect{
    HorizontalTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:cellClassNameArr[0] owner:self options:nil] objectAtIndex:0];
    self = [self initWithFrame:CGRectMake(3.0f, 3.0f, rect.size.width, cell.frame.size.height)];
    CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.transform = transform;
    
    // Repositions and resizes the view.
    CGRect contentRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, cell.frame.size.width);
    self.frame = contentRect;
    
    if(self){
        
        for (NSString *cellClass in cellClassNameArr) {
            //register nib
            [self registerNib:[UINib nibWithNibName:cellClass bundle:nil] forCellReuseIdentifier:cellClass];
        }
        
        //init vars
        [self setRowHeight:cell.frame.size.height];
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

#pragma -mark HorizontalTableViewCell

