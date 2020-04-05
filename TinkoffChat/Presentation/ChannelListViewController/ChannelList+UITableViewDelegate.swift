//
//  ChannelList+UITableViewDelegate.swift
//  TinkoffChat
//
//  Created by Vera on 05.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
extension ChannelList: UITableViewDelegate {
    
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
