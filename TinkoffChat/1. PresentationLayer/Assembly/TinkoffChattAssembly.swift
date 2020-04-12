//
//  TinkoffChattAssembly.swift
//  TinkoffChat
//
//  Created by Vera on 12.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import UIKit

protocol IPresentationAssembly {

    func navigationController() -> UINavigationController
    
    func profileViewController() -> ProfileViewController
    
    @available(iOS 13.0, *)
    func channelListViewController() -> ChannelListViewController
    
    func channelAddViewController() -> ChannelAddViewController
}

@available(iOS 13.0, *)
class PresentationAssembly: IPresentationAssembly{
    
    func navigationController() -> UINavigationController {
        return UINavigationController.init(rootViewController: channelListViewController())
    }
    
    func profileViewController() -> ProfileViewController {
        return ProfileViewController()
    }
    
    func channelListViewController() -> ChannelListViewController {
        return ChannelListViewController()
    }
    
    func channelAddViewController() -> ChannelAddViewController {
        return channelAddViewController()
    }
}

