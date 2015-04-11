//
//  CheckRegistrationViewController.m
//  PhillyVote
//
//  Created by Tyler Wiest on 3/28/15.
//  Copyright (c) 2015 codeforphilly. All rights reserved.
//

#import "CheckRegistrationViewController.h"
#define addressType 1
#define districtType 2

@interface CheckRegistrationViewController ()
@property (strong, nonatomic) API *api;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSString *ward;
@property (strong, nonatomic) NSString *district;
@end

@implementation CheckRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _api = [[API alloc] init];
    _submitButton.layer.cornerRadius = 4.0;
    _resultsShowOnMap.layer.cornerRadius = 4.0;
    
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(amIRegesteredResults:)
                                                 name:@"amIRegesteredResults"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(amIRegesteredResults:)
                                                 name:@"amIRegesteredResultsFailed"
                                               object:nil];
    
}

- (IBAction)submit:(id)sender {
    NSLog(@"Submit FirstName: %@ LastName: %@ DOB: %@", _firstName.text, _lastName.text, _dateOfBirth.text);
    [self showSpinner];
    _submitButton.enabled = NO;
    [_api checkRegistrationWithFirstName:_firstName.text LastName:_lastName.text DOB:_dateOfBirth.text];
}

- (void)amIRegesteredResults:(NSNotification *) notification  {
    [_spinner stopAnimating];
    _submitButton.enabled = YES;
    NSLog(@"Am I Regester Results: %@", notification.object);
    
    NSDictionary *results = [NSDictionary dictionaryWithDictionary:notification.object];
    
    _resultsName.text = [[results objectForKey:@"name"] capitalizedString];
    _resultsDOB.text = [[results objectForKey:@"dob"] capitalizedString];
    _resultsParty.text = [[results objectForKey:@"party"] capitalizedString];
    _resultsDistrict.text = [[results objectForKey:@"division"] capitalizedString];
    _resultsWard.text = [[results objectForKey:@"ward"] capitalizedString];
    
    NSDictionary *location = [NSDictionary dictionaryWithDictionary:[results objectForKey:@"polling_place"]];
    
    _resultsLocation.text = [[location objectForKey:@"name"] capitalizedString];
    _resultsAddress1.text = [[[location objectForKey:@"address"] objectForKey:@"street"] capitalizedString];
    
    NSString *address2 = [NSString stringWithFormat:@"%@, %@", [[[location objectForKey:@"address"] objectForKey:@"city"] capitalizedString], [[[location objectForKey:@"address"] objectForKey:@"state"] capitalizedString]];
    _resultsAddress2.text = address2;
    _resultsAccessability.text = [[location objectForKey:@"accessibility"] capitalizedString];
    
    // Fade view onto screen
    [UIView animateWithDuration:.5 animations:^{
        _resultsContainer.alpha = 1;
    }];
    
    _district = [results objectForKey:@"division"];
    _ward = [results objectForKey:@"ward"];
}

- (void)amIRegesteredResultsFailed:(NSNotification *) notification  {
    [_spinner stopAnimating];
    _submitButton.enabled = YES;
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"No Results Found"
                                                            message:@"You are ether not registered or entered the above information in incorrectly"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
    [failedAlert show];
}

- (void)showSpinner {
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _spinner.center = _submitButton.center;
        _spinner.hidesWhenStopped = YES;
        [self.view addSubview:_spinner];
        [self.view bringSubviewToFront:_spinner];
    }
    [_spinner startAnimating];
}

- (IBAction)resultsShowMap:(id)sender {
    [self performSegueWithIdentifier:@"showMapWithWard" sender:self];
}

- (IBAction)backToMenu:(id)sender {
    [self performSegueWithIdentifier:@"toMainMenu" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMapWithWard"]) {
        UINavigationController *navVC = [segue destinationViewController];
        ResultsMapViewController *mapVC = [navVC.childViewControllers objectAtIndex:0];
        [mapVC setDistrict:_district];
        [mapVC setWard:_ward];
    }
}

@end
