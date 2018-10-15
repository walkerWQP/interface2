//
//  YYCollectionViewLayout.m
//  自定义collectionView
//
//  Created by 杨金发 on 16/9/5.
//  Copyright © 2016年 杨金发. All rights reserved.
//

#import "YYCollectionViewLayout.h"



@interface YYCollectionViewLayout ()

@property(nonatomic,assign) CGFloat itemWidth;
@property(nonatomic,assign) NSInteger itemNumbers;
@property(nonatomic,assign) CGFloat leftOy;
@property(nonatomic,assign) CGFloat rightOy;

@end


@implementation YYCollectionViewLayout

//prepareLayout
-(void)prepareLayout
{
    //1.numberOfItemsInSection
    _itemNumbers=[self.collectionView numberOfItemsInSection:0];
    
    //2.itemWidth
    _itemWidth=ITEM_WIDTH;
    
    
    
}
//collectionViewContentSize
-(CGSize)collectionViewContentSize
{
    
    return     CGSizeMake(SCREEN_WIDTH, MAX(_leftOy, _rightOy));

    
}
//layoutAttributesForElementsInRect
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    
    
    // original
    
    _leftOy=PADDING;
    _rightOy=PADDING;
    
    NSMutableArray*attributes=[NSMutableArray arrayWithCapacity:_itemNumbers];
    for (int i=0; i<_itemNumbers; i++)
    {
        NSIndexPath*indexPath=[NSIndexPath indexPathForItem:i inSection:0];
        
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    
    return attributes;
    
}
//layoutAttributesForItemAtIndexPath
-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    CGSize itemSize=[self.delegate YYCollectionViewLayoutForCollectionView:self.collectionView withLayout:self atIndexPath:indexPath];
    
    UICollectionViewLayoutAttributes*attibutes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    BOOL isLeftNow =_leftOy<_rightOy;
    
    if (isLeftNow)
    {
        CGFloat x=PADDING;
        attibutes.frame=CGRectMake(x, _leftOy, _itemWidth,itemSize.height);
        _leftOy+=itemSize.height;
        
    }
    else
    {
        CGFloat x=PADDING*2+_itemWidth;
        attibutes.frame=CGRectMake(x, _rightOy, _itemWidth, itemSize.height);
        _rightOy+=itemSize.height;
        
    }
    
    
    return attibutes;
}

@end


