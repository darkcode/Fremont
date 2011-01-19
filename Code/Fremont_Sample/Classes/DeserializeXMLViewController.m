//
//  DeserializeXMLViewController.m
//  Fremont
//
//  Created by Bradley O'Hearne on 3/8/09.
//  Copyright 2009 Big Hill Software. All rights reserved.
//

#import "DeserializeXMLViewController.h"
#import "ApplicationState.h"
#import "Company.h"


@implementation DeserializeXMLViewController

@synthesize imageView, textView;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	ApplicationState *appState = [ApplicationState getInstance];
	Company *company = appState.deserializedCompany;
	textView.text = [company outputString];		
	imageView.image = company.logoImage;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[imageView release];
	[textView release];
    [super dealloc];
}


@end
