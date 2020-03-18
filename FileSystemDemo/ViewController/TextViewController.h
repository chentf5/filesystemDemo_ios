//
//  TextViewController.h
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/10.
//  Copyright © 2020 bytedance. All rights reserved.
//

#ifndef TextViewController_h
#define TextViewController_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TextViewController : UIViewController
@property(nonatomic,strong)NSString *folderPath;
@property(nonatomic,strong)NSString *filename;
@property(nonatomic)BOOL isread;
@end

#endif /* TextViewController_h */
