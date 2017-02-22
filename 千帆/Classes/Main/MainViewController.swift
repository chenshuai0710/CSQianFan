//
//  MainViewController.swift
//  千帆
//
//  Created by mac on 16/12/12.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addControllers("Home")
        addControllers("Rank")
        addControllers("Discover")
        addControllers("Profile")
    }

    fileprivate func addControllers(_ VCString:String) {
        let vc = UIStoryboard(name: VCString, bundle: nil).instantiateInitialViewController()!
        addChildViewController(vc)
    }

}
