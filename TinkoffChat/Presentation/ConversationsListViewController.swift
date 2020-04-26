//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Vera on 01.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit
import Firebase
@available(iOS 13.0, *)
class ConversationsListViewController: UIViewController, UIGestureRecognizerDelegate{
    
    private var onlineData: [ConversationCellModel] = []
    private var historyData: [ConversationCellModel] = []
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    private lazy var firebaseService = GeneralFirebaseService(collection: "channel")
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let insets = CGFloat(5)
    private lazy var profileButton: UIButton = {
        var profileButton = UIButton()
        profileButton.addTarget(self, action: #selector(showProfileAction(_:)), for: .touchUpInside)
        profileButton.setImage(UIImage.init(named: "userWhite.png"), for: .normal)
        profileButton.layer.cornerRadius = 30
        profileButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        return profileButton
    }()
    
    private lazy var addChannelButton: UIButton={
        var addChannelButton = UIButton()
        addChannelButton.addTarget(self, action: #selector(addChannelButtonAction(_:)), for: .touchUpInside)
        addChannelButton.setImage(UIImage.init(named: "penWhite.png"), for: .normal)
        addChannelButton.layer.cornerRadius = 30
        addChannelButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        addChannelButton.translatesAutoresizingMaskIntoConstraints = false
        return addChannelButton
    }()
    
    private lazy var profileLabel: UILabel={
        var label = UILabel()
        label.text = "Profile"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var channelLabel: UILabel={
        var label = UILabel()
        label.text = "Add Channel"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bottomView: UIView = {
        var bottomStack = UIView()
        bottomStack.backgroundColor = .mainColor
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        //bottomStack.axis  = .horizontal
        //bottomStack.distribution  = .equalCentering
        //bottomStack.alignment = .center
        return bottomStack
    }()
    
    private var spinner : UIActivityIndicatorView{
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }
    
    private lazy var testChannel = ""
    private lazy var channelList = [Channel]()
    var data = [ConversationCellModel]()
    
    var mainView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .none
        return view
    }()
    
    let longGestureRecognizer = UILongPressGestureRecognizer()
    let panGestureRecognizer = UIPanGestureRecognizer()
    let tap = UITapGestureRecognizer()
    let swipe = UISwipeGestureRecognizer()
    
    
//    @objc func panAction(_ gestureRecognizer: UIPanGestureRecognizer) {
//        let touchPoint = gestureRecognizer.location(in: self.mainView)
//        animateAt(touchPoint: touchPoint)
//    }
//    
//    @objc func tapAction(_ gestureRecognizer: UITapGestureRecognizer) {
//        let touchPoint = gestureRecognizer.location(in: self.mainView)
//        animateAt(touchPoint: touchPoint)
//    }
//    
//    @objc func swipeAction(_ gestureRecognizer: UISwipeGestureRecognizer) {
//        let touchPoint = gestureRecognizer.location(in: self.mainView)
//        animateAt(touchPoint: touchPoint)
//    }
//    @objc func longAction(_ gestureRecognizer: UILongPressGestureRecognizer) {
//        let touchPoint = gestureRecognizer.location(in: self.mainView)
//        animateAt(touchPoint: touchPoint)
//    }
//    
//    func animateAt (touchPoint: CGPoint){
//        let rnd = Int.random(in: -5..<5)
//        let rndRotation = Int.random(in: -4..<4)
//        let coat = UIImageView(frame: CGRect(x: touchPoint.x+CGFloat(rnd), y: touchPoint.y+CGFloat(rnd), width: 40, height: 40))
//        coat.image = UIImage(named: "logo.png")
//        self.mainView.addSubview(coat)
//        UIView.animateKeyframes(withDuration: 0.7,
//                                delay: 0.0,
//                                animations: {
//                                    UIView.addKeyframe(withRelativeStartTime: 0.1,
//                                                       relativeDuration: 0.5,
//                                                       animations: {
//                                                        coat.transform =
//                                                            CGAffineTransform(rotationAngle: -.pi / CGFloat(rndRotation))
//                                    })
//                                    
//                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
//                                                       relativeDuration: 0.5,
//                                                       animations: {
//                                                        coat.center.x += CGFloat(rnd)*5.0
//                                                        coat.center.y -= CGFloat(rnd)*5.0
//                                    })
//        },
//                                completion:  {(completed) in coat.removeFromSuperview()
//        })
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
//        panGestureRecognizer.addTarget(self, action: #selector(panAction(_:)))
//        tap.addTarget(self, action: #selector(tapAction(_:)))
//        swipe.addTarget(self, action: #selector(swipeAction(_:)))
//        longGestureRecognizer.addTarget(self, action: #selector(longAction(_:)))
//        //longGestureRecognizer.minimumPressDuration = 0
//        mainView.addGestureRecognizer(panGestureRecognizer)
//        mainView.addGestureRecognizer(longGestureRecognizer)
//        mainView.addGestureRecognizer(tap)
//        mainView.addGestureRecognizer(swipe)
        
        let _ = CoatAnimation.init(viewController: self, view: mainView)
            
        //MARK: spinner
        /*spinner.isHidden = true
         spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
         view.addSubview(spinner)
         view.bringSubviewToFront(spinner)
         spinner.isHidden = false*/
        
        
        //FirebaseApp.configure()
        reference.addSnapshotListener { [weak self] snapshot, error in
            self?.data.removeAll()
            self?.onlineData.removeAll()
            self?.historyData.removeAll()
            self?.channelList.removeAll()
            
            for doc in snapshot!.documents {
                let date = doc.data()["lastActivity"] as? Timestamp
                let newChannel = Channel(identifier: doc.documentID,
                                         name: stringFromAny(doc.data()["name"]),
                                         lastMessage: stringFromAny(doc.data()["lastMessage"]),
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
        
        
        //MARK: bottomStack
        bottomView.addSubview(profileButton)
        bottomView.addSubview(addChannelButton)
        bottomView.addSubview(profileLabel)
        bottomView.addSubview(channelLabel)
        
        mainView.addSubview(bottomView)
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
        mainView.addSubview(tableView)
        tableView.register(ConversationCell.self, forCellReuseIdentifier: String(describing: ConversationCell.self))
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
        
    }
    
    //MARK: Actions
    @objc func showProfileAction(_ sender : UIButton) {
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
            historyData = historyData.sorted { (ccm1, ccm2) -> Bool in
                if (ccm1.channel.name! > ccm2.channel.name!){
                    return false
                } else {return true}
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.mainColor]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationItem.title = "Tinkoff Chat"
        navigationItem.largeTitleDisplayMode = .automatic;
        //navigationItem.searchController = UISearchController(searchResultsController: nil)
        //navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.sizeToFit()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.navigationBar.prefersLargeTitles = false
    }
}

@available(iOS 13.0, *)
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


@available(iOS 13.0, *)
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
