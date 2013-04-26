//
//  MainViewController.h
//  iPadDianCan
//
//  Created by 李炜 on 13-4-24.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UITableView *foodTable;
@property(nonatomic,retain)NSMutableArray *allCategores;//所有种类
@end
