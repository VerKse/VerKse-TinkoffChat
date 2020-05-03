//
//  IChannelsSorter.swift
//  TinkoffChatTests
//
//  Created by Вера Ксенофонтова on 03.05.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

@testable import TinkoffChat

protocol IChannelsSorter {
    
    func sort(_ channels: [Channel]) -> [Channel]
    
    func separateOnline(_ channels: [Channel]) -> [Channel]
    
    func separateOffline(_ channels: [Channel]) -> [Channel]
}
