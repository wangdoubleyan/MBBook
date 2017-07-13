//
//  MBTabBarController.m
//  Loan
//
//  Created by Bing Ma on 5/3/17.
//  Copyright © 2017 CQ (Hannb). All rights reserved.
//

#import "MBTabBarController.h"
#import "AFHTTPSessionManager.h"

#import "MBNavigationController.h"

//#import "MBAboutViewController.h"
//#import "YSearchViewController.h"
//#import "YRankingViewController.h"
//#import "YCenterViewController.h"
//#import "YBookCatsViewController.h"

@interface MBTabBarController ()

@end

@implementation MBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AFNetworkReachabilityManager *reachMgr = [AFNetworkReachabilityManager sharedManager];
    [reachMgr startMonitoring];
    [reachMgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            [self showNetworkError];
        }
    }];

    UIViewController *vc = [[UIViewController alloc] init];
    [self addChildViewController:vc withImage:[UIImage imageNamed:@"tab_book"] selectedImage:[UIImage imageNamed:@"tab_book_hl"] withTittle:@"测·试"];
    
//    YCenterViewController *vc0 = [UIStoryboard storyboardWithName:@"YCenterVC" bundle:[NSBundle mainBundle]].instantiateInitialViewController;
//    [self addChildViewController:vc0 withImage:[UIImage imageNamed:@"tab_book"] selectedImage:[UIImage imageNamed:@"tab_book_hl"] withTittle:@"书·架"];
//    
//    YBookCatsViewController *vc1 = [UIStoryboard storyboardWithName:@"YBookCatsViewController" bundle:[NSBundle mainBundle]].instantiateInitialViewController;
//    [self addChildViewController:vc1 withImage:[UIImage imageNamed:@"tab_class"] selectedImage:[UIImage imageNamed:@"tab_class_hl"] withTittle:@"分类"];
//    
//    YRankingViewController *vc2 = [[YRankingViewController alloc] init];
//    [self addChildViewController:vc2 withImage:[UIImage imageNamed:@"tab_rank"] selectedImage:[UIImage imageNamed:@"tab_rank_hl"] withTittle:@"排行"];
//    
//    MBAboutViewController *vc3 = [[MBAboutViewController alloc] init];
//    [self addChildViewController:vc3 withImage:[UIImage imageNamed:@"tab_about"] selectedImage:[UIImage imageNamed:@"tab_about_hl"] withTittle:@"关于"];
}

- (void)addChildViewController:(UIViewController *)controller withImage:(UIImage *)image selectedImage:(UIImage *)selectImage withTittle:(NSString *)tittle{
    
    MBNavigationController *nav = [[MBNavigationController alloc] initWithRootViewController:controller];
    
    [nav.tabBarItem setImage:image];
    [nav.tabBarItem setSelectedImage:selectImage];
    controller.title = tittle;
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kMBColor(45, 197, 144, 1)} forState:UIControlStateSelected];
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    [self addChildViewController:nav];
}

- (void)showNetworkError {
    UIAlertView *altV = [[UIAlertView alloc]initWithTitle:@"网络异常，请检查网络设置！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"前往设置", @"取消", nil];
    altV.tag = 966;
    [altV show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 966) {
        if (buttonIndex == 0) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            }
        } else {
            
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
