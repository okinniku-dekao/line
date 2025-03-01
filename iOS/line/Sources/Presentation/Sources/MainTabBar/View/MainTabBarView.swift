//
//  MainTabBarView.swift
//  Presentation
//
//  Created by 東　秀斗 on 2025/02/27.
//

import SwiftUI
import ComposableArchitecture

struct MainTabBarView: View {
    @Bindable var store: StoreOf<MainTabBarFeature>

    var body: some View {
        TabView(selection: $store.currentTab) {
            ForEach(AppTab.allCases, id: \.rawValue) { tab in
                Text(tab.rawValue)
                    .tabItem {
                        tab.image
                        Text(tab.rawValue)
                    }
                    .tag(tab)
            }
        }
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
