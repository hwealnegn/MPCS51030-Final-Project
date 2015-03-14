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
#import "QuartzCore/CALayer.h"

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
    [self.scrollView addSubview:self.scrollImage];
    
    // Initialize scroll view at current time
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:currentTime];
    NSInteger hourNow = [components hour];
    NSInteger minuteNow = [components minute];
    
    NSLog(@"hour: %ld, minute: %ld", (long)hourNow, (long)minuteNow);
    
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    float currentTimeFloat = [resultString floatValue]; // current hour

    
    NSInteger pageWidth = self.view.frame.size.width;
    CGFloat maxPosition = 1200.0 - pageWidth;
    //CGFloat position = self.scrollView.contentOffset.x;
    //CGFloat increment = position/maxPosition;
    //NSInteger hour = increment*24;
    
    //CGFloat initialPosition = currentTimeFloat * maxPosition / 24.0;
    CGFloat initialPosition = ((hourNow * 60.0) + minuteNow) * maxPosition / 1440.0;
    NSLog(@"initial position: %f, time: %f", initialPosition, currentTimeFloat);
    
    [self.bottomScroll setContentOffset:CGPointMake(initialPosition, 0)];
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
    
    // Initialize scroll view
    [self.bottomScroll setContentSize:CGSizeMake(1200, 90)];
    
    // Add shadow to scroll view image
    // Reference: http://stackoverflow.com/questions/2044479/what-is-the-best-way-to-create-a-shadow-behind-a-uiimageview
    self.scrollImage.layer.shadowColor = [UIColor purpleColor].CGColor;
    self.scrollImage.layer.shadowOffset = CGSizeMake(1, 1);
    self.scrollImage.layer.shadowOpacity = 0.8f;
    self.scrollImage.layer.shadowRadius = 4.0f;
    self.scrollImage.clipsToBounds = NO;
    
    // Set background image
    // Reference for making navigation bar transparent: http://stackoverflow.com/questions/2315862/make-uinavigationbar-transparent
    self.selectContacts.backgroundColor = [UIColor clearColor];
    self.scrollImage.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    // Initialize day/night sky backgrounds
    self.dayView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.dayView setImage:[UIImage imageNamed:@"daySky"]];
    [self.view addSubview:self.dayView];
    [self.view sendSubviewToBack:self.dayView];
    
    self.sunView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.sunView setImage:[UIImage imageNamed:@"sunSky"]];
    [self.view addSubview:self.sunView];
    [self.view sendSubviewToBack:self.sunView];
    
    self.nightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.nightView setImage:[UIImage imageNamed:@"nightSky"]];
    [self.view addSubview:self.nightView];
    [self.view sendSubviewToBack:self.nightView];
    
    // Set your time as current time
    // Reference: http://stackoverflow.com/questions/8385132/get-current-time-on-the-iphone-in-a-chosen-format
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
     NSString *resultString = [dateFormatter stringFromDate: currentTime];
    NSLog(@"RESULT STRING: %@", resultString);
    self.yourTime.text = resultString;
    self.yourTime.textColor = [UIColor whiteColor];
    
    // Calculate time differences
    // Reference: http://stackoverflow.com/questions/5646539/iphonefind-the-current-timezone-offset-in-hours
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    float timeZoneOffset = [destinationTimeZone secondsFromGMT] / 3600.0;
    NSLog(@"Time zone offset: %f", timeZoneOffset);
    
    NSLog(@"FIRST VIEW DID LOAD");
    
    NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
    for (int i=0; i<[timeZoneNames count]; i++){
        //NSLog(@"%@", timeZoneNames[i]);
        
        // Get city name
        NSString *zone = timeZoneNames[i];
        NSString *city;
        NSRange range = [zone rangeOfString:@"/" options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            city = [zone substringFromIndex:range.location+1];
        } else {
            city = zone;
        }
        
        //NSLog(@"%@", city);
        
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
    cell.contactLocation.text = contact.location;
    
    // Contact's time should be displaced from value at yourTime label
    NSDate *currentTimeDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *resultString = [dateFormatter stringFromDate: currentTimeDate];
    NSString *currentTime = resultString;
    //NSString *currentTime = self.yourTime.text;
    NSLog(@"Current time?? %@", currentTime);
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
        hours = [NSString stringWithFormat:@"%d", (int)timeDifference];
        minutes = [currentTime substringFromIndex:range.location+1];
    }
    
    NSString *diffAsStr = [NSString stringWithFormat:@"%@:%@", hours, minutes];
    NSLog(@"Test: %@:%@ -- %@", hours, minutes, diffAsStr);
    cell.contactTime.text = diffAsStr;
    
    //NSLog(@"Cell configured: %@ %@ %@", contact.name, contact.time, contact.location);
    NSLog(@"time float: %f", currentTimeFloat);
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contactName.textColor = [UIColor whiteColor];
    cell.contactLocation.textColor = [UIColor whiteColor];
    cell.contactTime.textColor = [UIColor whiteColor];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Scroll View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger pageWidth = scrollView.frame.size.width;
    CGFloat maxPosition = 1200.0 - pageWidth;
    CGFloat quarterPosition = maxPosition / 4.0;
    CGFloat midPosition = maxPosition / 2.0;
    CGFloat threeQuarterPosition = 0.75 * maxPosition;
    CGFloat position = scrollView.contentOffset.x;
    CGFloat increment = position/maxPosition;
    NSInteger hour = increment*24;
    NSInteger minute = increment*1440-(hour*60);
    
    // Reference to keep leading zero: http://stackoverflow.com/questions/10790925/xcode-iphone-sdk-keep-nsinteger-zero-at-beginning
    self.yourTime.text = [NSString stringWithFormat:@"%ld:%02ld", (long)hour, (long)minute]; // something wrong with this
    
    //NSLog(@"Position: %f, increment: %f, hour: %ld, minute: %ld", position, increment, (long)hour, (long)minute);
    
    // Set alpha values of sky relative to position of scroll view
    /*if (position < maxPosition/2.0) {
        self.dayView.alpha = position/midPosition;
        self.nightView.alpha = 1 - position/midPosition;
    } else {
        self.dayView.alpha = (maxPosition - position)/midPosition;
        self.nightView.alpha = 1 - (maxPosition - position)/midPosition;
    }*/
    
    if (position < maxPosition/4.0) { // 0 to quarterPosition
        self.dayView.alpha = 0;
        self.sunView.alpha = position/quarterPosition;
        self.nightView.alpha = 1 - position/quarterPosition;
    } else if (position >= maxPosition/4.0 && position < maxPosition/2.0) { // quarterPosition to midPosition
        self.dayView.alpha = (position-quarterPosition)/(midPosition-quarterPosition);
        self.sunView.alpha = 1 - (position-quarterPosition)/(midPosition-quarterPosition);
        self.nightView.alpha = 0;
    } else if (position >= maxPosition/2.0 && position < (3.0 * maxPosition)/4.0){ // midPosition to threeQuarterPosition
        self.dayView.alpha = 1 - (position-midPosition)/(threeQuarterPosition-midPosition);
        self.sunView.alpha = (position - midPosition)/(threeQuarterPosition-midPosition);
        self.nightView.alpha = 0;
    } else { // threeQuarterPosition to maxPosition
        self.dayView.alpha = 0;
        self.sunView.alpha = 1 - (position - threeQuarterPosition)/(maxPosition-threeQuarterPosition);
        self.nightView.alpha = (position - threeQuarterPosition)/(maxPosition-threeQuarterPosition);
    }
    
    NSLog(@"Day: %f, Sun: %f, Night: %f", self.dayView.alpha, self.sunView.alpha, self.nightView.alpha);
    
    // Save alpha values for other view controllers
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toAllContactsSegue"]){
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        AllContactsTableViewController *controller = (AllContactsTableViewController *)navController.topViewController;
        controller.dayAlpha = self.dayView.alpha;
        controller.sunAlpha = self.sunView.alpha;
        controller.nightAlpha = self.nightView.alpha;
    }
}

@end
