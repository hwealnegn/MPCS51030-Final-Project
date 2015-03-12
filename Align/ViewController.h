//
//  ViewController.h
//  Align
//
//  Created by helenwang on 3/2/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *selectContacts;
@property (weak, nonatomic) IBOutlet UILabel *yourTime;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@property (strong, nonatomic) NSMutableArray *contactNames;
@property (strong, nonatomic) NSMutableArray *contactLocations;
@property (strong, nonatomic) NSMutableArray *contactSelections;
@property (strong, nonatomic) NSMutableArray *contactTimes;

@end

