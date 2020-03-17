//
//  MoveView.h
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/16.
//  Copyright © 2020 bytedance. All rights reserved.
//

#ifndef MoveView_h
#define MoveView_h
#import<UIKit/UIKit.h>
#import<Foundation/Foundation.h>

@interface MoveView : UIView
@property(nonatomic,strong) NSString *foldername;
- (void)showView:(UIView *)firstView;
- (void)hideView;
- (instancetype)initWithFrame:(CGRect)frame andFolderName:(NSString *)folder andPath:(NSString *)path;
- (void)refreshViewData;
@property(nonatomic,strong) UIButton *moveBtn;
@property(nonatomic,strong) NSString *toPath;
@property(nonatomic,strong) NSString *fromPath;
@end

#endif /* MoveView_h */
