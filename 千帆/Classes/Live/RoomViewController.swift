//
//  RoomViewController.swift
//  千帆
//
//  Created by mac on 16/12/14.
//  Copyright © 2016年 陈帅. All rights reserved.
//

import UIKit

let kBarHeight:CGFloat = 44
let kChatCell = "kChatCell"
class RoomViewController: UIViewController {
    fileprivate lazy var bgImgView: UIImageView = {
        let bgImgView = UIImageView(frame: self.view.bounds)
        return bgImgView
    }()
    fileprivate lazy var sendMsgBar : InputToolBar = InputToolBar()
    fileprivate lazy var giftView : GiftView = GiftView(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: 300))
    fileprivate lazy var chnaelContainer  = ChanelContainer(frame: CGRect(x: 0, y: 64, width: kScreenW, height: 100))
    fileprivate lazy var tibleView : UITableView = {
       let tableView = UITableView(frame: CGRect(x: 0, y: kScreenH-kBarHeight-200, width: kScreenW, height: 200))
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: kChatCell)
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        return tableView
    }()
    fileprivate var chatMsgArr : [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.randomColor()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(bottomSendBarAppear(_:)), name: Notification.Name.UIKeyboardWillChangeFrame , object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        chnaelContainer.removeFromSuperview()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.sendMsgBar.textView.resignFirstResponder()
        UIView.animate(withDuration: 0.25) { 
            self.giftView.frame.origin.y = kScreenH
        }
    }
}

extension RoomViewController {
    fileprivate func setupUI() {
        view.addSubview(bgImgView)
        
        setupBlurView()
        setupBottomBar()
        setupTopBar()
        setupSendMsgBar()
        setupGiftView()
        setupChanelContainer()
    }
    
    func setupBlurView() {
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = view.bounds
        view.addSubview(blurView)
    }
    
    private func setupBottomBar() {
        let bottomView = UIView(frame: CGRect(x: 0, y: kScreenH-kBarHeight, width: kScreenW, height: kBarHeight))
        
        view.addSubview(bottomView)
        
        let sendMsgBtn = UIButton(type: .custom)
        sendMsgBtn.setImage(UIImage(named: "room_btn_chat"), for: .normal)
        sendMsgBtn.addTarget(self, action:#selector(sendMsg(_:)), for: .touchUpInside)
        bottomView.addSubview(sendMsgBtn)
        sendMsgBtn.snp.makeConstraints { (make)->Void in
            make.left.top.equalToSuperview()
            make.width.equalTo(kScreenW/5.0)
            make.height.equalTo(kBarHeight)
        }
        
        let shareBtn = UIButton(type: .custom)
        shareBtn.setImage(UIImage(named: "menu_btn_share"), for: .normal)
        shareBtn.addTarget(self, action: #selector(shareClick(_:)), for: .touchUpInside)
        bottomView.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make)->Void in
            make.top.equalToSuperview()
            make.left.equalTo(sendMsgBtn.snp.right)
            make.width.height.equalTo(sendMsgBtn)
        }
        
        let giftBtn = UIButton(type: .custom)
        giftBtn.setImage(UIImage(named: "room_btn_gift"), for: .normal)
        giftBtn.addTarget(self, action: #selector(giftBtnClick(_:)), for: .touchUpInside)
        bottomView.addSubview(giftBtn)
        giftBtn.snp.makeConstraints { (make)->Void in
            make.top.equalToSuperview()
            make.left.equalTo(shareBtn.snp.right)
            make.width.height.equalTo(sendMsgBtn)
        }
        
        let moreBtn = UIButton(type: .custom)
        moreBtn.setImage(UIImage(named: "room_btn_more"), for: .normal)
        moreBtn.addTarget(self, action: #selector(moreBtnClick(_:)), for: .touchUpInside)
        bottomView.addSubview(moreBtn)
        moreBtn.snp.makeConstraints { (make)->Void in
            make.top.equalToSuperview()
            make.left.equalTo(giftBtn.snp.right)
            make.width.height.equalTo(sendMsgBtn)
        }
        
        let starBtn = UIButton(type: .custom)
        starBtn.setImage(UIImage(named: "room_btn_qfstar"), for: .normal)
        starBtn.addTarget(self, action: #selector(starBtnClick(_:)), for: .touchUpInside)
        bottomView.addSubview(starBtn)
        starBtn.snp.makeConstraints { (make)->Void in
            make.top.equalToSuperview()
            make.left.equalTo(moreBtn.snp.right)
            make.width.height.equalTo(sendMsgBtn)
        }
    }
    
    private func setupTopBar() {
        let closeBtn = UIButton(type: .custom)
        let closeImg = UIImage(named: "menu_btn_close")
        closeBtn.setImage(closeImg, for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClick(_:)), for: .touchUpInside)
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make)->Void in
            make.right.equalTo(-10)
            make.top.equalTo(20)
            make.size.equalTo(closeImg!.size)
        }
        
        let clean = UILabel()
        clean.text = "清屏"
        clean.isUserInteractionEnabled = true
        view.addSubview(clean)
        clean.snp.makeConstraints { (make) in
            make.top.equalTo(closeBtn)
            make.right.equalTo(closeBtn.snp.left).offset(-5)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(cleanScreen))
        clean.addGestureRecognizer(tap)
    }
    private func setupSendMsgBar() {
        
        sendMsgBar.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: kBarHeight)
        sendMsgBar.autoresizingMask = [.flexibleTopMargin ,.flexibleHeight]
        view.addSubview(sendMsgBar)
        sendMsgBar.sendMsgCallBack = { (message) in
            self.chatMsgArr.append(message)
            let indexPath = IndexPath(item: self.chatMsgArr.count-1, section: 0)
            self.tibleView.reloadData()
//            self.tibleView.reloadRows(at: [indexPath], with: .none)
            self.tibleView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            
        }
    }
    private func setupGiftView() {
        view.addSubview(tibleView)
        giftView.delegate = self
        view.addSubview(giftView)
    }
    private func setupChanelContainer() {
//        chnaelContainer.backgroundColor = UIColor.randomColor()
        view.addSubview(chnaelContainer)
    }
}

//  MARK:监听事件
extension RoomViewController {
    @objc fileprivate func bottomSendBarAppear(_ info: Notification) {
        let duration = info.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (info.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kBarHeight
        
        UIView.animate(withDuration: duration, animations: {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
            let endY = inputViewY == (kScreenH - kBarHeight) ? kScreenH : inputViewY
            self.sendMsgBar.frame.origin.y = endY
            self.tibleView.frame.origin.y = endY == kScreenH ? (kScreenH-kBarHeight-self.tibleView.frame.size.height) : (endY - self.tibleView.frame.size.height)
        })
    }
    
    @objc fileprivate func showGiftView() {
        UIView.animate(withDuration: 0.25) { 
            self.giftView.frame.origin.y = kScreenH - self.giftView.frame.size.height
        }
    }
    
    @objc fileprivate func cleanScreen() {
        self.chatMsgArr.removeAll()
        self.tibleView.reloadData()
    }
}

extension RoomViewController {
    @objc func sendMsg(_ sender:UIButton) {
        if sendMsgBar.textView.canBecomeFirstResponder {
            sendMsgBar.textView.becomeFirstResponder()
        }
        
    }
    @objc func shareClick(_ sender:UIButton) {
        sendMsgBar.textView.becomeFirstResponder()
    }
    @objc func giftBtnClick(_ sender:UIButton) {
        showGiftView()
    }
    @objc func moreBtnClick(_ sender:UIButton) {
        print("更多")
    }
    @objc func starBtnClick(_ sender:UIButton) {
        print("星星")
    }
    @objc func closeBtnClick(_ sender:UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}


extension RoomViewController : UITableViewDataSource,Attriable ,UITableViewDelegate,GiftViewDlegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMsgArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kChatCell, for: indexPath) as! ChatTableViewCell
        let text = chatMsgArr[indexPath.row]
        
        cell.chatLabel?.attributedText = textImgeHibrid(text)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, model cellModel: GiftModel) {
        let giftMsgModel = GiftMsgModel()
        giftMsgModel.name = "chen"
        giftMsgModel.giftName = cellModel.subject
        giftMsgModel.giftURL = cellModel.img2
        chnaelContainer.showChanel(giftMsgModel)
    }

}














