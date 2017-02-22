//
//  UIcolor+Extension.swift
//  随便写写
//
//  Created by mac on 16/12/5.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

extension UIColor{
    // 在extension中给系统的类扩充构造函数,只能扩充`便利构造函数`
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat = 1.0) {
        
        self.init(red: r/255.0,green: g/255.0,blue: b/255.0,alpha:alpha)
    }
    //  随机色
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    //  十六进制转换
    convenience init? (string:String,alpha:CGFloat) {
        let upperStr = string.uppercased()
        guard string.characters.count >= 6 else {
            fatalError("传入的字符必须大于6个")
        }
       
       let subString =  (upperStr as NSString).substring(from: upperStr.characters.count-6)
        
        var range = NSRange(location: 0,length: 2)
        let rHex = (subString as NSString).substring(with: range)
        range.location = 2
        let gHex = (subString as NSString).substring(with: range)
        range.location = 4
        let bHex = (subString as NSString).substring(with: range)
        
        //  把16进制字符串转换成数字
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        self.init(r:CGFloat(r),g:CGFloat(g),b:CGFloat(b),alpha:alpha)
    }
    
    //  获取颜色的rgb值
    func getRGB()->(CGFloat,CGFloat,CGFloat) {
        guard let cpm = cgColor.components else{
            fatalError("传入的颜色值必须是rgb格式的")
        }
        if cpm.count == 2 {
            return (cpm[0]*255,cpm[0]*255,cpm[0]*255)
        }else  {
            return (cpm[0]*255,cpm[1]*255,cpm[2]*255)
        }
        
    }
    //  获取颜色的差值
   class func getRGBDelta(firstColor:UIColor,sencondColor:UIColor) -> (CGFloat,CGFloat,CGFloat) {
        let firstRGB = firstColor.getRGB()
        let secondRGB = sencondColor.getRGB()
        return (firstRGB.0-secondRGB.0,firstRGB.1-secondRGB.1,firstRGB.2-secondRGB.2)
    }
}
