//
//  DetailsView.m
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/16.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailsView.h"
#import <Masonry.h>
@interface DetailsView()
@property(nonatomic,strong)NSDictionary *details;
@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UILabel *categroy;
@property(nonatomic,strong)UILabel *sizeLabel;
@property(nonatomic,strong)UILabel *location;
@property(nonatomic,strong)NSString *locationStr;
@property(nonatomic,strong)UILabel *createTime;
@property(nonatomic,strong)UILabel *modifyTime;
@property(nonatomic,strong)NSDictionary *categoryDic;
@end

@implementation DetailsView

- (instancetype)initWithDetails:(NSDictionary *)tempDetails andTitle:(NSString *)filename andLocation:(NSString *)loactionStr {
    self = [super init];
    if(tempDetails != nil)  {
        self.details = tempDetails;
        self.titleStr = filename;
        self.locationStr = loactionStr;
    }else {
        NSLog(@"error!");
    }
    return self;
}

- (void)setUpUI {
    //title 文件
    self.title = [[UILabel alloc]init];
    NSString *titleStr = [NSString stringWithFormat:@"名称：%@",self.titleStr];
    self.title.text = titleStr;
    [self.title setFont:[UIFont systemFontOfSize:15.0 weight:2.0]];
    
    //category
    self.categroy = [[UILabel alloc]init];
    if([[self.details valueForKey:@"NSFileType"] isEqualToString:@"NSFileTypeRegular"]) {
        NSArray *temp = [self.titleStr componentsSeparatedByString:@"."];
        NSString *type = [temp lastObject];
        [self.categroy setText:[NSString stringWithFormat:@"种类: %@",self.categoryDic[type]]];
    }else if([[self.details valueForKey:@"NSFileType"] isEqualToString:@"NSFileTypeDirectory"])   {
        [self.categroy setText:@"种类: 文件夹"];
    }else   {
        [self.categroy setText:@"种类: 未知w类型文件"];
    }
    
    
    //sizeLabel
    NSString *sizeOfFile = self.details[@"NSFileSize"];
    self.sizeLabel.text = [NSString stringWithFormat:@"大小: %@ 字节",sizeOfFile];
    
    //location
    self.location.text = [NSString stringWithFormat:@"位置: %@",self.locationStr];
    
    //createtime & modifytime
     NSDate *createTime = self.details[@"NSFileCreationDate"];
     NSDate *modifyTime = self.details[@"NSFileModificationDate"];
     NSDateFormatter *format = [[NSDateFormatter alloc]init];
     format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
     NSString *createStr = [format stringFromDate:createTime];
     NSString *modifyStr = [format stringFromDate:modifyTime];
    self.createTime.text = [NSString stringWithFormat:@"创建时间: %@",createStr];
    self.modifyTime.text = [NSString stringWithFormat:@"修改时间: %@",modifyStr];
    
    
    
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
