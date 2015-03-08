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

@interface AllContactsTableViewController ()

@property NSMutableArray *contacts;

@end

@implementation AllContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contacts = [[NSMutableArray alloc] init];
    [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog(@"SECOND VIEW DID LOAD");
}

- (void)loadInitialData {
    Contact *contact1 = [[Contact alloc] init];
    contact1.name = @"Mom";
    contact1.time = @"12:00";
    contact1.location = @"Taiwan";
    [self.contacts addObject:contact1];
    
    Contact *contact2 = [[Contact alloc] init];
    contact2.name = @"Dad";
    contact2.time = @"12:00";
    contact2.location = @"China";
    [self.contacts addObject:contact2];
    
    Contact *contact3 = [[Contact alloc] init];
    contact3.name = @"Kevin";
    contact3.time = @"11:00";
    contact3.location = @"New York";
    [self.contacts addObject:contact3];
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
    
    // Configure cell here!
    cell.contactName.text = contact.name;
    cell.contactTime.text = contact.time;
    cell.contactLocation.text = contact.location;
    
    NSLog(@"Cell configured: %@ %@ %@", contact.name, contact.time, contact.location);

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
