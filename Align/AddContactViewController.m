//
//  AddContactViewController.m
//  Align
//
//  Created by helenwang on 3/10/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import "AddContactViewController.h"

@interface AddContactViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        self.contact = [[Contact alloc] init];
        self.contact.name = self.nameField.text;
        self.contact.location = self.locationField.text;
        self.contact.time = @"3:00"; // need to implement logic where location is associated with time
    }
}

@end
