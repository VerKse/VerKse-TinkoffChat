//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Vera on 16.02.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    //MARK: Properties
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var editButton: UIButton!
    
    

    // init не позволяет вывести frame кнопки «редактировать», так как компоненты контроллера ещё не проинициализированы
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let margins = view.layoutMarginsGuide
        
        avatarButton.backgroundColor = UIColor(red:0.25, green:0.47, blue:0.94, alpha:1.0)
        avatarButton.layer.cornerRadius = 20
        avatarButton.setTitle("", for: .normal)
        avatarButton.imageEdgeInsets = UIEdgeInsets(top:10, left:10, bottom:10, right:10)
        avatarButton.trailingAnchor.constraint(equalTo: avatarImg.trailingAnchor).isActive = true
        avatarButton.bottomAnchor.constraint(equalTo: avatarImg.bottomAnchor).isActive = true
        view.bringSubviewToFront(avatarButton)
            
        avatarImg.layer.cornerRadius = 20
        avatarImg.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        avatarImg.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        avatarImg.heightAnchor.constraint(equalTo: avatarImg.widthAnchor).isActive = true
        avatarImg.image = UIImage.init(named: "placeholder-user.png")
        
        nameLable.text = "Александр Фёдоров"
        nameLable.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        nameLable.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        aboutText.text = "\u{1F496} программировать под iOS \n\u{1F496} убирать варнинги \n\u{1F496} верстать в storyboard'ах\n\u{1F496} убирать варнинги \n\u{1F496} ещё раз убирать варнинги\n🚀  \n🐶🐮 \n🥳 🥴 🥺"
        nameLable.font = UIFont.boldSystemFont(ofSize: 30)
        aboutText.font = UIFont.systemFont(ofSize: 18)
        aboutText.isScrollEnabled = true
        aboutText.isEditable = false
        aboutText.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        aboutText.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        editButton.backgroundColor = UIColor.white
        editButton.layer.cornerRadius = 15
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.setTitleColor(UIColor.black, for: .normal)
        editButton.titleEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        editButton.setTitleColor(.black, for: .normal)
        editButton.setTitle("редактировать", for: .normal)
        editButton.widthAnchor.constraint(equalTo: avatarImg.widthAnchor).isActive = true
        
        print("🌚 Редактировать.frame.viewDidLoad:")
        print(editButton.frame)
        
    }

    
    //MARK: Actions
    @IBAction func avatarButton(_ sender: Any) {
        print(" 🐲 Выберите изображение профиля")
        
        let imagePicker = UIImagePickerController()

        let actionSheet = UIAlertController(title: "", message: "Выберите изображение профиля", preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Выбрать из галереи", style: UIAlertAction.Style.default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(actionSheet, animated: true, completion: nil)
        })
        
        let galleryAction = UIAlertAction(title: "Сделать фото", style: UIAlertAction.Style.default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        
        let closeAction = UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.cancel){ (Action) -> Void in }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            actionSheet.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            actionSheet.addAction(galleryAction)
        }
        
        actionSheet.addAction(cameraAction)
        //actionSheet.addAction(galleryAction)
        actionSheet.addAction(closeAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func editButton(_ sender: Any) {
        print(" 🐲 Редактируйте профиль")
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
        
        //frame отличается, потому что в .storyboard файле выбран девайс iPhoneSE, а в качестве запускаемого симулятора выбран iPhone8Plus -- размер экрана этих устройств различаются, а констерйнты динамические:
        //  на X и Y  (выравнивание по вертикали),
        //  EditButton.bottom = Safe Area.bottom - 10,
        //  width от leadingAnchor и trailinAnchor
        print("🌚 Редактировать.frame.viewDidAppear:")
        print(editButton.frame)
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
