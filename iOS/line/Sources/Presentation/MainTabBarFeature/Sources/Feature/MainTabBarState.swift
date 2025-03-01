//
//  MainTabBarState.swift
//  Presentation
//
//  Created by 東　秀斗 on 2025/03/01.
//

import ComposableArchitecture
import HomeFeature
import TalkFeature
import NewsFeature
import WalletFeature

extension MainTabBarFeature {
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var currentTab: AppTab = .home
        var homeTopState: HomeTopFeature.State = .init()
        var talkTopState: TalkTopFeature.State = .init()
        var newsTopState: NewsTopFeature.State = .init()
        var walletTopState: WalletTopFeature.State = .init()
    }
}
