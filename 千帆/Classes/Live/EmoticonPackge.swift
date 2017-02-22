//
//  EmoticonPackge.swift
//  工具条
//
//  Created by mac on 16/12/16.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class EmoticonPackge {
    lazy var emoticons : [Emoticon] = [Emoticon]()
    
    init(plist : String) {
        guard let path = Bundle.main.path(forResource: plist, ofType: nil) else {
            return
        }
        guard let array = NSArray(contentsOfFile: path) as? [String] else {
            return
        }
        for i in array {
            let emoji = Emoticon(name : i)
            emoticons.append(emoji)
        }
    }
}
