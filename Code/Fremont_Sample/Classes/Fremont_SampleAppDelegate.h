//
//  Fremont_SampleAppDelegate.h
//  Fremont_Sample
//
//  Created by Bradley O'Hearne on 7/5/09.
//  Copyright Big Hill Software 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Fremont_SampleAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
