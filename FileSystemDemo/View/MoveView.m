//
//  MoveView.m
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/16.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoveView.h"
#import <Masonry.h>

#define WIDTH self.view.frame.size.width
#define HIGHT self.view.frame.size.height
#define LENView 400.0
@interface MoveView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *fileList;
@property(nonatomic,strong) UIButton *btnBack;
@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong)NSMutableArray *filesArray;
//@property(nonatomic,strong)NSMutableArray *filesMuArray;
@property(nonatomic,strong)NSMutableArray *filesDetails;
@property(nonatomic,strong) NSString *foldername;
@end


@implementation MoveView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupContent];
        self.foldername = @"t";
        [self getDataFromDOC];
        [self.contentView addSubview:self.fileList];
        self.fileList.delegate = self;
        self.fileList.dataSource = self;
        UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 800, self.frame.size.width, 50)];
        self.fileList.tableFooterView = footer;
    }
    
    return self;
}
 
- (void)setupContent {
   
    
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)]];
    
    if (_contentView == nil) {
                
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, LENView, self.frame.size.width, self.frame.size.height-LENView)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        // 右上角关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(self.contentView.frame.size.width-40, 15, 20, 20);
        [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:closeBtn];
    }
}


- (void)showView:(UIView *)firstView {
    if(!firstView) return;
    [firstView addSubview:self];
    [firstView addSubview:self.contentView];
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


- (UITableView *)fileList   {
    if(_fileList == nil)    {
        _fileList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-LENView-25.0) style:UITableViewStylePlain];
        
        
    }
    return _fileList;
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
    NSLog(@"%@",nextfoldername);
    NSString *fileType = [nowfile valueForKey:@"NSFileType"];
    if([fileType isEqualToString:@"NSFileTypeDirectory"])  {
        
        
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
    return 40;
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
    NSArray *tfilesArray = [fm contentsOfDirectoryAtPath:folderpath error:nil];
    NSLog(@"subpath = %@",tfilesArray);
    self.filesArray = [NSMutableArray arrayWithArray:tfilesArray];
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



@end
