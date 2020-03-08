//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Vera on 01.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: Properties
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let avatarImg = UIImageView()
        let nameLable = UILabel()
        let aboutText = UITextView()
        let editButton = UIButton()
        let backView = UIView()
        let backButton = UIButton()
        let avatarStack = UIStackView()
        
        view.addSubview(nameLable)
        view.addSubview(aboutText)
        view.addSubview(editButton)
        view.addSubview(backView)
        avatarStack.addSubview(avatarImg)
        view.addSubview(avatarStack)
        view.addSubview(backButton)
        view.backgroundColor = .white
        
        let margins = view.layoutMarginsGuide
        
        //MARK: avatarStack + avatarImg
        view.sendSubviewToBack(avatarStack)
        avatarStack.translatesAutoresizingMaskIntoConstraints = false
        avatarImg.translatesAutoresizingMaskIntoConstraints = false
        avatarImg.image = UIImage.init(named: "userMainColor.png")
        NSLayoutConstraint.activate([
            avatarStack.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 100),
            avatarStack.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -100),
            avatarStack.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40),
            avatarStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarStack.heightAnchor.constraint(equalTo: avatarStack.widthAnchor),
            
            avatarImg.leadingAnchor.constraint(equalTo: avatarStack.leadingAnchor),
            avatarImg.trailingAnchor.constraint(equalTo: avatarStack.trailingAnchor),
            avatarImg.topAnchor.constraint(equalTo: avatarStack.topAnchor),
            avatarImg.centerXAnchor.constraint(equalTo: avatarStack.centerXAnchor),
            avatarImg.heightAnchor.constraint(equalTo: avatarImg.widthAnchor)
        ])
        
        
        //MARK: backView
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 30
        backView.layer.shadowColor = UIColor.mainColor.cgColor
        backView.layer.shadowOpacity = 0.3
        backView.layer.shadowOffset = .zero
        backView.layer.shadowRadius = 10
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: avatarStack.bottomAnchor, constant: -10),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400),
            backView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        //MARK: nameLable
        view.bringSubviewToFront(nameLable)
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLable.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 40),
            nameLable.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            nameLable.centerYAnchor.constraint(lessThanOrEqualTo: backView.topAnchor, constant: 50)
        ])
        nameLable.text = "Иван Иванов"
        nameLable.font = UIFont.boldSystemFont(ofSize: 30)
        nameLable.textColor = .mainColor
        
        //MARK: aboutText
        view.bringSubviewToFront(aboutText)
        aboutText.translatesAutoresizingMaskIntoConstraints = false
        aboutText.backgroundColor = backView.backgroundColor
        //MARK: внутренняя тень не тень
        /*aboutText.layer.shadowColor = UIColor.white.cgColor
         aboutText.layer.shadowOpacity = 1
         aboutText.layer.shadowOffset = .zero
         aboutText.layer.shadowRadius = -3*/
        NSLayoutConstraint.activate([
            aboutText.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            aboutText.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            aboutText.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 20),
            aboutText.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -30)
        ])
        aboutText.text = "\u{1F496} программировать под iOS \n😍 убирать варнинги \n😍 верстать в storyboard'ах\n\u{1F496} убирать варнинги \n\u{1F496} ещё раз убирать варнинги"
        aboutText.font = UIFont.systemFont(ofSize: 18)
        aboutText.isScrollEnabled = true
        aboutText.isEditable = false
        
        // MARK: editButton
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)
        view.bringSubviewToFront(editButton)
        NSLayoutConstraint.activate([
            editButton.heightAnchor.constraint(equalToConstant: 50),
            editButton.centerYAnchor.constraint(equalTo: backView.bottomAnchor),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        editButton.backgroundColor = .mainColor
        editButton.layer.cornerRadius = 25
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.titleEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        editButton.setTitleColor(.white, for: .normal)
        //MARK: editButton.setImage(UIImage.init(named: "pen.svg"), for: .normal)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        editButton.setTitle("EDIT", for: .normal)
        editButton.setTitleColor(.mainColor, for: .selected)
        
        //MARK: backButton
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: avatarStack.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalTo:backButton.widthAnchor)
        ])
        backButton.layer.cornerRadius = 15
        backButton.backgroundColor = .mainColor
        backButton.layer.opacity = 1
        backButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        backButton.setImage(UIImage.init(named: "backWhite.png"), for: .normal)
    }
    
    
    //MARK: Actions
    @objc func backButtonAction(_ sender : UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func editButtonAction(_ sender: UIButton!) {
        
        let imagePicker = UIImagePickerController()
        
        let actionSheet = UIAlertController(title: "", message: "Настройте профиль", preferredStyle: UIAlertController.Style.actionSheet)
        
        let galleryAction = UIAlertAction(title: "Выбрать фото из галереи", style: UIAlertAction.Style.default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        })
        
        let cameraAction = UIAlertAction(title: "Сделать фото", style: UIAlertAction.Style.default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        
        let editAction = UIAlertAction(title: "Редактировать описание", style: UIAlertAction.Style.default, handler: { (action:UIAlertAction) in
            self.present(imagePicker, animated: true, completion: nil)
        })
        
        let closeAction = UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.cancel){ (Action) -> Void in }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            actionSheet.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            actionSheet.addAction(galleryAction)
        }
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(closeAction)
        
        present(actionSheet, animated: true, completion: nil)
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
