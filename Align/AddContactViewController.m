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
            [self.contactLocations addObjectsFromArray:[defaults objectForKey:@"contactLocations"]];
            [self.contactTimeDifferences addObjectsFromArray:[defaults objectForKey:@"contactTimes"]];
            [self.contactSelections addObjectsFromArray:[defaults objectForKey:@"contactSelections"]];
            
            // Check if contact is already in array (NOTE: NEED TO UPDATE THIS!)
            for (NSString *name in self.contactNames){
                if ([name isEqualToString:self.contact.name]) { // contact already saved
                    NSLog(@"Contact already exists");
                    exists = 1;
                    break;
                }
            }
            
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
            }
            
        } else {
            NSLog(@"Initialize name array in NSUserDefaults");
            //NSLog(@"Name: %@", self.contact.name);
            [self.contactNames addObject:self.contact.name]; // add contact to array
            [self.contactLocations addObject:self.contact.location];
            [self.contactTimeDifferences addObject:self.contact.time];
            NSNumber *boolean = [NSNumber numberWithBool:self.contact.selected];
            [self.contactSelections addObject:boolean];
            
            //NSLog(@"size: %lu", (unsigned long)[self.contactNames count]);
            
            [defaults setObject:self.contactNames forKey:@"contactNames"]; // save array in defaults
            [defaults setObject:self.contactLocations forKey:@"contactLocations"];
            [defaults setObject:self.contactTimeDifferences forKey:@"contactTimes"];
            [defaults setObject:self.contactSelections forKey:@"contactSelections"];
        }

        [defaults synchronize];
        
        NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    }
}

@end
