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
    if([User sharedInstance].emailUserId){
        emailUser = [PFObject objectWithoutDataWithClassName:@"_User" objectId:[User sharedInstance].emailUserId];   
    }
    
    if(!user[@"email"] && !emailUser){
        [self presentViewController:_signupVC animated:YES completion:nil];
    } else{
        if(user[@"email"]){
            [logInController dismissViewControllerAnimated:YES completion:nil];
        } else{
           
            [emailUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if(!error){
                    int verified = ((NSString*)object[@"emailVerified"]).intValue;
                    if(verified == 1){
                        user[@"email"] = [NSString stringWithFormat:@"%@.com", object[@"email"]];
                        
                        [user saveInBackground];
                        [logInController dismissViewControllerAnimated:YES completion:nil];
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
