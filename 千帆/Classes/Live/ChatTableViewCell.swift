//
//  ChatTableViewCell.swift
//  千帆
//
//  Created by mac on 16/12/21.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    var chatLabel : UILabel?
    var gifImgView : UIImageView?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func layoutSubviews() {
        chatLabel!.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.bottom.top.right.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatTableViewCell {
    fileprivate func setupUI() {
        chatLabel = UILabel()
        chatLabel?.font = UIFont.systemFont(ofSize: 15)
        chatLabel?.numberOfLines = 0
        self.selectionStyle = .none
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(chatLabel!)
        
    }
}



