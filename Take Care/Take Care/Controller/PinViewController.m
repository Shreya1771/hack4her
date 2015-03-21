//
//  PinViewController.m
//  Take Care
//
//  Created by codeegoh on 3/21/15.
//  Copyright (c) 2015 Digify. All rights reserved.
//

#import "PinViewController.h"
#import "JASidePanelController.h"
#import <UIViewController+JASidePanel.h>

@interface PinViewController ()

@end

@implementation PinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"drawerburger.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftPanel)];
    self.navigationItem.leftBarButtonItem = menu;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)toggleLeftPanel
{
    [self.sidePanelController showLeftPanelAnimated:YES];
}

@end
