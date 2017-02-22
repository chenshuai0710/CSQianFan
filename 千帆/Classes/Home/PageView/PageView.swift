//
//  PageView.swift
//  随便写写
//
//  Created by mac on 16/12/5.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class PageView: UIView {

    fileprivate var titles:[String]
    fileprivate var childsVC:[UIViewController]
    fileprivate var parentVC:UIViewController
    fileprivate var titleV: TitlesView?
    fileprivate var style: TitleStyle
    init(frame:CGRect, titles:[String],childsVC:[UIViewController],parentVC:UIViewController ,style:TitleStyle) {
        self.titles = titles
        self.childsVC = childsVC
        self.parentVC = parentVC
        self.style = style
        super.init(frame:frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PageView {
    fileprivate func setupUI() {
        setupTitlesView()
        setupContentView()
        isUserInteractionEnabled = true
    }
    private func setupTitlesView() {
        
        titleV = TitlesView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: style.titleVHeight), titles: titles, style:style)
        self.addSubview(titleV!)
    }
    private func setupContentView() {
        let contentV = ContentView(frame: CGRect(x: 0, y: style.titleVHeight, width: bounds.width, height: bounds.height-style.titleVHeight), childsVC: childsVC, parentVC: parentVC)

        titleV?.delegate = contentV
        contentV.delegate = titleV!
        self.addSubview(contentV)
    }
}


