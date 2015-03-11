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
#import "AllContactsTableViewController.h"

@interface ViewController ()

@property NSMutableArray *contacts;

@property(readonly) NSInteger secondsFromGMT;

@end

@implementation ViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    //AllContactsTableViewController *source = [segue sourceViewController];
    /*ToDoItem *item = source.toDoItem;
    if (item != nil) {
        [self.toDoItems addObject:item];
        [self.tableView reloadData];
    }*/
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contacts = [[NSMutableArray alloc] init];
    [self loadInitialData];
    
    // Set your time as current time
    // Reference: http://stackoverflow.com/questions/8385132/get-current-time-on-the-iphone-in-a-chosen-format
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
     NSString *resultString = [dateFormatter stringFromDate: currentTime];
    self.yourTime.text = resultString;
    
    NSLog(@"FIRST VIEW DID LOAD");
    
    /*NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
    for (int i=0; i<[timeZoneNames count]; i++){
        NSLog(@"%@", timeZoneNames[i]);
    }*/
    
    NSLog(@"Time in Taipei: %@", [NSTimeZone timeZoneWithName:@"Asia/Taipei"]);
    
    // Example code from http://rypress.com/tutorials/objective-c/data-types/dates
    NSTimeZone *centralStandardTime = [NSTimeZone timeZoneWithAbbreviation:@"CST"];
    NSTimeZone *cairoTime = [NSTimeZone timeZoneWithName:@"Africa/Cairo"];
    NSTimeZone *taipeiTime = [NSTimeZone timeZoneWithName:@"Asia/Taipei"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    
    [formatter setLocale:posix];
    //[formatter setDateFormat:@"M.d.y h:mm a"];
    [formatter setDateFormat:@"h a"];
    NSString *dateString = @"8 PM";
    //NSString *dateString = @"11.4.2012 8:09 PM";
    
    [formatter setTimeZone:centralStandardTime];
    NSDate *eightPMInChicago = [formatter dateFromString:dateString];
    NSLog(@"%@", eightPMInChicago);
    
    [formatter setTimeZone:cairoTime];
    NSDate *eightPMInCairo = [formatter dateFromString:dateString];
    NSLog(@"%@", eightPMInCairo);
    
    [formatter setTimeZone:taipeiTime];
    //NSDate *eightPMInTaipei = [formatter dateFromString:dateString];
    
    //long long msCairo = [eightPMInCairo timeIntervalSince1970]/3600;
    //long long msChicago = [eightPMInChicago timeIntervalSince1970]/3600;
    //long long msTaipei = [eightPMInTaipei timeIntervalSince1970]/3600;
    
    //NSLog(@"Time difference: %lld", msTaipei-msChicago);
    
    NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}

- (void)loadInitialData {
    // get time zone usin
    Contact *contact1 = [[Contact alloc] init];
    contact1.name = @"Mom";
    contact1.time = @"12:00";
    contact1.location = @"Taipei";
    [self.contacts addObject:contact1];
    
    Contact *contact2 = [[Contact alloc] init];
    contact2.name = @"Dad";
    contact2.time = @"12:00";
    contact2.location = @"Shanghai";
    [self.contacts addObject:contact2];
    
    Contact *contact3 = [[Contact alloc] init];
    contact3.name = @"Kevin";
    contact3.time = @"11:00";
    contact3.location = @"New York"; // replace " " with "_"
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
    
    //NSLog(@"Cell configured: %@ %@ %@", contact.name, contact.time, contact.location);
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
