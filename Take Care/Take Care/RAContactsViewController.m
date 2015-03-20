//
//  RAContactsViewController.m
//  ReadysasterPH
//
//  Created by Rodel Arenas on 5/9/14.
//  Copyright (c) 2014 i-Team. All rights reserved.
//

#import "RAContactsViewController.h"
#import "RAContactCell.h"

@interface RAContactsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@end

@implementation RAContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Do any additional setup after loading the view.

	// TableView Delegates
	self.tblView.delegate = self;
	self.tblView.dataSource = self;
	//self.tblView.backgroundColor =  [UIColor colorWithRed:(95/255.0) green:(100/255.0) blue:(115/255.0) alpha:1];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

#pragma mark - Table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RAContactCell *cell = (RAContactCell *)[self.tblView dequeueReusableCellWithIdentifier:@"CELL_CONTACT"];
	
	cell.lblFullname.text = [NSString stringWithFormat:@"Ma. Gaile Danica Leonidas #%d", indexPath.row];
	
	cell.imgContact.image = [UIImage imageNamed:@"user notactive btn.png"];
	
	return cell;
}



@end
