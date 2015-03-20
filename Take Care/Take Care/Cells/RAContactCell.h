//
//  RAContactCell.h
//  ReadysasterPH
//
//  Created by Rodel Arenas on 5/9/14.
//  Copyright (c) 2014 i-Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RAContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgContact;
@property (weak, nonatomic) IBOutlet UILabel *lblFullname;
@property (weak, nonatomic) IBOutlet UILabel *lblPrimaryNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblPrimaryEmail;

@end
