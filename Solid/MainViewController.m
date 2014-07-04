//
//  MainViewController.m
//  Solid
//
//  Created by Siddhant Dange on 5/31/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "MainViewController.h"
#import "LocationPinPopup.h"
#import "LocAnnotation.h"
#import "User.h"
#import "Task.h"

#import <Parse/Parse.h>

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySwitch;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) LocationPinPopup *popup;
@property (nonatomic, assign) BOOL zoomed;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil   
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)customPriorityButton:(id)sender {
}
- (IBAction)prevTasks:(id)sender {
}
- (IBAction)nextTasks:(id)sender {
}

-(void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    _zoomed = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Associate the device with a user
//    PFInstallation *installation = [PFInstallation currentInstallation];
//    installation[@"user"] = [PFUser currentUser];
//    [installation addUniqueObject:[PFUser currentUser].objectId forKey:@"channels"];
//    [installation saveInBackground];
    
    //remove annotations and update with local copy (from another screen or just loaded)
    [_mapView removeAnnotations:_mapView.annotations];
    
    NSArray *tasks = [User sharedInstance].visibleTasks;
    for (PFObject *task in tasks) {
        PFGeoPoint *geopoint = task[@"geocenter"];
        LocAnnotation *annotation = [[LocAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(geopoint.latitude, geopoint.longitude) title:@"title"];
        annotation.task = [Task taskFromPFObject:task];
        [_mapView addAnnotation:annotation];
    }
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.2, 0.2);
    [self.mapView setRegion:mapRegion animated: YES];
}


#pragma -mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    if(!_zoomed){
        MKCoordinateRegion mapRegion;
        mapRegion.center = self.mapView.userLocation.coordinate;
        mapRegion.span = MKCoordinateSpanMake(0.2, 0.2);
        [self.mapView setRegion:mapRegion animated: YES];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *identifier = @"LocAnnotation";
    if ([annotation isKindOfClass:[LocAnnotation class]]) {
        LocAnnotation *locAnn = (LocAnnotation*)annotation;
        LocationPinPopup *annotationView = (LocationPinPopup *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[LocationPinPopup alloc] initWithTask:locAnn.task annotation:locAnn reuseIdentifier:identifier popupBlock:^(NSDictionary *data) {
                [self goToScreen:@"TaskDetailScreen" animated:YES withData:data];
            }];
            annotationView.enabled = YES;
            
            
        } else {
            [annotationView setAnnotation:locAnn andTask:locAnn.task];
           // annotationView.annotation = annotation;
        }
        
        return annotationView;
        
        //TODO 
        //once accepted work on 'main screen'
        //later- profile view: owned tasks, money made, number tasks done, tasks done detail?, account    details
        //work on image uploads/check
        //work on messaging
        //set up payments integration
        //finish raw demo
        
        //cleanup
        //work on login rearchitecture - modularization
        //refactor all view controllers to screens, storyboard to xibs
        //make model objects using thrift
        
        //parallel
        //find a designer, maybe design team is good enough?
        //find backend guy
        //find good domain name, setup website
        
        //after
        //android
        //metrics
        //move backend from parse to soa
    }
    
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    return circleView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    id<MKAnnotation> annotation = view.annotation;
    if([annotation isKindOfClass:[LocAnnotation class]]){
        LocAnnotation *locAnn = (LocAnnotation*)annotation;
        //fade out all other pins
        NSArray *annotations = mapView.annotations;
        for (id<MKAnnotation> anno in annotations) {
            if(anno != locAnn){
                MKAnnotationView *view = [mapView viewForAnnotation:anno];
                [UIView animateWithDuration:0.2f animations:^{
                    [view setAlpha:0.0f];
                    [view setUserInteractionEnabled:NO];
                }];
            }
        }
        
        //draw radius around pin
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:locAnn.coordinate radius:locAnn.task.radius];
        [mapView addOverlay:circle];
        
        
        //add touch detector so when hit outside, disappear radius and make other pins appear
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:      @selector(showPins:)];
        [mapView addGestureRecognizer:recognizer];
        
        
    }
}

#pragma -mark UI Actions

-(void)showPins:(UIGestureRecognizer*)recognizer{
    NSLog(@"view: %@", recognizer.view);
    
    //if popup hit
    if([_popup hitTest:[recognizer locationInView:recognizer.view] withEvent:NULL]){
        NSLog(@"popup hit!");
    } else{
        
        //clear view
        [_popup close];
        _popup = nil;
        
        //clear radius
        [_mapView removeOverlays:_mapView.overlays];
        if(recognizer.state == UIGestureRecognizerStateRecognized) {
            NSLog(@"%@", [_mapView hitTest:[recognizer locationInView:recognizer.view] withEvent:NULL]);
            if([[_mapView hitTest:[recognizer locationInView:recognizer.view] withEvent:NULL] isKindOfClass:NSClassFromString(@"MKNewAnnotationContainerView")]){
                
                //show pins
                NSArray *annotations = _mapView.annotations;
                for (id<MKAnnotation> anno in annotations) {
                    MKAnnotationView *view = [_mapView viewForAnnotation:anno];
                    [UIView animateWithDuration:0.2f animations:^{
                        [view setAlpha:1.0f];
                        [view setUserInteractionEnabled:YES];
                    }];
                }
            }
        }
    }
}

@end
