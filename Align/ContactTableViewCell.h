//
//  ContactTableViewCell.h
//  Align
//
//  Created by helenwang on 3/2/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

// Custom table view cell for table views
@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactTime;
@property (weak, nonatomic) IBOutlet UILabel *contactLocation;

@end
