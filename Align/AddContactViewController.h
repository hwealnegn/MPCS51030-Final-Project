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

@property (strong, nonatomic) NSMutableArray *cityNames;

@property (strong, nonatomic) IBOutlet UIImageView *dayView;
@property (strong, nonatomic) IBOutlet UIImageView *sunView;
@property (strong, nonatomic) IBOutlet UIImageView *nightView;

@property CGFloat dayAlpha;
@property CGFloat sunAlpha;
@property CGFloat nightAlpha;

@end
