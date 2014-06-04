//
//  SignUpViewController.m
//  Solid
//
//  Created by Siddhant Dange on 6/2/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "SignUpViewController.h"
#import "User.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
    
    
}
- (void)viewDidLayoutSubviews{
    
    //remove other fields and background image
    [self.signUpView.usernameField removeFromSuperview];
    [self.signUpView.usernameField setText:[NSString stringWithFormat:@"%d", rand()]];
    [self.signUpView.passwordField removeFromSuperview];
    [self.signUpView.passwordField setText:@"a"];
    for (UIView *subview in self.signUpView.subviews) {
        if([subview isKindOfClass:[UIImageView class]]){
            [subview removeFromSuperview];
        }
    }
    
    //shift up email field
    CGRect emailRect = self.signUpView.emailField.frame;
    emailRect.origin.y -= 2 * emailRect.size.height;
    [self.signUpView.emailField setFrame:emailRect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma -mark PFSignUpViewController Delegate Methods



-(void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error{   
    
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    
    [User sharedInstance].emailUserId = user.objectId;
    [PFUser logOut];
    
    NSLog(@"Please verify email and login with facebook again");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info{
    return YES;
}

-(void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController{
}

@end
