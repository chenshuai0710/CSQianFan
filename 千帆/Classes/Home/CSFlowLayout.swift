//
//  CSFlowLayout.swift
//  随便写写
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

protocol flowLayoutDatasource:class {
    
    //  列数
    func numberOfCols(_ flowLayout: CSFlowLayout) -> Int
    //  每个item高度
    func waterfall(_ flowLayout: CSFlowLayout,item: Int) -> CGFloat
}

class CSFlowLayout: UICollectionViewFlowLayout {
    weak var datasource : flowLayoutDatasource?
    fileprivate var startIndex = 0
    fileprivate lazy var attris : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var cols : Int = {
        return self.datasource?.numberOfCols(self) ?? 2
    }()
    
    fileprivate lazy var totalHeights : [CGFloat] = Array(repeating: self.sectionInset.top, count: self.cols)
}


extension CSFlowLayout {
    override func prepare() {
        super.prepare()
        let count : Int = collectionView!.numberOfItems(inSection: 0)
        let width = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat((cols-1))) / CGFloat(cols)
        
        // 注意startIndex.如果不加这个,多次加载数据的时候,frame会有问题
        for i in startIndex..<count {
            let indexPath = IndexPath(item: i, section: 0)
            let attri : UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            guard let itemH : CGFloat = datasource?.waterfall(self, item: i) else {
                fatalError("cuo")
            }
            let minY = totalHeights.min()!
            let minIndex = totalHeights.index(of: minY)!
            totalHeights[minIndex] = minY + itemH + minimumLineSpacing
            
            let x = sectionInset.left + (width + minimumInteritemSpacing) * CGFloat(minIndex)
            let y = minY
            attri.frame = CGRect(x: x, y: y, width: width, height: itemH)
            attris.append(attri)
            startIndex = count
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attris
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: totalHeights.max()!+sectionInset.bottom - minimumLineSpacing)
    }
    
}
