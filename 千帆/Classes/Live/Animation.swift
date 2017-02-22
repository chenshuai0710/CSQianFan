//
//  Animation.swift
//  礼物动画
//
//  Created by mac on 16/12/23.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

protocol Animation {
    
}


extension Animation where Self:UIView {
    func jumpAnimation(comlete:@escaping ()->()) -> Void {
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: { 
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 3, y: 3)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            })
            }) { (isComplete) in
                UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: { 
                    self.transform = CGAffineTransform.identity
                    }, completion: { (isComplete) in
                        comlete()
                })
        }
    }

}





