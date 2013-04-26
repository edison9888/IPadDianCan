//
//  MainViewController.m
//  iPadDianCan
//
//  Created by 李炜 on 13-4-24.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "MainViewController.h"
#import "AFRestAPIClient.h"
#import "AFHTTPRequestOperation.h"
#import "Category.h"
#import "CategoryCell.h"
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize foodTable;
@synthesize allCategores;
-(id)init{
    self=[super init];
    if (self) {
        foodTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        [iv setImage:[UIImage imageNamed:@"MainViewBg"]];
        [self.view addSubview:iv];
        [iv release];
        UIImageView *ivtbbg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        [ivtbbg setImage:[UIImage imageNamed:@"MainViewBg"]];
        ivtbbg.tag=100;
        [foodTable setBackgroundView:ivtbbg];
        [ivtbbg release];
        allCategores=[[NSMutableArray alloc] init];
        foodTable.delegate=self;
        foodTable.dataSource=self;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *pathCategory=[NSString stringWithFormat:@"restaurants/%d/categories",2];
    NSString *pathRepice=[NSString stringWithFormat:@"restaurants/%d/recipes",2];
    NSString *udid=[ud objectForKey:@"udid"];
    [[AFRestAPIClient sharedClient] setDefaultHeader:@"X-device" value:udid];

    [[AFRestAPIClient sharedClient] getPath:pathCategory parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"返回内容: %@", responseObject);
        NSArray *list = (NSArray*)responseObject;
        for (int i=0; i<list.count;i++) {
            NSDictionary *dn=[list objectAtIndex:i];
            Category *category=[[Category alloc] initWithDictionary:dn];
            [allCategores addObject:category];
            [category release];
        }
        [[AFRestAPIClient sharedClient] getPath:pathRepice parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *list = (NSArray*)responseObject;
            for (int i=0; i<list.count;i++) {
                NSDictionary *dn=[list objectAtIndex:i];
                Recipe *recipe=[[Recipe alloc] initWithDictionary:dn];
                for (Category *category in allCategores) {
                    if (recipe.cid==category.cid) {
                        [category.allRecipes addObject:recipe];
                    }
                }
                [recipe release];
            }
            [self.view addSubview:foodTable];
            UIImageView *iv=(UIImageView *)[self.view viewWithTag:100];
            [iv removeFromSuperview];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableSouceDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return allCategores.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Category *category=[allCategores objectAtIndex:indexPath.section];
    NSString *SectionsTableIdentifier = category.name;
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[[CategoryCell alloc]
				 initWithStyle:UITableViewCellStyleSubtitle
				 reuseIdentifier:SectionsTableIdentifier] autorelease];
        cell.category=category;
    }
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Category *category=[allCategores objectAtIndex:indexPath.section];
    NSInteger row=category.allRecipes.count/3;
    if ((category.allRecipes.count%3)>0) {
        row+=1;
    }
    return 220*row+10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView=[[[UIView alloc] init] autorelease];
    UIImageView* customView = [[UIImageView alloc] init];
    [customView setImage:[UIImage imageNamed:@"CategoryHeadBg"]];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    Category *category=[allCategores objectAtIndex:section];
    headerLabel.text=[NSString stringWithFormat:@"%@(%d)", category.name,category.allRecipes.count];
    [headerLabel sizeToFit];
    CGRect rect=headerLabel.frame;
    rect.origin.x=(768-rect.size.width)/2;
    rect.size.width+=10;
    headerLabel.frame=rect;
    rect.origin.x-=5;
    [customView setFrame:rect];
    [headerView addSubview:customView];
    [headerView addSubview:headerLabel];
    [customView release];
    [headerLabel release];
    return headerView;
}

-(void)dealloc{
    [foodTable release];
    [allCategores release];
    [super dealloc];
}
@end
