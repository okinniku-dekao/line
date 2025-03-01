//
//  AppTab.swift
//  MainTabFeature
//
//  Created by 東　秀斗 on 2025/03/02.
//

import SwiftUI

enum AppTab: String, CaseIterable {
    case home = "ホーム"
    case talk = "トーク"
    case news = "ニュース"
    case wallet = "ウォレット"
    
    var image: Image {
        switch self {
        case .home:
            return Image(systemName: "house")
            
        case .talk:
            return Image(systemName: "message")
            
        case .news:
            return Image(systemName: "newspaper")
            
        case .wallet:
            return Image(systemName: "wallet.bifold")
            
        }
    }
}
