//
//  PageFlowLayoutCell.swift
//  表情键盘
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class PageFlowLayout: UICollectionViewFlowLayout {
    
    var cols : Int = 4
    var rows : Int = 2
    
    lazy var attris :[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    var maxWid: CGFloat = 0
    fileprivate var isOn : Bool  = true
}

extension PageFlowLayout {
    override func prepare() {
        super.prepare()
        guard isOn  else {
            return
        }
        guard let sectionCount = collectionView?.numberOfSections else {
            return
        }
        let width = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(cols-1)) / CGFloat(cols)
        let height = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing * CGFloat(rows - 1)) / CGFloat(rows)
        
        var prePages:Int = 0 // 不能生命为全局变量,因为此方法会重复调用,如果声明为全局变量,则一直自增
        for i in 0..<sectionCount {
            let items = collectionView?.numberOfItems(inSection: i)
            for j in 0..<items! {
                let indexPath = IndexPath(item: j, section: i)
                let attri = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                //  在这组的第几页
                let page = j / (rows * cols)
                let index = j % (rows * cols)
                //  第几行
                let row = index / cols
                //  第几列
                let col = index % cols
                let y = sectionInset.top + (height + minimumLineSpacing) * CGFloat(row)
                
                let x = CGFloat(prePages + page) * collectionView!.bounds.width + (width + minimumInteritemSpacing) * CGFloat(col) + sectionInset.left
                
                attri.frame = CGRect(x: x, y: y, width: width, height: height)
                attris.append(attri)
                if j == items! - 1 {
                    isOn = false
                }
            }
            prePages += (items!-1) / (rows * cols) + 1
           
        }
        maxWid = CGFloat(prePages) * collectionView!.bounds.width
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attris
    }
    
    override var collectionViewContentSize: CGSize {
       
        return CGSize(width: maxWid, height: 0)
    }
}
