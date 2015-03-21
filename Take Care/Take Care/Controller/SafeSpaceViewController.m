//
//  SafeSpaceViewController.m
//  Take Care
//
//  Created by louie on 3/20/15.
//  Copyright (c) 2015 Digify. All rights reserved.
//

#import "SafeSpaceViewController.h"
#import "AFNetworking.h"

@interface SafeSpaceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txt_street;
@property (weak, nonatomic) IBOutlet UITextField *txt_brgy;
@property (weak, nonatomic) IBOutlet UITextField *txt_municipality;
@property (weak, nonatomic) IBOutlet UITextField *txt_zip;
@end

@implementation SafeSpaceViewController

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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

- (void)animateTextField:(UITextField *)textField up:(BOOL)up
{
    const int movementDistance = -130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - AFNetworking (API Calls)

- (void)addStory:(NSString *)story_sender storyMsg:(NSString *)story_msg storyZone:(NSInteger)story_zone storyLocation:(NSString *)story_location
{
    [self displayHUD];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"story_sender" : story_sender,
                             @"story_msg" : story_msg,
                             @"story_zone" : @(story_zone),
                             @"story_location" : story_location};
    [manager POST:@"http://www.takecare.16mb.com/index.php/api/add_story" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        [self hideHUD];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        [self hideHUD];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [alert show];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (IBAction)btn_cancel_clicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btn_submit_clicked:(id)sender
{
    NSString *location = [NSString stringWithFormat:@"%@ %@ %@ %@", self.txt_street.text, self.txt_brgy.text, self.txt_municipality.text, self.txt_zip.text];
    location = [location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (location.length > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM dd yyyy"];
        NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
        [self addStory:@"" storyMsg:[NSString stringWithFormat:@"%@ is a safe place as of %@", location, stringFromDate] storyZone:1 storyLocation:location];
    }
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
}

@end
