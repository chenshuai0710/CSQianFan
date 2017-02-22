//
//  ContentView.swift
//  随便写写
//
//  Created by mac on 16/12/5.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

fileprivate let kCellID = "kCellID"

protocol ContentViewDelegate:class {
    func ContentView(_ contentV:ContentView,targetIndex:Int)
    func ContentView(_ content:ContentView,current:Int,targetIndex:Int,progress:CGFloat)
}

class ContentView: UIView {
    weak var delegate: ContentViewDelegate?
    fileprivate var childsVC:[UIViewController]
    fileprivate var parentVC:UIViewController
    fileprivate var targetIndex: Int = 0
    var beginX :CGFloat?
    var currentIndex: Int?
    fileprivate var isScroll = true
    fileprivate lazy var collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectView : UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectView.dataSource = self
        collectView.delegate = self
        collectView.isPagingEnabled = true
        collectView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        collectView.bounces = false
        return collectView
    }()
    init(frame:CGRect,childsVC:[UIViewController],parentVC:UIViewController) {
        self.childsVC = childsVC
        self.parentVC = parentVC
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:界面搭建
extension ContentView {
    fileprivate func setupUI() {
        //  如果不加到导航控制器中,会导致所有的子控制器都不能push
        for vc in childsVC {
            parentVC.addChildViewController(vc)
        }
        addSubview(collectionV)
    }
}

// MARK:dataSource&delegate
extension ContentView : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childsVC.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath)
        let VC = childsVC[indexPath.row]
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        VC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(VC.view)
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScroll = true
        beginX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isScroll else {
            return
        }
        guard beginX != scrollView.contentOffset.x else {
            return
        }
        
        // 1.定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > beginX! { // 左滑
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childsVC.count {
                targetIndex = childsVC.count - 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - beginX! == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // 右滑
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childsVC.count {
                sourceIndex = childsVC.count - 1
            }
        }
        
        delegate?.ContentView(self, current:sourceIndex,targetIndex: targetIndex, progress: progress)

        }

    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            changePage()
        }
        
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        changePage()
    }
    private func changePage() {
        let currentIndex = Int(collectionV.contentOffset.x / bounds.width)
        
        delegate?.ContentView(self, targetIndex: currentIndex)
    }
    
    
}

// MARK:titleViewDelegate
extension ContentView : TitlesViewDelegate {
    func setupContentViewScroll(_ titleV: TitlesView, targetIndex: Int) {
        isScroll = false
        let index = IndexPath(item: targetIndex, section: 0)
        collectionV.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
    }
}

