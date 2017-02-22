//
//  Attriable.swift
//  千帆
//
//  Created by mac on 16/12/22.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

protocol Attriable {
    
}

extension Attriable {
     func textImgeHibrid(_ text: String) -> NSMutableAttributedString {
        let attrs = NSMutableAttributedString(string: text)
        if text.characters.count > 2  {
            let range = NSRange(location: 0, length: 2)
            attrs.addAttributes([NSForegroundColorAttributeName: UIColor.red], range: range)
        }
        
        //  正则匹配[哈哈]
        let pattern = "\\[.*?\\]"
        //  []代表默认
        guard let rgex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attrs
        }
        
        let results = rgex.matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))
        //  顺序遍历的话,把若干的字符转成图片,会出问题.so,使用反向遍历
        for i in results.reversed() {
            let imgName = (text as NSString).substring(with: i.range)
//            print(imgName)
            let img = UIImage(named: imgName)
            let attach = NSTextAttachment()
            attach.image = img
            let font = UIFont.systemFont(ofSize: 15)
            attach.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
            let attr = NSAttributedString(attachment: attach)
            attrs.replaceCharacters(in: i.range, with: attr)
        }
        
        
        return attrs
    }

}
