//
//  HomeViewModel.swift
//  千帆
//
//  Created by mac on 16/12/12.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {
    lazy var contentModels = [HomeModel]()
}

extension HomeViewModel {
    func loadHomeData(type : Int, index : Int,  finishedCallback : @escaping () -> ()) {
       
        NetworkManager.requestData(.get, URLString: "http://qf.56.com/home/v4/moreAnchor.ios", parameters: ["type" : type, "index" : index, "size" : 48], finishedCallback: { (result) -> Void in
            guard let resultDict = result as? [String : Any] else { return }
            guard let messageDict = resultDict["message"] as? [String : Any] else { return }
            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else { return }
            
            for (index, dict) in dataArray.enumerated() {
                let anchor = HomeModel(dict: dict)
                anchor.isEvenIndex = index % 2 == 0
                self.contentModels.append(anchor)
            }
            finishedCallback()
        })
    }

    }
//}
