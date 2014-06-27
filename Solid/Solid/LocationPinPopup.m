//
//  LocationPinPopup.m
//  Solid
//
//  Created by Siddhant Dange on 6/23/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "LocationPinPopup.h"
#import "Screen.h"
#import "Task.h"

@interface LocationPinPopup()

@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIButton *infoButton;
@property (nonatomic, strong) Task *task;
@property (nonatomic, copy) void(^clickBlock)(void);

@end

@implementation LocationPinPopup

-(id)initWithTask:(Task*)task annotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString*)identifier popupBlock:(void(^)(void))clickBlock{
    self = [self initWithAnnotation:annotation reuseIdentifier:identifier];
    
    if(self){
        //init views
        _mainView = [[[NSBundle mainBundle] loadNibNamed:@"LocationPinPopup" owner:self   options:nil] objectAtIndex:0];
        _task = task;
        [_priceLabel setText:[NSString stringWithFormat:@"$%0.2f", task.amount]];
        _clickBlock = clickBlock;
        _mainView.alpha = 1.0f;
        
        [self addSubview:_mainView];
        self.frame = _mainView.frame;
    }
    
    return self;
}

-(void)show{
    [UIView animateWithDuration:0.2f animations:^{
        _mainView.userInteractionEnabled = YES;
        _mainView.alpha = 1.0f;
    }];
}

-(void)close{
    [UIView animateWithDuration:0.2f animations:^{
        _mainView.alpha = 0.0f;
        _mainView.userInteractionEnabled = NO;
    }];

}

-(IBAction)detailButtonPressed:(id)sender{
    _clickBlock();
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
