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
#import <Masonry/Masonry.h>
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]


@interface TextViewController()<UITextViewDelegate>
@property(nonatomic,strong) UITextView *articleTitle;
@property(nonatomic,strong) UILabel *titleplach;
@property(nonatomic,strong) UILabel *tip;
@property(nonatomic,strong) UITextView *articleWord;
@property(nonatomic,strong) UILabel *wordplach;

@end

@implementation TextViewController  {
    //sqlite3 *_db;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.title = @"写文章";
    
   
    
    self.articleTitle.delegate = self;
    
    self.title = @"写文件";
    self.articleTitle.scrollEnabled = YES;
     self.articleTitle.backgroundColor = [UIColor whiteColor];
    // _articleTitle.userInteractionEnabled = NO;
     self.articleTitle.autoresizingMask = UIViewAutoresizingFlexibleHeight;
     [self.articleTitle setFont:[UIFont systemFontOfSize:20.0]];
   
    [self.view addSubview:self.articleTitle];
    self.articleTitle.tag = 0;
    //打开数据库
    //[self openSqlDataBase];
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [topView setItems:buttonsArray];
    [self.articleTitle setInputAccessoryView:topView];
    
    
    self.articleWord.tag = 1;
    self.articleWord.delegate = self;
    self.articleWord.scrollEnabled = YES;
      self.articleWord.backgroundColor = [UIColor whiteColor];
     // _articleTitle.userInteractionEnabled = NO;
      self.articleWord.autoresizingMask = UIViewAutoresizingFlexibleHeight;
      [self.articleWord setFont:[UIFont systemFontOfSize:18.0]];
    [self.view addSubview:self.articleWord];
     [self.articleWord setInputAccessoryView:topView];
    //self.articleWord.backgroundColor = [UIColor blackColor];
    
    UIToolbar * topView2 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [topView2 setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton2 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard2)];
    NSArray * buttonsArray2 = [NSArray arrayWithObjects:btnSpace2, doneButton2, nil];
    [topView2 setItems:buttonsArray2];
    [self.articleWord setInputAccessoryView:topView2];
    
    
    
     [self setupPlaceHolder];
    [self UIset];
    
    
    
    
    //右上按钮
     NSMutableArray *btnArray = [NSMutableArray arrayWithCapacity:2];
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon/addfile"] style:UIBarButtonItemStyleDone target:self action:@selector(saveFile)];
    [btnArray addObject:save];
    //创建文件夹
    UIBarButtonItem *cancle = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon/addfolder"] style:UIBarButtonItemStyleDone target:self action:@selector(cancleSave)];
    [btnArray addObject:cancle];
    
    self.navigationController.navigationBar.topItem.rightBarButtonItems = btnArray;
}

- (UITextView *)articleTitle    {
    if(_articleTitle == nil)    {
//        NSTextContainer *containeriTitle = [[NSTextContainer alloc]initWithSize:CGSizeMake(WIDTH, 100)];
//        containeriTitle.widthTracksTextView = YES;
        _articleTitle = [[UITextView alloc]init];
        
    }
    return _articleTitle;
}

- (UITextView *)articleWord {
    if(_articleWord == nil) {
        _articleWord = [[UITextView alloc]init];
    }
    return _articleWord;
}
- (void)setupPlaceHolder
{
    UILabel *placeHolder = [[UILabel alloc] init];
    self.titleplach = placeHolder;
    [placeHolder setFont:[UIFont systemFontOfSize:20.0]];
    placeHolder.text = @"输入文件名";
    placeHolder.textColor = [UIColor lightGrayColor];
    placeHolder.numberOfLines = 0;
    placeHolder.contentMode = UIViewContentModeTop;
    [self.articleTitle addSubview:self.titleplach];
    
    UILabel *placeHolder2 = [[UILabel alloc]init];
    self.tip = placeHolder2;
    [placeHolder2 setFont:[UIFont systemFontOfSize:10.0]];
    placeHolder2.textColor = [UIColor redColor];
    placeHolder2.text = @"文件名长度不超过50字符";
    placeHolder2.numberOfLines = 0;
    placeHolder2.contentMode = UIViewContentModeTop;
    //placeHolder2.alpha = ;
    self.tip.alpha = 0;
    //self.tip.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tip];
    //self.tip.backgroundColor = [UIColor grayColor];
    
     UILabel *placeHolder3 = [[UILabel alloc]init];
    
    self.wordplach = placeHolder3;
    [placeHolder3 setFont:[UIFont systemFontOfSize:18.0]];
    placeHolder3.textColor = [UIColor lightGrayColor];
    placeHolder3.text = @"输入文件内容";
    placeHolder3.numberOfLines = 0;
    placeHolder3.contentMode = UIViewContentModeTop;
    //placeHolder3.backgroundColor = [UIColor blackColor];
    [self.articleWord addSubview:self.wordplach];
}
//UIset
- (void)UIset {
    [self.articleTitle mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(@100);
           make.left.equalTo(self.view.mas_left).with.offset(15.0);
           make.bottom.equalTo(self.tip.mas_top).with.offset(0);
           make.right.equalTo(self.view.mas_right).offset(-15.0);
           make.height.lessThanOrEqualTo(@50);
       }];
    [self.titleplach mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.articleTitle).insets(UIEdgeInsetsMake(8, 5, 8, 5));
        
    }];

    [self.tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.articleTitle.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(15.0);
        make.bottom.equalTo(self.articleWord.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right).offset(2.0);
        make.height.mas_equalTo(10);

    }];
    
    [self.articleWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tip.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(15.0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right).offset(-15.0);
    }];
    [self.wordplach mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.articleWord).insets(UIEdgeInsetsMake(9, 5, 10, 5));
        //make.height.mas_equalTo(20.0);
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.tag == 0)   {
        if (textView.text.length == 0) {
            self.titleplach.alpha = 1;
            self.tip.alpha = 0;
           
            
        } else if(textView.text.length < 50) {
            self.titleplach.alpha = 0;
            self.tip.alpha = 0;
           
        }else {
            textView.text = [textView.text substringToIndex:50];
            self.titleplach.alpha = 0;
            self.tip.alpha = 1;
           
        }
    }
    else {
        if (textView.text.length == 0) {
           self.wordplach.alpha = 1;
        }else {
            self.wordplach.alpha = 0;
    
        }
    }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView   {
    
    NSLog(@"fffffffffffffff");
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if(textView.tag == 0)   {
        NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
        if (str.length > 50)
        {
            NSRange range = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 50)];
            textView.text = [textView.text substringWithRange:range];
            return NO;
        }
    }
    
    return YES;
}




//关闭键盘
-(void) dismissKeyBoard{
    [self.articleTitle resignFirstResponder];
}
-(void) dismissKeyBoard2{
    [self.articleWord resignFirstResponder];
}


- (void)saveFile {
    NSString *fileName = self.articleTitle.text;
    NSString *nowPath = [NSString stringWithFormat:@"%@/%@",self.folderPath,fileName];
    NSLog(@"%@",nowPath);
    NSString *content = self.articleWord.text;
    NSData *data =  [content dataUsingEncoding:NSUTF8StringEncoding];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    [fm createFileAtPath:nowPath contents:data attributes:nil];
    [self showTip:@"成功创建文件"];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)cancleSave  {
    [self.navigationController popViewControllerAnimated:YES];
}


//成功or失败提示
- (void)showTip:(NSString *)tip {
    UIAlertController *SuccessTip = [UIAlertController alertControllerWithTitle:tip message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

    }];
    [SuccessTip addAction:sure];
    [self presentViewController:SuccessTip animated:YES completion:nil];
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
