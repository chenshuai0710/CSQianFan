//
//  TitlesView.swift
//  随便写写
//
//  Created by mac on 16/12/5.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

protocol TitlesViewDelegate: class {
    func setupContentViewScroll(_ titleV:TitlesView,targetIndex:Int)
}

class TitlesView: UIView {
    weak var delegate : TitlesViewDelegate?
    fileprivate var titles:[String]
    fileprivate var style:TitleStyle
    fileprivate var currentIndex:Int = 0
    fileprivate lazy var labels:[UILabel] = [UILabel]()
    fileprivate lazy var bottomLine : UIView = {
        let rect = CGRect(x: 10, y: self.scrollV.bounds.height-1, width: self.labels[0].frame.size.width, height: 1)
        let line = UIView(frame: rect)
        line.backgroundColor = .orange
        return line
    }()
    fileprivate lazy var scrollV :UIScrollView = {
        let scroll:UIScrollView = UIScrollView(frame: self.bounds)
        scroll.scrollsToTop = false
        scroll.backgroundColor = self.style.titleBackColor
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    init(frame:CGRect,titles:[String],style:TitleStyle) {
        self.titles = titles
        self.style = style
        super.init(frame:frame)
        setupUI()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TitlesView {
    fileprivate func setupUI() {
        setUpScroll()
        setupLabelFrame()
        setupBottomLine()
    }
    private func setUpScroll() {
        addSubview(scrollV)
        for (i,name) in titles.enumerated() {
            let label = UILabel()
            label.textAlignment = .center
            label.text = name
            label.font = UIFont.systemFont(ofSize: style.titleFont)
            label.tag = i
            label.textColor = style.colorNormal
            if i==0 {
                label.textColor = style.colorSelect
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelClick(_:)))
            label.addGestureRecognizer(tap)
            
            label.isUserInteractionEnabled = true
            labels.append(label)
        }
    }
    private func setupLabelFrame() {
        let margin:CGFloat = 20
        var x :CGFloat = 0
        let y :CGFloat = 0
        for(i, label) in labels.enumerated() {
            if titles.count <= 4 {
                let width = bounds.width / CGFloat(titles.count)
                label.frame = CGRect(x: CGFloat(i) * width , y: 0, width: width, height: style.titleVHeight)
                scrollV.contentSize = CGSize(width:0, height: 0)
            }else {
                let width = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil).width
                if i == 0 {
                    x = margin * 0.5
                }else {
                    let preLabel = labels[i-1]
                    x = preLabel.frame.maxX+margin
                }
                label.frame = CGRect(x:x, y: y, width: width, height: bounds.height)
                scrollV.contentSize = CGSize(width: labels.last!.frame.maxX+margin*0.5 , height: 0)
            }
            scrollV.addSubview(label)
        }
        
        }
    private func setupBottomLine() {
        
        scrollV.addSubview(bottomLine)
    }
}



extension TitlesView {
    @objc fileprivate func labelClick(_ tap:UITapGestureRecognizer) {
        
        let label = tap.view as! UILabel

        changeColor(label: label)
        
        delegate?.setupContentViewScroll(self, targetIndex: label.tag)
    }
    
    fileprivate func changeColor(label:UILabel) {
        let preLabel = labels[currentIndex]
        preLabel.textColor = style.colorNormal
        currentIndex = label.tag
        label.textColor =  style.colorSelect
        UIView.animate(withDuration: 0.3) {
            self.bottomLine.frame.origin.x = label.frame.origin.x
            self.bottomLine.frame.size.width = label.frame.size.width
        }
        guard titles.count > 4 else {
            return
        }
        var offsetX = label.center.x - bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        if offsetX > scrollV.contentSize.width - scrollV.bounds.width  {
            offsetX = scrollV.contentSize.width - scrollV.bounds.width
        }
        
        scrollV.setContentOffset(CGPoint(x:offsetX,y:0), animated: true)
    }
    
}
//  让外界调用
extension TitlesView {
    func scrollToChangeColor(_ indexPath: IndexPath) {
        let currentLabel = labels[indexPath.section]
        changeColor(label: currentLabel)
    }

}

extension TitlesView :ContentViewDelegate {
    func ContentView(_ contentV: ContentView,targetIndex: Int) {
        let currentLabel = labels[targetIndex]
        changeColor(label: currentLabel)
    }
    func ContentView(_ content: ContentView, current:Int, targetIndex: Int, progress: CGFloat) {
        let targetL = labels[targetIndex]

        let preL = labels[current]
        
        self.currentIndex = targetIndex
        let targetRGB = style.colorNormal.getRGB()
        
        let preRGB = style.colorSelect.getRGB()
        
        let delta = UIColor.getRGBDelta(firstColor: style.colorNormal, sencondColor: style.colorSelect)

        let preColorRGB = (preRGB.0+delta.0*progress,preRGB.1+delta.1*progress,preRGB.2+delta.2*progress)
        let targetColorRGB =  (targetRGB.0-delta.0 * progress,targetRGB.1-delta.1 * progress,targetRGB.2-delta.2 * progress)

        
        preL.textColor = UIColor(r: preColorRGB.0, g: preColorRGB.1, b: preColorRGB.2)
        targetL.textColor = UIColor(r: targetColorRGB.0, g: targetColorRGB.1, b: targetColorRGB.2)
        self.bottomLine.frame.origin.x = preL.frame.origin.x + ( targetL.frame.origin.x - preL.frame.origin.x) * progress
        self.bottomLine.frame.size.width = preL.frame.size.width + ( targetL.frame.size.width - preL.frame.size.width) * progress
        
    }
}





