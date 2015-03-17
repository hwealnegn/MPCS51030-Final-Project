//
//  AddContactViewController.h
//  Align
//
//  Created by helenwang on 3/10/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface AddContactViewController : UIViewController <UITextFieldDelegate>

@property Contact *contact;

// Store information of all contacts
@property (strong, nonatomic) NSMutableArray *contactNames;
@property (strong, nonatomic) NSMutableArray *contactLocations;
@property (strong, nonatomic) NSMutableArray *contactSelections;
@property (strong, nonatomic) NSMutableArray *contactTimeDifferences;

// All cities listed in NSTimeZone
@property (strong, nonatomic) NSMutableArray *cityNames;

// Background images
@property (strong, nonatomic) IBOutlet UIImageView *dayView;
@property (strong, nonatomic) IBOutlet UIImageView *sunView;
@property (strong, nonatomic) IBOutlet UIImageView *nightView;

// Store alpha values for background images
@property CGFloat dayAlpha;
@property CGFloat sunAlpha;
@property CGFloat nightAlpha;

// Action linked to button press of checkmark (add contact)
- (IBAction)addContactCheckpoint:(id)sender;

@end
