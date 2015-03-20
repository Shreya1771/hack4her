//
//  SafeSpaceViewController.h
//  Take Care
//
//  Created by louie on 3/20/15.
//  Copyright (c) 2015 Digify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SafeSpaceViewController : UIViewController <MBProgressHUDDelegate, UITextFieldDelegate> {
    MBProgressHUD *HUD;
}

@end
