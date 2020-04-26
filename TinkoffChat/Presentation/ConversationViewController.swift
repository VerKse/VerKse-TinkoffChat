//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Vera on 01.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController, UIGestureRecognizerDelegate{
    
    var channel: Channel?
    
    init(channel: Channel){
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = channel.name
        self.channel = channel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var messageList = [MessageCellModel]()
    private lazy var db = Firestore.firestore()
    private lazy var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    private lazy var reference: CollectionReference = {
        guard let channelIdentifier = channel?.identifier else { fatalError() }
        return db.collection("channels").document(channelIdentifier).collection("messages")
    }()
    
    //private lazy var messageService = GeneralMessagesService(channel: channel ?? Channel(identifier: "", name: "", lastMessage: "", lastActivity: Date.init(timeIntervalSinceNow: 0)))
    
    private lazy var messageView: UITextView = {
        var messageView = UITextView()
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.text = ""
        messageView.font = .systemFont(ofSize: 14)
        messageView.textColor = UIColor.blueGrey500.withAlphaComponent(0.5)
        messageView.layer.cornerRadius = 15
        messageView.layer.borderWidth = 1
        messageView.layer.borderColor = UIColor.blueGrey500.withAlphaComponent(0.5).cgColor
        messageView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 15);
        messageView.isScrollEnabled = false
        messageView.isUserInteractionEnabled = true
        messageView.delegate = self
        return messageView
    }()
    
    private lazy var messageButton: UIButton = {
        var messageButton = UIButton()
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.addTarget(self, action: #selector(messageButtonAction(_:)), for: .touchUpInside)
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.layer.cornerRadius = 20
        messageButton.backgroundColor = .mainLightColor
        messageButton.layer.opacity = 1
        messageButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        messageButton.setImage(UIImage.init(named: "backWhite.png"), for: .normal)
        messageButton.setImage(UIImage.init(named: "backWhite.png")?.rotate(radians: .pi/2), for: .normal)
        messageButton.isEnabled = false
        return messageButton
    }()
    
    private lazy var inputStack: UIStackView = {
        var inputStack = UIStackView()
        inputStack.translatesAutoresizingMaskIntoConstraints = false
        return inputStack
    }()
    
    private lazy var tableView : UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(MessageCell.self, forCellReuseIdentifier: String(describing: MessageCell.self))
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.layer.borderWidth = 0
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = CoatAnimation.init(viewController: self, view: view)
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //MARK: spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        view.bringSubviewToFront(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        //messageService.updateChannelList(tableView: tableView)
        reference.addSnapshotListener { [weak self]snapshot, error in
            self?.spinner.isHidden = false
            self?.messageList.removeAll()
            for doc in snapshot!.documents {
                let date = doc.data()["created"] as! Timestamp
                
                let newMess = MessageCellModel(content: doc.data()["content"] as! String,
                                               created: date.dateValue(),
                                               senderId: stringFromAny(doc.data()["senderID"]),
                                               senderName: stringFromAny(doc.data()["senderName"]))
                self?.messageList.append(newMess)
            }
            
            self?.messageList = (self!.messageList.sorted(by: { (mcm1, mcm2) -> Bool in
                if (mcm1.created < mcm2.created){
                    return true
                } else {return false}
            }))
            self?.spinner.isHidden = true
            self?.tableView.reloadData()
            if (self?.messageList.count != 0) {
                self?.tableView.scrollToRow(at: IndexPath(item:(self?.messageList.count ?? 1) - 1, section: 0), at: .bottom, animated: false)
            }
        }
        
        view.backgroundColor = .white        
        
        let margins = view.layoutMarginsGuide
        
        //MARK: inputStack
        inputStack.addSubview(messageView)
        inputStack.addSubview(messageButton)
        view.addSubview(inputStack)
        NSLayoutConstraint.activate([
            messageView.centerYAnchor.constraint(equalTo: inputStack.centerYAnchor),
            messageView.leftAnchor.constraint(equalTo: inputStack.leftAnchor, constant: 10),
            messageView.widthAnchor.constraint(equalTo: inputStack.widthAnchor, multiplier: 0.8),
            
            messageButton.bottomAnchor.constraint(equalTo: messageView.bottomAnchor),
            messageButton.rightAnchor.constraint(equalTo: inputStack.rightAnchor, constant: -10),
            messageButton.heightAnchor.constraint(equalToConstant: 40),
            messageButton.widthAnchor.constraint(equalTo:  messageButton.heightAnchor),
            
            messageView.heightAnchor.constraint(greaterThanOrEqualTo: messageButton.heightAnchor),
            
            inputStack.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            inputStack.leftAnchor.constraint(equalTo: margins.leftAnchor),
            inputStack.rightAnchor.constraint(equalTo: margins.rightAnchor),
            inputStack.heightAnchor.constraint(equalTo: messageView.heightAnchor, constant:30)
        ])
        
        //MARK: tableView
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputStack.topAnchor)
        ])
    }
    
    //MARK: Actions
    @objc func messageButtonAction(_ sender : UIButton) {
        print("Message sending...")
        let newMessage = MessageCellModel(content: messageView.text,
                                          created: .init(timeIntervalSinceNow: 0),
                                          senderId: String(UIDevice.current.identifierForVendor!.hashValue),
                                          senderName: "Shtirliz"
        )
        //messageService.sendMessage(message: newMessage)
        reference.addDocument(data: newMessage.toDict)
        messageView.text = ""
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

extension ConversationViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = String(describing: MessageCell.self)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell else {
            return UITableViewCell()
            
        }
        /*      let messageLeftAlign = cell.inputMessText.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 10)
         let messageRightAlign = cell.inputMessText.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -10)
         */
        let message = messageList[indexPath.row]
        if (message.senderId == String(UIDevice.current.identifierForVendor!.hashValue)){
            
            cell.senderNameLable.text = "me"
            cell.inputMessText.backgroundColor = UIColor.mainColor
        } else{
            cell.senderNameLable.text = message.senderName
            cell.inputMessText.backgroundColor = UIColor.blueGrey500.withAlphaComponent(0.25)
        }
        cell.isUserInteractionEnabled = false
        
        cell.inputMessText.text = message.content
        let formatter = DateFormatter()
        if(Calendar.current.isDateInToday(message.created)) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "HH:mm dd MMM"
        }
        cell.timeLable.text = formatter.string(from: message.created)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}


extension ConversationViewController: UITextViewDelegate{

    
    func textViewDidChange(_ textView: UITextView) {
        if (self.messageView.text == "") {
                messageButtonAnimation(color: .mainLightColor)
                self.messageButton.isEnabled = false
        } else if (!self.messageButton.isEnabled){
            messageButtonAnimation(color: .mainColor)
            self.messageButton.isEnabled = true
        }
    }
    
    func messageButtonAnimation(color: UIColor){
        UIView.animate(withDuration: 0.5, animations: {
            self.messageButton.backgroundColor = color
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.messageButton.transform = .init(scaleX: 1.15, y: 1.15)
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: [], animations: {
                self.messageButton.transform = .init(scaleX: 1, y: 1)
            }, completion: nil)
        })
        
        
    }
}
