//
//  IndexViewController.m
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/10.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndexViewController.h"
#import "TextViewController.h"
#import "FileListViewController.h"

#define RGBB(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]

@interface IndexViewController()<UITabBarControllerDelegate>
//@property(nonatomic,strong) UIButton *toWebView;
@property(nonatomic,strong) UITabBarController *tabbar;
@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tabbar.view];
    self.tabbar.delegate = self;
    self.title = @"文件";
    self.tabbar.selectedIndex = 0;
    self.navigationController.navigationBarHidden = YES;
//    //添加右边按钮
//        //添加右上按钮  创建文件 & 创建文件夹
//    NSMutableArray *btnArray = [NSMutableArray arrayWithCapacity:2];
//    
//    UIBarButtonItem *addFile = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon/addfile"] style:UIBarButtonItemStyleDone target:self action:@selector(addNewFile)];
//    [btnArray addObject:addFile];
//    //创建文件夹
//    UIBarButtonItem *addFolder = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon/addfolder"] style:UIBarButtonItemStyleDone target:self action:@selector(addNewFolder)];
//    [btnArray addObject:addFolder];
//    
//    self.navigationController.navigationBar.topItem.rightBarButtonItems = btnArray;
}
- (UITabBarController *)tabbar {
    if(_tabbar == nil)  {
        
        FileListViewController *firstVC = [[FileListViewController alloc]init];
        firstVC.tabBarItem.title = @"文件";
        firstVC.tabBarItem.image = [UIImage imageNamed:@"icon/folder_icon_1_18"];
        firstVC.tabBarItem.selectedImage = [UIImage imageNamed:@"icon/folder_select_icon_1_18"];
        //firstVC.view.backgroundColor = [UIColor grayColor];
        firstVC.foldername = @"t";
        _tabbar = [[UITabBarController alloc]init];
        UINavigationController *first = [[UINavigationController alloc]initWithRootViewController:firstVC];
        
        [_tabbar addChildViewController:first];
        
        UIViewController *MyVC = [[UIViewController alloc]init];
        MyVC.tabBarItem.title = @"我的";
        MyVC.tabBarItem.image = [UIImage imageNamed:@"icon/me_icon_18"];
        MyVC.tabBarItem.selectedImage = [UIImage imageNamed:@"icon/me_select_icon_18"];
       _tabbar = [[UITabBarController alloc]init];
       UINavigationController *second = [[UINavigationController alloc]initWithRootViewController:MyVC];
        [_tabbar addChildViewController:first];
        [_tabbar addChildViewController:second];
       
        //tabbar样式
       // _tabbar.tabBar.tintColor = [UIColor blackColor];
        //
        [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
        
    }
    return _tabbar;
}



#pragma mark UITabBarControllerDelegate Method

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController  {
    if(tabBarController.selectedIndex == 0) {
        NSLog(@"files");
        self.title = @"文件";
    }else if(tabBarController.selectedIndex == 1)   {
        NSLog(@"my");
        self.title = @"我的";
    }else   {
        NSLog(@"error");
    }
    NSLog(@"?>>>>");
}
    
    


                                  
                                  
                                  

@end
