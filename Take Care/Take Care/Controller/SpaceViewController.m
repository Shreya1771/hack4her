//
//  SpaceViewController.m
//  Take Care
//
//  Created by louie on 3/20/15.
//  Copyright (c) 2015 Digify. All rights reserved.
//

#import "SpaceViewController.h"
#import "JASidePanelController.h"
#import <UIViewController+JASidePanel.h>
#import "AFNetworking.h"
#import "StoryDetailViewController.h"

@interface SpaceViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refresh;
@end

@implementation SpaceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor whiteColor]];
    
    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"drawerburger.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftPanel)];
    self.navigationItem.leftBarButtonItem = menu;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor whiteColor];
    self.refresh = refreshControl;
    [self.tableView addSubview:self.refresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refresh beginRefreshing];
        [self.refresh endRefreshing];
    });
}

- (void)toggleLeftPanel
{
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (void)refreshTable
{
    [self.refresh endRefreshing];
    [self getStories];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToStoryDetail"]) {
        StoryDetailViewController *storyDetailVC = [segue destinationViewController];
        storyDetailVC.reporter = [self.array_stories[self.tableView.indexPathForSelectedRow.row] objectForKey:@"story_sender"];
        storyDetailVC.story = [self.array_stories[self.tableView.indexPathForSelectedRow.row] objectForKey:@"story_msg"];
        storyDetailVC.location = [self.array_stories[self.tableView.indexPathForSelectedRow.row] objectForKey:@"story_location"];
    }
}

#pragma mark - Table

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array_stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"storyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.array_stories[indexPath.row] objectForKey:@"story_msg"];
    cell.textLabel.numberOfLines = 4;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Where: %@", [self.array_stories[indexPath.row] objectForKey:@"story_location"]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"segueToStoryDetail" sender:self];
}

#pragma mark - AFNetworking (API Calls)

- (void)getStories
{
    [self.array_stories removeAllObjects];
    [self displayHUD];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{};
    [manager POST:@"http://www.takecare.16mb.com/index.php/api/get_story" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        [self hideHUD];
        NSNumber *result = [[[responseObject objectForKey:@"tc_api"] objectForKey:@"status"] objectForKey:@"result"];
        if ([result isEqualToNumber:[NSNumber numberWithInt:1]]) {
            self.array_stories = [[[[responseObject objectForKey:@"tc_api"] objectForKey:@"status"] objectForKey:@"message"] mutableCopy];
            NSLog(@"%@", self.array_stories);
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        [self hideHUD];
    }];
}

#pragma mark - MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
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
