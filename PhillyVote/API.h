//
//  API.h
//  PhillyVote
//
//  Created by Tyler Wiest on 3/28/15.
//  Copyright (c) 2015 codeforphilly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject

- (void)getPollingLocationFromDistrict:(NSString*)district andWard:(NSString*)ward;
- (void)checkRegistrationWithFirstName:(NSString*)firstName LastName:(NSString*)lastName DOB:(NSString*)dob;

@end
