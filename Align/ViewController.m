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
    [self.selectContacts reloadData];
}

/* Display UIAlertView detailing how to use app */
- (IBAction)showInstructions:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome to Align!" message:@"Align lets you see WHEN people in your life are relative to you.\n\nBegin by clicking the couple holding hands. Here you can view saved individuals and add new ones.\n\nSelect people to align times with by tapping them on your list. Highlighted names will show up on the main page.\n\nScroll the green field to align your time with those of your contacts." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self loadInitialData];
    //[self.selectContacts reloadData];
    NSLog(@"VIEW APPEARED!!!!!!!");
    //NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    // Empty arrays
    [self.contacts removeAllObjects];
    [self.contactSelections removeAllObjects];
    [self.contactNames removeAllObjects];
    [self.contactLocations removeAllObjects];
    [self.contactTimes removeAllObjects];
    [self.selectedContacts removeAllObjects];
    
    // Use defaults to repopulate contactSelections
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self.contactSelections addObjectsFromArray:[defaults objectForKey:@"contactSelections"]];
    [self.contactNames addObjectsFromArray:[defaults objectForKey:@"contactNames"]];
    [self.contactLocations addObjectsFromArray:[defaults objectForKey:@"contactLocations"]];
    [self.contactTimes addObjectsFromArray:[defaults objectForKey:@"contactTimes"]];
    
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
        if (isSelected) {
            [self.selectedContacts addObject:self.contacts[i]];
        }
    }
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
    
    [self.scrollView addSubview:self.scrollImage];
    
    // Initialize scroll view at current time
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:currentTime];
    NSInteger hourNow = [components hour];
    NSInteger minuteNow = [components minute];
    
    self.dynamicHour = hourNow;
    self.dynamicMinute = minuteNow;
    
    NSLog(@"HELLOLOLO %ld, %ld", (long)self.dynamicHour, (long)self.dynamicMinute);
    
    //NSLog(@"hour: %ld, minute: %ld", (long)hourNow, (long)minuteNow);
    
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    
    NSInteger pageWidth = self.view.frame.size.width;
    CGFloat maxPosition = 1200.0 - pageWidth;
    CGFloat quarterPosition = maxPosition / 4.0;
    CGFloat midPosition = maxPosition / 2.0;
    CGFloat threeQuarterPosition = 0.75 * maxPosition;

    CGFloat initialPosition = ((hourNow * 60.0) + minuteNow) * maxPosition / 1440.0;
    NSLog(@"initial position: %f, maxPos: %f, increment: %f", initialPosition, maxPosition, initialPosition/maxPosition);
    
    // Set initial scroll view position
    [self.bottomScroll setContentOffset:CGPointMake(initialPosition, 0)];
    
    // Add shadow to scroll view image
    // Reference: http://stackoverflow.com/questions/2044479/what-is-the-best-way-to-create-a-shadow-behind-a-uiimageview
    self.scrollImage.layer.shadowColor = [UIColor purpleColor].CGColor;
    self.scrollImage.layer.shadowOffset = CGSizeMake(1, 1);
    self.scrollImage.layer.shadowOpacity = 0.8f;
    self.scrollImage.layer.shadowRadius = 1.0f;
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
    
    // Set initial background
    if (initialPosition < maxPosition/4.0) { // 0 to quarterPosition
        self.dayView.alpha = 0;
        self.sunView.alpha = initialPosition/quarterPosition;
        self.nightView.alpha = 1 - initialPosition/quarterPosition;
    } else if (initialPosition >= maxPosition/4.0 && initialPosition < maxPosition/2.0) { // quarterPosition to midPosition
        self.dayView.alpha = (initialPosition-quarterPosition)/(midPosition-quarterPosition);
        self.sunView.alpha = 1 - (initialPosition-quarterPosition)/(midPosition-quarterPosition);
        self.nightView.alpha = 0;
    } else if (initialPosition >= maxPosition/2.0 && initialPosition < (3.0 * maxPosition)/4.0){ // midPosition to threeQuarterPosition
        self.dayView.alpha = 1 - (initialPosition-midPosition)/(threeQuarterPosition-midPosition);
        self.sunView.alpha = (initialPosition - midPosition)/(threeQuarterPosition-midPosition);
        self.nightView.alpha = 0;
    } else { // threeQuarterPosition to maxPosition
        self.dayView.alpha = 0;
        self.sunView.alpha = 1 - (initialPosition - threeQuarterPosition)/(maxPosition-threeQuarterPosition);
        self.nightView.alpha = (initialPosition - threeQuarterPosition)/(maxPosition-threeQuarterPosition);
    }
    
    // Set your time as current time
    // Reference: http://stackoverflow.com/questions/8385132/get-current-time-on-the-iphone-in-a-chosen-format
    [dateFormatter setDateFormat:@"HH:mm"];
    NSLog(@"RESULT STRING: %@", resultString);
    self.yourTime.text = resultString;
    self.yourTime.textColor = [UIColor whiteColor];
    
    // Calculate time differences
    // Reference: http://stackoverflow.com/questions/5646539/iphonefind-the-current-timezone-offset-in-hours
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    float timeZoneOffset = [destinationTimeZone secondsFromGMT] / 3600.0;
    NSLog(@"Time zone offset: %f", timeZoneOffset);
    
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
        if (isSelected) {
            [self.selectedContacts addObject:self.contacts[i]];
        }
    }
    
    //NSLog(@"Number of selected contacts: %lu", (unsigned long)[self.selectedContacts count]);
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

    NSString *minutes;
    NSString *hours;
    
    //float currentTimeFloat = [currentTime floatValue];
    float currentTimeFloat = self.dynamicHour;
    float contactTimeFloat = [contact.time floatValue];
    float timeDifference = contactTimeFloat + currentTimeFloat;
    if (timeDifference >= 24.0) {
        timeDifference = timeDifference - 24.0;
    }
    //NSLog(@"Current time: %f, Contact time: %f", currentTimeFloat, contactTimeFloat);
    //NSLog(@"Time difference: %f", timeDifference);
    
    hours = [NSString stringWithFormat:@"%d", (int)timeDifference];
    minutes = [NSString stringWithFormat:@"%02ld", (long)self.dynamicMinute];
    
    NSString *diffAsStr = [NSString stringWithFormat:@"%@:%@", hours, minutes];
    cell.contactTime.text = diffAsStr;
    
    //NSLog(@"Cell configured: %@ %@ %@", contact.name, contact.time, contact.location);
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contactName.textColor = [UIColor whiteColor];
    cell.contactLocation.textColor = [UIColor whiteColor];
    cell.contactTime.textColor = [UIColor whiteColor];
    NSLog(@"Is cell's minute updating? %@", minutes);
    NSLog(@"Test dynamic time: %ld, %ld", (long)self.dynamicHour, (long)self.dynamicMinute);
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Scroll View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSInteger pageWidth = scrollView.frame.size.width;
    NSInteger pageWidth = self.view.frame.size.width;
    CGFloat maxPosition = 1200.0 - pageWidth;
    CGFloat quarterPosition = maxPosition / 4.0;
    CGFloat midPosition = maxPosition / 2.0;
    CGFloat threeQuarterPosition = 0.75 * maxPosition;
    CGFloat position = scrollView.contentOffset.x;
    CGFloat increment = position/maxPosition;
    NSInteger hour = increment*24;
    NSInteger minute = increment*1440-(hour*60);
    
    // Reference to keep leading zero: http://stackoverflow.com/questions/10790925/xcode-iphone-sdk-keep-nsinteger-zero-at-beginning
    self.yourTime.text = [NSString stringWithFormat:@"%ld:%02ld", (long)hour, (long)minute];
    
    //NSLog(@"Position: %f, increment: %f, pagewidth: %ld, maxpos; %f, hour: %ld, minute: %ld", position, increment, (long)pageWidth, maxPosition, (long)hour, (long)minute);
    
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
    
    //NSLog(@"Day: %f, Sun: %f, Night: %f", self.dayView.alpha, self.sunView.alpha, self.nightView.alpha);
    
    self.dynamicHour = hour;
    self.dynamicMinute = minute;
    //NSLog(@"Your time text based on scroll view: %@", self.yourTime.text);
    //NSLog(@"**HOUR: %ld, MINUTE: %ld", self.dynamicHour, self.dynamicMinute);
    
    [self.selectContacts reloadData];
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
