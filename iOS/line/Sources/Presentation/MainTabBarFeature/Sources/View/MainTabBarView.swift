//
//  MainTabBarView.swift
//  Presentation
//
//  Created by 東　秀斗 on 2025/02/27.
//

import SwiftUI
import ComposableArchitecture
import HomeFeature
import TalkFeature
import NewsFeature
import WalletFeature

public struct MainTabBarView: View {
    public init(store: StoreOf<MainTabBarFeature>) {
        self.store = store
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.primary)
    }

    @Bindable var store: StoreOf<MainTabBarFeature>

    public var body: some View {
        TabView(selection: $store.currentTab) {
            HomeTopView(store: store.scope(state: \.homeTopState, action: \.homeTopAction))
                .tabItem {
                    AppTab.home.getTabImage(currentTab: store.currentTab)
                    Text(AppTab.home.rawValue)
                }
                .tag(AppTab.home)
            TalkTopView(store: store.scope(state: \.talkTopState, action: \.talkTopAction))
                .tabItem {
                    AppTab.talk.getTabImage(currentTab: store.currentTab)
                    Text(AppTab.talk.rawValue)
                }
                .tag(AppTab.talk)
            NewsTopView(store: store.scope(state: \.newsTopState, action: \.newsTopAction))
                .tabItem {
                    AppTab.news.getTabImage(currentTab: store.currentTab)
                    Text(AppTab.news.rawValue)
                }
                .tag(AppTab.news)
            WalletTopView(store: store.scope(state: \.walletTopState, action: \.walletTopAction))
                .tabItem {
                    AppTab.wallet.getTabImage(currentTab: store.currentTab)
                    Text(AppTab.wallet.rawValue)
                }
                .tag(AppTab.wallet)
        }
        .tint(.primary)
    }
}

#Preview {
    MainTabBarView(
        store: Store(
            initialState: MainTabBarFeature.State(),
            reducer: { MainTabBarFeature() }
        )
    )
}
