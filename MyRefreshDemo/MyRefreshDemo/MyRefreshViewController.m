//
//  MyRefreshViewController.m
//  TestProject
//
//  Created by iOS－Dev on 2017/5/22.
//  Copyright © 2017年 iOS－Dev. All rights reserved.
//

#import "MyRefreshViewController.h"
#import "MyRefreshView.h"
#import "InfoModel.h"
#import "Define.h"
#import "HttpTool.h"
#import "UIImageView+WebCache.h"

#define ImgUrl @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496306699603&di=8f71a457657f0a8b572b1192f772871b&imgtype=0&src=http%3A%2F%2Fen.pimg.jp%2F009%2F318%2F385%2F1%2F9318385.jpg"
#define DataUrl @"http://c.m.163.com/nc/article/headline/T1348647853363/0-20.html"
@interface MyRefreshViewController ()<UITableViewDelegate,UITableViewDataSource>


/**
 数据列表
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 刷新视图
 */
@property (nonatomic, strong) MyRefreshView *refreshView;
/**
 数据源数组
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 头部视图
 */
@property (nonatomic, strong) UIImageView *headImageView;
@end

@implementation MyRefreshViewController

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self getData];
}

- (void)createUI{
    
    self.title = @"导航栏";
    self.navigationController.navigationBar.alpha = 0;
    self.view.backgroundColor = [UIColor grayColor];
     //默认值为yes，当视图中包含scrollView时，系统会自动调整scrollView的坐标，这里设置为NO
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor grayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //添加观察者，用来实现导航栏渐变效果
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [self setExtraCellLineHidden:self.tableView];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
    self.tableView.tableHeaderView = headView;
    
    [self.view addSubview:self.headImageView];
    
    //添加自定义刷新视图，不需要自定义刷新的去掉这两行代码
    _refreshView = [MyRefreshView refreshViewWithScrollView:self.tableView];
    [self.view addSubview:_refreshView];
}

- (void)getData{
    
    [[HttpTool share]requestWithMethod:KGET url:DataUrl parameters:nil sucBlock:^(id responseObject) {
        [self.refreshView endRefresh];
        
        self.dataArray = [InfoModel arrayOfModelsFromDictionaries:responseObject[@"T1348647853363"]];
        [_tableView reloadData];
        NSLog(@"result---%@",responseObject);
    } failBlock:^{
        
        [self.refreshView endRefresh];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ide = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ide];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide];
    }
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    InfoModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.contentOffset.y < -80) {
        [self getData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView != self.tableView) {
        return;
    }
    
    CGFloat y = scrollView.contentOffset.y;
    
    if (y < 0) {
        
        CGRect rect = _headImageView.frame;
        rect.origin.y = -30;
        rect.size.height = 180-y;
        rect.size.width = KScreenWidth*(rect.size.height/180);
        rect.origin.x = -(rect.size.width-KScreenWidth)/2.0;
        _headImageView.frame = rect;
        NSLog(@"height:%lf,width:%lf",_headImageView.frame.size.height,_headImageView.frame.size.width);
    }else{
        CGRect rect = _headImageView.frame;
        rect.origin.y = -30-y;
        rect.size.height = 180;
        rect.size.width = KScreenWidth;
        _headImageView.frame = rect;
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat y = [change[@"new"] CGPointValue].y;
        CGFloat alpha = 0;
        if (y > 200) {
            alpha = 1.0;
        }else if (y > 0){
            alpha = y/200.0;
        }
        self.navigationController.navigationBar.alpha = alpha;
    }
}

- (void)setExtraCellLineHidden:(UITableView *)tableView{
    
    UIView *tempView = [[UIView alloc]init];
    tempView.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:tempView];
    
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -30, KScreenWidth, 180)];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:ImgUrl]];
    }
    return _headImageView;
}

- (void)dealloc{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
