//
//  FolderHandle.m
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/18.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FolderHandle.h"

@interface FolderHandle()<NSFileManagerDelegate>

@end

@implementation FolderHandle {
    
}
//foldername xxx path doc/t/xxxx/xxx
+ (BOOL)createFolder:(NSString *)Foldername path:(NSString *)path {
    NSString *newPath = [NSString stringWithFormat:@"%@/%@",path,Foldername];
    NSLog(@"%@",newPath);
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    BOOL isDir;
    BOOL isExist = [fm fileExistsAtPath:newPath isDirectory:&isDir];
    if(isDir == 1 && isExist == 1)  {
        return NO;
    }else {
        [fm createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    if(error != nil) return NO;
    return YES;

}


//folderpath doc/t/xxx/xxx
+ (BOOL)delectFolder:(NSString *)folderPath{
    NSFileManager *fm = [NSFileManager defaultManager];
    //NSString *nowPath = [NSString stringWithFormat:@"%@/%@",foldername,]
    BOOL isSuccess = [fm removeItemAtPath:folderPath error:nil];
    return isSuccess;
}//删除
// xxx/xxx
+ (BOOL)copyFolder:(NSString *)Foldername {
    
    NSString *newfoldername = [NSString stringWithFormat:@"%@的副本",Foldername];
    NSLog(@"copy newfoldername:%@",newfoldername);
    BOOL isSuccess = [self renameFolder:newfoldername path:Foldername];
    return isSuccess;
}//复制


//newName xxx/xxx   foldername = xxx/xxxxz
+ (BOOL)renameFolder:(NSString *)newName path:(NSString *)foldername{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *beforeFolder = [NSString stringWithFormat:@"%@/%@",docPath,foldername];
    NSString *afterFolder = [NSString stringWithFormat:@"%@/%@", docPath,newName];
    BOOL isDir;
    BOOL isexsamename = [fm fileExistsAtPath:afterFolder isDirectory:&isDir];
    if(isexsamename && isDir)   {
        return NO;
    }
    [fm createDirectoryAtPath:afterFolder withIntermediateDirectories:YES attributes:nil error:nil];


    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:beforeFolder];
    NSString *path;
    BOOL isSuccess = YES;
    while ((path = [dirEnum nextObject]) != nil) {
          isSuccess = [fm moveItemAtPath:[NSString stringWithFormat:@"%@/%@",beforeFolder,path]
                      toPath:[NSString stringWithFormat:@"%@/%@",afterFolder,path]
                       error:NULL];
    }
    
    BOOL is = [fm removeItemAtPath:beforeFolder error:nil];
    return (is&&isSuccess);
}//重命名 && 移动
//frompath xxx/xxx topath xxx/xxx
+ (BOOL)moveFolder:(NSString *)fromPath with:(NSString *)toPath{
    BOOL isSuccess = [self renameFolder:toPath path:fromPath];
    return isSuccess;
}
@end


