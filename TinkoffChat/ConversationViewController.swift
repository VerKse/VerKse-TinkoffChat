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
        MessageCellModel(text: "input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1 input1", input: true),
        MessageCellModel(text: "output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2 output2", input: false),
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
        MessageCellModel(text: "input18", input: true),
        MessageCellModel(text: "output19", input: false),
        MessageCellModel(text: "input20", input: true),
        MessageCellModel(text: "output21", input: false),
        MessageCellModel(text: "input22", input: true),
        MessageCellModel(text: "output23", input: false),
    ]
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = nameCVC
        view.backgroundColor = .white
        
        let margins = view.layoutMarginsGuide
        
        //MARK: tableView
        tableView.register(MessageCell.self, forCellReuseIdentifier: String(describing: MessageCell.self))
        view.addSubview(tableView)
        tableView.backgroundColor = .white
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
            cell.inputMessText.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            cell.outputMessText.text = ""
        } else {
            cell.outputMessText.text = message.text
            cell.outputMessText.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
            cell.inputMessText.text = ""
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
}


