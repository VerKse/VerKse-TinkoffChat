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
    var profileView: ProfileView! {
        return self.view as? ProfileView
    }
    
    
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
        
        self.profileView.editButton.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)
        self.profileView.saveButton.addTarget(self, action: #selector(saveButtonAction(_:)), for: .touchUpInside)
        self.profileView.backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        self.profileView.backEditButton.addTarget(self, action: #selector(backButtonEditAction(_:)), for: .touchUpInside)
        self.profileView.nameLable.text = user?.name
        self.profileView.aboutText.text = user?.about
        self.profileView.avatarImg.image = UIImage.init(named: user?.avatar ?? "userMainColor.png")
        self.profileView.editNameField.text = user?.name
        self.profileView.editAboutField.text = user?.about
        self.profileView.editAvatarField.text = user?.avatar
        
        
        //MARK: sucsessAlert
        sucsessAlert.addAction(UIAlertAction(title: "👌", style: .default,
                                             handler: {action in self.profileView.regularMode()
        }))
        
        //MARK: failAlert
        failAlert.addAction(UIAlertAction(title: "👌", style: .default,
                                          handler: {action in
                                            self.profileView.regularMode()
                                            return
        }))
        
        //MARK: spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.isHidden = true
        spinner.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
    }
    
    //MARK: Actions
    @objc func backButtonAction(_ sender : UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonEditAction(_ sender : UIButton) {
        self.profileView.regularMode()
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
            
            self.profileView.editMode()
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
            self.profileView.nameLable.text = user?.name
            self.profileView.aboutText.text = user?.about
            self.profileView.avatarImg.image = UIImage.init(named: user?.avatar ?? "userMainColor.png")
            
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
        if self.profileView.editNameField.text!.isEmpty {
            let alert = UIAlertController(title: "Validation error", message: "Input the name of the User!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        self.user?.name = self.profileView.editNameField.text
        self.user?.about = self.profileView.editAboutField.text
        self.user?.avatar = self.profileView.editAvatarField.text
        
        StorageManager.instance.save(profile: self.user!, completion: { _ in })
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
