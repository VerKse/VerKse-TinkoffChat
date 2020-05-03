//
//  ChannelSorter.swift
//  TinkoffChatTests
//
//  Created by Вера Ксенофонтова on 03.05.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import XCTest
@testable import TinkoffChat

final class ChannelsSorter: IChannelsSorter {
    
    func separateOnline(_ channels: [Channel]) -> [Channel] {
        return separate(channels, isOnlineReturn: true)
    }
    
    func separateOffline(_ channels: [Channel]) -> [Channel] {
        return separate(channels, isOnlineReturn: false)
    }
    
    
    func sort(_ channels: [Channel]) -> [Channel] {
        
        var sortedChannels = [Channel]()
        sortedChannels = channels.sorted { (ch1, ch2) -> Bool in
            
            if (ch1.lastActivity! < ch2.lastActivity!){
                return false
            } else {return true}
        }
        
        return sortedChannels
    }
    
    func separate(_ channels: [Channel], isOnlineReturn: Bool) -> [Channel] {
        
        var channelArray: [Channel] = []
        
        for channel in channels {
            
            switch isOnlineReturn {
            case true:
                if (channel.lastActivity!>Date.init(timeIntervalSinceNow: -10*60)){
                    channelArray.append(channel)
                }
            case false:
                if (channel.lastActivity!<Date.init(timeIntervalSinceNow: -10*60)){
                    channelArray.append(channel)
                }
                break;
            }
        }
        
        channelArray = sort(channelArray)
        return channelArray
    }
}






