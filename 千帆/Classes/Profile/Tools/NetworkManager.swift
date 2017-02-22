//
//  NetworkManager.swift
//  千帆
//
//  Created by mac on 16/12/13.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class NetworkManager {
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
//        print("\(URLString)")
//        var string = ""
//        for (_,value) in parameters! {
//            string = string + String(describing: value)
//        }
        // 2.发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            // 4.将结果回调出去
            finishedCallback(result)
            
            
        }
        
    }
    
}

