//
//  TestViewController3.m
//  DDOCScrollPageViewDemo
//
//  Created by abiaoyo on 2019/10/28.
//  Copyright © 2019 abiaoyo. All rights reserved.
//

#import "TestViewController3.h"

@interface  DDOCScrollPageCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel * textLabel;

@end

@implementation DDOCScrollPageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    frame.origin.x = 15;
    frame.size.width = CGRectGetWidth(frame)-30;
    self.textLabel.frame = frame;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.textLabel];
}

- (UILabel *)textLabel{
    if(!_textLabel){
        UILabel * v = [[UILabel alloc] initWithFrame:CGRectZero];
        //        v.font = [UIFont boldSystemFontOfSize:17];
        v.text = @"DDOCScrollPageCollectionViewCell";
        _textLabel = v;
    }
    return _textLabel;
}

@end


@interface TestViewController3 ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation TestViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIScrollView *)createScrollView{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,100);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    DDOCScrollPageContainerCollectionView * v = [[DDOCScrollPageContainerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    v.backgroundColor = UIColor.whiteColor;
    v.delegate = self;
    v.dataSource = self;
    [v registerClass:DDOCScrollPageCollectionViewCell.class forCellWithReuseIdentifier:@"DDOCScrollPageCollectionViewCell"];
    return v;
}



#pragma mark - Delegate Method Override
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDOCScrollPageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DDOCScrollPageCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
