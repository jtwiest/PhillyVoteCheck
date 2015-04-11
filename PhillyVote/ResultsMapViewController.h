//
//  ResultsMapViewController.h
//  PhillyVote
//
//  Created by Tyler Wiest on 3/28/15.
//  Copyright (c) 2015 codeforphilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "API.h"
#import "PollingInformationView.h"
#import "PollingLocationAnnotation.h"
#import "PollingLocationAnnotationView.h"


@interface ResultsMapViewController : UIViewController <MKMapViewDelegate, MKAnnotation>

@property int type;
@property (strong, nonatomic) IBOutlet UIView *addressInputView;
@property (strong, nonatomic) IBOutlet UIView *districtWardInputView;
@property (strong, nonatomic) IBOutlet UITextField *addressField;
@property (strong, nonatomic) IBOutlet UITextField *districtField;
@property (strong, nonatomic) IBOutlet UITextField *wardField;

@property (strong, nonatomic) NSString *ward;
@property (strong, nonatomic) NSString *district;

- (IBAction)goBack:(id)sender;
- (IBAction)search:(id)sender;

@end
