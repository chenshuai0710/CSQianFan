//
//  EmoticonView.swift
//  工具条
//
//  Created by mac on 16/12/16.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

let kEmoticonCellID = "kEmoticonCellID"
class EmoticonView: UIView {
    
    fileprivate var emojiKeyboard : DIYKeyboard!

    var selectCallBack : ((String)->())?
    
    fileprivate lazy var style : TitleStyle = {
      let style = TitleStyle()
        style.isTitleInTop = false
        return style
    }()
    fileprivate var layout : PageFlowLayout = {
      let layout = PageFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.cols = 7
        layout.rows = 3
        return layout
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension EmoticonView {
    fileprivate func setupUI() {
        
        emojiKeyboard = DIYKeyboard(frame: frame, style: style, titles: ["大众表情","粉丝专属"], layout: layout)
        emojiKeyboard.dataSource = self
        emojiKeyboard.delegate = self
        emojiKeyboard.rigister(EmojiCell.self, forCellWithReuseIdentifier: kEmoticonCellID)
        addSubview(emojiKeyboard)
    }
   
}


extension EmoticonView  : DIYKeyboardDataSource , DIYKeyboardDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return EmojiViewModel.shareInstance.packges.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmojiViewModel.shareInstance.packges[section].emoticons.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let emoji = EmojiViewModel.shareInstance.packges[indexPath.section].emoticons[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCellID, for: indexPath) as! EmojiCell
        cell.emoji = emoji
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = EmojiViewModel.shareInstance.packges[indexPath.section].emoticons[indexPath.item]
        guard let callback = selectCallBack else {
            return
        }
        callback(emoji.name)
        
    }
}


