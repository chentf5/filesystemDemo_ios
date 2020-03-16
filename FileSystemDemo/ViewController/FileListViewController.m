//
//  FileListViewController.m
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/13.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileListViewController.h"
#import "TextViewController.h"
#import "DetailsViewController.h"
#define WIDTH self.view.frame.size.width
#define HIGHT self.view.frame.size.height

@interface FileListViewController()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *fileList;
@property(nonatomic,strong)NSArray *filesArray;
@property(nonatomic,strong)NSMutableArray *filesDetails;
//@property(nonatomic,strong)UIAlertController *detailsView;
@property(nonatomic,strong)UIView *detailsView;
@end


@implementation FileListViewController  {
    NSInteger fileNumber;
}
- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:YES];
    //数据初始化
    [self getDataFromDOC];
    fileNumber = self.filesArray.count;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //UI 初始化
    [self.view addSubview:self.fileList];
    //添加右上按钮
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewFile)];
    self.navigationItem.rightBarButtonItem = addButton;
    //数据源协议委托
    self.fileList.delegate = self;
    self.fileList.dataSource = self;
    //隐藏分割线
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 800, WIDTH, 50)];
    self.fileList.tableFooterView = footer;
    
    //添加cell长按事件
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handlerlongPress:)];
    longPressReger.minimumPressDuration = 1.0;
    //添加控制器到TableView
    [self.fileList addGestureRecognizer:longPressReger];
    
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated    {
    [super viewWillDisappear:YES];
   
}
- (UITableView *)fileList   {
    if(_fileList == nil)    {
        _fileList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT) style:UITableViewStylePlain];
        
        
    }
    return _fileList;
}

- (UIView *)detailsView {
    if(_detailsView == nil) {
        _detailsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    }
    return _detailsView;
}
//构建View模版
- (void)setupDetailsView    {
    
}
#pragma mark UITableViewDelegate method

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    NSInteger rowIndex = indexPath.row;
    NSLog(@"count %ld",self.filesDetails.count);
    NSDictionary *nowfile = [self.filesDetails objectAtIndex:rowIndex];
    
    NSLog(@"cell for %@",nowfile);
    //判断
    //title
    cell.textLabel.text = [self.filesArray objectAtIndex:rowIndex];
    //time
    //NSString *createTime = [nowfile valueForKey:@"NSFileModificationDate"];
    NSDate *modifyTime = [nowfile valueForKey:@"NSFileModificationDate"];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //NSDate *createDate = [format dateFromString:createTime];
   // NSDate *modifyDate = [format dateFromString:modifyTime];
    //NSString *createStr = [format stringFromDate:createDate];
    NSString *modifyStr = [format stringFromDate:modifyTime];
    NSString *detailsText = [NSString stringWithFormat:@"上次访问时间: %@",modifyStr];
    cell.detailTextLabel.text = detailsText;
    NSString *fileType = [nowfile valueForKey:@"NSFileType"];
    NSLog(@"%@",fileType);
    
    if([fileType isEqualToString:@"NSFileTypeDirectory"])  {
        [cell.imageView setImage:[UIImage imageNamed:@"icon/folder_icon_18"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else if([fileType isEqualToString:@"NSFileTypeRegular"])    {
        [cell.imageView setImage:[UIImage imageNamed:@"icon/file_icon_18"]];
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
    NSInteger rowIndex = indexPath.row;
    NSDictionary *nowfile = [self.filesDetails objectAtIndex:rowIndex];
    NSString *nextfoldername = [NSString stringWithFormat:@"%@/%@",self.foldername,[self.filesArray objectAtIndex:rowIndex]];
    NSLog(@"%@",nextfoldername);
    NSString *fileType = [nowfile valueForKey:@"NSFileType"];
    if([fileType isEqualToString:@"NSFileTypeDirectory"])  {
        FileListViewController *next = [[FileListViewController alloc]init];
        [next setFoldername:nextfoldername];
        [self.navigationController pushViewController:next animated:YES];
        
    }else if([fileType isEqualToString:@"NSFileTypeRegular"])    {
        
    }
    
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
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    
    NSString *folderpath = [NSString stringWithFormat:@"%@/%@",docPath,_foldername];
    NSLog(@"%@",folderpath);
    NSFileManager *fm = [NSFileManager defaultManager];
    
    self.filesArray = [fm contentsOfDirectoryAtPath:folderpath error:nil];
    NSLog(@"subpath = %@",self.filesArray);
    self.filesDetails = [[NSMutableArray alloc]init];
    for(id filestr in self.filesArray) {
        NSError *error;
        NSString *nowfilePath = [NSString stringWithFormat:@"%@/%@",folderpath,filestr];
        NSDictionary *details = [[NSFileManager defaultManager] attributesOfItemAtPath:nowfilePath error:&error];
        if(error == nil)    {
            NSLog(@"%@",details);
            
        }else {
            NSLog(@"%@",error);
            
        }
        
        [self.filesDetails addObject:details];
    }
    NSLog(@"alll%@",self.filesDetails);
}

//长按事件
- (void)handlerlongPress:(UILongPressGestureRecognizer *)longPress {
    //定位cell位置
    CGPoint point = [longPress locationInView:self.fileList];
    NSIndexPath *indexPath = [self.fileList indexPathForRowAtPoint:point];
       if(indexPath == nil)    {
           
           NSLog(@"error, no tableview");
       }else   {
           
       }
    
    if(longPress.state == UIGestureRecognizerStateBegan)    {
        NSLog(@"begin....");
       
    //显示弹出框列表选择
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
      handler:^(UIAlertAction * action) {
          //响应事件
          NSLog(@"action = %@", action);
      }];
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive
     handler:^(UIAlertAction * action) {
         //响应事件
         NSLog(@"action = %@", action);
     }];
    UIAlertAction* detailAction = [UIAlertAction actionWithTitle:@"查看信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
         NSLog(@"action = %@", action);
        
        
        NSDictionary *now = self.filesDetails[indexPath.row];
        NSString *temptitle = self.filesArray[indexPath.row];
        NSString *local = [NSString stringWithFormat:@"%@/%@",self.foldername,temptitle];
        DetailsViewController *DView = [[DetailsViewController alloc]initWithDetails:now andTitle:temptitle andLoacl:local];
          
          //弹出下拉框
        DView.view.backgroundColor = [UIColor whiteColor];
          [self.navigationController pushViewController:DView animated:YES];
        
        
     }];
    UIAlertAction* copyAction = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            //响应事件
            NSLog(@"action = %@", action);
        }];
    UIAlertAction* moveAction = [UIAlertAction actionWithTitle:@"移动" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
        //响应事件
        NSLog(@"action = %@", action);
    }];
    [alert addAction:detailAction];
    [alert addAction:copyAction];
    [alert addAction:moveAction];
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    [self presentViewController:alert animated:YES completion:nil];

    }else if(longPress.state == UIGestureRecognizerStateEnded)  {
        NSLog(@"end....");
    }
   
}
//新建文件函数
- (void)addNewFile  {
    TextViewController *editArticle = [[TextViewController alloc]init];
    //防止push时应为背景颜色透明而出现视图重叠
    editArticle.view.backgroundColor = [UIColor whiteColor];


    [self.navigationController pushViewController:editArticle animated:YES];
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
