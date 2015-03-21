//
//  RAContactsViewController.m
//  ReadysasterPH
//
//  Created by Rodel Arenas on 5/9/14.
//  Copyright (c) 2014 i-Team. All rights reserved.
//

#import "RAContactsViewController.h"
#import "RAContactCell.h"
#import "JASidePanelController.h"
#import <UIViewController+JASidePanel.h>

@interface RAContactsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *array_contacts;
@end

@implementation RAContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tblView.delegate = self;
	self.tblView.dataSource = self;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"drawerburger.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftPanel)];
    self.navigationItem.leftBarButtonItem = menu;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.tblView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.array_contacts = [NSMutableArray array];
    self.array_contacts = [[userDefaults objectForKey:@"array_contacts"] mutableCopy];
    [self.tblView reloadData];
}

- (void)toggleLeftPanel
{
    [self.sidePanelController showLeftPanelAnimated:YES];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

#pragma mark - Table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.array_contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CELL_CONTACT";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSArray *array_contact_detail = [self.array_contacts[indexPath.row] componentsSeparatedByString:@"|"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@", array_contact_detail[0], array_contact_detail[1]];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
	
	return cell;
}

@end
