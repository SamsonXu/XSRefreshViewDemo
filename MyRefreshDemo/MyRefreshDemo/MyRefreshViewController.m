//
//  MyRefreshViewController.m
//  TestProject
//
//  Created by iOS－Dev on 2017/5/22.
//  Copyright © 2017年 iOS－Dev. All rights reserved.
//

#import "MyRefreshViewController.h"
#import "MyRefreshView.h"
#import "Define.h"
#import "HttpTool.h"
@interface MyRefreshViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MyRefreshView *refreshView;

@end

@implementation MyRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor grayColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor grayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
    
    _refreshView = [MyRefreshView refreshViewWithScrollView:self.tableView];
    
}

- (void)getData{
    
    NSString *url = @"http://news-at.zhihu.com/api/4/news/latest";
    [[HttpTool share]requestWithMethod:KGET url:url parameters:nil sucBlock:^(id responseObject) {
        [self.refreshView endRefresh];
        NSLog(@"result---%@",responseObject);
    } failBlock:^{
        
        [self.refreshView endRefresh];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ide = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ide];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"myRefreshCell%ld",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.contentOffset.y < -80) {
        [self getData];
    }
}

- (void)setExtraCellLineHidden:(UITableView *)tableView{
    
    UIView *tempView = [[UIView alloc]init];
    tempView.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:tempView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
