//
//  MainTabBarState.swift
//  Presentation
//
//  Created by 東　秀斗 on 2025/03/01.
//

import ComposableArchitecture

extension MainTabBarFeature {
    @ObservableState
    struct State: Equatable {
        var currentTab: AppTab = .home
    }
}
