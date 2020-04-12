//
//  ProfileViewController+EditMode.swift
//  TinkoffChat
//
//  Created by Vera on 12.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ProfileViewController{
    
    //MARK: Actions
    @objc func backButtonAction(_ sender : UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonEditAction(_ sender : UIButton) {
        regularMode()
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
            aboutText.text = user?.about
            avatarImg.image = UIImage.init(named: user?.avatar ?? "userMainColor.png")
            
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
        
        self.user?.name = editNameField.text
        self.user?.about = editAboutField.text
        self.user?.avatar = editAvatarField.text
        
        StorageManager.instance.save(profile: self.user!, completion: { _ in })
        return true
    }
    
    func regularMode(){
        
        editNameField.isHidden = true
        editAboutField.isHidden = true
        editAvatarField.isHidden = true
        saveButton.isHidden = true
        editButton.isHidden = false
        avatarImg.isHidden = false
        nameLable.isHidden = false
        aboutText.isHidden = false
        editButton.isHidden = false
        backView.isHidden = false
        avatarImg.isHidden = false
        editNameField.endEditing(true)
        editAboutField.endEditing(true)
        editAvatarField.endEditing(true)
        backEditButton.isHidden = true
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
        editNameField.endEditing(false)
        editAboutField.endEditing(false)
        editAvatarField.endEditing(false)
        backEditButton.isHidden = false
        editNameField.becomeFirstResponder()
        editAboutField.becomeFirstResponder()
        editAvatarField.becomeFirstResponder()

        
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
}
