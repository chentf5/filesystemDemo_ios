//
//  MoveView.m
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/16.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoveView.h"
#import "FileModel.h"
#import <Masonry.h>

#define WIDTH self.view.frame.size.width
#define HIGHT self.view.frame.size.height

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define LENView 400.0
@interface MoveView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *fileList;
@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong)NSMutableArray *filesArray;
//@property(nonatomic,strong)NSMutableArray *filesMuArray;
@property(nonatomic,strong)NSMutableArray *filesDetails;

@property(nonatomic,strong)NSMutableArray<__kindof FileModel *> *data;
@property(nonatomic,strong)UILabel *pathLabel;


@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UIView *parentView;

@end


@implementation MoveView

- (instancetype)initWithFrame:(CGRect)frame andFolderName:(NSString *)folder andPath:(NSString *)path{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupContent];
        self.foldername = folder;
        self.fromPath = path;
        [self getDataFromDOC];
        [self.contentView addSubview:self.fileList];
        [self.contentView addSubview:self.pathLabel];
        self.fileList.delegate = self;
        self.fileList.dataSource = self;
        UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 800, self.frame.size.width, 50)];
        self.fileList.tableFooterView = footer;
        
        NSMutableArray *t = [self setUpTree];
        NSLog(@"the tree is  %@",t);
        
        self.data = [NSMutableArray new];
        for (int i = 0; i < t.count; i++) {
            FileModel *foldCellModel = [FileModel modelWithDic:(NSDictionary *)t[i]];
            [self.data addObject:foldCellModel];
        }
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        
        NSString *folderpath = [NSString stringWithFormat:@"%@/t",docPath];
        self.toPath = folderpath;
    }
    
    return self;
}
 
- (void)setupContent {
   
    
    //self.pathLabel.backgroundColor = [UIColor grayColor];
    
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)]];
    
    if (_contentView == nil) {
                
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, LENView, self.frame.size.width, self.frame.size.height-LENView)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        // 右上角关闭按钮
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeBtn.frame = CGRectMake(self.contentView.frame.size.width-40, 10, 20, 20);
        [self.closeBtn setImage:[UIImage imageNamed:@"icon/cancle"] forState:UIControlStateNormal];
        [self.closeBtn setImage:[UIImage imageNamed:@"icon/close_select"] forState:UIControlStateSelected];
        [self.closeBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.closeBtn];
        //移动按钮
        self.moveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moveBtn.frame = CGRectMake(self.contentView.frame.size.width-70, 10, 20, 20);
        [self.moveBtn setImage:[UIImage imageNamed:@"icon/move1"] forState:UIControlStateNormal];
        [self.moveBtn setImage:[UIImage imageNamed:@"icon/move_select"] forState:UIControlStateSelected];
        
        [self.moveBtn addTarget:self action:@selector(moveFile) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.moveBtn];
        
    }
}


- (void)showView:(UIView *)firstView {
    if(!firstView) return;
    [firstView addSubview:self];
    [firstView addSubview:self.contentView];
    //self.parentView = firstView;
    [self.contentView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height-LENView)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [self.contentView setFrame:CGRectMake(0, LENView, self.frame.size.width, self.frame.size.height-LENView)];
        
    } completion:nil];
}

- (void)hideView {
    [self.contentView setFrame:CGRectMake(0, self.frame.size.height - LENView, self.frame.size.width, LENView)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [self.contentView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height-LENView)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [self.contentView removeFromSuperview];
                         
                     }];
    
}

- (UILabel *)pathLabel  {
    if(_pathLabel == nil)   {
        _pathLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0,self.frame.size.width-45, 50)];
        [_pathLabel setText:@"/t"];
        [_pathLabel setFont:[UIFont systemFontOfSize:15 weight:0.5]];
        //_pathLabel.textColor = [UIColor blueColor];
    }
    return _pathLabel;
}
- (UITableView *)fileList   {
    if(_fileList == nil)    {
        _fileList = [[UITableView alloc]initWithFrame:CGRectMake(0, 50.0, self.frame.size.width, self.frame.size.height-LENView-50.0) style:UITableViewStylePlain];
        
        
    }
    return _fileList;
}


#pragma mark UITableViewDelegate method

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
    if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        }
    //title
    FileModel *foldCellModel = self.data[indexPath.row];
    cell.textLabel.text = foldCellModel.text;

    //获取此时选中路径
    NSString *path = [self nowPath:foldCellModel];
    NSLog(@"%@",path);
    //self.pathLabel.text = path;
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];

    NSString *folderpath = [NSString stringWithFormat:@"%@/t/%@",docPath,path];
    NSLog(@"%@",folderpath);
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    [fm fileExistsAtPath:folderpath isDirectory:&isDir];
    if(isDir) {
        NSLog(@"this is a dir");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.userInteractionEnabled = NO;
    }

//
//     cell.separatorInset = UIEdgeInsetsMake(0, 20, 10, 20);
    return cell;
}

//- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.data.count;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView   {
//    return 1;
//}
//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
//    FileModel *foldCellModel = self.data[indexPath.row];
//    return foldCellModel.level.intValue;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *identifier = @"identifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//
//    FileModel *foldCellModel = self.data[indexPath.row];
//    cell.textLabel.text = foldCellModel.text;
//
//    return cell;
//}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileModel *foldCellModel = self.data[indexPath.row];
    return foldCellModel.level.intValue;
}

#pragma mark UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.3f];
//    NSInteger rowIndex = indexPath.row;
//    NSDictionary *nowfile = [self.filesDetails objectAtIndex:rowIndex];
//    NSString *nextfoldername = [NSString stringWithFormat:@"%@/%@",self.foldername,[self.filesArray objectAtIndex:rowIndex]];
//    //NSLog(@"%@",nextfoldername);
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
//    NSString *nextPath = [NSString stringWithFormat:@"%@/%@",docPath,nextfoldername];
//    NSString *fileType = [nowfile valueForKey:@"NSFileType"];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    [tableView beginUpdates];
//    if([fileType isEqualToString:@"NSFileTypeDirectory"])  {
//        //NSLog(@"dfasfsd");
//        //Data
//        NSArray *nextdata = [fm contentsOfDirectoryAtPath:nextPath error:nil];
//        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:((NSRange){indexPath.row + 1,nextdata.count})];
//        [self.filesArray insertObjects:nextdata atIndexes:indexes];
//        //UI
//        NSMutableArray *indexPaths = [NSMutableArray new];
//        for (int i = 0; i < nextdata.count; i++) {
//            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
//            [indexPaths addObject:insertIndexPath];
//        }
//        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    }else if([fileType isEqualToString:@"NSFileTypeRegular"])    {
//        //do nothing
//        //NSLog(@"fdsfasdf");
//    }
//    [tableView endUpdates];
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    FileModel *didSelectFoldCellModel = self.data[indexPath.row];
//    
//    [tableView beginUpdates];
//    if (didSelectFoldCellModel.belowCount == 0) {
//        
//        //Data
//        NSArray *submodels = [didSelectFoldCellModel open];
//        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:((NSRange){indexPath.row + 1,submodels.count})];
//        [self.data insertObjects:submodels atIndexes:indexes];
//        
//        //Rows
//        NSMutableArray *indexPaths = [NSMutableArray new];
//        for (int i = 0; i < submodels.count; i++) {
//            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
//            [indexPaths addObject:insertIndexPath];
//        }
//        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//        
//    }else {
//        
//        //Data
//        NSArray *submodels = [self.data subarrayWithRange:((NSRange){indexPath.row + 1,didSelectFoldCellModel.belowCount})];
//        [didSelectFoldCellModel closeWithSubmodels:submodels];
//        [self.data removeObjectsInArray:submodels];
//        
//        //Rows
//        NSMutableArray *indexPaths = [NSMutableArray new];
//        for (int i = 0; i < submodels.count; i++) {
//            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
//            [indexPaths addObject:insertIndexPath];
//        }
//        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    }
//    [tableView endUpdates];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FileModel *didSelectFoldCellModel = self.data[indexPath.row];
    //获取此时选中路径
    NSString *path = [self nowPath:didSelectFoldCellModel];
    NSLog(@"%@",path);

    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];

    NSString *folderpath = [NSString stringWithFormat:@"%@/t/%@",docPath,path];
    NSLog(@"%@",folderpath);
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    [fm fileExistsAtPath:folderpath isDirectory:&isDir];

    if(!isDir) {
        NSLog(@"this is a file");
        return;
    }
    self.pathLabel.text = [NSString stringWithFormat:@"/t/%@",path];
    self.toPath = [NSString stringWithFormat:@"%@/t/%@",docPath,path];
    [tableView beginUpdates];
    if (didSelectFoldCellModel.belowCount == 0) {

        //Data
        NSArray *submodels = [didSelectFoldCellModel open];
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:((NSRange){indexPath.row + 1,submodels.count})];
        [self.data insertObjects:submodels atIndexes:indexes];

        //Rows
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (int i = 0; i < submodels.count; i++) {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
            [indexPaths addObject:insertIndexPath];
        }
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

    }else {

        //Data
        NSArray *submodels = [self.data subarrayWithRange:((NSRange){indexPath.row + 1,didSelectFoldCellModel.belowCount})];
        [didSelectFoldCellModel closeWithSubmodels:submodels];
        [self.data removeObjectsInArray:submodels];

        //Rows
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (int i = 0; i < submodels.count; i++) {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
            [indexPaths addObject:insertIndexPath];
        }
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    [tableView endUpdates];



}

//获取选中路径
- (NSString *)nowPath:(FileModel *)didSelectFoldCellModel  {
    NSMutableString *path = [NSMutableString stringWithFormat:@"%@",didSelectFoldCellModel.text];
       FileModel *now = didSelectFoldCellModel;
       while (true) {
           now = now.supermodel;
           if(now.level == 0)  break;
           NSString *a = [NSString stringWithFormat:@"%@/",now.text];
           [path insertString:a atIndex:0];
           
       }
       NSLog(@"%@",path);
       
    return path;
}

- (void)deselect{
    //取消选中状态
    [self.fileList deselectRowAtIndexPath:[self.fileList indexPathForSelectedRow] animated:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath   {
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 40;
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
    //NSArray *sub = [fm subpathsAtPath:folderpath];
    //NSLog(@"suboath sdfasdfsdfsd %@",sub);
    
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
    ////NSLog(@"alll%@",self.filesDetails);
}


- (void)refreshViewData {
    NSMutableArray *t = [self setUpTree];
    NSLog(@"the tree is  %@",t);
    [self.data removeAllObjects];
    //self.data = [NSMutableArray new];
    for (int i = 0; i < t.count; i++) {
        FileModel *foldCellModel = [FileModel modelWithDic:(NSDictionary *)t[i]];
        [self.data addObject:foldCellModel];
    }
}
//处理数据，形成树状结构
- (NSMutableArray *)setUpTree {
    NSMutableArray *result = [self getSubTree:self.foldername Level:0];
    return result;
}


- (NSMutableArray *)getSubTree:(NSString *)name Level:(int)level    {
    
    NSMutableArray *result = [NSMutableArray new];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    
    NSString *folderpath = [NSString stringWithFormat:@"%@/%@",docPath,name];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *nextfileArray = [fm contentsOfDirectoryAtPath:folderpath error:nil];
    //NSLog(@"%@",folderpath);
   
    for(id filestr in nextfileArray) {
       
        NSMutableDictionary *now = [NSMutableDictionary new];
        //NSMutableDictionary *now = [self getSubTree:filestr];
        BOOL isDir;
        NSString *nowfilePath = [NSString stringWithFormat:@"%@/%@",folderpath,filestr];
        [fm fileExistsAtPath:nowfilePath isDirectory:&isDir];
        
        [now setObject:filestr forKey:@"text"];
        [now setObject:[NSNumber numberWithInt:level] forKey:@"level"];
        if(isDir)   {
            NSLog(@"%@ is a dir",filestr);
            NSString *nextpath = [NSString stringWithFormat:@"%@/%@",name,filestr];
            NSLog(@"%@",nextpath);
            level++;
            NSMutableArray *next =  [self getSubTree:nextpath Level:level];
            [now setObject:next forKey:@"submodels"];
            level--;
        }
        [result addObject:now];
    }
    
    return result;
    
}




//移动文件文件夹逻辑操作
- (void)moveFile {
    NSLog(@"move the file or the folder to");
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    [fm fileExistsAtPath:self.fromPath isDirectory:&isDir];
    //NSString *name = [self.fromPath pathComponents];
    NSString *lastPathComponent = [NSString new];
    //获取文件名： 视频.MP4
    lastPathComponent = [self.fromPath lastPathComponent];
    //NSString *extend = [self.fromPath pathExtension];
    NSString *toPathFinal = [NSString stringWithFormat:@"%@/%@",self.toPath,lastPathComponent];
    NSLog(@"the to path is %@",toPathFinal);
    if(!isDir)  {
        NSError *error;
        [fm moveItemAtPath:self.fromPath toPath:toPathFinal error:&error];
        if(error == nil)    {
            
            NSLog(@"move success");
        }
    }
    [self hideView];
   // [self refreshViewData];
    
}



@end
