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
    
    let insets = CGFloat(10)
    let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.RawValue(1)]
    
    private lazy var backButton: UIButton = {
        var backButton = UIButton()
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.layer.cornerRadius = 15
        backButton.backgroundColor = .mainColor
        backButton.layer.opacity = 1
        backButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        backButton.setImage(UIImage.init(named: "backWhite.png"), for: .normal)
        return backButton
    }()
    
    private lazy var nameLable: UILabel = {
        var nameLable = UILabel()
        nameLable.text = "Name:"
        nameLable.font = .boldSystemFont(ofSize: 18)
        nameLable.textColor = .mainColor
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        return nameLable
    }()
    
    private lazy var nameTextField: UITextField = {
        var nameTextField = UITextField()
        nameTextField.attributedText = NSAttributedString(string: "New channel", attributes: underlineAttribute)
        nameTextField.layer.cornerRadius = 10
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    }()
    
    private lazy var messageLable: UILabel = {
        var messageLable = UILabel()
        messageLable.translatesAutoresizingMaskIntoConstraints = false
        messageLable.text = "First message:"
        messageLable.font = .boldSystemFont(ofSize: 18)
        messageLable.textColor = .mainColor
        return messageLable
    }()
    private lazy var messageTextField: UITextField = {
        var messageTextField = UITextField()
        messageTextField.attributedText = NSAttributedString(string: "The channel has been created", attributes: underlineAttribute)
        messageTextField.layer.cornerRadius = 10
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        return messageTextField
    }()
    
    private lazy var channelIdentifiers = [String]()
    private lazy var topicLable: UILabel = {
        var topicLable = UILabel()
        topicLable.text = "New channel"
        topicLable.font = UIFont.boldSystemFont(ofSize: 30)
        topicLable.textColor = .mainColor
        topicLable.translatesAutoresizingMaskIntoConstraints = false
        return topicLable
    }()
    
    private lazy var commitButton: UIButton = {
        var commitButton = UIButton()
        commitButton.addTarget(self, action: #selector(commitButtonAction(_:)), for: .touchUpInside)
        commitButton.setImage(UIImage.init(named: "tickMainColor.png"), for: .normal)
        commitButton.backgroundColor = .white
        commitButton.layer.cornerRadius = 15
        commitButton.layer.shadowColor = UIColor.mainColor.cgColor
        commitButton.layer.shadowOpacity = 0.3
        commitButton.layer.shadowOffset = .zero
        commitButton.layer.shadowRadius = 10
        commitButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        commitButton.translatesAutoresizingMaskIntoConstraints = false
        return commitButton
    }()
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    
    let sucsessAlert = UIAlertController(title: "Канал добавлен",
                                         message: "",
                                         preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let margins = view.layoutMarginsGuide
        
        //MARK: backButton
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 30),
            backButton.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalTo:backButton.widthAnchor)
        ])
        
        //MARK: commitButton
        view.addSubview(commitButton)
        NSLayoutConstraint.activate([
            commitButton.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10),
            commitButton.topAnchor.constraint(equalTo: backButton.topAnchor),
            commitButton.widthAnchor.constraint(equalToConstant: 30),
            commitButton.heightAnchor.constraint(equalTo: commitButton.widthAnchor)
        ])
        
        //MARK: topicLable
        view.addSubview(topicLable)
                NSLayoutConstraint.activate([
            topicLable.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 60),
            topicLable.leftAnchor.constraint(equalTo: backButton.leftAnchor),
            topicLable.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10)
        ])
        
        
        //MARK: nameLable+nameTextField
        view.addSubview(nameLable)
        NSLayoutConstraint.activate([
            nameLable.topAnchor.constraint(equalTo: topicLable.bottomAnchor, constant: 60),
            nameLable.leftAnchor.constraint(equalTo: backButton.leftAnchor),
            nameLable.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10)
        ])
        
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.leftAnchor.constraint(equalTo: nameLable.leftAnchor),
            nameTextField.rightAnchor.constraint(equalTo: margins.rightAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 20),
        ])
        
        //MARK: messageTextField
        view.addSubview(messageLable)
        view.addSubview(messageTextField)
        NSLayoutConstraint.activate([
            messageLable.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
            messageLable.leftAnchor.constraint(equalTo: backButton.leftAnchor),
            messageLable.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10),
            messageTextField.leftAnchor.constraint(equalTo: messageLable.leftAnchor),
            messageTextField.rightAnchor.constraint(equalTo: margins.rightAnchor),
            messageTextField.topAnchor.constraint(equalTo: messageLable.bottomAnchor, constant: 20),
        ])
    }
    
    @objc func commitButtonAction(_ sender : UIButton) {
        // MARK: добавить обработку ошибки
        let id = Int(Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970)+(UIDevice.current.identifierForVendor!.hashValue)
        let date = Date.init(timeIntervalSinceNow: 0)
        let newChannel = ChannelModel(identifier: String(id),
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
