//
//  EmergencyContactViewController.m
//  Take Care
//
//  Created by codeegoh on 3/21/15.
//  Copyright (c) 2015 Digify. All rights reserved.
//

#import "EmergencyContactViewController.h"

@interface EmergencyContactViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txt_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_number;
@end

@implementation EmergencyContactViewController

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (IBAction)btn_submit_clicked:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array_contacts = [NSMutableArray array];
    array_contacts = [[userDefaults objectForKey:@"array_contacts"] mutableCopy];
    if (!array_contacts && array_contacts.count <= 0) {
        array_contacts = [NSMutableArray array];
    }
    [array_contacts addObject:[NSString stringWithFormat:@"%@|%@", self.txt_name.text, self.txt_number.text]];
    [userDefaults setObject:array_contacts forKey:@"array_contacts"];
    [userDefaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
