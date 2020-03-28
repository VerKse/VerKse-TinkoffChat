//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Vera on 01.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit

struct UserInfo{
    var name: String
    var about: String?
    var image: String?
}

class ProfileViewController: UIViewController {
    
    var user: User?

    private lazy var avatarImg: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage.init(named: "userMainColor.png")
        return image
    }()
    
    private lazy var nameLable: UILabel = {
        var lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Иван Иванов"
        lable.font = UIFont.boldSystemFont(ofSize: 30)
        lable.textColor = .mainColor
        return lable
    }()
    
    private lazy var aboutText: UITextView = {
        var textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = backView.backgroundColor
        textView.text = "\u{1F496} программировать под iOS \n😍 убирать варнинги \n😍 верстать в storyboard'ах\n\u{1F496} убирать варнинги \n\u{1F496} ещё раз убирать варнинги"
        return textView
    }()
    
    private lazy var editButton: UIButton = {
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
    
    private lazy var saveButton: UIButton = {
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
    
    private lazy var backView: UIView = {
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
    
    private lazy var backButton: UIButton = {
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
    
    private lazy var editNameField = UITextField()
    private lazy var editAboutField = UITextField()
    private lazy var editAvatarField = UITextField()
    
    private lazy var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    let sucsessAlert = UIAlertController(title: "Изменения успешно сохранены",
                                         message: "Абсолютно успешно.",
                                         preferredStyle: .alert)
    let failAlert = UIAlertController(title: "Изменения не успешно сохранены",
                                      message: "Абсолютно не успешно.",
                                      preferredStyle: .alert)
    var fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "User", keyForSort: "name")
    
    //MARK: Properties
    override func viewDidLoad() {
        
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
        let userList = fetchedResultsController.fetchedObjects
        
        if (userList?.isEmpty ?? true) {
            user?.name = "Ivan"
            user?.about = ""
        } else { user = userList?[0] as? User }
        
        nameLable.text = user?.name
        aboutText.text = user?.about
        
        regularMode()
        backView.addSubview(nameLable)
        backView.addSubview(aboutText)
        view.addSubview(editButton)
        view.addSubview(saveButton)
        view.addSubview(backView)
        view.addSubview(avatarImg)
        view.addSubview(backButton)
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
            backView.bottomAnchor.constraint(equalTo: aboutText.bottomAnchor, constant: 30),
            backView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.9),
            
            nameLable.topAnchor.constraint(equalTo: backView.topAnchor, constant: 40),
            
            aboutText.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            aboutText.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 0.8),
            aboutText.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 20),
            
            nameLable.leftAnchor.constraint(equalTo: aboutText.leftAnchor),
            nameLable.rightAnchor.constraint(equalTo: aboutText.rightAnchor)
        ])
        
        // MARK: editButton
        view.bringSubviewToFront(editButton)
        NSLayoutConstraint.activate([
            editButton.centerYAnchor.constraint(equalTo: backView.bottomAnchor),
            editButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor)
        ])
        
        //MARK: backButton
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: avatarImg.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalTo:backButton.widthAnchor)
        ])
        
        //MARK: editAvatar
        view.addSubview(editAvatarField)
        //editAvatarField.text = imageName
        editAvatarField.font = UIFont.boldSystemFont(ofSize: 18)
        editAvatarField.textColor = .mainColor
        editAvatarField.backgroundColor = .mainLightColor
        editAvatarField.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: editNameField
        view.addSubview(editNameField)
        editNameField.backgroundColor = .mainLightColor
        editNameField.text = nameLable.text
        editNameField.font = UIFont.boldSystemFont(ofSize: 18)
        editNameField.textColor = .mainColor
        editNameField.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: editAboutField
        view.addSubview(editAboutField)
        editAboutField.backgroundColor = .mainLightColor
        editAboutField.text = aboutText.text
        editAboutField.font = UIFont.systemFont(ofSize: 18)
        editAboutField.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    func regularMode(){
        
        editNameField.isHidden = true
        editAboutField.isHidden = true
        editAvatarField.isHidden = true
        saveButton.isHidden = true
        editButton.isHidden = false
        backButton.isHidden = false
        avatarImg.isHidden = false
        nameLable.isHidden = false
        aboutText.isHidden = false
        editButton.isHidden = false
        backView.isHidden = false
        avatarImg.isHidden = false
        editNameField.endEditing(true)
        editAboutField.endEditing(true)
        editAvatarField.endEditing(true)
    }
    
    func editMode(){
        saveButton.isHidden = false
        editButton.isHidden = true
        avatarImg.isHidden = true
        nameLable.isHidden = true
        aboutText.isHidden = true
        editButton.isHidden = true
        backView.isHidden = true
        avatarImg.isHidden = true
        editNameField.isHidden = false
        editAboutField.isHidden = false
        editAvatarField.isHidden = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leftAnchor.constraint(equalTo: editNameField.leftAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalTo:backButton.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
            
            self.editMode()
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
    
     @objc func saveButtonAction(_ sender: UIButton!) {
        if (saveUser()) {
            nameLable.text = user?.name
            aboutText.text = "about"
            
            self.present(self.sucsessAlert, animated: true)
        } else {
            self.failAlert.addAction(UIAlertAction(title: "Ок", style: .default,
                                                   handler: {action in self.dismiss(animated: true, completion: nil)

            }))
            self.present(self.failAlert, animated: true)
            return
        }
    }
    
    func saveUser() -> Bool {
        if editNameField.text!.isEmpty {
            let alert = UIAlertController(title: "Validation error", message: "Input the name of the User!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
    
        user?.name = editNameField.text
        user?.about = editAboutField.text
        CoreDataManager.instance.saveContext()
        
        return true
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
