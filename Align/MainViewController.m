//
//  MainViewController.m
//  Align
//
//  Created by helenwang on 3/8/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import "MainViewController.h"
#import "ContainerViewController.h"

@interface MainViewController ()

@property (nonatomic, weak) ContainerViewController *containerViewController;
- (IBAction)swapButtonPressed:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.containerViewController = segue.destinationViewController;
    }
}

- (IBAction)swapButtonPressed:(id)sender {
    [self.containerViewController swapViewControllers];
}

@end
