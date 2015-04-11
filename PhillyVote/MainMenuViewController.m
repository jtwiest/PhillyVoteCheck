//
//  MainMenuViewController.m
//  PhillyVote
//
//  Created by Tyler Wiest on 3/28/15.
//  Copyright (c) 2015 codeforphilly. All rights reserved.
//

#import "MainMenuViewController.h"

#define addressType 1
#define districtType 2

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _amIRegistredButton.layer.cornerRadius = 4.0;
    _wheresMyLocationButton.layer.cornerRadius = 4.0;
}

- (IBAction)findLocation:(id)sender {
    UIAlertView *locationAlert = [[UIAlertView alloc] initWithTitle:@"Find Polling Location by:"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Address",@"District & Ward",nil];
    [locationAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // Search by Address
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"toMapWithAddress" sender:self];
    // Search by District & Ward
    } else if (buttonIndex == 2) {
        [self performSegueWithIdentifier:@"toMapWithDistrict" sender:self];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toMapWithAddress"]) {
        UINavigationController *navVC = [segue destinationViewController];
        ResultsMapViewController *mapVC = [navVC.childViewControllers objectAtIndex:0];
        [mapVC setType:addressType];
        
    } else if ([segue.identifier isEqualToString:@"toMapWithDistrict"]) {
        UINavigationController *navVC = [segue destinationViewController];
        ResultsMapViewController *mapVC = [navVC.childViewControllers objectAtIndex:0];
        [mapVC setType:districtType];
    }
}

@end
