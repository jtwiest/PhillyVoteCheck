//
//  MainMenuViewController.h
//  PhillyVote
//
//  Created by Tyler Wiest on 3/28/15.
//  Copyright (c) 2015 codeforphilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultsMapViewController.h"

@interface MainMenuViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *amIRegistredButton;
@property (strong, nonatomic) IBOutlet UIButton *wheresMyLocationButton;

- (IBAction)findLocation:(id)sender;

@end
