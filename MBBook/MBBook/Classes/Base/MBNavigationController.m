//
//  MBNavigationController.m
//  Loan
//
//  Created by Bing Ma on 5/3/17.
//  Copyright © 2017 CQ (Hannb). All rights reserved.
//

#import "MBNavigationController.h"

@interface MBNavigationController ()

@end

@implementation MBNavigationController

+ (void)initialize {
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_color"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[NSForegroundColorAttributeName] = [UIColor whiteColor];
    md[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [navBar setTitleTextAttributes:md];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"navigationbar_pic_back_icon"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 30, 30);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // UIStatusBarStyleLightContent
    return UIStatusBarStyleLightContent;
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

-(void)didReceiveMemoryWarning {}

-(void)dealloc {}

@end
