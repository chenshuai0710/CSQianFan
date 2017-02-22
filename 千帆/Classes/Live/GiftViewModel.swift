//
//  GiftViewModel.swift
//  千帆
//
//  Created by mac on 16/12/19.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class GiftViewModel: NSObject {
    lazy var gifts : [GiftPackge] = [GiftPackge]()
    
}

extension GiftViewModel {
     func loadData(_ completeCallBack : @escaping ()->())  {
        if gifts.count != 0 { completeCallBack() }
        NetworkManager.requestData(.get, URLString: "http://qf.56.com/pay/v4/giftList.ios", parameters: ["type" : 0, "page" : 1, "rows" : 150], finishedCallback: { (result) in
            guard let resultDic  = result as? [String:Any] else {return}
            guard let messageDic = resultDic["message"] as? [String:Any] else {return}
            for i in 0..<messageDic.count {
                let key = "type\(i+1)"
                guard let tempDic = messageDic[key] as? [String:Any] else {continue}
                self.gifts.append(GiftPackge(dict: tempDic))
                
            }
            self.gifts = self.gifts.filter({ return $0.t != 0 }).sorted(by: { return $0.t > $1.t })
            completeCallBack()
        })
        
    }
}
