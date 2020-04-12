//
//  ChannelListView.swift
//  TinkoffChat
//
//  Created by Vera on 12.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import UIKit

class ChannelListView: UIView {
    let insets = CGFloat(5)
    
    lazy var profileButton: UIButton = {
        var profileButton = UIButton()
        profileButton.setImage(UIImage.init(named: "userWhite.png"), for: .normal)
        profileButton.layer.cornerRadius = 30
        profileButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        return profileButton
    }()
    
    lazy var addChannelButton: UIButton={
        var addChannelButton = UIButton()
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //MARK: bottomStack
        bottomView.addSubview(profileButton)
        bottomView.addSubview(addChannelButton)
        bottomView.addSubview(profileLabel)
        bottomView.addSubview(channelLabel)
        
        self.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.leftAnchor.constraint(equalTo: self.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: self.rightAnchor),
            bottomView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1),
            bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
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
    }
}
