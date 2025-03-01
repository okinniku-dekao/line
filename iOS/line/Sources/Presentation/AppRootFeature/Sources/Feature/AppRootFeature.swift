//
//  AppRootFeature.swift
//  Presentation
//
//  Created by 東　秀斗 on 2025/03/01.
//

import ComposableArchitecture
import MainTabBarFeature

@Reducer
public struct AppRootFeature {
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.mainTabState, action: \.mainTabAction) {
            MainTabBarFeature()
        }
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
