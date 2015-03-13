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
    /*AddContactViewController *source = [segue sourceViewController];
    Contact *contact = source.contact;
    if (contact != nil) {
        [self.contacts addObject:contact];
        [self.selectContacts reloadData];
    }*/

    [self.selectContacts reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.selectContacts reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contacts = [[NSMutableArray alloc] init];
    self.contactNames = [[NSMutableArray alloc] init];
    self.contactLocations = [[NSMutableArray alloc] init];
    self.contactSelections = [[NSMutableArray alloc] init];
    self.contactTimes = [[NSMutableArray alloc] init];
    self.selectedContacts = [[NSMutableArray alloc] init];
    
    [self loadInitialData];
    
    // Set your time as current time
    // Reference: http://stackoverflow.com/questions/8385132/get-current-time-on-the-iphone-in-a-chosen-format
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
     NSString *resultString = [dateFormatter stringFromDate: currentTime];
    self.yourTime.text = resultString;
    
    // Trying out a different method
    // Reference: http://stackoverflow.com/questions/5646539/iphonefind-the-current-timezone-offset-in-hours
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    float timeZoneOffset = [destinationTimeZone secondsFromGMT] / 3600.0;
    NSLog(@"Time zone offset: %f", timeZoneOffset);
    
    NSLog(@"FIRST VIEW DID LOAD");
    
    NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
    for (int i=0; i<[timeZoneNames count]; i++){
        //NSLog(@"%@", timeZoneNames[i]);
        
        // get city name
        NSString *zone = timeZoneNames[i];
        NSString *city;
        NSRange range = [zone rangeOfString:@"/" options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            city = [zone substringFromIndex:range.location+1];
        } else {
            city = zone;
        }
        
        NSLog(@"%@", city);
        
        for (int j=0; j<[self.contacts count]; j++) {
            NSString *contactCity = self.contactLocations[j];
            if ([contactCity isEqualToString:city]) {
                NSTimeZone *contactTimeZone = [NSTimeZone timeZoneWithName:zone];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setTimeZone:contactTimeZone];
                
                // Attempt #2
                float contactTZOffset = [contactTimeZone secondsFromGMT] / 3600.0;
                NSLog(@"Time where contact is: %f", contactTZOffset-timeZoneOffset);
                
                float timeDifference = contactTZOffset-timeZoneOffset;
                NSString *diffAsStr = [NSString stringWithFormat:@"%f", timeDifference];
                
                self.contactTimes[j] = diffAsStr;
            }
        }
    }
    
    for (int i=0; i<[self.contacts count]; i++) {
        NSLog(@"Contact: %@, time: %@, location: %@", self.contactNames[i], self.contactTimes[i], self.contactLocations[i]);
    }
    
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
    //long long msChicago = [eightPMInChicago timeIntervalSinceNow]/3600;
    //long long msTaipei = [eightPMInTaipei timeIntervalSince1970]/3600;
    //NSLog(@"Time difference: %lld", msTaipei-msChicago);
    
    NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}

- (void)loadInitialData {
    
    // Load data from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"contactNames"] != nil) {
        [self.contactNames addObjectsFromArray:[defaults objectForKey:@"contactNames"]]; // add existing objects
    }
    if ([defaults objectForKey:@"contactLocations"] != nil) {
        [self.contactLocations addObjectsFromArray:[defaults objectForKey:@"contactLocations"]];
    }
    if ([defaults objectForKey:@"contactSelections"] != nil) {
        [self.contactSelections addObjectsFromArray:[defaults objectForKey:@"contactSelections"]];
    }
    if ([defaults objectForKey:@"contactTimes"] != nil) {
        [self.contactTimes addObjectsFromArray:[defaults objectForKey:@"contactTimes"]];
    }
    
    if (self.contactNames != nil) {
        for (int i=0; i<[self.contactNames count]; i++){
            Contact *addContact = [[Contact alloc] init];
            addContact.name = self.contactNames[i];
            addContact.location = self.contactLocations[i];
            BOOL b = [[self.contactSelections objectAtIndex:i] boolValue]; // convert back to bool
            addContact.selected = b;
            addContact.time = self.contactTimes[i];
            
            [self.contacts addObject:addContact];
        }
    }
    
    for (int i=0; i<[self.contacts count]; i++) {
        
        BOOL isSelected = [[self.contactSelections objectAtIndex:i] boolValue];
        NSLog(@"Is selected? %d", isSelected);
        
        if (isSelected) {
            [self.selectedContacts addObject:self.contacts[i]];
        }
    }
    
    NSLog(@"Number of selected contacts: %lu", (unsigned long)[self.selectedContacts count]);
    
    /*Contact *contact1 = [[Contact alloc] init];
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
    [self.contacts addObject:contact3];*/
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
    return [self.selectedContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    Contact *contact = [self.selectedContacts objectAtIndex:indexPath.row]; // only show selected contacts
    
    // Configure cell here!
    cell.contactName.text = contact.name;
    //cell.contactTime.text = contact.time;
    cell.contactLocation.text = contact.location;
    
    // Contact's time should be displaced from value at yourTime label
    NSString *currentTime = self.yourTime.text;
    NSString *minutes;
    NSString *hours;
    
    float currentTimeFloat = [currentTime floatValue];
    float contactTimeFloat = [contact.time floatValue];
    float timeDifference = contactTimeFloat + currentTimeFloat;
    if (timeDifference >= 24.0) {
        timeDifference = timeDifference - 24.0;
    }
    NSLog(@"Current time: %f, Contact time: %f", currentTimeFloat, contactTimeFloat);
    NSLog(@"Time difference: %f", timeDifference);
    
    NSRange range = [currentTime rangeOfString:@":" options:NSBackwardsSearch]; // minutes
    if (range.location != NSNotFound) {
        //hours = [currentTime substringToIndex:range.location];
        hours = [NSString stringWithFormat:@"%d", (int)timeDifference];
        // Take the difference from the hours
        
        minutes = [currentTime substringFromIndex:range.location+1];
    }
    
    //NSString *diffAsStr = [NSString stringWithFormat:@"%f", timeDifference];
    NSString *diffAsStr = [NSString stringWithFormat:@"%@:%@", hours, minutes];
    NSLog(@"Test: %@:%@ -- %@", hours, minutes, diffAsStr);
    cell.contactTime.text = diffAsStr;
    
    //NSLog(@"Cell configured: %@ %@ %@", contact.name, contact.time, contact.location);
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
