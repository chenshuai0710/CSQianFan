//
//  EmojiCell.swift
//  工具条
//
//  Created by mac on 16/12/16.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class EmojiCell: UICollectionViewCell {
    private var img : UIImageView!
    var emoji:Emoticon? {
        didSet{
            img.image = UIImage(named: emoji!.name)
        }
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI(){
        img = UIImageView()
        img.contentMode = .center
        addSubview(img)
    }
    
    override func layoutSubviews() {
        img.snp.makeConstraints { (make)->Void in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
