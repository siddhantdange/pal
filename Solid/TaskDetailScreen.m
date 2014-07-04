//
//  TaskDetailScreen.m
//  Solid
//
//  Created by Siddhant Dange on 6/23/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "TaskDetailScreen.h"
#import "Task.h"
#import "APIManager.h"
#import "User.h"
#import "LocAnnotation.h"

@interface TaskDetailScreen ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, strong) Task *task;

@end

@implementation TaskDetailScreen
-(void)setup{
    
    //init props
    _task = self.passedData[@"task"];
    [_priceLabel setText:[NSString stringWithFormat:@"$%0.2f", _task.amount]];
    [_descriptionTextView setText:_task.descriptionText];
    [_mapView setDelegate:self];
    
    //add pin to mapview and zoom
    LocAnnotation *locAnnotation = [[LocAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(_task.geocenter.latitude, _task.geocenter.longitude) title:@""];
    [_mapView addAnnotation:locAnnotation];
     MKCoordinateRegion mapRegion;
    mapRegion.center = locAnnotation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.2, 0.2);
    [self.mapView setRegion:mapRegion animated: YES];
}

- (IBAction)taskAccepted:(id)sender {
    
    //update on cloud
    [APIManager acceptTask:_task sent:^{
        NSLog(@"accepted sent!");
        [self popScreen];
        
        //update local
        [[User sharedInstance].visibleTasks removeObject:_task.obj];
        [[User sharedInstance].acceptedTasks addObject:_task];
    } completed:^(NSError *error) {
        NSLog(@"had %@ error accepting task", error);
    }];
}

#pragma -mark MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *identifier = @"LocAnnotation";
    if ([annotation isKindOfClass:[LocAnnotation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:  identifier];
            annotationView.enabled = NO;
            
            
        } else {
            annotationView.annotation = annotation;
        }
        
        NSLog(@"%@", ((LocAnnotation*)annotationView.annotation).title);
        return annotationView;
    }
    
    return nil;
}

@end
