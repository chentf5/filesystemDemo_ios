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
#import "../View/MoveView.h"
#import "FolderHandle.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
UITextField *textField1;
@interface FileListViewController()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *fileList;
@property(nonatomic,strong)NSMutableArray *filesArray;
//@property(nonatomic,strong)NSMutableArray *filesMuArray;
@property(nonatomic,strong)NSMutableArray *filesDetails;
//@property(nonatomic,strong)UIAlertController *detailsView;
@property(nonatomic,strong)UIView *detailsView;
@property(nonatomic)NSInteger fileNumber;

//从下弹出框

@end


@implementation FileListViewController  {
    NSString *docPath;
       
}
- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:YES];
    //数据初始化
    //d[self getDataFromDOC];
    docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    //self.fileNumber = self.filesArray.count;
}
- (void)viewDidAppear:(BOOL)animated    {
    [super viewDidAppear:YES];
    [self getDataFromDOC];
    [self.fileList reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //UI 初始化
    [self.view addSubview:self.fileList];
    self.title = @"文件";
   
    self.navigationController.navigationBarHidden=NO;
    NSMutableArray *btnArray = [NSMutableArray arrayWithCapacity:2];
    UIBarButtonItem *addFile = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon/addfile"] style:UIBarButtonItemStyleDone target:self action:@selector(addNewFile)];
    [btnArray addObject:addFile];
    //创建文件夹
    UIBarButtonItem *addFolder = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon/addfolder"] style:UIBarButtonItemStyleDone target:self action:@selector(addNewFolder)];
    [btnArray addObject:addFolder];
    
   // self.navigationController.navigationBar.topItem.rightBarButtonItems = btnArray;
    self.navigationItem.rightBarButtonItems = btnArray;
    
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
        _fileList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
        
        
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
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
  if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    NSInteger rowIndex = indexPath.row;
    //NSLog(@"count %ld",self.filesDetails.count);
    NSDictionary *nowfile = [self.filesDetails objectAtIndex:rowIndex];
    
    //NSLog(@"cell for %@",nowfile);
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
    //NSLog(@"%@",fileType);
    
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
    return self.filesArray.count;
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
    //NSLog(@"%@",nextfoldername);
    NSString *fileType = [nowfile valueForKey:@"NSFileType"];
    if([fileType isEqualToString:@"NSFileTypeDirectory"])  {
        FileListViewController *next = [[FileListViewController alloc]init];
        [next setFoldername:nextfoldername];
        [self.navigationController pushViewController:next animated:YES];
        
        
    }else if([fileType isEqualToString:@"NSFileTypeRegular"])    {
       
        
        NSString *lastPathComponent = [NSString new];
        //获取文件名： 视频.MP4
        lastPathComponent = [nextfoldername lastPathComponent];
        NSString *extend = [nextfoldername pathExtension];
        
        //NSString *thisfilepath = [NSString stringWithFormat:@"%@/%@",docPath,nextfoldername];
        NSString *folderpath = [NSString stringWithFormat:@"%@/%@",docPath,self.foldername];
        NSLog(@"extend:%@,filename:%@",extend,lastPathComponent);
        NSLog(@"nextfolderpath:  %@",nextfoldername);
        if([extend isEqualToString:@"txt"] || [extend isEqualToString:@""]) {
            TextViewController *showfile = [[TextViewController alloc]init];
            [showfile setFolderPath:folderpath];
            [showfile setFilename:lastPathComponent];
            [showfile setIsread:YES];
            [self.navigationController pushViewController:showfile animated:YES];
        }
        
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
    //NSLog(@"%@",folderpath);
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *tfilesArray = [fm contentsOfDirectoryAtPath:folderpath error:nil];
    //NSLog(@"subpath = %@",tfilesArray);
    self.filesArray = [NSMutableArray arrayWithArray:tfilesArray];
    self.filesDetails = [[NSMutableArray alloc]init];
    
    
    for(id filestr in self.filesArray) {
        NSError *error;
        NSString *nowfilePath = [NSString stringWithFormat:@"%@/%@",folderpath,filestr];
        NSDictionary *details = [[NSFileManager defaultManager] attributesOfItemAtPath:nowfilePath error:&error];
        if(error == nil)    {
            //NSLog(@"%@",details);
            
        }else {
            //NSLog(@"%@",error);
            
        }
        
        [self.filesDetails addObject:details];
    }
    //NSLog(@"alll%@",self.filesDetails);
}

//长按事件
- (void)handlerlongPress:(UILongPressGestureRecognizer *)longPress {
    //定位cell位置
    CGPoint point = [longPress locationInView:self.fileList];
    NSIndexPath *indexPath = [self.fileList indexPathForRowAtPoint:point];
       if(indexPath == nil)    {
           
           //NSLog(@"error, no tableview");
       }else   {
           
       }


    NSString *folderpath = [NSString stringWithFormat:@"%@/%@",docPath,_foldername];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filename = self.filesArray[indexPath.row];
    NSString *filePath = [folderpath stringByAppendingFormat:@"/%@",self.filesArray[indexPath.row]];
    if(longPress.state == UIGestureRecognizerStateBegan)    {
       
    //显示弹出框列表选择
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
      handler:^(UIAlertAction * action) {
          //响应事件
          //NSLog(@"action = %@", action);
      }];
        
        
        //重命名
    
    //删除
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive
     handler:^(UIAlertAction * action) {
         //响应事件
         //NSLog(@"action = %@", action);
        
        UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"是否删除" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //删除文件or文件夹操作
            NSError *error;
            //NSLog(@"%@",filePath);
            bool isSuccess = [fm removeItemAtPath:filePath error:&error];
            if(isSuccess)   {
                //NSLog(@"删除成功");
                
                [self.filesArray removeObjectAtIndex:indexPath.row];
                //[self getDataFromDOC];
                [self.fileList reloadData];


                [self showTip:@"成功删除"];
            }
            
            if(error)   {
                //NSLog(@"%@",error);
                [self showTip:@"删除失败"];
            }
            
            
        }];
        
        [deleteAlert addAction:yes];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [deleteAlert addAction:no];
        [self.view.window.rootViewController presentViewController:deleteAlert animated:YES completion:^{
            //NSLog(@"delete the folder or the file");
        }];
        
        
     }];
        
        
    UIAlertAction *renamefile = [UIAlertAction actionWithTitle:@"重命名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertController *input = [UIAlertController alertControllerWithTitle:@"重命名" message:@"输入新名字（不含后缀）" preferredStyle:UIAlertControllerStyleAlert];
           //添加文本框
           [input addTextFieldWithConfigurationHandler:^(UITextField *textField) {
               //设置键盘输入为数字键盘
               //textField.keyboardType = UIKeyboardTypeNumberPad;
               textField.placeholder = @"请填写";
               textField1 = textField;
           }];

           UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
               //取消
           }];
           [input addAction: cancelBtn];
               
           //添加确定按钮
           UIAlertAction *confirmBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               //文本框结束编辑，收起键盘
    //           //NSLog(@"%@",textField1.text);
               textField1 = [input.textFields firstObject];
               BOOL isDir;
               [fm fileExistsAtPath:filePath isDirectory:&isDir];
               if(isDir)    { //文件夹重命名
                   //FolderHandle *folderhandle;
                   NSString *prefile = [NSString stringWithFormat:@"%@/%@",self.foldername,filename];
                   NSString *newfile = [NSString stringWithFormat:@"%@/%@",self.foldername,textField1.text];
                   BOOL isSuccess = [FolderHandle renameFolder:newfile path:prefile];
                   if(isSuccess)    {
                       [self showTip:@"文件夹重命名成功"];
                   }else {
                        [self showTip:@"文件夹重命名失败,命名冲突"];
                   }
               }else {
                   BOOL isSuccess = [self reFileName:filePath andtoName:textField1.text];
                   if(isSuccess)   [self showTip:@"文件重命名成功"];
                   else  [self showTip:@"文件重命名失败,命名冲突"];
                  
                   
               }
               [self getDataFromDOC];
               [self.fileList reloadData];
           }];
           [input addAction: confirmBtn];
            [self.view.window.rootViewController presentViewController:input animated:YES completion:nil];
            
            
        }];
                
    //查看信息
    UIAlertAction* detailAction = [UIAlertAction actionWithTitle:@"查看信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
         //NSLog(@"action = %@", action);
        
        
        NSDictionary *now = self.filesDetails[indexPath.row];
        NSString *temptitle = self.filesArray[indexPath.row];
        NSString *local = [NSString stringWithFormat:@"%@/%@",self.foldername,temptitle];
        DetailsViewController *DView = [[DetailsViewController alloc]initWithDetails:now andTitle:temptitle andLoacl:local];
          
          //弹出下拉框
        DView.view.backgroundColor = [UIColor whiteColor];
          [self.navigationController pushViewController:DView animated:YES];
     }];
        
    //复制
    UIAlertAction* copyAction = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            //响应事件
          //NSLog(@"action = %@", action);
        
          NSString *now_filename =  self.filesArray[indexPath.row];
          NSArray *nametemp = [now_filename componentsSeparatedByString:@"."];
        //NSString *extendname;
        NSString *toURLStr;
        if(nametemp.count == 1) {
            toURLStr = [NSString stringWithFormat:@"%@/%@的副本",folderpath,[nametemp firstObject]];
        }else{
            toURLStr = [NSString stringWithFormat:@"%@/%@的副本.%@",folderpath,[nametemp firstObject],[nametemp lastObject]];
        }
        
        
        //NSLog(@"%@",toURLStr);
        NSData *fileData = [self readFileData:filePath];
        bool isCreateSuccess = [fm createFileAtPath:toURLStr contents:fileData attributes:nil];
        if(isCreateSuccess)   {
            [self getDataFromDOC];
            [self.fileList reloadData];
            [self showTip:@"复制成功"];
        }else {
            [self.fileList reloadData];
            [self showTip:@"复制失败"];
        }
        }];
        
        
        
        
        
      
    //移动到
    UIAlertAction* moveAction = [UIAlertAction actionWithTitle:@"移动" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
        //响应事件
        //NSLog(@"action = %@", action);
        MoveView *nowView = [[MoveView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andFolderName:@"t" andPath:filePath];
        
        [nowView showView:self.view];
        [self.filesArray removeObjectAtIndex:indexPath.row];
        //[self getDataFromDOC];
        [self.fileList reloadData];
    }];
        
        
        
        
        
        
    [alert addAction:detailAction];
    [alert addAction:copyAction];
    [alert addAction:moveAction];
    [alert addAction:renamefile];
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];

    }
   
}
//新建文件函数
- (void)addNewFile  {
    TextViewController *editArticle = [[TextViewController alloc]init];
    //防止push时应为背景颜色透明而出现视图重叠
    editArticle.view.backgroundColor = [UIColor whiteColor];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    
    NSString *folderpath = [NSString stringWithFormat:@"%@/%@",docPath,_foldername];
    [editArticle setFolderPath:folderpath];
    [editArticle setIsread:NO];
    NSLog(@"%@",folderpath);
    [self.navigationController pushViewController:editArticle animated:YES];
}

//添加文件夹

- (void)addNewFolder {
    NSLog(@"file");
    UIAlertController *addNewFolder = [UIAlertController alertControllerWithTitle:@"创建文件夹" message:@"输入文件夹名称" preferredStyle:UIAlertControllerStyleAlert];
    [addNewFolder addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入文件夹名称";
    }];
    
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"新建" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *docPathtemp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *newPath = [NSString stringWithFormat:@"%@/t/%@",docPathtemp,[addNewFolder.textFields firstObject].text];
        NSLog(@"%@",newPath);
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error;
        [fm createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:&error];
        if(error == nil)    {
            [self showTip:@"创建文件夹成功"];
            
            [self getDataFromDOC];
            [self.fileList reloadData];
            
        }else {
            [self showTip:@"创建文件夹失败"];
        }
    }];
    [addNewFolder addAction:add];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [addNewFolder addAction:cancle];
     [self.view.window.rootViewController presentViewController:addNewFolder animated:YES completion:^{
               //NSLog(@"delete the folder or the file");
         
        
           
     }];
    
    
    
    
}


//读文件数据
- (NSData*)readFileData:(NSString *)path{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *fileData = [handle readDataToEndOfFile];
    [handle closeFile];
    return fileData;
}

//文件重命名
- (BOOL)reFileName:(NSString *)filePath andtoName:(NSString *)tofilePath {
    
    NSString *lastPathComponent = [NSString new];
    //获取文件名： 视频.MP4
    lastPathComponent = [filePath lastPathComponent];
    //获取后缀：MP4
    NSString *pathExtension = [filePath pathExtension];
    //用传过来的路径创建新路径 首先去除文件名
    NSString *pathNew = [filePath stringByReplacingOccurrencesOfString:lastPathComponent withString:@""];
    NSString *moveToPath;
    if([pathExtension isEqualToString:@""]) {
        moveToPath = [NSString stringWithFormat:@"%@%@",pathNew,tofilePath];
        //NSLog(@"%@",moveToPath);
    }else {
        moveToPath = [NSString stringWithFormat:@"%@%@.%@",pathNew,tofilePath,pathExtension];
        //NSLog(@"%@",moveToPath);
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //通过移动该文件对文件重命名
    BOOL isDir;
    BOOL isExist = [fileManager fileExistsAtPath:moveToPath isDirectory:&isDir];
    if((!isDir) && isExist) {
        return NO;
    }
    BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil];
    if (isSuccess) {
        //NSLog(@"rename success");
        [self getDataFromDOC];
        [self.fileList reloadData];
    }else{
        //NSLog(@"rename fail");
        return NO;
    }
    
    return YES;
}


//文件夹重命名



//成功or失败提示
- (void)showTip:(NSString *)tip {
    UIAlertController *SuccessTip = [UIAlertController alertControllerWithTitle:tip message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

    }];
    [SuccessTip addAction:sure];
    [self.view.window.rootViewController presentViewController:SuccessTip animated:YES completion:nil];
}




@end
