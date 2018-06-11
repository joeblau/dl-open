//
//  DLOpenFrameworkDelegate.h
//  DLOpenFramework
//
//  Created by Joe Blau on 7/10/17.
//  Copyright © 2017 Uber ATC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLOpenFrameworkDelegate : UIResponder

@property (strong, nonatomic) UIWindow *window;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)sharedInstance;
- (void)start;

@end
