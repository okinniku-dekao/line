//
//  MainTabBarAction.swift
//  Presentation
//
//  Created by 東　秀斗 on 2025/03/01.
//

import ComposableArchitecture

extension MainTabBarFeature {
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
    }
}
