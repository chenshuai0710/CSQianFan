//
//  GiftPackge.swift
//  千帆
//
//  Created by mac on 16/12/19.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class GiftPackge: BaseModel {
    var t :Int = 0
    var title:String = ""
    var list : [GiftModel] = [GiftModel]()
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list" {
            if let listArr = value as? [[String : Any]] {
                for listDict in listArr {
                    list.append(GiftModel(dict: listDict))
                }
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }


}
