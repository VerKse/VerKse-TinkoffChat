//
//  Question.swift
//  TinkoffChat
//
//  Created by Vera on 19.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import UIKit

struct Question: Codable {
    var id: Int?
    var webformatURL: String?
    var largeImageURL: String?
}

struct Answer {
    var id: Int?
    var webFormatImage: UIImage?
}
