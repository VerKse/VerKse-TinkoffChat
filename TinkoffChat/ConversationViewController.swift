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


/*
struct MessageCellModel {
    let text : String
    let input : Bool
}

class ConversationViewController: UIViewController
{
    private lazy var tableView = UITableView()
    
    private lazy var data = [
        MessageCellModel(text: "wnobiktwbonirb", input: true),
        MessageCellModel(text: "kisjroh roitjmopek p ijieoh me", input: false),
        MessageCellModel(text: "w nbr erbrbiktwbokjnboko ekjnboe bjpe[orp roitjmopek p ijieoh me", input: false),
        MessageCellModel(text: "kisjroh roitjmopek p ijieoh me", input: true),
        MessageCellModel(text: "w nbr erbrbiktwbokjnboko ekjnboe bjpe[orp roitjmopek p ijieoh me", input: true),
        MessageCellModel(text: "kisjroh roitjmopek p ijieoh me", input: false),
        MessageCellModel(text: "w nbr erbrbiktwbokjnboko ekjnboe bjpe[orp roitjmopek p ijieoh me", input: false),
    ]
    
    var nameCVC = "Conversation"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = nameCVC// "ConversationViewController"
        view.backgroundColor = .white
        
        //MARK: tableView
        tableView.register(UINib(nibName: String(describing: MessageCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: MessageCell.self))
        view.addSubview(tableView)
        view.bringSubviewToFront(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.topAnchor)
        ])
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }
}

extension ConversationViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        if (data[indexPath.row].input) {
            cell.inputMessText.text = data[indexPath.row].text
            cell.outputMessText.text = ""
        } else {
            cell.inputMessText.text = ""
            cell.outputMessText.text = data[indexPath.row].text
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
*/


class ConversationViewController: UIViewController{
    
    private var data = [
        MessageCellModel(text: "input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 ", input: true),
        MessageCellModel(text: "output2 output2 output2 output2 output2 output2 output2 output2 output2", input: false),
        MessageCellModel(text: "output3", input: false),
        MessageCellModel(text: "input4", input: true),
        MessageCellModel(text: "input5", input: true),
        MessageCellModel(text: "output6", input: false),
        MessageCellModel(text: "output7", input: false),
        MessageCellModel(text: "input8", input: true),
        MessageCellModel(text: "output9", input: false),
        MessageCellModel(text: "input10", input: true),
        MessageCellModel(text: "output11", input: false),
        MessageCellModel(text: "input12", input: true),
        MessageCellModel(text: "output13", input: false),
        MessageCellModel(text: "input14", input: true),
        MessageCellModel(text: "output15", input: false),
        MessageCellModel(text: "input16", input: true),
        MessageCellModel(text: "output17", input: false),
    ]
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Tinkoff Chat"
        view.backgroundColor = .white
        
        let margins = view.layoutMarginsGuide
        
        //MARK: tableView
        tableView.register(UINib(nibName: String(describing: MessageCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: MessageCell.self))
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10)
        ])
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
}

extension ConversationViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        let message = data[indexPath.row]
        cell.isUserInteractionEnabled = false
        
        if (message.input) {
            cell.inputMessText.text = message.text
            cell.outputMessText.text = ""
        } else {
            cell.inputMessText.text = ""
            cell.outputMessText.text = message.text
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
}


