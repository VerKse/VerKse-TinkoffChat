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
class ChannelList: UIViewController, NSFetchedResultsControllerDelegate{
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    lazy var firebaseService = GeneralFirebaseService(collection: "channel")
        
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    lazy var  onlineChannelFetchedResultsController =
        StorageManager.instance.fetchedResultsController(entityName: "Channel",
                                                 keyForSort: "lastActivity",
                                                 sectionNameKeyPath: nil,
                                                 sortAscending: false,
                                                 predicate: NSPredicate(format: "lastActivity < %@",
                                                 Date.init(timeIntervalSinceNow: -10*60) as NSDate))
    
    lazy var offlineChannelFetchedResultsController =
        StorageManager.instance.fetchedResultsController(entityName: "Channel",
                                                 keyForSort: "lastActivity",
                                                 sectionNameKeyPath: nil,
                                                 sortAscending: false,
                                                 predicate: NSPredicate(format: "lastActivity > %@",
                                                 Date.init(timeIntervalSinceNow: -10*60) as NSDate))
    
    let insets = CGFloat(5)
    
    lazy var profileButton: UIButton = {
        var profileButton = UIButton()
        profileButton.addTarget(self, action: #selector(profileButtonAction(_:)), for: .touchUpInside)
        profileButton.setImage(UIImage.init(named: "userWhite.png"), for: .normal)
        profileButton.layer.cornerRadius = 30
        profileButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        return profileButton
    }()
    
    lazy var addChannelButton: UIButton={
        var addChannelButton = UIButton()
        addChannelButton.addTarget(self, action: #selector(addChannelButtonAction(_:)), for: .touchUpInside)
        addChannelButton.setImage(UIImage.init(named: "penWhite.png"), for: .normal)
        addChannelButton.layer.cornerRadius = 30
        addChannelButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        addChannelButton.translatesAutoresizingMaskIntoConstraints = false
        return addChannelButton
    }()
    
    lazy var profileLabel: UILabel={
        var label = UILabel()
        label.text = "Profile"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var channelLabel: UILabel={
        var label = UILabel()
        label.text = "Add Channel"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bottomView: UIView = {
        var bottomStack = UIView()
        bottomStack.backgroundColor = .mainColor
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        return bottomStack
    }()
    
    var spinner : UIActivityIndicatorView{
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onlineChannelFetchedResultsController.delegate = self
        offlineChannelFetchedResultsController.delegate = self
        
        reference.addSnapshotListener { [weak self] snapshot, error in
            for doc in snapshot!.documents {
                let date = doc.data()["lastActivity"] as? Timestamp
                let channel = Channel()
                channel.name = stringFromAny(doc.data()["name"])
                channel.identifier = doc.documentID
                channel.lastMessage = stringFromAny(doc.data()["lastMessage"])
                channel.lastActivity = date?.dateValue()
                StorageManager.instance.saveContext()
            }
            
            do{
                try self?.onlineChannelFetchedResultsController.performFetch()
                try self?.offlineChannelFetchedResultsController.performFetch()
            } catch {
                print("Error: \(error))")
            }
            self?.tableView.reloadData()
        }
        
        //MARK: bottomStack
        bottomView.addSubview(profileButton)
        bottomView.addSubview(addChannelButton)
        bottomView.addSubview(profileLabel)
        bottomView.addSubview(channelLabel)
        
        view.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        //MARK: profileButton
        NSLayoutConstraint.activate([
            profileButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: -5),
            profileButton.rightAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: -40),
            profileButton.widthAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 0.6),
            profileButton.heightAnchor.constraint(equalTo: profileButton.widthAnchor)
        ])
        
        //MARK: addChannelButton
        NSLayoutConstraint.activate([
            addChannelButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: -5),
            addChannelButton.leftAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 40),
            addChannelButton.widthAnchor.constraint(equalTo: profileButton.widthAnchor),
            addChannelButton.heightAnchor.constraint(equalTo: addChannelButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            profileLabel.centerXAnchor.constraint(equalTo: profileButton.centerXAnchor),
            profileLabel.topAnchor.constraint(equalTo: profileButton.bottomAnchor),
            
            channelLabel.centerXAnchor.constraint(equalTo:addChannelButton.centerXAnchor),
            channelLabel.topAnchor.constraint(equalTo: addChannelButton.bottomAnchor),
        ])
        
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
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationItem.title = "Tinkoff Chat"
        navigationItem.largeTitleDisplayMode = .automatic
        //navigationItem.searchController = UISearchController(searchResultsController: nil)
        //navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.sizeToFit()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    private func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [(indexPath as IndexPath)], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let channel = onlineChannelFetchedResultsController.object(at: indexPath as IndexPath) as! Channel
                let cell = tableView.cellForRow(at: indexPath as IndexPath)
                cell!.textLabel?.text = channel.name
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [(indexPath as IndexPath)], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [(newIndexPath as IndexPath)], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [(indexPath as IndexPath)], with: .automatic)
            }
        @unknown default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
