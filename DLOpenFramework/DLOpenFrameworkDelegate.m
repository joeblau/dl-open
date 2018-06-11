//
//  DLOpenFrameworkDelegate.m
//  DLOpenFramework
//
//  Created by Joe Blau on 7/10/17.
//  Copyright © 2017 Uber ATC. All rights reserved.
//

#import "DLOpenFrameworkDelegate.h"

@implementation DLOpenFrameworkDelegate

+ (instancetype)sharedInstance
{
    static DLOpenFrameworkDelegate *mySharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mySharedInstance = [[self alloc] init];
    });
    
    return mySharedInstance;
}

- (void)start
{    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UIViewController alloc] init];
    self.window.backgroundColor = [UIColor greenColor];
    [self.window makeKeyAndVisible];
}


@end
