//
//  AllContactsTableViewController.m
//  Align
//
//  Created by helenwang on 3/8/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import "AllContactsTableViewController.h"
#import "ContactTableViewCell.h"
#import "Contact.h"
#import "AddContactViewController.h"

@interface AllContactsTableViewController ()

@property NSMutableArray *contacts;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

@implementation AllContactsTableViewController

- (IBAction)unwindToContacts:(UIStoryboardSegue *)segue {
    AddContactViewController *source = [segue sourceViewController];
    Contact *newContact = source.contact;
     if (newContact != nil) {
         [self.contacts addObject:newContact];
         //[self.tableView reloadData];
     }
    
    //[self loadInitialData];
    [self.tableView reloadData];
}

- (IBAction)addContact:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contacts = [[NSMutableArray alloc] init];
    self.contactNames = [[NSMutableArray alloc] init];
    self.contactLocations = [[NSMutableArray alloc] init];
    self.contactSelections = [[NSMutableArray alloc] init];
    self.contactTimes = [[NSMutableArray alloc] init];

    [self loadInitialData];
    
    NSLog(@"Size of contactNames: %lu, contacts: %lu, contactSelections: %lu", (unsigned long)[self.contactNames count], (unsigned long)[self.contacts count], (unsigned long)[self.contactSelections count]);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog(@"SECOND VIEW DID LOAD");
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
    NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.contacts count];
    //return [self.contactNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    
    //cell.contactName.text = [self.contactNames objectAtIndex:indexPath.row];
    //cell.contactLocation.text = [self.contactLocations objectAtIndex:indexPath.row];
    
    Contact *contact = [self.contacts objectAtIndex:indexPath.row];
    
    // Configure cell here!
    cell.contactName.text = contact.name;
    cell.contactLocation.text = contact.location;
    
    NSLog(@"Cell configured: %@ %@ %@", contact.name, contact.time, contact.location);
    
    /*if (self.contactNames != nil) {
        cell.contactName.text = [self.contactNames objectAtIndex:indexPath.row];
        cell.contactLocation.text = [self.contactLocations objectAtIndex:indexPath.row];
    }*/
    
    /*if (contact.selected) {
        cell.selected = YES;
    } else {
        cell.selected = NO;
    }*/

    return cell;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected! %ld", (long)indexPath.row);
    
    // Toggle 'selected' boolean
    Contact *tappedContact = [self.contacts objectAtIndex:indexPath.row];
    tappedContact.selected = !tappedContact.selected;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // Update NSUserDefaults -- NOTE: SOME ISSUES HERE WITH UPDATING/ARRAY (both local and defaults)
    // Attempt from 3/11 (Wednesday)
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"contactSelections"] != nil) {
        NSLog(@"Updating selection array at %ld", (long)indexPath.row);
        NSNumber *boolean = [NSNumber numberWithBool:tappedContact.selected];
        //[self.contactSelections addObjectsFromArray:[defaults objectForKey:@"contactSelections"]]; // get selections array
        
        NSLog(@"Size of contactSelections array: %lu", [self.contactSelections count]);
        
        self.contactSelections[indexPath.row] = boolean; // update selections array at specified index (i.e. selected row)
        [defaults setObject:self.contactSelections forKey:@"contactSelections"]; // save updated array to defaults
    } else {
        NSLog(@"Contact selection booleans were not initialized/stored.");
    }*/
    // End of 3/11 attempt
    
    // Toggle bool for whether contact has been selected or not
    /*[tableView deselectRowAtIndexPath:indexPath animated:NO];
    Contact *tappedContact = [self.contacts objectAtIndex:indexPath.row];
    tappedContact.selected = !tappedContact.selected;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];*/
    
    
    // Keep track of selected contacts -- DOES NOT WORK PROPERLY
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"selectedContacts"] != nil) {
        NSLog(@"There's something");
        
        NSInteger exists = 0;
        
        [self.selectedContacts addObjectsFromArray:[defaults objectForKey:@"selectedContacts"]];
        
        // Check if contact is already in array (NOTE: NEED TO UPDATE THIS!)
        for (NSString *name in self.selectedContacts){
            if ([name isEqualToString:[self.contactNames objectAtIndex:indexPath.row]]) { // contact already saved
                exists = 1;
                break;
            }
        }
        
        // If contact is not found
        if (exists == 0) {
            [self.selectedContacts addObject:[self.contactNames objectAtIndex:indexPath.row]]; // add new contact
            [defaults setObject:self.selectedContacts forKey:@"selectedContacts"]; // save updated array to defaults
        }
        
    } else {
        NSLog(@"Initialize name array in NSUserDefaults");
        NSLog(@"Name: %@", [self.contactNames objectAtIndex:indexPath.row]);
        [self.selectedContacts addObject:[self.contactNames objectAtIndex:indexPath.row]]; // add contact to array
        
        [defaults setObject:self.selectedContacts forKey:@"selectedContacts"]; // save array in defaults
    }
    NSLog(@"size: %lu", (unsigned long)[self.selectedContacts count]);
    [defaults synchronize];*/
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
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
        
        // Remove objects from all arrays
        [self.contacts removeObjectAtIndex:indexPath.row];
        
        [self.contactNames removeObjectAtIndex:indexPath.row];
        [defaults setObject:self.contactNames forKey:@"contactNames"];
        
        [self.contactLocations removeObjectAtIndex:indexPath.row];
        [defaults setObject:self.contactLocations forKey:@"contactLocations"];
        
        [self.contactSelections removeObjectAtIndex:indexPath.row];
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for (int i=0; i<[self.contactSelections count]; i++) {
            NSNumber *boolean = [NSNumber numberWithBool:self.contactSelections[i]]; // convert to bool for defaults
            [tmpArray addObject:boolean];
        }
        [defaults setObject:tmpArray forKey:@"contactSelections"]; // store array of booleans in defaults
        
        [self.contactTimes removeObjectAtIndex:indexPath.row];
        [defaults setObject:self.contactTimes forKey:@"contactTimes"];
        
        [defaults synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
