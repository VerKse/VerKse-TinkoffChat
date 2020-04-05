//
//  ChannelAddViewController.swift
//  TinkoffChat
//
//  Created by Vera on 21.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit
import Firebase

class ChannelAddViewController: UIViewController {
    
    private lazy var backButton = UIButton()
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    private lazy var nameLable = UILabel()
    private lazy var nameTextField = UITextField()
    private lazy var messageLable = UILabel()
    private lazy var messageTextField = UITextField()
    private lazy var channelIdentifiers = [String]()
    private lazy var topicLable = UILabel()
    
    let sucsessAlert = UIAlertController(title: "Канал добавлен",
                                         message: "",
                                         preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let margins = view.layoutMarginsGuide
        let commitButton = UIButton()
        let insets = CGFloat(10)
        
        //MARK: backButton = UIButton()
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.layer.cornerRadius = 15
        backButton.backgroundColor = .mainColor
        backButton.layer.opacity = 1
        backButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        backButton.setImage(UIImage.init(named: "backWhite.png"), for: .normal)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 30),
            backButton.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalTo:backButton.widthAnchor)
        ])
        
        //MARK: commitButton
        commitButton.addTarget(self, action: #selector(commitButtonAction(_:)), for: .touchUpInside)
        view.addSubview(commitButton)
        commitButton.setImage(UIImage.init(named: "tickMainColor.png"), for: .normal)
        commitButton.backgroundColor = .white
        commitButton.layer.cornerRadius = 15
        commitButton.layer.shadowColor = UIColor.mainColor.cgColor
        commitButton.layer.shadowOpacity = 0.3
        commitButton.layer.shadowOffset = .zero
        commitButton.layer.shadowRadius = 10
        commitButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        commitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commitButton.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10),
            commitButton.topAnchor.constraint(equalTo: backButton.topAnchor),
            commitButton.widthAnchor.constraint(equalToConstant: 30),
            commitButton.heightAnchor.constraint(equalTo: commitButton.widthAnchor)
        ])
        
        //MARK: topicLable
        view.addSubview(topicLable)
        topicLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topicLable.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 60),
            topicLable.leftAnchor.constraint(equalTo: backButton.leftAnchor),
            topicLable.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10)
        ])
        topicLable.text = "New channel"
        topicLable.font = UIFont.boldSystemFont(ofSize: 30)
        topicLable.textColor = .mainColor
        
        
        //MARK: nameLable+nameTextField
        view.addSubview(nameLable)
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLable.topAnchor.constraint(equalTo: topicLable.bottomAnchor, constant: 60),
            nameLable.leftAnchor.constraint(equalTo: backButton.leftAnchor),
            nameLable.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10)
        ])
        nameLable.text = "Name:"
        nameLable.font = .boldSystemFont(ofSize: 18)
        nameLable.textColor = .mainColor
        view.addSubview(nameTextField)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.RawValue(1)]
        nameTextField.attributedText = NSAttributedString(string: "New channel", attributes: underlineAttribute)
        nameTextField.layer.cornerRadius = 10
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.leftAnchor.constraint(equalTo: nameLable.leftAnchor),
            nameTextField.rightAnchor.constraint(equalTo: margins.rightAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 20),
        ])
        
        //MARK: messageTextField
        view.addSubview(messageLable)
        messageLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLable.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
            messageLable.leftAnchor.constraint(equalTo: backButton.leftAnchor),
            messageLable.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10)
        ])
        messageLable.text = "First message:"
        messageLable.font = .boldSystemFont(ofSize: 18)
        messageLable.textColor = .mainColor
        view.addSubview(messageTextField)
        messageTextField.attributedText = NSAttributedString(string: "The channel has been created", attributes: underlineAttribute)
        messageTextField.layer.cornerRadius = 10
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageTextField.leftAnchor.constraint(equalTo: messageLable.leftAnchor),
            messageTextField.rightAnchor.constraint(equalTo: margins.rightAnchor),
            messageTextField.topAnchor.constraint(equalTo: messageLable.bottomAnchor, constant: 20),
        ])
        
        
        
    }
    
    @objc func commitButtonAction(_ sender : UIButton) {
        // MARK: добавить обработку ошибки
        let id = Int(Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970)+(UIDevice.current.identifierForVendor!.hashValue)
        let date = Date.init(timeIntervalSinceNow: 0)
        let newChannel = ChannelOld(identifier: String(id),
                                 name: stringFromAny(self.nameTextField.text),
                                 lastMessage: stringFromAny(self.messageTextField.text),
                                 lastActivity: date)
        reference.addDocument(data: ["identifier": newChannel.identifier,
                                     "name": newChannel.name as Any,
                                     "lastMessage": newChannel.lastMessage as Any,
                                     "lastActivity": newChannel.lastActivity as Any])
        let newMessage = MessageCellModel(content: stringFromAny(self.messageTextField.text),
                                          created: date,
                                          senderId: String(UIDevice.current.identifierForVendor!.hashValue),
                                          senderName: "Vera")
        let messegeReference: CollectionReference = {
            return db.collection("channels").document(String(id)).collection("messages")
        }()
        messegeReference.addDocument(data: newMessage.toDict)
        //MARK: sucsessAlert
        sucsessAlert.addAction(UIAlertAction(title: "👌", style: .default,
                                             handler: {action in self.backAction()
        }))
        self.present(self.sucsessAlert, animated: true)
    }
    
    //MARK: Actions
    @objc func backButtonAction(_ sender : UIButton) {
        backAction()
    }
    
    func backAction(){
        dismiss(animated: true, completion: nil)
        self.nameTextField.endEditing(true)
        self.messageTextField.endEditing(true)
    }
    
}
