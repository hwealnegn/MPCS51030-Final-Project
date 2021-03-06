//
//  AllContactsTableViewController.h
//  Align
//
//  Created by helenwang on 3/8/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllContactsTableViewController : UITableViewController

- (IBAction)unwindToContacts:(UIStoryboardSegue *)segue; // segue from AddContactViewController

// Store information of all contacts
@property (strong, nonatomic) NSMutableArray *contactNames;
@property (strong, nonatomic) NSMutableArray *contactLocations;
@property (strong, nonatomic) NSMutableArray *contactSelections;
@property (strong, nonatomic) NSMutableArray *contactTimes;

// Background images
@property (strong, nonatomic) IBOutlet UIImageView *dayView;
@property (strong, nonatomic) IBOutlet UIImageView *sunView;
@property (strong, nonatomic) IBOutlet UIImageView *nightView;

// Store alpha values for background images
@property CGFloat dayAlpha;
@property CGFloat sunAlpha;
@property CGFloat nightAlpha;

@end
