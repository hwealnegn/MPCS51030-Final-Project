//
//  AddContactViewController.m
//  Align
//
//  Created by helenwang on 3/10/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import "AddContactViewController.h"
#import "ViewController.h"

@interface AddContactViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.contactNames = [[NSMutableArray alloc] init];
    self.contactLocations = [[NSMutableArray alloc] init];
    self.contactTimeDifferences = [[NSMutableArray alloc] init];
    self.contactSelections = [[NSMutableArray alloc] init];
    
    // Reference for making navigation bar transparent: http://stackoverflow.com/questions/2315862/make-uinavigationbar-transparent
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
    
    // Set alpha values of background images
    self.dayView.alpha = self.dayAlpha;
    self.sunView.alpha = self.sunAlpha;
    self.nightView.alpha = self.nightAlpha;
    
    // Populate cities array (get city names from NSTimeZone)
    NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
    self.cityNames = [[NSMutableArray alloc] init];
    for (int i=0; i<[timeZoneNames count]; i++){
        // Get city name
        NSString *zone = timeZoneNames[i];
        NSString *city;
        NSRange range = [zone rangeOfString:@"/" options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            city = [zone substringFromIndex:range.location+1];
        } else {
            city = zone;
        }
        [self.cityNames addObject:city];
    }
    
    // Save original value of view center
    self.originalCenter = self.view.center;
    self.viewShifted = false;
    
    // Send notification when keyboard is displayed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
}

// Method called when keyboard is shown; used to resolve issue of keyboard obscuring text fields
// Entire view is shifted a set increment if the text fields are obscured
- (void)keyboardWasShown:(NSNotification *)notification {
    NSLog(@"Keyboard shown!");
    
    NSDictionary *info = [notification userInfo];
    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;

    // If keyboard covers location (bottom) text field, shift the text fields up
    if ((self.view.frame.size.height - self.locationField.frame.origin.y) <= (self.view.frame.size.height - kbHeight)) {
        NSLog(@"Text field obscured");
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y - 50); // shift up by keyboard height
        self.viewShifted = true;
    } else {
        NSLog(@"Text field not obscured");
    }
    NSLog(@"Keyboard height: %f, text field origin: %f", self.view.frame.size.height - kbHeight, self.view.frame.size.height - self.locationField.frame.origin.y);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameField | textField == self.locationField) {
        [textField resignFirstResponder];
    }
    
    // If view was shifted to accommodate keyboard, restore original view
    if (self.viewShifted) {
        self.view.center = self.originalCenter;
        self.viewShifted = false;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Create and save new contact
- (void)addNewContact {
    if (self.nameField.text.length > 0) {
        self.contact = [[Contact alloc] init];
        self.contact.name = self.nameField.text;
        self.contact.location = self.locationField.text;
        self.contact.time = @"-1"; // this is overwritten depending on location
        self.contact.selected = NO; // will not display on main view unless selected
        
        // Calculate time difference
        // Reference: http://stackoverflow.com/questions/5646539/iphonefind-the-current-timezone-offset-in-hours
        NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
        float timeZoneOffset = [destinationTimeZone secondsFromGMT] / 3600.0;
        NSLog(@"Time zone offset: %f", timeZoneOffset);
        
        NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
        for (int i=0; i<[timeZoneNames count]; i++){
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
            
            NSString *contactCity = [self.locationField.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            if ([contactCity isEqualToString:city]) {
                NSTimeZone *contactTimeZone = [NSTimeZone timeZoneWithName:zone];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setTimeZone:contactTimeZone];
                
                float contactTZOffset = [contactTimeZone secondsFromGMT] / 3600.0;
                NSLog(@"Time where contact is: %f", contactTZOffset-timeZoneOffset);
                
                float timeDifference = contactTZOffset-timeZoneOffset;
                NSString *diffAsStr = [NSString stringWithFormat:@"%f", timeDifference];
                
                self.contact.time = diffAsStr;
            }
        }
        
        // Save information to NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        // Save contact name
        if ([defaults objectForKey:@"contactNames"] != nil) {
            NSInteger exists = 0;
            
            [self.contactNames addObjectsFromArray:[defaults objectForKey:@"contactNames"]];
            [self.contactLocations addObjectsFromArray:[defaults objectForKey:@"contactLocations"]];
            [self.contactTimeDifferences addObjectsFromArray:[defaults objectForKey:@"contactTimes"]];
            [self.contactSelections addObjectsFromArray:[defaults objectForKey:@"contactSelections"]];
            
            // Check if contact is already in array
            for (NSString *name in self.contactNames){
                if ([name isEqualToString:self.contact.name]) { // contact already saved
                    NSLog(@"Contact already exists");
                    exists = 1;
                    break;
                }
            }
            NSLog(@"Exists? %ld", (long)exists);
            // If contact is not found, create new one
            if (exists == 0) {
                NSLog(@"Creating new contact");
                
                // Add new contact info to respective arrays
                // Reference for storing booleans: http://stackoverflow.com/questions/3437942/how-to-deal-with-booleans-in-nsmutablearrays
                [self.contactNames addObject:self.contact.name];
                [self.contactLocations addObject:self.contact.location];
                [self.contactTimeDifferences addObject:self.contact.time];
                NSNumber *boolean = [NSNumber numberWithBool:self.contact.selected];
                [self.contactSelections addObject:boolean];
                
                // Update defaults
                [defaults setObject:self.contactNames forKey:@"contactNames"]; // save updated array to defaults
                [defaults setObject:self.contactLocations forKey:@"contactLocations"];
                [defaults setObject:self.contactTimeDifferences forKey:@"contactTimes"];
                [defaults setObject:self.contactSelections forKey:@"contactSelections"];
                
                [self performSegueWithIdentifier:@"unwindToContacts" sender:self];
            } else {
                NSLog(@"DO NOT CREATE NEW CONTACT");
                UIAlertView *alertConflict = [[UIAlertView alloc] initWithTitle:@"Contact Already Exists" message:@"This contact is already in your list! Would you like to update their location?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                alertConflict.tag = 11;
                [alertConflict show];
            }
            
        } else {
            NSLog(@"Initialize contacts arrays in NSUserDefaults");
            
            // Add contact info to arrays
            [self.contactNames addObject:self.contact.name];
            [self.contactLocations addObject:self.contact.location];
            [self.contactTimeDifferences addObject:self.contact.time];
            NSNumber *boolean = [NSNumber numberWithBool:self.contact.selected];
            [self.contactSelections addObject:boolean];
            
            // Save arrays to defaults
            [defaults setObject:self.contactNames forKey:@"contactNames"];
            [defaults setObject:self.contactLocations forKey:@"contactLocations"];
            [defaults setObject:self.contactTimeDifferences forKey:@"contactTimes"];
            [defaults setObject:self.contactSelections forKey:@"contactSelections"];
            
            // Go back to AllContactsTableViewController
            [self performSegueWithIdentifier:@"unwindToContacts" sender:self];
        }
        
        [defaults synchronize];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Clicked a button on the contacts conflict alert view
    // Resource for performing alert view before segue: http://stackoverflow.com/questions/24128437/perform-uialertview-before-performing-segue
    // Resource for distinguishing alert views: http://stackoverflow.com/questions/2338546/several-uialertviews-for-a-delegate
    if (alertView.tag == 11) {
        NSLog(@"There is a conflict");
        if (buttonIndex == [alertView cancelButtonIndex]) {
            // Don't do anything
            NSLog(@"Do not overwrite contact");
        } else {
            // Pass along the contact (modify existing contact's location in segue method)
            // Resource for performing unwind segue programmatically: http://spin.atomicobject.com/2014/12/01/program-ios-unwind-segue/
            [self performSegueWithIdentifier:@"unwindToContacts" sender:self];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"unwindToContacts"]) {
        if (sender != self.saveButton) return;
        
        // First determine if location is valid
        NSString *contactCity = [self.locationField.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        
        if ([self.cityNames containsObject:contactCity]) {
            NSLog(@"Location is valid!");
            [self addNewContact];
        } else {
            NSLog(@"Place: %@", contactCity);
            NSLog(@"LOCATION DOES NOT EXIST!");
        }
    }
}

// Check if location is valid and if contact already exists
- (IBAction)addContactCheckpoint:(id)sender {
    NSString *contactCity = [self.locationField.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    if ([self.cityNames containsObject:contactCity]) {
        NSLog(@"Location is valid!");
        [self addNewContact]; // handles case if contact already exists
    } else {
        NSLog(@"Place: %@", contactCity);
        NSLog(@"LOCATION DOES NOT EXIST!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Location" message:@"We're sorry - we do not recognize this location. Please try a different one." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
