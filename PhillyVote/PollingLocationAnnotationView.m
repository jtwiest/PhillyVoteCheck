//
//  PollingLocationAnnotationView.m
//  PhillyVote
//
//  Created by Tyler Wiest on 3/28/15.
//  Copyright (c) 2015 codeforphilly. All rights reserved.
//

#import "PollingLocationAnnotationView.h"

@implementation PollingLocationAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Set the frame size to the appropriate values.
        CGRect  myFrame = self.frame;
        myFrame.size.width = 100;
        myFrame.size.height = 100;
        self.frame = myFrame;
        
        // The opaque property is YES by default. Setting it to
        // NO allows map content to show through any unrendered parts of your view.
        self.opaque = NO;
    }
    return self;
}

@end
