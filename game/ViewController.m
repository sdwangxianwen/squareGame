//
//  ViewController.m
//  game
//
//  Created by wang on 2018/8/15.
//  Copyright © 2018年 wang. All rights reserved.
//

#import "ViewController.h"
#import "demoModel.h"



@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property(nonatomic,strong) NSArray  *dataArr;
@property(nonatomic,assign) NSInteger setup;
@property (weak, nonatomic) IBOutlet UILabel *setupLabel;
@property(nonatomic,assign) NSInteger blockCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.setup = 0;
    self.blockCount = 2;
    _dataArr = [self getDataArr:self.blockCount];
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;

    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重新开始" style:(UIBarButtonItemStyleDone) target:self action:@selector(reset)];
}

-(void)reset {
    for (demoModel *model in _dataArr) {
        model.isSelected = NO;
    }
    self.setup = 0;
    self.setupLabel.text = @"所用步数:0";
    [_collectionView reloadData];
}

-(NSArray *)getDataArr :(NSInteger)count {
     NSMutableArray *tempArrM = [NSMutableArray array];
    for (NSInteger i = 0; i < count * count; i ++ ) {
        demoModel *model = [[demoModel alloc] init];
        [tempArrM addObject:model];
    }
    return tempArrM.copy;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake([UIScreen mainScreen].bounds.size.width/self.blockCount, [UIScreen mainScreen].bounds.size.width/self.blockCount);
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor =  [UIColor whiteColor];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
     demoModel *model = _dataArr[indexPath.row];
    if (model.isSelected) {
        cell.backgroundColor = [UIColor brownColor];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.setup ++ ;
    self.setupLabel.text = [NSString stringWithFormat:@"所用步数:%ld",self.setup];
    
    demoModel *model1 = _dataArr[indexPath.row];
    model1.isSelected = !model1.isSelected;
    demoModel *mode2;
    demoModel *mode3;
    demoModel *mode4;
    demoModel *mode5;
   
    //找出十字花
    NSInteger index = indexPath.row;
    if (index % self.blockCount != 0) {
        //左面的
        mode2 = _dataArr[indexPath.row - 1];
        mode2.isSelected = !mode2.isSelected;
    }
    if (indexPath.row / self.blockCount >= 1) {
        //上面的
        mode3 = _dataArr[indexPath.row - self.blockCount];
        mode3.isSelected = !mode3.isSelected;
    }
    if (indexPath.row / self.blockCount < self.blockCount - 1) {
        //下面的
        mode4 = _dataArr[indexPath.row + self.blockCount];
        mode4.isSelected = !mode4.isSelected;
    }
    if ((indexPath.row + 1) % self.blockCount != 0) {
        //右面的
        mode5 = _dataArr[indexPath.row + 1];
        mode5.isSelected = !mode5.isSelected;
    }
    [collectionView reloadData];
    [self changeSelectAll];
}

- (IBAction)finishBtnClick:(id)sender {
    self.blockCount ++ ;
    _dataArr = [self getDataArr:self.blockCount];
    self.setup = 0;
     self.setupLabel.text = @"所用步数:0";
    [_collectionView reloadData];
}
- (IBAction)cleanBtnClick:(id)sender {
    self.blockCount -- ;
    if (self.blockCount < 2) {
        self.blockCount = 2;
    }
    _dataArr = [self getDataArr:self.blockCount];
    self.setup = 0;
    self.setupLabel.text = @"所用步数:0";
    [_collectionView reloadData];
}
-(void)changeSelectAll {
    NSMutableArray *tempArrM = [NSMutableArray array];
    for (demoModel *model in _dataArr) {
        if (!model.isSelected) {
            return;
        } else {
            [tempArrM addObject:model];
        }
    }
    if (tempArrM.count == _dataArr.count) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"恭喜您进入下一关" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            self.blockCount ++;
            self.dataArr = [self getDataArr:self.blockCount];
            self.setup = 0;
            [self.collectionView reloadData];
        }] ;
        [alertVC addAction:sureAction];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:cancle];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}


@end
