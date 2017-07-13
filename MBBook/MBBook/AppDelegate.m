//
//  AppDelegate.m
//  MBBook
//
//  Created by Bing Ma on 7/13/17.
//  Copyright © 2017 Bing Ma (Hannb). All rights reserved.
//

#import "AppDelegate.h"

#import "MBTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //UMeng
    UMConfigInstance.appKey = @"594896054ad15618240022b6";
    UMConfigInstance.channelId = @"GitHub";
    [MobClick startWithConfigure:UMConfigInstance];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[MBTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
