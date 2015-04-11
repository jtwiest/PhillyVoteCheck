//
//  ResultsMapViewController.m
//  PhillyVote
//
//  Created by Tyler Wiest on 3/28/15.
//  Copyright (c) 2015 codeforphilly. All rights reserved.
//

#import "ResultsMapViewController.h"
#define addressType 1
#define districtType 2

@interface ResultsMapViewController ()
@property (strong, nonatomic) MKMapView *map;
@property CLLocationCoordinate2D initialLocation;
@property (strong, nonatomic) API *api;
@property (strong, nonatomic) NSMutableDictionary *activeAttribute;
@property (strong, nonatomic) PollingInformationView *pollingInfoView;
@property (strong, nonatomic) UIButton *removeResultsButton;
@end

@implementation ResultsMapViewController
@synthesize coordinate;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Init api
    _api = [[API alloc] init];
    
    _addressInputView.layer.cornerRadius = 4.0;
    _districtWardInputView.layer.cornerRadius = 4.0;
    
    // Init map
    _map = [[MKMapView alloc] initWithFrame:self.view.frame];
    _map.delegate = self;
    _map.showsUserLocation = YES;
    _map.userInteractionEnabled = YES;
    _initialLocation = CLLocationCoordinate2DMake(39.9523893, -75.1636291);
    [_map setRegion:MKCoordinateRegionMake(_initialLocation, MKCoordinateSpanMake(.05,.05))];
    [self.view addSubview:_map];
    
    // Go start to API if Ward / District are already set
    if (_ward && _district) {
        [_api getPollingLocationFromDistrict:_district andWard:_ward];

    } else {
        
        // Show / hide relevant input boxes
        if (_type == addressType) {
            _districtWardInputView.hidden = YES;
            [self.view bringSubviewToFront:_addressInputView];
        } else {
            _addressInputView.hidden = YES;
            [self.view bringSubviewToFront:_districtWardInputView];
        }
    }
    
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addPollingLocationToMap:)
                                                 name:@"addPollingLocationToMap"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showFullInfo:)
                                                 name:@"showFullInfo"
                                               object:nil];
    
}

#pragma mark Map Function

- (void)addPollingLocationToMap:(NSNotification *) notification  {
    
    if ([[NSArray alloc] initWithArray:[notification.object valueForKey:@"features"]] == nil) {
        NSLog(@"No feature to add!");
        return;
    }
    
    NSArray *features = [[NSArray alloc] initWithArray:[notification.object valueForKey:@"features"]];
    for (int i=0; i < features.count; i++) {
        NSDictionary *attribute = [[NSDictionary alloc] initWithDictionary:[features objectAtIndex:i]];
        [self addAttributeToMap:[attribute objectForKey:@"attributes"]];
    }
}

- (void)addAttributeToMap:(NSDictionary*)attribute {
    NSLog(@"Add attribute to map: %@", attribute);
    _activeAttribute = [[NSMutableDictionary alloc] initWithDictionary:attribute];
    
    // Remove old annotation
    [_map removeAnnotations:_map.annotations];
    
    // Get coordinates
    float lat = [[attribute objectForKey:@"lat"] floatValue];
    float lng = [[attribute objectForKey:@"lng"] floatValue];
    
    // Get map center
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(lat, lng);
    NSLog(@"Lat: %f, Lng: %f", lat, lng);
    
    center.latitude += _map.region.span.latitudeDelta * 0.20;
    [_map setCenterCoordinate:center animated:YES];
    
    // Create point and set values
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = center;
    point.title = [[attribute valueForKey:@"location"] capitalizedString];
    point.subtitle = [NSString stringWithFormat:@"%@", [attribute objectForKey:@"display_address"]];
    
    // Add point to map
    [_map addAnnotation:point];
    [_map selectAnnotation:point animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString* AnnotationIdentifier = @"PollingLocationIdentifier";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    } else {
        pinView.annotation = annotation;
    }
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(showPointDetails:) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView = rightButton;
    
    return pinView;
}

#pragma mark Actions

- (void)showPointDetails:(id)sender {
    NSLog(@"Show point details");
    NSLog(@"active %@", _activeAttribute);
    
    if (!_removeResultsButton) {
        _removeResultsButton = [[UIButton alloc] initWithFrame:self.view.frame];
        [_removeResultsButton addTarget:self action:@selector(removeLocationOverview) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_removeResultsButton];
    
    if (!_pollingInfoView) {
        _pollingInfoView = [[PollingInformationView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*.1,
                                                                                    (self.view.frame.size.height-250)/2.0,
                                                                                    self.view.frame.size.width*.8,
                                                                                    250)
                                                            andAttribute:_activeAttribute];
    } else {
        // update view
    }
    
    [self.view addSubview:_pollingInfoView];
}

- (IBAction)goBack:(id)sender {
    [self performSegueWithIdentifier:@"toMainMenu" sender:self];
}

- (IBAction)search:(id)sender {
    if (_type == addressType) {
        NSLog(@"Search with Address %@", _addressField.text);
        if ([_addressField.text isEqualToString:@""]) {
            [self showEmptyAlert];
        } else {
            _addressInputView.hidden = YES;
            [[self view] endEditing:YES];
            
            // Hit API
            
        }
    } else if (_type == districtType)  {
        NSLog(@"Search with District %@ Ward %@", _districtField.text, _wardField.text);
        if ([_wardField.text isEqualToString:@""] || [_addressField.text isEqualToString:@""]) {
            [self showEmptyAlert];
        } else {
            _districtWardInputView.hidden = YES;
            [[self view] endEditing:YES];
            
            // Hit API
            [_api getPollingLocationFromDistrict:_districtField.text andWard:_wardField.text];
        }
    }
}

- (void)removeLocationOverview {
    [_pollingInfoView removeFromSuperview];
    [_removeResultsButton removeFromSuperview];
}

#pragma mark Alerts

- (void)showEmptyAlert {
    
    NSString *message;
    if (_type == addressType) {
        message = @"Please provide an address";
    } else {
        message = @"Please provide a district and ward";
    }
    
    UIAlertView *emptyAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
    [emptyAlert show];
}

#pragma mark Segues

- (void)showFullInfo:(NSNotification *) notification  {
    [self performSegueWithIdentifier:@"toFullDetails" sender:self];
}

@end
