//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Vera on 01.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit

var DIR = "/Users/main/Documents/Tinkoff/TinkoffChat/"

struct UserInfo{
    let name: String
    let about: String
    let image: String
}

class GCDDataManager{
    
    func save(info: UserInfo, completion: @escaping (Bool)-> Void){
        DispatchQueue.global().async {
            if info.name != fileDataIntoString("name") {
                stringToFileData(info.name, fileName: "name")
            }
            if info.about != fileDataIntoString("about") {
                stringToFileData(info.about, fileName: "about")
            }
            if info.image != fileDataIntoString("img") {
                stringToFileData(info.image, fileName: "img")
            }
            //этот малыш просто чтобы показать как крутится spinner
            sleep(5)
            completion(true)
        }
    }
    
    func uploadUserInfo(completion: @escaping (UserInfo)->Void){
        DispatchQueue.main.async{
            let userInfo = UserInfo.init(name: fileDataIntoString("name") ?? "Name",
                                         about: fileDataIntoString("about") ?? "Bio",
                                         image: fileDataIntoString("img") ?? "userMainColor.png")
            completion(userInfo)
        }
    }
}

class OperationDataManager : Operation {
    
    var inputName:UITextField
    var outputName:String?
    
    init(inputName:UITextField){
        self.inputName = inputName
    }
    
    override func main(){
        stringToFileData(inputName.text ?? "text", fileName: "name")
    }
}

class ProfileViewController: UIViewController {
    
    lazy var regularView = UIView()
    lazy var avatarImg = UIImageView()
    lazy var nameLable = UILabel()
    lazy var aboutText = UITextView()
    lazy var editButton = UIButton()
    lazy var backView = UIView()
    lazy var backButton = UIButton()
    lazy var avatarStack = UIStackView()
    lazy var imageName: String = "userMainColor.png"
    
    lazy var editNameField = UITextField()
    lazy var editAboutField = UITextField()
    lazy var editAvatarField = UITextField()
    //lazy var editAvatarStack = UIStackView()
    lazy var warningObj = UIView()
    lazy var warningLable = UILabel()
    lazy var gcdButton = UIButton()
    lazy var operationButton = UIButton()
    lazy var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    //MARK: Properties
    override func viewDidLoad() {
        
        super.viewDidLoad()
        regularMode()
        view.addSubview(nameLable)
        view.addSubview(aboutText)
        view.addSubview(editButton)
        view.addSubview(backView)
        avatarStack.addSubview(avatarImg)
        view.addSubview(avatarStack)
        view.addSubview(backButton)
        view.backgroundColor = .white
        
        let margins = view.layoutMarginsGuide
        
        //MARK: spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.isHidden = true
        spinner.backgroundColor = UIColor.black.withAlphaComponent(0.75)
            
        //MARK: avatarStack + avatarImg
        view.sendSubviewToBack(avatarStack)
        avatarStack.translatesAutoresizingMaskIntoConstraints = false
        avatarImg.translatesAutoresizingMaskIntoConstraints = false
        imageName = fileDataIntoString("img") ?? "userMainColor.png"
        avatarImg.image = UIImage.init(named: imageName)
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
            backView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            backView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
        
        //MARK: nameLable
        view.bringSubviewToFront(nameLable)
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLable.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 40),
            nameLable.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            nameLable.centerYAnchor.constraint(lessThanOrEqualTo: backView.topAnchor, constant: 50)
        ])
        nameLable.text = fileDataIntoString("name")// "Иван Иванов"
        nameLable.font = UIFont.boldSystemFont(ofSize: 30)
        nameLable.textColor = .mainColor
        
        //MARK: aboutText
        view.bringSubviewToFront(aboutText)
        aboutText.translatesAutoresizingMaskIntoConstraints = false
        aboutText.backgroundColor = backView.backgroundColor
        aboutText.text = fileDataIntoString("about") //"\u{1F496} программировать под iOS \n😍 убирать варнинги \n😍 верстать в storyboard'ах\n\u{1F496} убирать варнинги \n\u{1F496} ещё раз убирать варнинги"
        NSLayoutConstraint.activate([
            aboutText.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 20),
            aboutText.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -10),
            aboutText.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 20),
            aboutText.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -30)
        ])
        
        aboutText.font = UIFont.systemFont(ofSize: 18)
        aboutText.isScrollEnabled = true
        aboutText.isEditable = false
        
        // MARK: editButton
        designEditButton(editButton)
        editButton.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)
        view.bringSubviewToFront(editButton)
        NSLayoutConstraint.activate([
            editButton.centerYAnchor.constraint(equalTo: backView.bottomAnchor),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        editButton.setTitle("EDIT", for: .normal)
        
        //MARK: backButton
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.layer.cornerRadius = 15
        backButton.backgroundColor = .mainColor
        backButton.layer.opacity = 1
        backButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        backButton.setImage(UIImage.init(named: "backWhite.png"), for: .normal)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: avatarStack.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalTo:backButton.widthAnchor)
        ])
        
        //MARK: editWarning
        warningLable.text = "Экран в режиме редактирования"
        warningObj.backgroundColor = .none
        warningObj.layer.borderColor = UIColor.red.cgColor
        warningObj.layer.borderWidth = 1
        warningLable.font = .systemFont(ofSize: 12)
        warningLable.textColor = .blueGrey500
        warningObj.addSubview(warningLable)
        view.addSubview(warningObj)
        warningObj.translatesAutoresizingMaskIntoConstraints = false
        warningLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            warningObj.topAnchor.constraint(equalTo: self.view.topAnchor),
            warningObj.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            warningObj.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            warningObj.heightAnchor.constraint(equalToConstant: 40),
            warningLable.centerYAnchor.constraint(equalTo: warningObj.centerYAnchor),
            warningLable.leftAnchor.constraint(equalTo: warningObj.leftAnchor, constant: 20 )
        ])
        
        //MARK: saveButton
        designEditButton(gcdButton)
        designEditButton(operationButton)
        view.addSubview(gcdButton)
        view.addSubview(operationButton)
        gcdButton.setTitle("GCD", for: .normal)
        operationButton.setTitle("OPERATION", for: .normal)
        gcdButton.translatesAutoresizingMaskIntoConstraints = false
        operationButton.translatesAutoresizingMaskIntoConstraints = false
        gcdButton.addTarget(self, action: #selector(gcdButtonAction(_:)), for: .touchUpInside)
        operationButton.addTarget(self, action: #selector(operationButtonAction(_:)), for: .touchUpInside)
        
        //MARK: editAvatar
        view.addSubview(editAvatarField)
        editAvatarField.text = imageName
        editNameField.font = UIFont.boldSystemFont(ofSize: 18)
        editNameField.textColor = .mainColor
        editAvatarField.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: editNameField
        view.addSubview(editNameField)
        editNameField.text = nameLable.text
        editNameField.font = UIFont.boldSystemFont(ofSize: 18)
        editNameField.textColor = .mainColor
        editNameField.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: editAboutField
        view.addSubview(editAboutField)
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
        warningObj.isHidden = true
        warningLable.isHidden = true
        editNameField.isHidden = true
        editAboutField.isHidden = true
        editAvatarField.isHidden = true
        gcdButton.isHidden = true
        operationButton.isHidden = true
        editButton.isHidden = false
        backButton.isHidden = false
        avatarImg.isHidden = false
        nameLable.isHidden = false
        aboutText.isHidden = false
        editButton.isHidden = false
        backView.isHidden = false
        avatarStack.isHidden = false
        editNameField.endEditing(true)
        editAboutField.endEditing(true)
        editAvatarField.endEditing(true)
    }
    
    func editMode(){
        editButton.isHidden = true
        avatarImg.isHidden = true
        nameLable.isHidden = true
        aboutText.isHidden = true
        editButton.isHidden = true
        backView.isHidden = true
        avatarStack.isHidden = true
        warningObj.isHidden = false
        warningLable.isHidden = false
        editNameField.isHidden = false
        editAboutField.isHidden = false
        editAvatarField.isHidden = false
        gcdButton.isHidden = false
        operationButton.isHidden = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: warningObj.bottomAnchor, constant: 10),
            backButton.leftAnchor.constraint(equalTo: editNameField.leftAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalTo:backButton.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            gcdButton.bottomAnchor.constraint(equalTo: backButton.bottomAnchor),
            gcdButton.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: 20),
            gcdButton.heightAnchor.constraint(equalToConstant: 30),
            operationButton.bottomAnchor.constraint(equalTo: backButton.bottomAnchor),
            operationButton.leftAnchor.constraint(equalTo: gcdButton.rightAnchor, constant: 20),
            operationButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        gcdButton.layer.cornerRadius = 15
        operationButton.layer.cornerRadius = 15
        gcdButton.isEnabled = false
        operationButton.isEnabled = false
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
            self.editNameField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            self.editAboutField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            self.editAvatarField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
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
    
    @objc func textFieldDidChange(_ textField: UITextField){
        self.gcdButton.isEnabled = true
        self.operationButton.isEnabled = true
    }
    
    @objc func gcdButtonAction(_ sender: UIButton!) {
        gcdButton.isEnabled = false
        operationButton.isEnabled = false
        
        view.bringSubviewToFront(spinner)
        spinner.startAnimating()
        spinner.isHidden = false
        let gcd = GCDDataManager()
        let userInfo = UserInfo.init(name: editNameField.text ?? "",
                                     about: editAboutField.text ?? "",
                                     image: editAvatarField.text ?? "")
        gcd.save(info: userInfo) {isSucces in
            guard isSucces else{
                let alert = UIAlertController(title: "Изменения не успешно сохранены",
                                              message: "Абсолютно не успешно.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "👌", style: .default,
                                              handler: {action in
                    self.regularMode()
                    return
                }))
                alert.addAction(UIAlertAction(title: "Повторить", style: .default,
                                              handler: {action in
                               gcd.save(info: userInfo) {isSucces in
                           guard isSucces else{
                               let alert = UIAlertController(title: "И снова не получилось.",
                                                             message: "",
                                                             preferredStyle: .alert)
                               alert.addAction(UIAlertAction(title: "👌", style: .default,
                                                             handler: {action in
                                   self.regularMode()
                               }))
                               return
                           }
                           gcd.uploadUserInfo { userInfo in
                               self.nameLable.text = userInfo.name
                               self.aboutText.text = userInfo.about
                               self.avatarImg.image = UIImage.init(named: userInfo.image)
                               self.spinner.isHidden = true
                               let alert = UIAlertController(title: "Изменения успешно сохранены",
                                                             message: "Абсолютно успешно.",
                                                             preferredStyle: .alert)
                               alert.addAction(UIAlertAction(title: "👌", style: .default,
                                                             handler: {action in self.regularMode()
                               }))
                               self.present(alert, animated: true)
                           }
                       }
                }))
                return
            }
            gcd.uploadUserInfo { userInfo in
                self.nameLable.text = userInfo.name
                self.aboutText.text = userInfo.about
                self.avatarImg.image = UIImage.init(named: userInfo.image)
                self.spinner.isHidden = true
                let alert = UIAlertController(title: "Изменения успешно сохранены",
                                              message: "Абсолютно успешно.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "👌", style: .default,
                                              handler: {action in self.regularMode()
                }))

                self.present(alert, animated: true)
            }
        }
    }
    
    @objc func operationButtonAction(_ sender: UIButton!) {
        gcdButton.isEnabled = false
        operationButton.isEnabled = false
        print ("operationButtonAction")
        
        
        let saveQueue = OperationQueue()
        let uploadQueue = OperationQueue()
        
        for data in [editNameField, editAboutField]{
            let operation = OperationDataManager.init(inputName: data)
            operation.completionBlock = {
                
            }
        }
        saveQueue.waitUntilAllOperationsAreFinished()
        uploadQueue.waitUntilAllOperationsAreFinished()
        
        regularMode()
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

func designEditButton (_ button: UIButton) {
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
}

func stringToFileData(_ text: String, fileName: String){
    
    let path = "\(DIR)\(fileName).txt"
    
    do {
        try text.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
    }
    catch {print("Writing error")}
    
}

func fileDataIntoString(_ fileName: String) -> String?{
    let path = "\(DIR)\(fileName).txt"
    
    do {
        return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
    }
    catch {print("Reading error")}
    
    return nil
}

