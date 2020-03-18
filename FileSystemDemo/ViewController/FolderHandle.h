//
//  FolderHandle.h
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/18.
//  Copyright © 2020 bytedance. All rights reserved.
//

#ifndef FolderHandle_h
#define FolderHandle_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface FolderHandle : NSObject

+ (BOOL)createFolder:(NSString *)Foldername path:(NSString *)path;//创建
+ (BOOL)copyFolder:(NSString *)Foldername;//复制
+ (BOOL)moveFolder:(NSString *)fromPath with:(NSString *)toPath;//移动
+ (BOOL)renameFolder:(NSString *)newName path:(NSString *)foldername;//重命名
+ (BOOL)delectFolder:(NSString *)folderPath;//删除

@end

#endif /* FolderHandle_h */
