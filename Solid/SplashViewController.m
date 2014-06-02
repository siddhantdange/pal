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

@interface SplashViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation SplashViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [_spinner startAnimating];
    
    if (![PFUser currentUser]) {
        // Customize the Log In View Controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self];
        [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
        [logInViewController setFields: PFLogInFieldsDefault | PFLogInFieldsFacebook | PFLogInFieldsDismissButton];
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present Log In View Controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    } else{
        //load data
        [APIManager pullAllTasks:^(NSArray *tasks) {
            NSLog(@"tasks: %@", tasks);
            
            //move to next VC
            [self proceedToNextVC];
        }];
        
        
    }
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    NSLog(@"user: %@", user);
    [logInController dismissViewControllerAnimated:YES completion:nil];
    [self proceedToNextVC];
}

-(void)proceedToNextVC{
    [self performSegueWithIdentifier:@"mainSegue" sender:self];
}

-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error{
    
}
-(BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password{
    return YES;
}

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController{
    
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error{
    
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    NSLog(@"USER %@", user);
}

-(BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info{
    return YES;
}

-(void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController{
    
}

@end
