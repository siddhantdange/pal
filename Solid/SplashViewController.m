//
//  SplashViewController.m
//  Solid
//
//  Created by Siddhant Dange on 5/31/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "SplashViewController.h"
#import "MainViewController.h"
#import "APIManager.h"
#import "LoginViewController.h"

@interface SplashViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation SplashViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [_spinner startAnimating];
    
   // if (![PFUser currentUser]) {
        // Customize the Log In View Controller
        LoginViewController *logInViewController = [[LoginViewController alloc] initVC];
        [logInViewController setDelegate:logInViewController];
        
        // Present Log In View Controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
//    } else{
//        //load data
//        [APIManager pullAllTasks:^(NSArray *tasks) {
//            NSLog(@"tasks: %@", tasks);
//            
//            //move to next VC
//            [self proceedToNextVC];
//        }];
//        
//        
//    }
}

-(void)proceedToNextVC{
    [self performSegueWithIdentifier:@"mainSegue" sender:self];
}

@end
