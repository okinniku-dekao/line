//
//  AppRootState.swift
//  Presentation
//
//  Created by 東　秀斗 on 2025/03/01.
//

import ComposableArchitecture
import MainTabBarFeature

extension AppRootFeature {
    public struct State: Equatable {
        public init() {}

        var mainTabState: MainTabBarFeature.State = .init()
    }
}
