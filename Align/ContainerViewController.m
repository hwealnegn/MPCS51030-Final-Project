//
//  ContainerViewController.m
//  Align
//
//  Created by helenwang on 3/8/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import "ContainerViewController.h"
#import "ViewController.h"
#import "AllContactsTableViewController.h"

#define SegueIdentifierFirst @"embedFirst"
#define SegueIdentifierSecond @"embedSecond"

// Reference: https://github.com/mluton/EmbeddedSwapping/blob/master/EmbeddedSwapping/ContainerViewController.m

@interface ContainerViewController ()

@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (strong, nonatomic) ViewController *firstViewController;
@property (strong, nonatomic) AllContactsTableViewController *secondViewController;
@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transitionInProgress = NO;
    self.currentSegueIdentifier = SegueIdentifierFirst;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([segue.identifier isEqualToString:SegueIdentifierFirst]) {
        self.firstViewController = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:SegueIdentifierSecond]) {
     self.secondViewController = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:SegueIdentifierFirst]) {
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.firstViewController];
        } else {
            [self addChildViewController:segue.destinationViewController];
            UIView *destView = ((UIViewController *)segue.destinationViewController).view;
            //destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    } else if ([segue.identifier isEqualToString:SegueIdentifierSecond]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.secondViewController];
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
    }];
}

- (void)swapViewControllers {
    if (self.transitionInProgress) {
        return;
    }
    
    self.transitionInProgress = YES;
    self.currentSegueIdentifier = ([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst]) ? SegueIdentifierSecond : SegueIdentifierFirst;
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst]) && self.firstViewController) {
        [self swapFromViewController:self.secondViewController toViewController:self.firstViewController];
        return;
    }
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierSecond]) && self.secondViewController) {
        [self swapFromViewController:self.firstViewController toViewController:self.secondViewController];
        return;
    }
    
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
    
}

@end
