//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Vera on 01.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit

struct ConversationCellModel {
    let name : String
    let message : String
    let date : Date
    let isOnline : Bool
    let hasUnreadMessage : Bool
}

class ConversationsListViewController: UIViewController{
    
    private var onlineData: [ConversationCellModel] = []
    private var historyData: [ConversationCellModel] = []
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = [
            ConversationCellModel(name: "user1", message: "message1", date:  Date(),
                                  isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "user2", message: "", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "user3", message: "message3", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: true, hasUnreadMessage: true),
            ConversationCellModel(name: "user4", message: "message4", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "user5", message: "message5", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "user6", message: "", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "user7", message: "message7", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "user8", message: "message", date:  Date(),
                                  isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "user9", message: "", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "user10", message: "messagemessagemessagemessagemessagemessagemessagemessage", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: true, hasUnreadMessage: true),
            ConversationCellModel(name: "user11", message: "message", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "user12", message: "message", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "user13", message: "", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "user14", message: "message", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "user15", message: "message", date:  Date(),
                                  isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "user16", message: "", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "user17", message: "message", date:  Date(),
                                  isOnline: true, hasUnreadMessage: true),
            ConversationCellModel(name: "user18", message: "message", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "user19", message: "message", date:  Date(),
                                  isOnline: false, hasUnreadMessage: true),
            ConversationCellModel(name: "user20", message: "", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "user21", message: "message", date:  .init(timeIntervalSince1970: 0),
                                  isOnline: false, hasUnreadMessage: false)]
        generateSectionsData(data: data)
        
        navigationItem.title = "Tinkoff Chat"
        view.backgroundColor = .white
        
        let margins = view.layoutMarginsGuide
        let profileButton = UIButton()
        
        //MARK: profileButton
        profileButton.addTarget(self, action: #selector(profileButtonAction(_:)), for: .touchUpInside)
        view.addSubview(profileButton)
        profileButton.setImage(UIImage.init(named: "userMainColor.png"), for: .normal)
        profileButton.backgroundColor = .white
        profileButton.layer.cornerRadius = 30
        let insets = CGFloat(10)
        profileButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            profileButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10),
            profileButton.widthAnchor.constraint(equalToConstant: 60),
            profileButton.heightAnchor.constraint(equalTo: profileButton.widthAnchor)
        ])
        
        //MARK: tableView
        tableView.register(UINib(nibName: String(describing: ConversationCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: ConversationCell.self))
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: profileButton.topAnchor, constant: -20)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    //MARK: Actions
    @objc func profileButtonAction(_ sender : UIButton) {
        let profileViewController = ProfileViewController()
        present(profileViewController, animated: true, completion: nil)
    }
    
    func generateSectionsData( data: [ConversationCellModel]){
        for user in data {
            if (user.isOnline == true) {
                onlineData.append(user)
            } else {
                historyData.append(user)
            }
        }
    }
}

extension ConversationsListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.onlineData.count
        case 1:
            return self.historyData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: ConversationCell.self))
            else {
             return UITableViewCell()
        }
        
        
        switch indexPath.section {
        case 0:
            let user = onlineData[indexPath.row]
            cell.backgroundColor = .yellowLight
            makeCell(cell: cell as! ConversationCell, user: user)
        case 1:
            let user = historyData[indexPath.row]
            cell.backgroundColor = .white
            makeCell(cell: cell as! ConversationCell, user: user)
        default:
            cell.textLabel?.text = "Cell #\(indexPath.row)"
        }
        
        return cell
    }
    
    func makeCell( cell: ConversationCell,  user: ConversationCellModel){
        
        cell.nameLable.text = user.name
        if (user.hasUnreadMessage) {
            cell.messageLable.font = .boldSystemFont(ofSize: 16)
            cell.messageLable.text = user.message
        } else if (user.message.isEmpty) {
            cell.messageLable.font = UIFont(name:"Avenir", size: 10)
            cell.messageLable.text = "No messages yet"
        } else {
            cell.messageLable.font = .systemFont(ofSize: 16)
            cell.messageLable.text = user.message}
        
        let formatter = DateFormatter()
        if(Calendar.current.compare(Date(), to: user.date, toGranularity: .day) == ComparisonResult.orderedSame) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "dd MMM"
        }
        cell.dateLable.text = formatter.string(from: user.date)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.cellForRow(at: indexPath) as! ConversationCell
        
        let conversationViewController = ConversationViewController()
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return "Section header \(section)"
        }
    }
}
