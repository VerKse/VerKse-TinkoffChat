//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Vera on 01.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    var user: User?
    
    lazy var avatarImg: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage.init(named: "userMainColor.png")
        return image
    }()
    
    lazy var nameLable: UILabel = {
        var lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = ""
        lable.font = UIFont.boldSystemFont(ofSize: 30)
        lable.textColor = .mainColor
        return lable
    }()
    
    lazy var aboutText: UITextView = {
        var textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = backView.backgroundColor
        textView.text = ""
        return textView
    }()
    
    lazy var editButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.black.cgColor
        button.titleEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.mainColor, for: .selected)
        button.titleLabel?.adjustsFontSizeToFitWidth = true;
        button.setBackgroundColor(color: .mainLightColor, forState: .disabled)
        button.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)
        button.setTitle("EDIT", for: .normal)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.black.cgColor
        button.titleEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.mainColor, for: .selected)
        button.titleLabel?.adjustsFontSizeToFitWidth = true;
        button.setBackgroundColor(color: .mainLightColor, forState: .disabled)
        button.addTarget(self, action: #selector(saveButtonAction(_:)), for: .touchUpInside)
        button.setTitle("SAVE", for: .normal)
        return button
    }()
    
    lazy var backView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.shadowColor = UIColor.mainColor.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()
    
    lazy var backButton: UIButton = {
        var button = UIButton()
        button.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.backgroundColor = .mainColor
        button.layer.opacity = 1
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.setImage(UIImage.init(named: "backWhite.png"), for: .normal)
        return button
    }()
    
    lazy var backEditButton: UIButton = {
        var button = UIButton()
        button.addTarget(self, action: #selector(backButtonEditAction(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.backgroundColor = .mainColor
        button.layer.opacity = 1
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.setImage(UIImage.init(named: "cancelWhite.png"), for: .normal)
        return button
    }()
    
    lazy var editNameField: UITextField = {
        var editNameField = UITextField()
        editNameField.backgroundColor = .mainLightColor
        editNameField.text = nameLable.text
        editNameField.font = UIFont.boldSystemFont(ofSize: 18)
        editNameField.textColor = .mainColor
        editNameField.translatesAutoresizingMaskIntoConstraints = false
        return editNameField
    }()
    
    lazy var editAboutField: UITextField = {
        var editAboutField = UITextField()
        editAboutField.backgroundColor = .mainLightColor
        editAboutField.text = aboutText.text
        editAboutField.font = UIFont.systemFont(ofSize: 18)
        editAboutField.textColor = .mainColor
        editAboutField.translatesAutoresizingMaskIntoConstraints = false
        return editAboutField
    }()
    
    lazy var editAvatarField: UITextField = {
        var editAvatarField = UITextField()
        editAvatarField.text = "userMainColor.png"
        editAvatarField.font = UIFont.boldSystemFont(ofSize: 18)
        editAvatarField.textColor = .mainColor
        editAvatarField.backgroundColor = .mainLightColor
        editAvatarField.translatesAutoresizingMaskIntoConstraints = false
        return editAvatarField
    }()
    
    lazy var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    let sucsessAlert = UIAlertController(title: "Изменения успешно сохранены",
                                         message: "Абсолютно успешно.",
                                         preferredStyle: .alert)
    let failAlert = UIAlertController(title: "Изменения не успешно сохранены",
                                      message: "Абсолютно не успешно.",
                                      preferredStyle: .alert)

    var ready: Bool = false
    //MARK: Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StorageManager.instance.activate(completion: { _ in })
        StorageManager.instance.load { (user) in
            self.user = user
        }
        
        nameLable.text = user?.name
        aboutText.text = user?.about
        avatarImg.image = UIImage.init(named: user?.avatar ?? "userMainColor.png")
        
        editNameField.text = user?.name
        editAboutField.text = user?.about
        editAvatarField.text = user?.avatar
        
        regularMode()
        backView.addSubview(nameLable)
        backView.addSubview(aboutText)
        view.addSubview(editButton)
        view.addSubview(saveButton)
        view.addSubview(backView)
        view.addSubview(avatarImg)
        view.addSubview(backButton)
        view.addSubview(editAvatarField)
        view.addSubview(editNameField)
        view.addSubview(editAboutField)
        view.addSubview(backEditButton)
        view.backgroundColor = .white
        
        
        //MARK: sucsessAlert
        sucsessAlert.addAction(UIAlertAction(title: "👌", style: .default,
                                             handler: {action in self.regularMode()
        }))
        
        //MARK: failAlert
        failAlert.addAction(UIAlertAction(title: "👌", style: .default,
                                          handler: {action in
                                            self.regularMode()
                                            return
        }))
        
        //MARK: spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.isHidden = true
        spinner.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        //MARK: avatarStack + avatarImg
        view.sendSubviewToBack(avatarImg)
        NSLayoutConstraint.activate([
            avatarImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            avatarImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImg.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.27),
            avatarImg.widthAnchor.constraint(equalTo: avatarImg.heightAnchor),
        ])
        
        
        //MARK: backView: nameLable + aboutText
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: avatarImg.bottomAnchor, constant: -10),
            backView.bottomAnchor.constraint(equalTo: aboutText.bottomAnchor, constant: 50),
            backView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.9),
            
            nameLable.topAnchor.constraint(equalTo: backView.topAnchor, constant: 40),
            
            aboutText.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            aboutText.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 20),
            
            nameLable.centerXAnchor.constraint(equalTo: aboutText.centerXAnchor),
            nameLable.leftAnchor.constraint(greaterThanOrEqualTo: aboutText.leftAnchor),
            nameLable.rightAnchor.constraint(lessThanOrEqualTo: aboutText.rightAnchor)
        ])
        
        // MARK: editButton
        view.bringSubviewToFront(editButton)
        NSLayoutConstraint.activate([
            editButton.centerYAnchor.constraint(equalTo: backView.bottomAnchor),
            editButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor)
        ])
        
        //MARK: backButton
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalTo:backButton.widthAnchor)
        ])
        
        //MARK: backEditButton
        NSLayoutConstraint.activate([
            backEditButton.topAnchor.constraint(equalTo: backButton.topAnchor),
            backEditButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            backEditButton.widthAnchor.constraint(equalToConstant: 30),
            backEditButton.heightAnchor.constraint(equalTo:backButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            editAvatarField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            editAboutField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            editAvatarField.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 50),
            editNameField.topAnchor.constraint(equalTo: editAvatarField.bottomAnchor, constant: 20),
            editAboutField.topAnchor.constraint(equalTo: editNameField.bottomAnchor, constant: 20),
            
            editNameField.leftAnchor.constraint(equalTo: editAvatarField.leftAnchor),
            editNameField.rightAnchor.constraint(equalTo: editAvatarField.rightAnchor),
            editAboutField.leftAnchor.constraint(equalTo: editNameField.leftAnchor),
            editAboutField.rightAnchor.constraint(equalTo: editNameField.rightAnchor),
            editAboutField.widthAnchor.constraint(equalTo: aboutText.widthAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (ProcessInfo.processInfo.environment["UIVC_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application moved from DISAPPEARED/DISAPPEARING to APPEARING : viewWillAppear")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (ProcessInfo.processInfo.environment["UIVC_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application is about to layout its subviews: viewWillLayoutSubviews")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (ProcessInfo.processInfo.environment["UIVC$_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application has just laid out its subviews: viewDidLayoutSubviews")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (ProcessInfo.processInfo.environment["UIVC_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application moved from APPEARING to APPEARED: viewDidAppear")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (ProcessInfo.processInfo.environment["UIVC_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application moved from APPEARED/APPEARING to DISAPPEARING: viewWillDisappear")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if (ProcessInfo.processInfo.environment["UIVC_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application moved from DISAPPEARING to DISAPPEAR: viewDidDisappear")
        }
    }
    
}
