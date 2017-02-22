//
//  ChanelView.swift
//  礼物动画2
//
//  Created by mac on 16/12/23.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit


enum ChanelViewState {
    case idle
    case animating
    case willEnd
    case endAnimating
}

class ChanelView: UIView {
    
    var model : GiftMsgModel? {
        didSet{
            self.giftNameL?.text = model?.giftName
            let string = "\((model?.name)!)  送出"
            nameLabel?.text = string
            let attri = NSMutableAttributedString(string: string)
            let range = NSRange(location: 0, length: string.characters.count-3)
            attri.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range:range)
            nameLabel?.attributedText = attri
            giftImg?.setImage(model?.giftURL!, "room_btn_gift")
            
            digetalL?.text =  "X1"
            state = .animating
            prepareAnimation()
        }
    }
    fileprivate var nameLabel : UILabel?
    fileprivate var giftNameL : UILabel?
    fileprivate var giftImg : UIImageView?
    fileprivate var digetalL : AnimatLabel?
    fileprivate var count : Int = 0
    fileprivate var times : Int = 0
    var state : ChanelViewState = .idle
    var idleCallBack : (()->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
}

//  MARK:暴露出的方法
extension ChanelView {
    func addDegitalAnimat() {
        if state == .willEnd {
            jumpAnimating()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        }else {
            times += 1
        }

        
    }
}

extension ChanelView {
    fileprivate func setupUI() {
        nameLabel = UILabel()
//        nameLabel?.textColor = .orange
        
        addSubview(nameLabel!)
        
        giftNameL = UILabel()
        giftNameL?.textColor = .red
        addSubview(giftNameL!)
        
        giftImg = UIImageView()
        giftImg?.contentMode = .scaleAspectFit
        addSubview(giftImg!)
        
        digetalL = AnimatLabel()
        addSubview(digetalL!)
    }
    
    fileprivate func prepareAnimation() {
        
        

        UIView.animate(withDuration: 0.3, animations: { 
            self.frame.origin.x = 0
            }) { (isComplete) in
                self.jumpAnimating()
            
        }
    }
    
    fileprivate func jumpAnimating() {
        count += 1
        self.digetalL?.text =  "X\(count)"
        
        digetalL?.jumpAnimation(comlete: {
            if self.times > 0 {
                self.times -= 1
                self.jumpAnimating()
            }else {
                self.state = .willEnd
                self.perform(#selector(self.willDisAppear), with: nil, afterDelay: 3.0)
            }
            
        })
    }
    
   @objc fileprivate func willDisAppear() {
        self.state = .endAnimating
        UIView.animate(withDuration: 0.25, animations: { 
            self.frame.origin.x = UIScreen.main.bounds.size.width
            }) { (isFinish) in
                self.state = .idle
                self.count = 0
                self.times = 0
                self.frame.origin.x = -self.frame.size.width
                guard self.idleCallBack != nil else {
                    return
                }
                self.idleCallBack!()
        }
    }
    
}

extension ChanelView {
    override func layoutSubviews() {
        nameLabel!.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
        }
        giftNameL!.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel!.snp.right).offset(5)
            make.centerY.equalToSuperview()
        }
        
        giftImg!.snp.makeConstraints { (make) in
            make.left.equalTo(giftNameL!.snp.right).offset(5)
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.centerY.equalToSuperview()
        }
        
        digetalL!.snp.makeConstraints { (make) in
            make.left.equalTo(giftImg!.snp.right).offset(5)
            make.centerY.equalToSuperview()
        }
    }
}






