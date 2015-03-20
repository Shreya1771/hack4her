//
//  SpaceViewController.h
//  Take Care
//
//  Created by louie on 3/20/15.
//  Copyright (c) 2015 Digify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SpaceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) NSMutableArray *array_stories;
@end
