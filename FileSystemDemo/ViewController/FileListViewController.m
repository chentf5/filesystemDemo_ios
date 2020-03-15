//
//  FileListViewController.m
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/13.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileListViewController.h"

#define WIDTH self.view.frame.size.width
#define HIGHT self.view.frame.size.height

@interface FileListViewController()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *fileList;

@end


@implementation FileListViewController  {
    NSInteger fileNumber;
}
- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:YES];
    fileNumber = 3;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.fileList];
    //数据源协议委托
    self.fileList.delegate = self;
    self.fileList.dataSource = self;
    //隐藏分割线
    UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.fileList.tableFooterView = footer;
    //UI 初始化
    
    //数据初始化
    
}
- (UITableView *)fileList   {
    if(_fileList == nil)    {
        _fileList = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, WIDTH, HIGHT) style:UITableViewStylePlain];
        //
        
        
    }
    return _fileList;
}

#pragma mark UITableViewDelegate method

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    NSInteger rowIndex = indexPath.row;
    if(rowIndex == 0)    {
        cell.textLabel.text = @"testfile 1 Title test";
        cell.detailTextLabel.text = @"2020-03-12";
        [cell.imageView setImage:[UIImage imageNamed:@"icon/folder_icon_18"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else if(rowIndex == 1)  {
        cell.textLabel.text = @"testfile 2 Title test";
        cell.detailTextLabel.text = @"2020-03-12";
        [cell.imageView setImage:[UIImage imageNamed:@"icon/file_icon_18"]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }else  {
        cell.textLabel.text = @"testfile 3 Title test";
        cell.detailTextLabel.text = @"2020-03-12";
        [cell.imageView setImage:[UIImage imageNamed:@"icon/folder_icon_18"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       
        
        
    }
     cell.separatorInset = UIEdgeInsetsMake(0, 20, 10, 20);
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return fileNumber;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView   {
    return 1;
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.3f];
}

- (void)deselect{
    //取消选中状态
    [self.fileList deselectRowAtIndexPath:[self.fileList indexPathForSelectedRow] animated:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath   {
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section   {
    return 50.0;
}


#pragma mark getDataFromDOC

- (void)getDataFromDOC  {
    
}
//- (void)encodeWithCoder:(nonnull NSCoder *)coder {
//
//}

//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}

//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}

//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    <#code#>
//}

//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}

//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}

@end
