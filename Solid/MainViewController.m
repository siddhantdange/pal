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
#import "HorizontalTableView.h"
#import "TaskSliderCell.h"
#import "User.h"
#import "Task.h"

#import <Parse/Parse.h>

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySwitch;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) LocationPinPopup *popup;
@property (nonatomic, strong) HorizontalTableView *tb;
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
    
    CGRect screen = [UIScreen mainScreen].bounds;
    _tb = [[HorizontalTableView alloc] initWithCellNibNames:@[@"TaskSliderCell"] andFrame:CGRectMake(0.0f, screen.size.height - 100.0f, screen.size.width, 3.0f)];
    _tb.delegate = self;
    _tb.dataSource = self;
    [self.view addSubview:_tb];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    
    if(tasks.count == 0){
        [_tb removeFromSuperview];
    } else{
        if(_tb.superview == nil){
            [self.view addSubview:_tb];
        }
        [_tb reloadData];
    }
}

#pragma -mark UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int numRows = (int)_mapView.annotations.count;
    return numRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{   
    
    // Identifier for retrieving reusable cells.
    static NSString *cellIdentifier = @"TaskSliderCell";
    
    // Attempt to request the reusable cell.
    TaskSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // No cell available - create one.
    if(cell == nil) {
        cell = [[TaskSliderCell alloc] init];
    }
    
    if(![_mapView.annotations[indexPath.row] isKindOfClass:[MKUserLocation class]]){
        LocAnnotation *ann = _mapView.annotations[indexPath.row];
        [cell prepWithLocationAnnotation:ann];
        
        //set annotation view visible
        [UIView animateWithDuration:0.2f animations:^{
            [[_mapView viewForAnnotation:ann] setAlpha:1.0f];
            [[_mapView viewForAnnotation:ann] setEnabled:YES];
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.indexPathsForVisibleRows indexOfObject:indexPath] == NSNotFound){
        
        //set annotation view invisible
        [UIView animateWithDuration:0.2f animations:^{
            [[_mapView viewForAnnotation:_mapView.annotations[indexPath.row]] setAlpha:0.0f];
            [[_mapView viewForAnnotation:_mapView.annotations[indexPath.row]] setEnabled:NO];
        }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self mapView:_mapView didSelectAnnotationView:[_mapView viewForAnnotation:_mapView.annotations[indexPath.row]]];
}


#pragma -mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.2, 0.2);
    [self.mapView setRegion:mapRegion animated: YES];
    [_mapView setUserTrackingMode:MKUserTrackingModeNone];
    [self.mapView setShowsUserLocation:NO];
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
            
            if([_mapView.annotations indexOfObject:annotation] > 3){
                [annotationView setAlpha:0.0f];
                annotationView.enabled = NO;
            } else{
                [annotationView setAlpha:1.0f];
                annotationView.enabled = YES;
            }
            
            
        } else {
            [annotationView setAnnotation:locAnn andTask:locAnn.task];
        }
        
        return annotationView;
        
        //TODO
        //fix task view
            //horizontal scrolling on bottom, when new item enters, item enters on screen
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
                    if(view.enabled){
                        [UIView animateWithDuration:0.2f animations:^{
                            [view setAlpha:1.0f];
                        }];
                    }
                }
            }
        }
    }
}

@end
