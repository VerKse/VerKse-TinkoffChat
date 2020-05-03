//
//  ChannelsTest.swift
//  TinkoffChatTests
//
//  Created by Вера Ксенофонтова on 03.05.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import XCTest
@testable import TinkoffChat

final class ChannelsTest: XCTestCase{
    
    private var channelsSorter: IChannelsSorter!
    
    private var date: Date!
    
    private var unsorted = [Channel]()
    
    private var unseparate = [Channel]()
    
    //MARK: - Lifecycle
    
    override func setUp() {
        
        self.date = Date.init(timeIntervalSinceNow: 0)
        
        self.channelsSorter = ChannelsSorter()
        
        self.unsorted = [ Channel(identifier: "123", name: "somebody", lastMessage: "", lastActivity: Date.init(timeInterval: -10*10, since: self.date)),
                          Channel(identifier: "234", name: "world", lastMessage: "", lastActivity: Date.init(timeInterval: -10*60, since: self.date)),
                          Channel(identifier: "123", name: "told", lastMessage: "", lastActivity: Date.init(timeInterval: -10*30, since: self.date)),
                          Channel(identifier: "234", name: "me", lastMessage: "", lastActivity: Date.init(timeInterval: -10*40, since: self.date)),
                          Channel(identifier: "234", name: "once", lastMessage: "", lastActivity: Date.init(timeInterval: -10*20, since: self.date)),
                          Channel(identifier: "123", name: "the", lastMessage: "", lastActivity: Date.init(timeInterval: -10*50, since: self.date)),
                          Channel(identifier: "234", name: "me", lastMessage: "", lastActivity: Date.init(timeInterval: -10*100, since: self.date)),
                          Channel(identifier: "123", name: "will", lastMessage: "", lastActivity: Date.init(timeInterval: -10*70, since: self.date)),
                          Channel(identifier: "234", name: "gona", lastMessage: "", lastActivity: Date.init(timeInterval: -10*80, since: self.date)),
                          Channel(identifier: "123", name: "roll", lastMessage: "", lastActivity: Date.init(timeInterval: -10*90, since: self.date))
        ]
        
        self.unseparate = [ Channel(identifier: "123", name: "скажите", lastMessage: "", lastActivity: Date.init(timeInterval: -10*0, since: self.date)),
                            Channel(identifier: "234", name: "если", lastMessage: "", lastActivity: Date.init(timeInterval: -10*5, since: self.date)),
                            Channel(identifier: "123", name: "тесты", lastMessage: "", lastActivity: Date.init(timeInterval: -10*10, since: self.date)),
                            Channel(identifier: "234", name: "пишут", lastMessage: "", lastActivity: Date.init(timeInterval: -10*15, since: self.date)),
                            Channel(identifier: "123", name: "значит это", lastMessage: "", lastActivity: Date.init(timeInterval: -10*20, since: self.date)),
                            Channel(identifier: "234", name: "кому-нибудь", lastMessage: "", lastActivity: Date.init(timeInterval: -10*25, since: self.date)),
                            Channel(identifier: "123", name: "нужно?", lastMessage: "", lastActivity: Date.init(timeInterval: -10*30, since: self.date)),
                            Channel(identifier: "234", name: "значит кто-то хочет", lastMessage: "", lastActivity: Date.init(timeInterval: -10*100, since: self.date)),
                            Channel(identifier: "123", name: "чтобы они", lastMessage: "", lastActivity: Date.init(timeInterval: -10*110, since: self.date)),
                            Channel(identifier: "234", name: "работали?", lastMessage: "", lastActivity: Date.init(timeInterval: -10*120, since: self.date))
        ]
    }
    
    //MARK: - Tests
    func testThatChannelSorterReturnsSortedChannel(){
        
        let expectedResult = [ Channel(identifier: "123", name: "somebody", lastMessage: "", lastActivity: Date.init(timeInterval: -10*10, since: self.date)),
                               Channel(identifier: "234", name: "once", lastMessage: "", lastActivity: Date.init(timeInterval: -10*20, since: self.date)),
                               Channel(identifier: "123", name: "told", lastMessage: "", lastActivity: Date.init(timeInterval: -10*30, since: self.date)),
                               Channel(identifier: "234", name: "me", lastMessage: "", lastActivity: Date.init(timeInterval: -10*40, since: self.date)),
                               Channel(identifier: "123", name: "the", lastMessage: "", lastActivity: Date.init(timeInterval: -10*50, since: self.date)),
                               Channel(identifier: "234", name: "world", lastMessage: "", lastActivity: Date.init(timeInterval: -10*60, since: self.date)),
                               Channel(identifier: "123", name: "will", lastMessage: "", lastActivity: Date.init(timeInterval: -10*70, since: self.date)),
                               Channel(identifier: "234", name: "gona", lastMessage: "", lastActivity: Date.init(timeInterval: -10*80, since: self.date)),
                               Channel(identifier: "123", name: "roll", lastMessage: "", lastActivity: Date.init(timeInterval: -10*90, since: self.date)),
                               Channel(identifier: "234", name: "me", lastMessage: "", lastActivity: Date.init(timeInterval: -10*100, since: self.date))
        ]
        
        
        let result = channelsSorter.sort(unsorted)
        
        XCTAssertEqual(expectedResult, result)
    }
    
    func testThatChannelSeparatorReturnOnlineChannels(){
        
        let expectedResult = [ Channel(identifier: "123", name: "скажите", lastMessage: "", lastActivity: Date.init(timeInterval: -10*0, since: self.date)),
                               Channel(identifier: "234", name: "если", lastMessage: "", lastActivity: Date.init(timeInterval: -10*5, since: self.date)),
                               Channel(identifier: "123", name: "тесты", lastMessage: "", lastActivity: Date.init(timeInterval: -10*10, since: self.date)),
                               Channel(identifier: "234", name: "пишут", lastMessage: "", lastActivity: Date.init(timeInterval: -10*15, since: self.date)),
                               Channel(identifier: "123", name: "значит это", lastMessage: "", lastActivity: Date.init(timeInterval: -10*20, since: self.date)),
                               Channel(identifier: "234", name: "кому-нибудь", lastMessage: "", lastActivity: Date.init(timeInterval: -10*25, since: self.date)),
                               Channel(identifier: "123", name: "нужно?", lastMessage: "", lastActivity: Date.init(timeInterval: -10*30, since: self.date))
        ]
        
        let result = channelsSorter.separateOnline(unseparate)
        
        XCTAssertEqual(expectedResult, result)
        
    }
    
    func testThatChannelSeparatorReturnOfflineChannels(){
        
        let expectedResult = [ Channel(identifier: "234", name: "значит кто-то хочет", lastMessage: "", lastActivity: Date.init(timeInterval: -10*100, since: self.date)),
                               Channel(identifier: "123", name: "чтобы они", lastMessage: "", lastActivity: Date.init(timeInterval: -10*110, since: self.date)),
                               Channel(identifier: "234", name: "работали?", lastMessage: "", lastActivity: Date.init(timeInterval: -10*120, since: self.date))
        ]
        
        let result = channelsSorter.separateOffline(unseparate)
        
        XCTAssertEqual(expectedResult, result)
    }
    
}
