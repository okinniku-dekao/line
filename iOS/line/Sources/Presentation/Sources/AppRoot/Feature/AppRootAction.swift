//
//  AppRootAction.swift
//  Presentation
//
//  Created by 東　秀斗 on 2025/03/01.
//

import ComposableArchitecture

extension AppRootFeature {
    @CasePathable
    public enum Action {
        case mainTabAction(MainTabBarFeature.Action)
    }
}
