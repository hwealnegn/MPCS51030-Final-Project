//
//  Contact.h
//  Align
//
//  Created by helenwang on 3/2/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import <Foundation/Foundation.h>

// Object that groups together information for each contact
@interface Contact : NSObject

@property NSString *name;
@property NSString *time;
@property NSString *location;
@property BOOL selected;

@end
