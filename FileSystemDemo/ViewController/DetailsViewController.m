//
//  DetailsViewController.m
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/16.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailsViewController.h"

#import <Masonry.h>
#define WIDTH self.view.frame.size.width
#define HIGHT self.view.frame.size.height

@interface DetailsViewController()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *detailsTable;
@property(nonatomic,strong)NSDictionary *categoryDic;

@end

@implementation DetailsViewController

- (instancetype)initWithDetails:(NSDictionary *)t_details andTitle:(NSString *)t_title andLoacl:(NSString *)t_local{
    self = [super init];
    self.details = t_details;
    self.titleStr = t_title;
    self.locationStr = t_local;
    return self;
}
- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.detailsTable];
    //self.detailsTable.backgroundColor = [UIColor grayColor];
    self.detailsTable.delegate = self;
    self.detailsTable.dataSource = self;
    //NSLog(@"selffdsfdsfsfdsfdsfdsfds %@",self.details);
    [self.detailsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(20);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
}

- (UITableView *)detailsTable   {
    if(_detailsTable == nil)    {
        _detailsTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT) style:UITableViewStylePlain];
        _detailsTable.estimatedRowHeight = 80.0;
        _detailsTable.rowHeight = UITableViewAutomaticDimension;
        _detailsTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _detailsTable;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cellID"];
    long rowIndex = indexPath.row;
    [cell setSeparatorInset:UIEdgeInsetsZero];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    if(rowIndex == 0)   {
        //category
        cell.textLabel.text = @"种类:   ";
        if([[self.details valueForKey:@"NSFileType"] isEqualToString:@"NSFileTypeRegular"]) {
            NSArray *temp = [self.titleStr componentsSeparatedByString:@"."];
            NSString *type = [temp lastObject];
            NSString *t = self.categoryDic[type];
            if(type != nil) {
                cell.detailTextLabel.text = t;
            }else {
                cell.detailTextLabel.text = @"未知文件类型";
            }
            
        }else if([[self.details valueForKey:@"NSFileType"] isEqualToString:@"NSFileTypeDirectory"])   {
            cell.detailTextLabel.text = @"文件夹";
        }else   {
            cell.detailTextLabel.text = @"未知文件类型";
        }
    }else if(rowIndex == 1)  {
        cell.textLabel.text = @"大小:   ";
        NSString *sizeOfFile = self.details[@"NSFileSize"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 字节",sizeOfFile];
        
       
    }else if(rowIndex == 2)  {
        //location
        cell.textLabel.text = @"位置:   ";
        cell.detailTextLabel.text = self.locationStr;
        
    }else if(rowIndex == 3)  {
        cell.textLabel.text = @"创建时间:    ";
        NSDate *createTime = self.details[@"NSFileCreationDate"];
        NSString *createStr = [format stringFromDate:createTime];
        cell.detailTextLabel.text = createStr;
    }else if(rowIndex == 4) {
        cell.textLabel.text = @"修改时间:   ";
        NSDate *modifyTime = self.details[@"NSFileModificationDate"];
        NSString *modifyStr = [format stringFromDate:modifyTime];
        cell.detailTextLabel.text = modifyStr;
    }else {
        NSLog(@"details view cell has error!");
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView   {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titleStr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section   {
    return 50.0;
}

- (NSDictionary *)categoryDic   {
    if(_categoryDic == nil) {
        _categoryDic = @{
            @"txt":@"纯文稿文本",
            @"html":@"HTML文本",
            @"htm":@"HTML文本",
            @"shtml":@"HTML文本",
            @"xhtml":@"HTML文本",
            @"pdf":@"PDF文本",
            @"doc":@"WORD文本",
            @"docx":@"WORD文本",
            @"jpg":@"JPG图片",
            @"jpeg":@"JPEG图片",
            @"png":@"PNG图片",
        };
    }
    return _categoryDic;
}

@end
