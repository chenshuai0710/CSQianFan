//
//  BaseModel.swift
//  千帆
//
//  Created by mac on 16/12/12.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    override init() {
        
    }
    
    init(dict:[String: Any]) {
        
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
