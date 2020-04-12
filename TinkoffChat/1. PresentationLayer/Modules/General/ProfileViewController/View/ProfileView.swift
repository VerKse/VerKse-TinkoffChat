//
//  ProfileView.swift
//  TinkoffChat
//
//  Created by Vera on 12.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import UIKit

class ProfileView: UIView{
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        regularMode()
        backView.addSubview(nameLable)
        backView.addSubview(aboutText)
        self.addSubview(editButton)
        self.addSubview(saveButton)
        self.addSubview(backView)
        self.addSubview(avatarImg)
        self.addSubview(backButton)
        self.addSubview(editAvatarField)
        self.addSubview(editNameField)
        self.addSubview(editAboutField)
        self.addSubview(backEditButton)
        self.backgroundColor = .white
        
        //MARK: avatarStack + avatarImg
        self.sendSubviewToBack(avatarImg)
        NSLayoutConstraint.activate([
            avatarImg.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
            avatarImg.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            avatarImg.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.27),
            avatarImg.widthAnchor.constraint(equalTo: avatarImg.heightAnchor),
        ])
        
        
        //MARK: backView: nameLable + aboutText
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: avatarImg.bottomAnchor, constant: -10),
            backView.bottomAnchor.constraint(equalTo: aboutText.bottomAnchor, constant: 50),
            backView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier:0.9),
            
            nameLable.topAnchor.constraint(equalTo: backView.topAnchor, constant: 40),
            
            aboutText.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            aboutText.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 20),
            
            nameLable.centerXAnchor.constraint(equalTo: aboutText.centerXAnchor),
            nameLable.leftAnchor.constraint(greaterThanOrEqualTo: aboutText.leftAnchor),
            nameLable.rightAnchor.constraint(lessThanOrEqualTo: aboutText.rightAnchor)
        ])
        
        // MARK: editButton
        self.bringSubviewToFront(editButton)
        NSLayoutConstraint.activate([
            editButton.centerYAnchor.constraint(equalTo: backView.bottomAnchor),
            editButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor)
        ])
        
        //MARK: backButton
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalTo:backButton.widthAnchor)
        ])
        
        //MARK: backEditButton
        NSLayoutConstraint.activate([
            backEditButton.topAnchor.constraint(equalTo: backButton.topAnchor),
            backEditButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            backEditButton.widthAnchor.constraint(equalToConstant: 30),
            backEditButton.heightAnchor.constraint(equalTo:backButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            editAvatarField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            editAboutField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            
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
            backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leftAnchor.constraint(equalTo: editNameField.leftAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalTo:backButton.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            saveButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
