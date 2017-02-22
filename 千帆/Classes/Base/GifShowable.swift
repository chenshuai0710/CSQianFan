//
//  GifShowable.swift
//  千帆
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit
import ImageIO

protocol GifShowable {
    
}


extension GifShowable where Self:UIImageView {
    
  func showGif(_ gifName:String) {
    guard let path = Bundle.main.path(forResource: gifName, ofType: nil) else {
        return
    }
        let data = NSData(contentsOfFile: path)!
        let imageSource = CGImageSourceCreateWithData(data, nil)!
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        let imageCount = CGImageSourceGetCount(imageSource)
        for i in 0..<imageCount {
            guard let cImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else {return}
            let image = UIImage(cgImage: cImage)
            if i == 0 {
                self.image = image
            }
            images.append(image)
            // 取出持续的时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary else { continue }
            guard let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
    }
        self.animationImages = images
        self.animationDuration = totalDuration
        self.startAnimating()
    }
    
}
