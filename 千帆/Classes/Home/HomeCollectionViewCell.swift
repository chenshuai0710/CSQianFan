//
//  HomeCollectionViewCell.swift
//  千帆
//
//  Created by mac on 16/12/12.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit
import SnapKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    lazy var photoImg: UIImageView = UIImageView()
    
    lazy var liveImg: UIImageView = UIImageView()
    
    lazy var roomNameLabel: UILabel = UILabel()
    
    lazy  var viewerCountBtn: UIButton = UIButton(type: .custom)
    
    var model : HomeModel? {
        didSet {
            photoImg.setImage(model!.isEvenIndex ? model?.pic74 : model?.pic51, "home_pic_default")
            roomNameLabel.text = model?.name
            roomNameLabel.textColor = UIColor.lightGray
            roomNameLabel.font = UIFont.systemFont(ofSize: 12)
        }
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        roomNameLabel.sizeToFit()
        contentView.addSubview(photoImg)
        contentView.addSubview(liveImg)
        contentView.addSubview(roomNameLabel)
        contentView.addSubview(viewerCountBtn)
    }
    
    override func layoutSubviews() {
        photoImg.snp.makeConstraints { (make) -> Void in
            make.left.right.top.bottom.equalToSuperview()
        }
        liveImg.snp.makeConstraints { (make)->Void in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }
        roomNameLabel.snp.makeConstraints { (make)->Void in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
