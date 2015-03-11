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
        self.contact.time = @"3:00"; // need to implement logic where location is associated with time
        
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
        
        [defaults synchronize];
        
        NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    }
}

@end
