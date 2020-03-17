//
//  FileModel.m
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/17.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileModel.h"

@interface FileModel()

@end

@implementation FileModel

+ (instancetype)modelWithDic:(NSDictionary *)dic {
    FileModel *foldCellModel = [FileModel new];
    foldCellModel.text = dic[@"text"];
    foldCellModel.level = dic[@"level"];
    foldCellModel.belowCount = 0;
    
    foldCellModel.submodels = [NSMutableArray new];
    NSArray *submodels = dic[@"submodels"];
    for (int i = 0; i < submodels.count; i++) {
        FileModel *submodel = [FileModel modelWithDic:(NSDictionary *)submodels[i]];
        submodel.supermodel = foldCellModel;
        [foldCellModel.submodels addObject:submodel];
    }
    
    return foldCellModel;
}

- (NSArray *)open {
    NSArray *submodels = self.submodels;
    self.submodels = nil;
    self.belowCount = submodels.count;
    return submodels;
}

- (void)closeWithSubmodels:(NSArray *)submodels {
    self.submodels = [NSMutableArray arrayWithArray:submodels];
    self.belowCount = 0;
}

- (void)setBelowCount:(NSUInteger)belowCount {
    self.supermodel.belowCount += (belowCount - _belowCount);
    _belowCount = belowCount;
}


@end
