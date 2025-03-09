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
    
    private var unselectedImage: Resources.ImageResource {
        switch self {
        case .home:
            return R.image.house
            
        case .talk:
            return R.image.message
            
        case .news:
            return R.image.newspaper
            
        case .wallet:
            return R.image.walletBifold
            
        }
    }
    
    private var selectedImage: Resources.ImageResource {
        switch self {
        case .home:
            return R.image.houseFill
            
        case .talk:
            return R.image.messageFill
            
        case .news:
            return R.image.newspaperFill
            
        case .wallet:
            return R.image.walletBifoldFill
        }
    }
    
    func getTabImage(currentTab: Self) -> Image {
        Image(currentTab == self ? selectedImage : unselectedImage)
    }
}
