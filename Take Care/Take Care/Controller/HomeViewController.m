//
//  HomeViewController.m
//  Take Care
//
//  Created by louie on 3/20/15.
//  Copyright (c) 2015 Digify. All rights reserved.
//

#import "HomeViewController.h"
#import "JASidePanelController.h"
#import <UIViewController+JASidePanel.h>
#import "AFNetworking.h"
#import "SpaceViewController.h"

@interface HomeViewController ()
@property (strong, nonatomic) NSMutableArray *array_stories;
@end

@implementation HomeViewController

- (NSMutableArray *)array_stories
{
    if (!_array_stories) {
        _array_stories = [NSMutableArray array];
    }
    return _array_stories;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"drawerburger.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftPanel)];
    self.navigationItem.leftBarButtonItem = menu;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)toggleLeftPanel
{
    [self.sidePanelController showLeftPanelAnimated:YES];
}

#pragma mark - Action Methods
- (IBAction)btn_feel_unsafe_clicked:(id)sender
{
    [self performSegueWithIdentifier:@"segueToReporting" sender:self];
}

- (IBAction)btn_enter_space_clicked:(id)sender
{
    [self getStories];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToSpace"])
    {
        SpaceViewController *spaceVC = [segue destinationViewController];
        spaceVC.array_stories = self.array_stories;
    }
}

#pragma mark - AFNetworking (API Calls)
- (void)getStories
{
    [self.array_stories removeAllObjects];
    [self displayHUD];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{};
    [manager POST:@"http://www.takecare.16mb.com/index.php/api/get_story" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHUD];
        NSNumber *result = [[[responseObject objectForKey:@"tc_api"] objectForKey:@"status"] objectForKey:@"result"];
        if ([result isEqualToNumber:[NSNumber numberWithInt:1]]) {
            self.array_stories = [[[[responseObject objectForKey:@"tc_api"] objectForKey:@"status"] objectForKey:@"message"] mutableCopy];
            NSLog(@"%@", self.array_stories);
        }
        [self performSegueWithIdentifier:@"segueToSpace" sender:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        [self hideHUD];
    }];
}

#pragma mark - MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}

#pragma mark - HUD methods
- (void)hideHUD
{
    [HUD hide:YES];
    HUD.userInteractionEnabled = YES;
}

- (void)displayHUD
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    HUD.userInteractionEnabled = NO;
    [self.sidePanelController setAllowLeftSwipe:NO];
    [self.sidePanelController setAllowRightSwipe:NO];
    [self.sidePanelController setAllowLeftOverpan:NO];
}

@end
