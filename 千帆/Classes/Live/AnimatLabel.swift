//
//  AnimatLabel.swift
//  礼物动画
//
//  Created by mac on 16/12/22.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class AnimatLabel: UILabel , Animation {

    override func drawText(in rect: CGRect) {
        //  获取上下文
        let conText = UIGraphicsGetCurrentContext()
        //  设置conText线宽
        conText?.setLineWidth(5)
        conText?.setLineJoin(.round)
        conText?.setTextDrawingMode(.stroke)
        textColor = .orange
        super.drawText(in: rect)
        conText?.setTextDrawingMode(.fill)
        textColor = .white
        super.drawText(in: rect)
        
    }

}
