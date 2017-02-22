//
//  NavViewController.swift
//  随便写写
//
//  Created by mac on 16/12/5.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //  获取系统的手势
//        var count : UInt32 = 0
//        let propertyList = class_copyIvarList(self, &count)
//        for i in propertyList {
//            print(i)
//        }
//        
        guard let targets = interactivePopGestureRecognizer!.value(forKey:  "_targets") as? [NSObject] else { return }
        let targetObjc = targets[0]
        let target = targetObjc.value(forKey: "target")
        let action = Selector(("handleNavigationTransition:"))
        let panGes = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(panGes)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }
}
