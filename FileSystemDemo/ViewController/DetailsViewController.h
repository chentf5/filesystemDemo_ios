//
//  DetailsViewController.h
//  FileSystemDemo
//
//  Created by bytedance on 2020/3/16.
//  Copyright © 2020 bytedance. All rights reserved.
//

#ifndef DetailsViewController_h
#define DetailsViewController_h
#import<UIKit/UIKit.h>
#import<Foundation/Foundation.h>
@interface DetailsViewController : UIViewController
@property(nonatomic,strong)NSDictionary  *details;
@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)NSString *locationStr;
- (instancetype)initWithDetails:(NSDictionary *)t_details andTitle:(NSString *)t_title andLoacl:(NSString *)t_local;
@end

#endif /* DetailsViewController_h */
