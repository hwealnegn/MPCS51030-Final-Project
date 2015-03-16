//
//  ViewController.h
//  Align
//
//  Created by helenwang on 3/2/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// View controller outlets
@property (weak, nonatomic) IBOutlet UITableView *selectContacts;
@property (weak, nonatomic) IBOutlet UILabel *yourTime;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScroll;
@property (weak, nonatomic) IBOutlet UIImageView *scrollImage;

@property (strong, nonatomic) IBOutlet UIImageView *dayView;
@property (strong, nonatomic) IBOutlet UIImageView *sunView;
@property (strong, nonatomic) IBOutlet UIImageView *nightView;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue; // segue from AllContactsTableViewController
- (IBAction)showInstructions:(id)sender; // display instructions

// NSMutableArrays to store contact information
@property (strong, nonatomic) NSMutableArray *contactNames;
@property (strong, nonatomic) NSMutableArray *contactLocations;
@property (strong, nonatomic) NSMutableArray *contactSelections;
@property (strong, nonatomic) NSMutableArray *contactTimes;

// Array to store selected contacts (to populate table view)
@property (strong, nonatomic) NSMutableArray *selectedContacts;

// Variables to store hour and minute values based on scroll view position
// Initialized as system time
@property NSInteger dynamicHour;
@property NSInteger dynamicMinute;

@end

