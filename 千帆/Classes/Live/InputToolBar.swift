//
//  InputToolBar.swift
//  千帆
//
//  Created by mac on 16/12/16.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

class InputToolBar: UIView {
    var textView : UITextField!
    fileprivate var sendBnt : UIButton!
    fileprivate var emoticonBtn : UIButton!
    lazy var emojiView : EmoticonView = EmoticonView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 250))
    var sendMsgCallBack : ((String)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension InputToolBar {
    fileprivate func setupUI() {
        sendBnt = UIButton(type: .custom)
        sendBnt.setTitle("发送", for: .normal)
        sendBnt.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        sendBnt.isEnabled = false
        sendBnt.addTarget(self, action: #selector(sendBtnClick(_:)) , for: .touchUpInside)
        sendBnt.backgroundColor = .orange
        addSubview(sendBnt)
        
        textView = UITextField()
        textView.borderStyle = .roundedRect
        textView.placeholder = "随便送根黄瓜"

        textView.addTarget(self, action: #selector(textfieldEditing), for: .touchUpInside)
        addSubview(textView)
        
        emoticonBtn = UIButton(type: .custom)
        emoticonBtn.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        emoticonBtn.setImage(UIImage(named: "chat_btn_emoji"), for: .normal)
        emoticonBtn.setImage(UIImage(named: "chat_btn_keyboard"), for: .selected)
        emoticonBtn.addTarget(self, action: #selector(emoticonBtnClick(_:)), for: .touchUpInside)
        textView.rightView = emoticonBtn
        textView.rightViewMode = .always
        textView.allowsEditingTextAttributes = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(textfieldEditing), name: .UITextFieldTextDidChange, object: nil)
    }
    
    override func layoutSubviews() {
        sendBnt.snp.makeConstraints { (make)->Void in
            make.right.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(5)
            make.width.equalTo(34)
            make.height.equalTo(34)
        }
        
        textView.snp.makeConstraints { (make)->Void in
            make.left.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.right.equalTo(sendBnt.snp.left).offset(-5)
        }
    }
}

// MARK:监听按钮的点击
extension InputToolBar {
    @objc func emoticonBtnClick(_ sender: UIButton) {
        let range = textView.selectedTextRange
        sender.isSelected = !sender.isSelected
        textView.resignFirstResponder()

        textView.inputView = textView.inputView == nil ? emojiView : nil
        
        emojiView.selectCallBack = { (name) in
            if name == "delete-n" {
                self.textView.deleteBackward()
            }else {
                self.textView.insertText(name)
            }
        }
        textView.becomeFirstResponder()
        textView.selectedTextRange = range
    }
    @objc func sendBtnClick(_ sender:UIButton) {
        let msg = textView.text!
        textView.text = ""
        sendBnt.isEnabled = false
        guard let callBack = sendMsgCallBack else {
            return
        }
        callBack(msg)
    }
    
    @objc func textfieldEditing() {
        sendBnt.isEnabled = textView.text?.characters.count == 0 ? false : true
        
    }
}





