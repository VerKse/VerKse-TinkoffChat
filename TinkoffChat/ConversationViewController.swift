//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Vera on 01.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit
struct MessageCellModel {
    let text : String
    let input : Bool
}
class ConversationViewController: UIViewController{
    
    var nameCVC: String?
    
    init(title: String){
        super.init(nibName: nil, bundle: nil)
        self.nameCVC = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var data = [
        MessageCellModel(text: "Давай, подгони бакс.", input: true),
        MessageCellModel(text: "Не, я чаевых не даю.", input: false),
        MessageCellModel(text: "Не даёшь?", input: true),
        MessageCellModel(text: "Не считаю нужным.", input: false),
        MessageCellModel(text: "Не считаешь нужным?", input: true),
        MessageCellModel(text: "Мало платят — пусть уволятся.", input: false),
        MessageCellModel(text: "Последний жид такого не ляпнет. Значит никому не даёшь чаевых?", input: true),
        MessageCellModel(text: "Не даю потому, что общество говорит, что я должен дать. Ну, если я вижу, что стараются — я могу дать сверху. Но давать автоматом — это для бестолковых. Они просто выполняют свои обязанности.", input: false),
        MessageCellModel(text: "Ничего особенного.", input: false),
        MessageCellModel(text: "А что надо особенного? Отвести тебя за угол?", input: true),
        MessageCellModel(text: "Так, я заказал кофе. И сколько мы тут сидим? Она накатила мне всего три чашки. А я бы выпил шесть.", input: false),
        MessageCellModel(text: "Прошу прощения, Мистер Розовый, но вот что вам не надо, так это ещё чашку кофе.", input: true)
    ]
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    var messageView: UITextView = {
        var messageView = UITextView()
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.text = "Write a message..."
        messageView.font = .systemFont(ofSize: 14)
        messageView.textColor = UIColor.blueGrey500.withAlphaComponent(0.5)
        messageView.layer.cornerRadius = 15
        messageView.layer.borderWidth = 1
        messageView.layer.borderColor = UIColor.blueGrey500.withAlphaComponent(0.5).cgColor
        messageView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 15);
        messageView.isScrollEnabled = false
        messageView.isUserInteractionEnabled = false
        return messageView
    }()
    var messageButton: UIButton = {
        var messageButton = UIButton()
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.addTarget(self, action: #selector(messageButtonAction(_:)), for: .touchUpInside)
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.layer.cornerRadius = 20
        messageButton.backgroundColor = .mainColor
        messageButton.layer.opacity = 1
        messageButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        messageButton.setImage(UIImage.init(named: "backWhite.png")?.rotate(radians: .pi/2), for: .normal)
        
        return messageButton
    }()
    var inputStack: UIStackView = {
        var inputStack = UIStackView()
        inputStack.translatesAutoresizingMaskIntoConstraints = false
        return inputStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = nameCVC
        //navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        view.backgroundColor = .white        
        
        let margins = view.layoutMarginsGuide
        
        //MARK: inputStack
        inputStack.addSubview(messageView)
        inputStack.addSubview(messageButton)
        view.addSubview(inputStack)
        NSLayoutConstraint.activate([
            messageView.centerYAnchor.constraint(equalTo: inputStack.centerYAnchor),
            messageView.leftAnchor.constraint(equalTo: inputStack.leftAnchor, constant: 10),
            messageView.widthAnchor.constraint(equalTo: inputStack.widthAnchor, multiplier: 0.8),
            
            messageButton.bottomAnchor.constraint(equalTo: messageView.bottomAnchor),
            messageButton.rightAnchor.constraint(equalTo: inputStack.rightAnchor, constant: -10),
            messageButton.heightAnchor.constraint(equalToConstant: 40),
            messageButton.widthAnchor.constraint(equalTo:  messageButton.heightAnchor),
            
            messageView.heightAnchor.constraint(greaterThanOrEqualTo: messageButton.heightAnchor),
            
            inputStack.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            inputStack.leftAnchor.constraint(equalTo: margins.leftAnchor),
            inputStack.rightAnchor.constraint(equalTo: margins.rightAnchor),
            inputStack.heightAnchor.constraint(equalTo: messageView.heightAnchor, constant:50)
        ])
        
        //MARK: tableView
        tableView.register(MessageCell.self, forCellReuseIdentifier: String(describing: MessageCell.self))
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputStack.topAnchor)
        ])
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.layer.borderWidth = 0
        tableView.separatorStyle = .none
    }
    
    //MARK: Actions
    @objc func messageButtonAction(_ sender : UIButton) {
        print("Message sending...")
    }
}

extension ConversationViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = String(describing: MessageCell.self)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell else {
            return UITableViewCell()
        }
        
        let message = data[indexPath.row]
        cell.isUserInteractionEnabled = false
        cell.inputMessText.backgroundColor = nil
        cell.outputMessText.backgroundColor = nil
        cell.layer.borderWidth = 0

        if (message.input) {
            cell.inputMessText.text = message.text
            cell.inputMessText.backgroundColor = UIColor.blueGrey500.withAlphaComponent(0.25)
            cell.outputMessText.text = ""
        } else {
            cell.outputMessText.text = message.text
            cell.outputMessText.backgroundColor = UIColor.blueGrey500.withAlphaComponent(0.75)
            cell.inputMessText.text = ""
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}


