//
//  LeftPanelViewController.m
//  TakeCare
//
//  Created by louie on 3/16/15.
//  Copyright (c) 2015 Digify. All rights reserved.
//

#import "LeftPanelViewController.h"
#import <JASidePanelController.h>
#import <JASidePanels/UIViewController+JASidePanel.h>

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

#pragma mark - Action Methods
- (IBAction)contactsClicked:(UIButton *)sender
{
    [self setCenterVC:[self.storyboard instantiateViewControllerWithIdentifier:@"S_CONTACTS_VC"]];
}

- (IBAction)btn_home_clicked:(id)sender
{
//     UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainSidePanel"];
//     [self presentViewController:navController animated:NO completion:nil];
    
    [self setCenterVC:[self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"]];
}

- (void)setCenterVC:(UIViewController *)vc
{
    [self.sidePanelController setCenterPanel:vc];
    [self.sidePanelController showCenterPanelAnimated:YES];
}

- (IBAction)change_pin_clicked:(id)sender {
    //S_PIN_VC
    [self setCenterVC:[self.storyboard instantiateViewControllerWithIdentifier:@"S_PIN_VC"]];
}

@end
