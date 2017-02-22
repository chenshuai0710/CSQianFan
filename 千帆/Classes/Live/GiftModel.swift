//
//  GiftModel.swift
//  千帆
//
//  Created by mac on 16/12/19.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class GiftModel: BaseModel {
    var img2 : String = "" // 图片
    var coin : Int = 0 // 价格
    var subject : String = "" { // 标题
        didSet {
            if subject.contains("(有声)") {
                subject = subject.replacingOccurrences(of: "(有声)", with: "")
            }
        }
    }

    
}
