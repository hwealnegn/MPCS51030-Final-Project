//
//  AddContactViewController.m
//  Align
//
//  Created by helenwang on 3/10/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import "AddContactViewController.h"
#import "ViewController.h"

@interface AddContactViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contactNames = [[NSMutableArray alloc] init];
    self.contactLocations = [[NSMutableArray alloc] init];
    self.contactTimeDifferences = [[NSMutableArray alloc] init];
    self.contactSelections = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender != self.saveButton) return;
    if (self.nameField.text.length > 0) { // need to change to whether location exists
        NSLog(@"ADD THIS CONTACT!!!!");
        self.contact = [[Contact alloc] init];
        self.contact.name = self.nameField.text;
        self.contact.location = self.locationField.text;
        self.contact.time = @"3"; // need to implement logic where location is associated with time
        self.contact.selected = NO; // will not display on main view unless selected
        
        // Save information to NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        // Save contact name
        if ([defaults objectForKey:@"contactNames"] != nil) {
            NSLog(@"There's something");
            
            NSInteger exists = 0;
            
            [self.contactNames addObjectsFromArray:[defaults objectForKey:@"contactNames"]];
            
            // Check if contact is already in array (NOTE: NEED TO UPDATE THIS!)
            for (NSString *name in self.contactNames){
                if ([name isEqualToString:self.contact.name]) { // contact already saved
                    exists = 1;
                    break;
                }
            }
            
            // If contact is not found
            if (exists == 0) {
                [self.contactNames addObject:self.contact.name]; // add new contact
                [defaults setObject:self.contactNames forKey:@"contactNames"]; // save updated array to defaults
            }
            
        } else {
            NSLog(@"Initialize name array in NSUserDefaults");
            NSLog(@"Name: %@", self.contact.name);
            [self.contactNames addObject:self.contact.name]; // add contact to array
            
            NSLog(@"size: %lu", (unsigned long)[self.contactNames count]);
            
            [defaults setObject:self.contactNames forKey:@"contactNames"]; // save array in defaults
        }
        
        // Save contact location; note: may be repeated (people may have same locations)
        if ([defaults objectForKey:@"contactLocations"] != nil) {
            [self.contactLocations addObjectsFromArray:[defaults objectForKey:@"contactLocations"]];
            [self.contactLocations addObject:self.contact.location]; // add new contact
            [defaults setObject:self.contactLocations forKey:@"contactLocations"]; // save updated array to defaults
            
        } else {
            NSLog(@"Initialize location array in NSUserDefaults");
            [self.contactLocations addObject:self.contact.location]; // add contact to array
            [defaults setObject:self.contactLocations forKey:@"contactLocations"]; // save array in defaults
        }
        
        // Save time difference (NEED TO UPDATE TO DO TIME CALCULATIONS)
        if ([defaults objectForKey:@"contactTimes"] != nil) {
            [self.contactTimeDifferences addObjectsFromArray:[defaults objectForKey:@"contactTimes"]];
            [self.contactTimeDifferences addObject:self.contact.time]; // add new contact
            [defaults setObject:self.contactTimeDifferences forKey:@"contactTimes"]; // save updated array to defaults
            
        } else {
            NSLog(@"Initialize time array in NSUserDefaults");
            [self.contactTimeDifferences addObject:self.contact.time]; // add time to array
            [defaults setObject:self.contactTimeDifferences forKey:@"contactTimes"]; // save array in defaults
        }
        
        // Also have record of if contacts are selected or not
        // Reference for storing booleans: http://stackoverflow.com/questions/3437942/how-to-deal-with-booleans-in-nsmutablearrays
        NSNumber *boolean = [NSNumber numberWithBool:self.contact.selected];
        if ([defaults objectForKey:@"contactSelections"] != nil) {
            [self.contactSelections addObjectsFromArray:[defaults objectForKey:@"contactSelections"]];
            [self.contactSelections addObject:boolean]; // add new contact
            [defaults setObject:self.contactSelections forKey:@"contactSelections"]; // save updated array to defaults
            
        } else {
            NSLog(@"Initialize location array in NSUserDefaults");
            [self.contactSelections addObject:boolean]; // add contact to array
            [defaults setObject:self.contactSelections forKey:@"contactSelections"]; // save array in defaults
        }
        
        [defaults synchronize];
        
        NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    }
}

@end
