//
//  AddContactViewController.h
//  Align
//
//  Created by helenwang on 3/10/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface AddContactViewController : UIViewController

@property Contact *contact;

// Store information of all contacts
@property (strong, nonatomic) NSMutableArray *contactNames;
@property (strong, nonatomic) NSMutableArray *contactLocations;
@property (strong, nonatomic) NSMutableArray *contactSelections;
@property (strong, nonatomic) NSMutableArray *contactTimeDifferences;

@end
