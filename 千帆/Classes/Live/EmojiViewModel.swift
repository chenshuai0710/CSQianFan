//
//  EmojiViewModel.swift
//  工具条
//
//  Created by mac on 16/12/16.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class EmojiViewModel {
    static let shareInstance  = EmojiViewModel()
    lazy var packges = [EmoticonPackge]()
    
    init() {
        packges.append(EmoticonPackge(plist: "QHNormalEmotionSort.plist"))
        packges.append(EmoticonPackge(plist: "QHSohuGifSort.plist"))
    }
}
