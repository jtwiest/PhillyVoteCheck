//
//  CheckRegistrationViewController.h
//  PhillyVote
//
//  Created by Tyler Wiest on 3/28/15.
//  Copyright (c) 2015 codeforphilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "ResultsMapViewController.h"

@interface CheckRegistrationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirth;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;

@property (strong, nonatomic) IBOutlet UIView *resultsContainer;
@property (strong, nonatomic) IBOutlet UILabel *resultsName;
@property (strong, nonatomic) IBOutlet UILabel *resultsDOB;
@property (strong, nonatomic) IBOutlet UILabel *resultsParty;
@property (strong, nonatomic) IBOutlet UILabel *resultsDistrict;
@property (strong, nonatomic) IBOutlet UILabel *resultsWard;
@property (strong, nonatomic) IBOutlet UILabel *resultsLocation;
@property (strong, nonatomic) IBOutlet UILabel *resultsAddress1;
@property (strong, nonatomic) IBOutlet UILabel *resultsAddress2;
@property (strong, nonatomic) IBOutlet UILabel *resultsAccessability;
@property (strong, nonatomic) IBOutlet UIButton *resultsShowOnMap;

- (IBAction)submit:(id)sender;
- (IBAction)resultsShowMap:(id)sender;
- (IBAction)backToMenu:(id)sender;

@end
