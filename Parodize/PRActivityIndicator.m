//
//  TWActivityIndicator.m
//  Titan Watch
//
//  Created by VenkateshX Mandapati on 10/30/15.
//  Copyright © 2015 VenkateshX Mandapati. All rights reserved.
//

#import "PRActivityIndicator.h"

@implementation PRActivityIndicator

+ (PRActivityIndicator *) createTGCActivityIndicator
{
    NSArray *xibViews = [[NSBundle mainBundle] loadNibNamed:@"PRActivityIndicator"
                                                      owner:nil
                                                    options:nil];
    
    return [xibViews lastObject];
}

@end
