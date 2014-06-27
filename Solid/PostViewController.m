//
//  PostViewController.m
//  Solid
//
//  Created by Siddhant Dange on 5/23/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "PostViewController.h"
#import <AddressBook/AddressBook.h>
#import "LocAnnotation.h"
#import "APIManager.h"
#import "User.h"

#import <Parse/Parse.h>

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *urgencySwitch;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property (nonatomic, strong) MKPlacemark *centerMark;

@end

@implementation PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.mapView setDelegate:self];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
    [self.mapView setShowsUserLocation:YES];
    
    _amountTextField.delegate = self;
    
    NSLog(@"");
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.2, 0.2);
    [self.mapView setRegion:mapRegion animated: YES];
}


- (IBAction)submitPost:(id)sender {
    int urgency = (int)self.urgencySwitch.selectedSegmentIndex;
    float amount = self.amountTextField.text.floatValue;
    NSString *description = self.descriptionTextField.text;
    PFUser *user = [PFUser currentUser];
    float latDelta = _mapView.region.span.latitudeDelta/2.0;
    int radius = [[[CLLocation alloc] initWithLatitude:_mapView.center.x longitude:_mapView.center.y - latDelta] distanceFromLocation:[[CLLocation alloc] initWithLatitude:_mapView.center.x longitude:_mapView.center.y + latDelta]];
    CLLocationCoordinate2D location2d = _mapView.region.center;
    PFGeoPoint *location = [PFGeoPoint geoPointWithLatitude:location2d.latitude longitude:location2d.longitude];
    
    Task *task = [Task new];
    task.urgency = urgency;
    task.amount = amount;
    task.descriptionText = description;
    task.owner = [User sharedInstance].user;
    task.geocenter = location;
    task.radius = radius;
    task.venue = [User sharedInstance].venue;
    
    [APIManager uploadTask:task withCompletion:^(NSError *error) {
        NSLog(@"uploaded: %@", error);
         [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
