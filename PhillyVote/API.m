//
//  API.m
//  PhillyVote
//
//  Created by Tyler Wiest on 3/28/15.
//  Copyright (c) 2015 codeforphilly. All rights reserved.
//

#import "API.h"

@interface API ()
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation API

- (id)init {
    if (self = [super init]) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)getPollingLocationFromDistrict:(NSString*)district andWard:(NSString*)ward {
    
    NSString *url = [NSString stringWithFormat:@"http://api.phila.gov/polling-places/v1/?ward=%@&division=%@", ward, district];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:_queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [[NSOperationQueue mainQueue] addOperationWithBlock:^ {

                                   if (error == nil) {
                                       NSError* error;
                                       NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                    options:kNilOptions
                                                                                                      error:&error];
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"addPollingLocationToMap" object:responseData];
                                   } else {
                                       NSLog(@"Get polling location error: %@", error);
                                       // [[NSNotificationCenter defaultCenter] postNotificationName:@"loginTokenExpired" object:self];
                                   }
                               }];
                           }];
}


- (void)checkRegistrationWithFirstName:(NSString*)firstName LastName:(NSString*)lastName DOB:(NSString*)dob {
    
    NSString *url = @"http://pavoter.banderkat.com/pavoter";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    
    // Add Headers
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Add Post Values
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         firstName, @"firstName",
                         lastName, @"lastName",
                         dob, @"dob",
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:_queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                                   
                                   NSLog(@"response %@" , response);
                                   
                                   if (error == nil) {
                                       NSError* error;
                                       NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                    options:kNilOptions
                                                                                                      error:&error];
                                       if ([responseData objectForKey:@"registration"]) {
                                           NSDictionary *results = [responseData objectForKey:@"registration"];
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"amIRegesteredResults" object:results];
                                       } else {
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"amIRegesteredResultsFailed" object:responseData];

                                       }
                                       
                                   } else {
                                       NSLog(@"Get polling location error: %@", error);
                                       // [[NSNotificationCenter defaultCenter] postNotificationName:@"loginTokenExpired" object:self];
                                   }
                               }];
                           }];
}

@end
