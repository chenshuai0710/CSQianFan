//
//  DIYKeyboard.swift
//  千帆
//
//  Created by mac on 16/12/14.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit



protocol DIYKeyboardDataSource : class {
    func numberOfSections(in collectionView: UICollectionView) -> Int
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

protocol DIYKeyboardDelegate : class {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) -> Void
}

class DIYKeyboard: UIView {
    
    weak var dataSource : DIYKeyboardDataSource?
    weak var delegate : DIYKeyboardDelegate?
    
    fileprivate var style:TitleStyle
    fileprivate var titles:[String]
    fileprivate var layout:PageFlowLayout
    fileprivate var colletionView:UICollectionView!
    fileprivate var pageControl : UIPageControl!
    fileprivate var indexSource  = IndexPath(item: 0, section: 0)
    fileprivate var titleView : TitlesView!

    init(frame: CGRect,style:TitleStyle,titles:[String],layout:PageFlowLayout) {
        self.style = style
        self.titles = titles
        self.layout = layout
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DIYKeyboard {
    fileprivate func setupUI() {
        
        let titleY =  style.isTitleInTop ? 0 : bounds.height - style.titleVHeight
        titleView = TitlesView(frame: CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleVHeight), titles: titles, style: style)
        titleView.backgroundColor = .red
        titleView.delegate = self
        addSubview(titleView)
        
        let pageH : CGFloat = 20
        let pageY = style.isTitleInTop ? bounds.height - pageH :  bounds.height - pageH - style.titleVHeight
        pageControl = UIPageControl(frame: CGRect(x: 0, y: pageY, width: bounds.width, height: pageH))
        pageControl.numberOfPages = 4
        
        addSubview(pageControl)
        
        
        let contentY = style.isTitleInTop ? style.titleVHeight : 0
        colletionView = UICollectionView(frame: CGRect(x: 0, y: contentY, width: bounds.width, height: bounds.height - pageH - style.titleVHeight), collectionViewLayout: layout)
        colletionView.isPagingEnabled = true
        colletionView.dataSource = self
        colletionView.delegate = self
        colletionView.frame = CGRect(x: 0, y: contentY, width: bounds.width, height: bounds.height - pageH - style.titleVHeight)
        pageControl.backgroundColor = colletionView.backgroundColor
        
        addSubview(colletionView)
    }
}

//  暴露给外部调用的方法
extension DIYKeyboard {
    func rigister(_ anyClass:AnyClass? ,forCellWithReuseIdentifier  Identifier : String) {
        colletionView.register(anyClass, forCellWithReuseIdentifier: Identifier)
    }
    func reloadData() {
        colletionView.reloadData()
    }
}

extension DIYKeyboard : UICollectionViewDataSource, UICollectionViewDelegate, TitlesViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: colletionView) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1)/(layout.cols * layout.rows)+1
        }
        
        
        return itemCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        return dataSource!.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func setupContentViewScroll(_ titleV: TitlesView, targetIndex: Int) {
        let indexPath = IndexPath(item: 0, section: targetIndex)
        colletionView.scrollToItem(at: indexPath, at: .left, animated: false)
        colletionView.contentOffset.x = colletionView.contentOffset.x - CGFloat(10)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        endScroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            endScroll()
        }
    }
    func endScroll() {
        let point = CGPoint(x: layout.sectionInset.left + 1 + colletionView.contentOffset.x, y: layout.sectionInset.top+1)
        guard let indexPath = colletionView.indexPathForItem(at: point) else {
            return
        }
       pageControl.numberOfPages = (colletionView.numberOfItems(inSection: indexPath.section)-1)/(layout.cols * layout.rows)+1
        let page = indexPath.item / (layout.cols * layout.rows)
        pageControl.currentPage = page

        guard indexPath.section != indexSource.section else {
            return
        }

        indexSource = indexPath
        titleView.scrollToChangeColor(indexPath)
    }
}



