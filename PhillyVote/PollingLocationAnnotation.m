//
//  PollingLocationAnnotation.m
//  PhillyVote
//
//  Created by Tyler Wiest on 3/28/15.
//  Copyright (c) 2015 codeforphilly. All rights reserved.
//

#import "PollingLocationAnnotation.h"

@implementation PollingLocationAnnotation

@synthesize coordinate;

-(id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

- (MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"PollingLocationAnnotation"];
    annotationView.enabled = YES;    
    return annotationView;
}

@end
