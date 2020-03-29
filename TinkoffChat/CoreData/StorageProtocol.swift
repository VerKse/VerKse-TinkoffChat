//
//  PersistentContainer.swift
//  TinkoffChat
//
//  Created by Vera on 29.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import CoreData

protocol StorageProtocol {
    
    func load(completion: @escaping (User?) -> Void)
    func save(profile: User, completion: @escaping (Bool) -> Void)
    func basicEntity()

}




