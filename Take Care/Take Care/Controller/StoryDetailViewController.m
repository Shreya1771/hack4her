//
//  StoryDetailViewController.m
//  Take Care
//
//  Created by louie on 3/20/15.
//  Copyright (c) 2015 Digify. All rights reserved.
//

#import "StoryDetailViewController.h"

@interface StoryDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbl_reporter;
@property (weak, nonatomic) IBOutlet UITextView *txt_story;
@property (weak, nonatomic) IBOutlet UILabel *lbl_location;
@end

@implementation StoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.reporter.length > 0) {
        self.reporter = @"Anonymous";
    }
    self.lbl_reporter.text = self.reporter;
    self.txt_story.text = self.story;
    self.lbl_location.text = self.location;
}

- (IBAction)btn_close_clicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
