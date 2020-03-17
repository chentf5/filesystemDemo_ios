//
//  TextViewController.m
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/10.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TextViewController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]


@interface TextViewController()<UITextViewDelegate>
@property(nonatomic,strong) UITextView *articleTitle;
@property(nonatomic,strong) UITextView *articleWord;

@end

@implementation TextViewController  {
    //sqlite3 *_db;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.title = @"写文章";
    [self.view addSubview:self.articleTitle];
    self.articleTitle.delegate = self;
    self.title = @"写文件";
    //打开数据库
    //[self openSqlDataBase];
}

- (UITextView *)articleTitle    {
    if(_articleTitle == nil)    {
        NSTextContainer *containeriTitle = [[NSTextContainer alloc]initWithSize:CGSizeMake(WIDTH, 100)];
        containeriTitle.widthTracksTextView = YES;
        _articleTitle = [[UITextView alloc]initWithFrame:CGRectMake(0, 200, WIDTH, 100) textContainer:containeriTitle];
        _articleTitle.scrollEnabled = NO;
        
    }
    return _articleTitle;
}


//数据库操作
//打开数据库
//- (void)openSqlDataBase {
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//    NSString *fileName = [docPath stringByAppendingPathComponent:@"student.sqlite"];
//    NSLog(@"fileNamePath %@",fileName);
//    //转化为c单词
//    const char *cfilename = fileName.UTF8String;
//    //打开数据库
//    int result = sqlite3_open(cfilename, &_db);
//    if(result == SQLITE_OK) {
//        NSLog(@"成功打开数据库");
//    }else{
//        NSLog(@"失败");
//    }
//}
@end
