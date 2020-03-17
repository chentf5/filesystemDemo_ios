//
//  FileModel.h
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/17.
//  Copyright © 2020 bytedance. All rights reserved.
//

#ifndef FileModel_h
#define FileModel_h
#import<Foundation/Foundation.h>

@interface FileModel : NSObject
@property(nonatomic,copy) NSString *text;
@property(nonatomic,copy) NSString *level;
//...

@property(nonatomic,assign) NSUInteger belowCount;
@property(nullable,nonatomic) FileModel *supermodel;
@property(nonatomic,strong) NSMutableArray<__kindof FileModel *> *submodels;

+ (instancetype)modelWithDic:(NSDictionary *)dic;
- (NSArray *)open;
- (void)closeWithSubmodels:(NSArray *)submodels;

@end

#endif /* FileModel_h */
