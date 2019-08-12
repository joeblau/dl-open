//
//  AppDelegate.m
//  DLOpen
//
//  Created by Joe Blau on 7/10/17.
//  Copyright © 2017 Uber ATC. All rights reserved.
//

#import "AppDelegate.h"
#import <dlfcn.h>

@interface AppDelegate ()

@property (nonatomic) id framework;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UIViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _loadFramework];
    });
    
    return YES;
}


#pragma mark - Internal

- (void)_loadFramework
{
    if ([self _loadDownloadedFramework]) {
        [self _startFramework];
        return;
    }
    
    if ([self _loadBuiltInFramework]) {
        [self _startFramework];
        return;
    }
    
    NSLog(@"no framework could be loaded.");
}

- (BOOL)_loadDownloadedFramework
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolderPath = paths.firstObject;
    return [self _loadFrameworkWithinFolderAtPath:documentFolderPath];
}

- (BOOL)_loadBuiltInFramework
{
    return [self _loadFrameworkWithinFolderAtPath:[[NSBundle mainBundle] resourcePath]];
}

- (BOOL)_loadFrameworkWithinFolderAtPath:(NSString *)folderPath
{
    NSString *frameworkPath = [folderPath stringByAppendingPathComponent:@"Frameworks/DLOpenFramework.framework"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:frameworkPath]) {
        return NO;
    }
    
    NSString *frameworkExecutable = [frameworkPath stringByAppendingPathComponent:@"DLOpenFramework"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:frameworkPath]) {
        return NO;
    }
    
    void *handle = dlopen([frameworkExecutable cStringUsingEncoding:NSASCIIStringEncoding], RTLD_NOW);
    if (!handle) {
        NSLog(@"dlopen failed: %s", dlerror());
        return NO;
    }
    
    return YES;
}

- (void)_startFramework
{
    Class frameworkDelegateClass = NSClassFromString(@"DLOpenFrameworkDelegate");
    if (frameworkDelegateClass) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        self.framework = [frameworkDelegateClass performSelector:NSSelectorFromString(@"sharedInstance")];
#pragma clang diagnostic pop
        
        SEL selector = NSSelectorFromString(@"start");
        ((void (*)(id, SEL))[self.framework methodForSelector:selector])(self.framework, selector);
    }
}


@end
