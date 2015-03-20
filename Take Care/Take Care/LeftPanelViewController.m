//
//  LeftPanelViewController.m
//  TakeCare
//
//  Created by louie on 3/16/15.
//  Copyright (c) 2015 Digify. All rights reserved.
//

#import "LeftPanelViewController.h"

@interface LeftPanelViewController ()

@end

@implementation LeftPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     self.view.backgroundColor = [UIColor colorWithPatternImage:image];*/
    
}

- (IBAction)btn_home_clicked:(id)sender
{
     UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainSidePanel"];
     [self presentViewController:navController animated:NO completion:nil];
}

@end
