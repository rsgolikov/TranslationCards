//
//  TCDataViewController.m
//  TranslationCards
//
//  Created by user6230 on 8/28/13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import "TCDataViewController.h"

@interface TCDataViewController ()

@end

@implementation TCDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

@end
