//
//  ChanelContainer.swift
//  千帆
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class ChanelContainer: UIView {

    fileprivate var chanelV1 : ChanelView!
    fileprivate var chanelV2 : ChanelView!
    fileprivate lazy var giftModels = [GiftMsgModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

extension ChanelContainer {
    fileprivate func setupUI() {
        chanelV1 = ChanelView(frame: CGRect(x: -300, y: 0, width: 300, height: 44))
        
        chanelV1.idleCallBack = { [weak self]  in
            guard self!.giftModels.count > 0 else {
                return
            }
            let model = self!.giftModels[0]
            self?.chanelV1.model = model
            self?.giftModels.removeFirst()
            for (i,value) in self!.giftModels.enumerated().reversed() {
                if model.isEqual(value)  {
                    self?.chanelV1.addDegitalAnimat()
                    self?.giftModels.remove(at: i)
                }
            }
            
        }
        chanelV2 = ChanelView(frame: CGRect(x: -300, y: 54, width: 300, height: 44))
        chanelV2.idleCallBack = {[weak self]  in
            guard self!.giftModels.count > 0 else {
                return
            }
            let model = self!.giftModels[0]
            self!.chanelV2.model = model
            self?.giftModels.removeFirst()
            
            for (i,value) in self!.giftModels.enumerated().reversed() {
                if model.isEqual(value)  {
                    self!.chanelV2.addDegitalAnimat()
                    self!.giftModels.remove(at: i)
                }
                
            }
            
        }
        addSubview(chanelV1)
        addSubview(chanelV2)
    }
}

extension ChanelContainer {
    func showChanel(_ model: GiftMsgModel) {
        checkChanelState(model)
    }
    private func checkChanelState(_ model: GiftMsgModel) {
        
        switch chanelV1.state {
        case .idle:
            if chanelV2.state == .animating || chanelV2.state == .willEnd {
                if (chanelV2.model?.isEqual(model))! {
                    chanelV2.addDegitalAnimat()
                    return
                }
            }
            //  chanelV1执行一次,return
            chanelV1.model = model
            return
        case .animating,.willEnd:
            //  如果model一致,执行一次return
            if model.isEqual(chanelV1.model) {
                chanelV1.addDegitalAnimat()
                return
            }
            break
            
        default:
            
            break
        }
        
        switch chanelV2.state {
        case .idle:
            //  执行一次,return
            chanelV2.model = model
            return
        case .animating,.willEnd:
            //  模型一致,执行一次,return
            if model.isEqual(chanelV2.model) {
                chanelV2.addDegitalAnimat()
                return
            }
            break
            
        default:
            //  加入队列
            break
        }
        
        //  如果执行到这,说明连2个通道都在忙,并且模型不一致,加到数组里等待调用
        
        self.giftModels.append(model)
        
    }

}




