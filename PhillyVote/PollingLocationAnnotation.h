//
//  PollingLocationAnnotation.h
//  PhillyVote
//
//  Created by Tyler Wiest on 3/28/15.
//  Copyright (c) 2015 codeforphilly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PollingLocationAnnotation : NSObject  <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@end
