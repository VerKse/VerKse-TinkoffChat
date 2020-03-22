//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Vera on 01.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit
import Firebase




class ConversationsListViewController: UIViewController{
    
    private var onlineData: [ConversationCellModel] = []
    private var historyData: [ConversationCellModel] = []
    //private lazy var db = Firestore.firestore()
    //private lazy var reference = db.collection("channels")
    
    private lazy var firebaseService = FirebaseService(GeneralFirebaseService)
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var profileButton = UIButton()
    private lazy var spinner = UIActivityIndicatorView(style: .whiteLarge)
    private lazy var testChannel = ""
    private lazy var channelList = [Channel]()
    var data = [ConversationCellModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let margins = view.layoutMarginsGuide
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.mainColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Tinkoff Chat"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false

        
        //MARK: spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        view.bringSubviewToFront(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.isHidden = false
        
        
        FirebaseApp.configure()
        reference.addSnapshotListener { [weak self] snapshot, error in
            self?.data.removeAll()
            self?.onlineData.removeAll()
            self?.historyData.removeAll()
            self?.channelList.removeAll()
            
            for doc in snapshot!.documents {
                let date = doc.data()["lastActivity"] as? Timestamp
                let newChannel = Channel(identifier: doc.documentID,
                                         name: doc.data()["name"] as! String,
                                         lastMessage: doc.data()["lastMessage"] as? String,
                                         lastActivity: date?.dateValue())
                self?.channelList.append(newChannel)
            }
            
            for channel in self!.channelList{
                self!.data.append(ConversationCellModel(channel: channel, hasUnreadMessage: false))
            }
            self!.generateSectionsData(dataSet: self!.data)
            
            
            self!.spinner.isHidden = true
            self!.tableView.reloadData()
        }
    
        
        //MARK: profileButton
        profileButton.addTarget(self, action: #selector(profileButtonAction(_:)), for: .touchUpInside)
        view.addSubview(profileButton)
        profileButton.setImage(UIImage.init(named: "userMainColor.png"), for: .normal)
        profileButton.backgroundColor = .white
        profileButton.layer.cornerRadius = 30
        profileButton.layer.shadowColor = UIColor.mainColor.cgColor
        profileButton.layer.shadowOpacity = 0.3
        profileButton.layer.shadowOffset = .zero
        profileButton.layer.shadowRadius = 10
        let insets = CGFloat(10)
        profileButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            profileButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10),
            profileButton.widthAnchor.constraint(equalToConstant: 60),
            profileButton.heightAnchor.constraint(equalTo: profileButton.widthAnchor)
        ])
        
        //MARK: addChannelButton
        let addChannelButton = UIButton()
        addChannelButton.addTarget(self, action: #selector(addChannelButtonAction(_:)), for: .touchUpInside)
        view.addSubview(addChannelButton)
        addChannelButton.setImage(UIImage.init(named: "penMainColor.png"), for: .normal)
        addChannelButton.backgroundColor = .white
        addChannelButton.layer.cornerRadius = 30
        addChannelButton.layer.shadowColor = UIColor.mainColor.cgColor
        addChannelButton.layer.shadowOpacity = 0.3
        addChannelButton.layer.shadowOffset = .zero
        addChannelButton.layer.shadowRadius = 10
        addChannelButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        addChannelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addChannelButton.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -50),
            addChannelButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10),
            addChannelButton.widthAnchor.constraint(equalTo: profileButton.widthAnchor),
            addChannelButton.heightAnchor.constraint(equalTo: addChannelButton.widthAnchor)
        ])
        
        //MARK: view
        //view.addSubview(niceView)
        
        //MARK: tableView
        tableView.register(ConversationCell.self, forCellReuseIdentifier: String(describing: ConversationCell.self))
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
    
    @objc func addChannelButtonAction(_ sender : UIButton) {
        let channelAddViewController = ChannelAddViewController()
        present(channelAddViewController, animated: true, completion: nil)
    }
    
    func generateSectionsData( dataSet: [ConversationCellModel]){
        for data in dataSet {
            if (data.channel.lastActivity==nil ) { historyData.append(data) }
            else if (data.channel.lastActivity!>Date.init(timeIntervalSinceNow: -10*60)){
                onlineData.append(data)
            } else {
                historyData.append(data)
            }
            onlineData = onlineData.sorted { (ccm1, ccm2) -> Bool in
                if (ccm1.channel.lastActivity! < ccm2.channel.lastActivity!){
                return false
                } else {return true}
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
        let identifier = String(describing: ConversationCell.self)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            let user = onlineData[indexPath.row]
            cell.backgroundColor = .yellowLight
            makeCell(cell: cell, user: user)
        case 1:
            let user = historyData[indexPath.row]
            cell.backgroundColor = .white
            makeCell(cell: cell, user: user)
        default:
            cell.textLabel?.text = "Cell #\(indexPath.row)"
        }
        
        return cell
    }
    
    func makeCell( cell: ConversationCell,  user: ConversationCellModel){
        
        cell.nameLable.text = user.channel.name
        if (user.hasUnreadMessage) {
            cell.messageLable.font = .boldSystemFont(ofSize: 16)
            cell.messageLable.text = user.channel.lastMessage
        } else if (user.channel.lastMessage == nil) {
            cell.messageLable.font = .systemFont(ofSize: 16)
            cell.messageLable.text = "No messages yet"
        } else {
            cell.messageLable.font = .systemFont(ofSize: 16)
            cell.messageLable.text = user.channel.lastMessage}
        
        let formatter = DateFormatter()
        if (user.channel.lastActivity == nil ) {cell.dateLable.text = ""}
        else {if(Calendar.current.isDateInToday(user.channel.lastActivity!)) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "dd MMM"
        }
        cell.dateLable.text = formatter.string(from: user.channel.lastActivity!)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            let channel = Channel(identifier: onlineData[indexPath.row].channel.identifier,
                                 name: onlineData[indexPath.row].channel.name,
                                 lastMessage: nil,
                                 lastActivity: nil)
            let conversationViewController = ConversationViewController.init(channel: channel)
            navigationController?.pushViewController(conversationViewController, animated: true)
            break
        case 1:
            let channel = Channel(identifier: historyData[indexPath.row].channel.identifier,
                             name: historyData[indexPath.row].channel.name,
                             lastMessage: nil,
                             lastActivity: nil)
            let conversationViewController = ConversationViewController.init(channel: channel)
            navigationController?.pushViewController(conversationViewController, animated: true)
            break
        default:
            break
        }
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
