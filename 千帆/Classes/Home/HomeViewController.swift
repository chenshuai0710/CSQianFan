//
//  HomeViewController.swift
//  千帆
//
//  Created by mac on 16/12/12.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    fileprivate lazy var titleModels:[TitleModel] = [TitleModel]()
    fileprivate lazy var contenVCs : [ContentViewController] = [ContentViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        setupUI()
    }

    

}

// MARK:-设置UI
extension HomeViewController {
    fileprivate func setupUI() {
        setupNavigatBar()
        setupPageView()
        
    }
    private func setupNavigatBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "home-logo"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"search_btn_follow"), style: .plain, target: self, action:#selector(rightBtnClick))
        let searchBar = UISearchBar()
        searchBar.barStyle = .black
        searchBar.placeholder = "主播/房间号/链接"
        navigationItem.titleView = searchBar
        
        let textfield = searchBar.value(forKey: "_searchField") as? UITextField
        textfield?.textColor = .white
    }
    
    private func setupPageView() {
        // 从plist中获取标题
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)!
        let dataArray = NSArray(contentsOfFile: path) as! [[String: Any]]
        
        for dic in dataArray {
            let model = TitleModel(dict: dic)
            titleModels.append(model)
            
           let vc = ContentViewController()
            vc.type = model.type
            contenVCs.append(vc)
        }
        
        let titles = titleModels.map({$0.title})
        let style = TitleStyle()
        let pageView = PageView(frame:CGRect(x: 0, y: 64, width: kScreenW, height: kScreenH-64-49) , titles: titles, childsVC: contenVCs, parentVC: self, style: style)
        view.addSubview(pageView)
    }
}

extension HomeViewController {
    //  分类中方法没有加入到对象的方法列表中,所以需要在前面加上@objc
    @objc fileprivate func rightBtnClick() {
        print("接我一掌")
    }
}
