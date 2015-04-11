//
//  PollingInformationView.m
//  PhillyVote
//
//  Created by Tyler Wiest on 3/28/15.
//  Copyright (c) 2015 codeforphilly. All rights reserved.
//

#import "PollingInformationView.h"

@interface PollingInformationView()
@property (strong, nonatomic) UIScrollView *container;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *address1;
@property (strong, nonatomic) UILabel *address2;
@property (strong, nonatomic) UILabel *parking;
@property (strong, nonatomic) UILabel *access;
@property (strong, nonatomic) UIButton *moreInfo;
@property (strong, nonatomic) NSDictionary *apiValues;
@end


@implementation PollingInformationView

-(id)initWithFrame:(CGRect)frame andAttribute:(NSMutableDictionary*)attribute {
    
    if (self = [super initWithFrame:frame]) {
        
        UIColor *fontColor = [UIColor whiteColor];
        _apiValues = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"APIValues"
                                                                                                ofType:@"plist"]];
        
        self.backgroundColor = [UIColor blueColor];
        self.layer.cornerRadius = 4.0;
        
        // Container
        _container = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_container];
        
        float xMargin = self.frame.size.width*.05;
        float yMargin = self.frame.size.height*.02;
        float inputWidth = self.frame.size.width*.9;
        float inputHeight = 20;
        
        // Name
        _name = [[UILabel alloc] initWithFrame:CGRectMake(xMargin,
                                                          yMargin+20,
                                                          inputWidth,
                                                          inputHeight*2)];
        _name.text = [[attribute valueForKey:@"location"] capitalizedString];
        _name.lineBreakMode = NSLineBreakByWordWrapping;
        _name.numberOfLines = 0;
        _name.textColor = fontColor;
        [_name sizeToFit];
        [_container addSubview:_name];
        
        // Address 1
        _address1 = [[UILabel alloc] initWithFrame:CGRectMake(xMargin,
                                                              _name.frame.size.height+_name.frame.origin.y+yMargin,
                                                              inputWidth,
                                                              inputHeight)];
        _address1.text = [[attribute valueForKey:@"display_address"] capitalizedString];
        _address1.textColor = fontColor;
        [_container addSubview:_address1];
        
        // Address 2
        _address2 = [[UILabel alloc] initWithFrame:CGRectMake(xMargin,
                                                              _address1.frame.size.height+_address1.frame.origin.y+yMargin,
                                                              inputWidth,
                                                              inputHeight)];
        _address2.text = [NSString stringWithFormat:@"Philadelphia, PA %@",[[attribute valueForKey:@"zip_code"] capitalizedString]];
        _address2.textColor = fontColor;
        [_container addSubview:_address2];
        
        // Parking
        _parking = [[UILabel alloc] initWithFrame:CGRectMake(xMargin,
                                                              _address2.frame.size.height+_address2.frame.origin.y+yMargin,
                                                              inputWidth,
                                                              inputHeight)];
        _parking.text = [NSString stringWithFormat:@"Parking: %@", [[_apiValues objectForKey:@"Parking"] objectForKey:[attribute objectForKey:@"parking"]]];
        _parking.textColor = fontColor;
        [_container addSubview:_parking];
        
        // Accessability
        _access = [[UILabel alloc] initWithFrame:CGRectMake(xMargin,
                                                            _parking.frame.size.height+_parking.frame.origin.y+yMargin,
                                                            inputWidth,
                                                            inputHeight*3)];
        _access.text = [NSString stringWithFormat:@"Accessability: %@", [[_apiValues objectForKey:@"Building"] objectForKey:[attribute objectForKey:@"building"]]];
        _access.lineBreakMode = NSLineBreakByWordWrapping;
        _access.numberOfLines = 0;
        [_access sizeToFit];
        _access.textColor = fontColor;
        [_container addSubview:_access];
        
        // More info button
        _moreInfo = [[UIButton alloc] initWithFrame:CGRectMake(xMargin,
                                                              self.frame.size.height-2*inputHeight,
                                                              inputWidth,
                                                              inputHeight)];
        [_moreInfo setTitle:@"Need More Info?" forState:UIControlStateNormal];
        [_moreInfo addTarget:self action:@selector(showMoreInfo) forControlEvents:UIControlEventTouchUpInside];
        [_container addSubview:_moreInfo];
        
    }
    return self;
}

- (void)showMoreInfo {
    NSLog(@"Show more info");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showFullInfo" object:nil];
}

@end
