//
//  LoginViewController.m
//  Solid
//
//  Created by Siddhant Dange on 6/2/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "User.h"

@interface LoginViewController ()

@property (nonatomic, strong) SignUpViewController *signupVC;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initVC{
    self = [super init];
    [self setFields:PFLogInFieldsFacebook];
    [self setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
    
    // Create the sign up view controller
    _signupVC = [[SignUpViewController alloc] init];
    
    // [_signupVC setFields:PFSignUpFieldsEmail | PFSignUpFieldsSignUpButton];
    [_signupVC setDelegate:_signupVC]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [self setSignUpController:_signupVC];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view.
    
    //    if([PFUser currentUser][@"emailVerified"]){
    //        NSLog(@"please verify email!");
    //    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark PFLoginViewController Delegate Methods

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    NSLog(@"user: %@", user);
    [User sharedInstance].user = user;
    PFObject *emailUser;
    
    //if just signed up then get email user
    if([User sharedInstance].emailUserId){
        emailUser = [PFObject objectWithoutDataWithClassName:@"_User" objectId:[User sharedInstance].emailUserId];
    }
    
    //if user email field is empty and no email user then we know user hasn't signed up
    if(!user[@"email"] && !emailUser){
        [self presentViewController:_signupVC animated:YES completion:nil];
    } else{
        
        //if email field linked then log in directly else first signup setup hasnt finished
        if(user[@"email"]){
            //            [PFCloud callFunctionInBackground:@"linkVenue"
            //                               withParameters:@{}
            //                                        block:^(NSArray *results, NSError *error) {
            //                                            if (!error) {
            //                                                // this is where you handle the results and change the UI.
            //                                                [logInController dismissViewControllerAnimated:YES completion:nil];
            //                                                NSLog(@"results: %@", results);
            //                                            } else{
            //                                                NSLog(@"error: %@", error);
            //                                            }
            //                                        }];
            [logInController dismissViewControllerAnimated:YES completion:nil];
            
            
        } else{
            
            //finish first signup setup by fetching temporary user and checking if email verified
            [emailUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if(!error){
                    int verified = ((NSString*)object[@"emailVerified"]).intValue;
                    
                    //if verified then pull email and link with venue - first sign up case else prompt user to confirm email
                    if(verified == 1){
                        user[@"email"] = [NSString stringWithFormat:@"%@.com", object[@"email"]];
                        
                        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            [PFCloud callFunctionInBackground:@"linkVenue"
                                               withParameters:@{}
                                                        block:^(NSArray *results, NSError *error) {
                                                            if (!error) {
                                                                [PFCloud callFunctionInBackground:@"deleteUser"
                                                                                   withParameters:@{@"userID" : [User sharedInstance].emailUserId}
                                                                                            block:^(NSArray *results, NSError *error) {
                                                                                                if (!error) {
                                                                                                    // this is where you handle the results and change the UI.
                                                                                                    [logInController dismissViewControllerAnimated:YES completion:nil];
                                                                                                    NSLog(@"results: %@", results);
                                                                                                } else{
                                                                                                    NSLog(@"error: %@", error);
                                                                                                }
                                                                                            }];
                                                            } else{
                                                                NSLog(@"error: %@", error);
                                                            }
                                                        }];
                        }];
                        
                    } else{
                        NSLog(@"confirm email!");
                    }
                } else{
                    [self presentViewController:_signupVC animated:YES completion:nil];
                }
            }];
        }
    }
}

-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error{
    
}

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController{
    
    
}

@end
