//
//  ViewController.m
//  Align
//
//  Created by helenwang on 3/2/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import "ViewController.h"
#import "ContactTableViewCell.h"
#import "Contact.h"

@interface ViewController ()

@property NSMutableArray *contacts;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contacts = [[NSMutableArray alloc] init];
    [self loadInitialData];
    NSLog(@"Number of contacts: %lu", (unsigned long)[self.contacts count]);
    
    // Set your time as current time
    // Reference: http://stackoverflow.com/questions/8385132/get-current-time-on-the-iphone-in-a-chosen-format
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
     NSString *resultString = [dateFormatter stringFromDate: currentTime];
    self.yourTime.text = resultString;
}

- (void)loadInitialData {
    Contact *contact1 = [[Contact alloc] init];
    contact1.name = @"Mom";
    contact1.time = @"12:00";
    contact1.location = @"Taiwan";
    [self.contacts addObject:contact1];
    
    Contact *contact2 = [[Contact alloc] init];
    contact1.name = @"Dad";
    contact1.time = @"12:00";
    contact1.location = @"China";
    [self.contacts addObject:contact2];
    
    Contact *contact3 = [[Contact alloc] init];
    contact1.name = @"Kevin";
    contact1.time = @"11:00";
    contact1.location = @"New York";
    [self.contacts addObject:contact3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    Contact *contact = [self.contacts objectAtIndex:indexPath.row];
    
    // Configure cell here!
    cell.contactName.text = contact.name;
    cell.contactTime.text = contact.time;
    cell.contactLocation.text = contact.location;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
