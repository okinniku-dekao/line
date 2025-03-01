//
//  AppRootView.swift
//  Presentation
//
//  Created by 東　秀斗 on 2025/03/01.
//

import SwiftUI
import ComposableArchitecture
import MainTabBarFeature

public struct AppRootView: View {
    let store: StoreOf<AppRootFeature>

    public init(store: StoreOf<AppRootFeature>) {
        self.store = store
    }

    public var body: some View {
        MainTabBarView(store: store.scope(state: \.mainTabState, action: \.mainTabAction))
    }
}

#Preview {
    AppRootView(
        store: Store(
            initialState: AppRootFeature.State()
        ){
            AppRootFeature()
        }
    )
}
