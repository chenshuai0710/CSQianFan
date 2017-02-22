//
//  GiftViewCell.swift
//  千帆
//
//  Created by mac on 16/12/19.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class GiftViewCell: UICollectionViewCell {
    fileprivate var imageV : UIImageView!
    fileprivate var priceL : UILabel!
    fileprivate var titleL : UILabel!
    var model : GiftModel? {
        didSet{
            imageV.setImage(model?.img2, "room_btn_gift")
            priceL.text = "\(model?.coin ?? 0) "
            titleL.text = model?.subject
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GiftViewCell {
    fileprivate func setupUI() {
        imageV = UIImageView()
        
        contentView.addSubview(imageV)
        priceL = UILabel()
        priceL.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(priceL)
        titleL = UILabel()
        titleL.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(titleL)
        
        let backgroundBoder = UIView()
        backgroundBoder.layer.cornerRadius = 5
        
        backgroundBoder.layer.masksToBounds = true
        backgroundBoder.layer.borderWidth = 1
        backgroundBoder.layer.borderColor = UIColor.orange.cgColor
        
        selectedBackgroundView = backgroundBoder
        
    }
    override func layoutSubviews() {
        imageV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        titleL.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageV.snp.bottom).offset(5)
        }
        priceL.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleL.snp.bottom)
        }
    }
}



