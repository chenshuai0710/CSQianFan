//
//  GiftView.swift
//  千帆
//
//  Created by mac on 16/12/19.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit


let kGiftViewCell = "kGiftViewCell"
protocol GiftViewDlegate : class{
    func collectionView(_ collectionView: UICollectionView, model cellModel: GiftModel)
}
class GiftView: UIView {
    
    weak var delegate : GiftViewDlegate?
    fileprivate var giftViewModel : GiftViewModel?
    fileprivate var  contentView : DIYKeyboard!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        loadCellData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension GiftView {
    fileprivate func setupUI() {
        let style = TitleStyle()
        let layout = PageFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentView = DIYKeyboard(frame: self.bounds, style: style, titles: ["热门", "高级", "豪华", "专属"], layout: layout)
        contentView.rigister(GiftViewCell.self, forCellWithReuseIdentifier: kGiftViewCell)
        contentView.delegate = self
        contentView.dataSource = self
        addSubview(contentView)
    }
}

extension GiftView : DIYKeyboardDelegate,DIYKeyboardDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return giftViewModel?.gifts.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giftViewModel?.gifts[section].list.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = giftViewModel?.gifts[indexPath.section].list[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGiftViewCell, for: indexPath) as! GiftViewCell
        cell.backgroundColor = UIColor.randomColor()
        cell.model = model
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = giftViewModel?.gifts[indexPath.section].list[indexPath.item]
        delegate?.collectionView(collectionView,model: model!)
    }
}


extension GiftView {
    fileprivate  func loadCellData() {
        giftViewModel = GiftViewModel()
        giftViewModel?.loadData({
            self.contentView.reloadData()
        })
    }
}






