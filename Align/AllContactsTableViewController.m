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

// Segue from AddContactViewController
// Receives information about new/edited contact
- (IBAction)unwindToContacts:(UIStoryboardSegue *)segue {
    AddContactViewController *source = [segue sourceViewController];
    Contact *newContact = source.contact;
     if (newContact != nil) {
         if ([self.contactNames containsObject:newContact.name]) {
             NSLog(@"Update contact location");
             
             // Overwrite location
             NSInteger index = [self.contactNames indexOfObject:newContact.name];
             Contact *existingContact = self.contacts[index];
             self.contactLocations[index] = newContact.location;
             existingContact.location = newContact.location;
             
             // Also need to update time
             self.contactTimes[index] = newContact.time;
             existingContact.time = newContact.time;
             
             // Update defaults
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:self.contactLocations forKey:@"contactLocations"];
             [defaults setObject:self.contactTimes forKey:@"contactTimes"];
             [defaults synchronize];
             
             [self.tableView reloadData];
         } else {
             NSLog(@"Welcome newcomer!");
             
             // Add new contact's information to arrays
             [self.contacts addObject:newContact];
             [self.contactNames addObject:newContact.name];
             [self.contactLocations addObject:newContact.location];
             [self.contactTimes addObject:newContact.time];
             NSNumber *boolean = [NSNumber numberWithBool:newContact.selected];
             [self.contactSelections addObject:boolean];
             [self.tableView reloadData];
         }
     }
}

// Segue from AddContactViewController
// Simply returns to AllContactsTableViewController without passing data
- (IBAction)unwindNoAdd:(UIStoryboardSegue *)segue {
    // Don't do anything
    NSLog(@"Do not add/edit contact");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contacts = [[NSMutableArray alloc] init];
    self.contactNames = [[NSMutableArray alloc] init];
    self.contactLocations = [[NSMutableArray alloc] init];
    self.contactSelections = [[NSMutableArray alloc] init];
    self.contactTimes = [[NSMutableArray alloc] init];

    [self loadInitialData];
    
    // Set up background and navigation bar appearance
    // Reference for making navigation bar transparent: http://stackoverflow.com/questions/2315862/make-uinavigationbar-transparent
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    
    UIView *tmpView = [[UIView alloc] init];
    
    // Initialize day/night sky backgrounds
    self.dayView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.dayView setImage:[UIImage imageNamed:@"daySky"]];
    [tmpView addSubview:self.dayView];
    [tmpView sendSubviewToBack:self.dayView];
    
    self.sunView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.sunView setImage:[UIImage imageNamed:@"sunSky"]];
    [tmpView addSubview:self.sunView];
    [tmpView sendSubviewToBack:self.sunView];
    
    self.nightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.nightView setImage:[UIImage imageNamed:@"nightSky"]];
    [tmpView addSubview:self.nightView];
    [tmpView sendSubviewToBack:self.nightView];
    
    [self.tableView setBackgroundView:tmpView];
    
    self.dayView.alpha = self.dayAlpha;
    self.sunView.alpha = self.sunAlpha;
    self.nightView.alpha = self.nightAlpha;
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
    //NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    Contact *contact = [self.contacts objectAtIndex:indexPath.row];
    
    // Configure cell
    cell.contactName.text = contact.name;
    cell.contactLocation.text = contact.location;
    
    cell.contactName.textColor = [UIColor whiteColor];
    cell.contactLocation.textColor = [UIColor whiteColor];
    
    if (contact.selected) {
        cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
    }

    return cell;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected! %ld", (long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // Toggle 'selected' boolean
    Contact *tappedContact = [self.contacts objectAtIndex:indexPath.row];
    tappedContact.selected = !tappedContact.selected;
    
    for (int i=0; i<[self.contacts count]; i++) {
        Contact *tmp = self.contacts[i];
        BOOL tmpBool = tmp.selected;
        
        NSNumber *boolean = [NSNumber numberWithBool:tmpBool];
        self.contactSelections[i] = boolean;
    }
    
    // Update defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.contactSelections forKey:@"contactSelections"];
    [defaults synchronize];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        // Remove objects from all arrays and update defaults
        [self.contacts removeObjectAtIndex:indexPath.row];
        
        [self.contactNames removeObjectAtIndex:indexPath.row];
        [defaults setObject:self.contactNames forKey:@"contactNames"];
        
        [self.contactLocations removeObjectAtIndex:indexPath.row];
        [defaults setObject:self.contactLocations forKey:@"contactLocations"];
        
        [self.contactSelections removeObjectAtIndex:indexPath.row];
        [defaults setObject:self.contactSelections forKey:@"contactSelections"]; // store array of booleans in defaults
        
        [self.contactTimes removeObjectAtIndex:indexPath.row];
        [defaults setObject:self.contactTimes forKey:@"contactTimes"];
        
        [defaults synchronize];
        NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toAddContactsSegue"]){
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        AddContactViewController *controller = (AddContactViewController *)navController.topViewController;
        controller.dayAlpha = self.dayView.alpha;
        controller.sunAlpha = self.sunView.alpha;
        controller.nightAlpha = self.nightView.alpha;
    }
}


@end
