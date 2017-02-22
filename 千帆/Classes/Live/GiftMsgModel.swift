//
//  GiftMsgModel.swift
//  礼物动画2
//
//  Created by mac on 16/12/23.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class GiftMsgModel:NSObject {

    var name: String?
    var giftName: String?
    var giftURL : String?
    var giftCount : Int?
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let model = object as? GiftMsgModel else {return false}
        if self.name == model.name && self.giftName == model.giftName {
            return true
        }else {
            return false
        }
    }
}
