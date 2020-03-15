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


@interface TextViewController()<UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong) UITextField *articleTitle;
@property(nonatomic,strong) UITextView *articleWord;

@end

@implementation TextViewController  {
    sqlite3 *_db;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.title = @"写文章";
    [self.view addSubview:self.articleTitle];
    self.articleTitle.delegate = self;
    self.title = @"files";
    //打开数据库
    //[self openSqlDataBase];
}

- (UITextField *)articleTitle   {
    if(_articleTitle == nil)    {
        _articleTitle = [[UITextField alloc]initWithFrame:CGRectMake(20, 100,WIDTH-40,30)];
        _articleTitle.borderStyle = UITextBorderStyleNone;
        _articleTitle.placeholder = @"输入文章标题";
        _articleTitle.font = [UIFont fontWithName:@"Arial" size:25.0f];
        //_articleTitle.backgroundColor = RGBCOLOR(210, 210, 210, 1);
        _articleTitle.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _articleTitle.adjustsFontSizeToFitWidth = YES;
        _articleTitle.minimumFontSize = 15.0;
    }
    return _articleTitle;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField  {
    [self.articleTitle resignFirstResponder];
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string    {
    NSString *testStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if([testStr length] > 20)   {
        textField.text = [testStr substringToIndex:20];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                       message:@"字数超出20"
                                       preferredStyle:UIAlertControllerStyleAlert];
         
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"test3" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"不写了" style:UIAlertActionStyleCancel
        handler:^(UIAlertAction * action) {}];
        
        
        [alert addAction:defaultAction];
        [alert addAction:defaultAction2];
        [alert addAction:action2];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                NSLog(@"%@",textField.text);
            }];
        // 可以通过textFields方法，取出添加进去的TextField，然后对UITextField对象进行操作
        NSArray<UITextField *> *alertTextField = [alert textFields];
        UITextField *firstTextField = [alertTextField firstObject];
        firstTextField.text = @"firstTextField";
        [textField setText:firstTextField.text];
        alert.preferredAction = defaultAction;
        [self presentViewController:alert animated:YES completion:nil];
        NSString *docpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSLog(@"%@",docpath);
        return NO;
    }
    return YES;
}
//数据库操作
//打开数据库
- (void)openSqlDataBase {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [docPath stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"fileNamePath %@",fileName);
    //转化为c单词
    const char *cfilename = fileName.UTF8String;
    //打开数据库
    int result = sqlite3_open(cfilename, &_db);
    if(result == SQLITE_OK) {
        NSLog(@"成功打开数据库");
    }else{
        NSLog(@"失败");
    }
}
@end
