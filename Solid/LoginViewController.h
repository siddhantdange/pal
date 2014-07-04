//
//  LoginViewController.h
//  Solid
//
//  Created by Siddhant Dange on 6/2/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : PFLogInViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

-(void)populateFieldsWithPFUser:(PFUser*)user;
-(id)initVC;

@end
