//
//  ChannelList+UIViewController.swift
//  TinkoffChat
//
//  Created by Vera on 05.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit
import Firebase
import CoreData


@available(iOS 13.0, *)
class ChannelListViewController: UIViewController, NSFetchedResultsControllerDelegate{
    
    var channelListView: ChannelListView! {
        return self.view as? ChannelListView
    }
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    lazy var channelFetchedResultsController =
        StorageManager.instance.fetchedResultsController(
            entityName: "Channel",
            sortDescriptor: [NSSortDescriptor(key: "isActive", ascending: true), NSSortDescriptor(key: "lastActivity", ascending: true)],
            sectionNameKeyPath: "isActive",
            predicate: nil,
            cacheName: "channelCache")

    
    
    
    var channelService = ChannelListServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelListView.profileButton.addTarget(self, action: #selector(profileButtonAction(_:)), for: .touchUpInside)
        channelListView.addChannelButton.addTarget(self, action: #selector(addChannelButtonAction(_:)), for: .touchUpInside)
        
        channelFetchedResultsController.delegate = self
    
        channelService.listener(completion: { _ in            
            //NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: "channelCache")
            
        })
        
        do{
            try self.channelFetchedResultsController.performFetch()
        } catch {
            print("Error: \(error))")
        }
    
        
        //MARK: tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        view.addSubview(tableView)
        tableView.register(ConversationCell.self, forCellReuseIdentifier: String(describing: ConversationCell.self))
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: channelListView.bottomView.topAnchor)
        ])
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.mainColor]
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationItem.title = "Tinkoff Chat"
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
}

