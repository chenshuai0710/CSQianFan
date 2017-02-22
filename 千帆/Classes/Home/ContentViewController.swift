//
//  ContentViewController.swift
//  千帆
//
//  Created by mac on 16/12/12.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

let kHomeCellID = "kHomeCellID"
class ContentViewController: UIViewController {
    var type : Int!
    fileprivate lazy var homeVM : HomeViewModel = HomeViewModel()
    fileprivate lazy var collectView : UICollectionView = {
        let layout = CSFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.datasource = self
        
        let collectView : UICollectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: kScreenW, height: self.view.bounds.height) , collectionViewLayout: layout)
        collectView.dataSource = self
        collectView.delegate = self
        collectView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellWithReuseIdentifier: kHomeCellID)
        collectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectView.backgroundColor = .white
    return collectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData(0)
    }
    


}

extension ContentViewController {
    fileprivate func setupUI() {
        view.addSubview(collectView)
    }
}

extension ContentViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.contentModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kHomeCellID, for: indexPath) as! HomeViewCell
        cell.anchorModel = homeVM.contentModels[indexPath.row]
        if indexPath.item == homeVM.contentModels.count - 1 {
            loadData(homeVM.contentModels.count)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let roomVc = RoomViewController()
        self.navigationController?.pushViewController(roomVc, animated: true)
    }
}

extension ContentViewController : flowLayoutDatasource {
    func numberOfCols(_ flowLayout: CSFlowLayout) -> Int {
        return 2
    }
    func waterfall(_ flowLayout: CSFlowLayout, item: Int) -> CGFloat {
        return item % 2 == 0 ? kScreenW * 2 / 3 : kScreenW * 0.5
    }
}

extension ContentViewController {
    fileprivate func loadData(_ index:Int) {
        homeVM.loadHomeData(type: type, index : index, finishedCallback: {
            self.collectView.reloadData()
        })
    
    }

}

