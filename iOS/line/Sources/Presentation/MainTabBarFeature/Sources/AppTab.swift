//
//  AppTab.swift
//  MainTabFeature
//
//  Created by 東　秀斗 on 2025/03/02.
//

import SwiftUI
import Resources

enum AppTab: String, CaseIterable {
    case home = "ホーム"
    case talk = "トーク"
    case news = "ニュース"
    case wallet = "ウォレット"
    
    var image: Image {
        switch self {
        case .home:
            return Image(R.image.house)
            
        case .talk:
            return Image(R.image.bookmark)
            
        case .news:
            return Image(R.image.newspaper)
            
        case .wallet:
            return Image(R.image.walletBifold)
            
        }
    }
}
