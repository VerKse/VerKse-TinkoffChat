//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Vera on 01.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {
    let coreDataStack = StorageManager()
    
    var user: User?
    var imagePicker = UIImagePickerController()
    
    lazy var avatarImg: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage.init(named: "userMainColor.png")
        image.isUserInteractionEnabled = true
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.updateAvatarAction(_:)))
        singleTap.numberOfTouchesRequired = 1
        image.addGestureRecognizer(singleTap)
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
        button.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(saveButtonAction(_:)), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
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
    
    private lazy var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    let sucsessAlert = UIAlertController(title: "Изменения успешно сохранены",
                                         message: "Абсолютно успешно.",
                                         preferredStyle: .alert)
    let failAlert = UIAlertController(title: "Изменения не успешно сохранены",
                                      message: "Абсолютно не успешно.",
                                      preferredStyle: .alert)
    
    
    var ready: Bool = false
    
    var mainView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .none
        return view
    }()
    
    var panGestureRecognizer = UIPanGestureRecognizer()
    var longGestureRecognizer = UILongPressGestureRecognizer()
    var coat = Coat()
    
    //MARK: Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        //let _ = CoatAnimation.init(viewController: self, view: mainView)
        panGestureRecognizer.addTarget(self, action: #selector(panAction(_:)))
        longGestureRecognizer.addTarget(self, action: #selector(longAction(_:)))
        mainView.addGestureRecognizer(panGestureRecognizer)
        mainView.addGestureRecognizer(longGestureRecognizer)
        
        coreDataStack.activate(completion: { _ in })
        coreDataStack.load { (user) in
            self.user = user
        }
        
        imagePicker.delegate = self
        
        nameLable.text = user?.name
        aboutText.text = user?.about
        avatarImg.image = UIImage.init(named: user?.avatar ?? "userMainColor.png")
        
        editNameField.text = user?.name
        editAboutField.text = user?.about
        editAvatarField.text = user?.avatar
        
        regularMode()
        backView.addSubview(nameLable)
        backView.addSubview(aboutText)
        mainView.addSubview(editButton)
        mainView.addSubview(saveButton)
        mainView.addSubview(backView)
        mainView.addSubview(avatarImg)
        mainView.addSubview(backButton)
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
        mainView.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.isHidden = true
        spinner.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        //MARK: avatarImg
        mainView.sendSubviewToBack(avatarImg)
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
        mainView.bringSubviewToFront(editButton)
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
        mainView.addSubview(backEditButton)
        NSLayoutConstraint.activate([
            backEditButton.topAnchor.constraint(equalTo: backButton.topAnchor),
            backEditButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            backEditButton.widthAnchor.constraint(equalToConstant: 30),
            backEditButton.heightAnchor.constraint(equalTo:backButton.widthAnchor)
        ])
        
        //MARK: editAvatarField
        mainView.addSubview(editAvatarField)
        editAvatarField.text = "userMainColor.png"
        editAvatarField.font = UIFont.boldSystemFont(ofSize: 18)
        editAvatarField.textColor = .mainColor
        editAvatarField.backgroundColor = .mainLightColor
        editAvatarField.translatesAutoresizingMaskIntoConstraints = false
        
        
        //MARK: editNameField
        mainView.addSubview(editNameField)
        editNameField.backgroundColor = .mainLightColor
        editNameField.text = nameLable.text
        editNameField.font = UIFont.boldSystemFont(ofSize: 18)
        editNameField.textColor = .mainColor
        editNameField.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: editAboutField
        mainView.addSubview(editAboutField)
        editAboutField.backgroundColor = .mainLightColor
        editAboutField.text = aboutText.text
        editAboutField.font = UIFont.systemFont(ofSize: 18)
        editAboutField.textColor = .mainColor
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
    
    //MARK: Actions
    @objc func panAction(_ gestureRecognizer: UIPanGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: self.view)
        coat.animateAt(touchPoint: touchPoint, view: self.view)
    }

    @objc func longAction(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: self.view)
        coat.animateAt(touchPoint: touchPoint, view: self.view)
    }
    
    @objc func updateAvatarAction(_ sender : UIButton) {
        
        let actionSheet = UIAlertController(title: "", message: "Настройте профиль", preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Сфотографировать", style: UIAlertAction.Style.default, handler: { (action:UIAlertAction) in
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
            {
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert  = UIAlertController(title: "Warning", message: "Something wrong with your camera 📷", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
        
        let galleryAction = UIAlertAction(title: "Выбрать из галереи", style: UIAlertAction.Style.default, handler: { (action:UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let uploadAction = UIAlertAction(title: "Загрузить", style: UIAlertAction.Style.default, handler: { (action:UIAlertAction) in
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 16
            let galleryViewController = GalleryViewController(collectionViewLayout: layout)
            self.present(galleryViewController, animated: true, completion: nil)
        })
        
        let closeAction = UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.cancel){ (Action) -> Void in }
        /*
         if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
         actionSheet.addAction(cameraAction)
         }
         
         if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
         actionSheet.addAction(galleryAction)
         }*/
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(uploadAction)
        actionSheet.addAction(closeAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func backButtonAction(_ sender : UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonEditAction(_ sender : UIButton) {
        regularMode()
    }
    
    @objc func editButtonAction(_ sender: UIButton!) {
        
        let actionSheet = UIAlertController(title: "", message: "Настройте профиль", preferredStyle: UIAlertController.Style.actionSheet)
        
        let editAction = UIAlertAction(title: "Редактировать описание", style: UIAlertAction.Style.default, handler: { (action:UIAlertAction) in
            self.editMode()
        })
        
        let closeAction = UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.cancel){ (Action) -> Void in }
        
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
        
        coreDataStack.save(profile: self.user!, completion: { _ in })
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
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:-- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.avatarImg.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
