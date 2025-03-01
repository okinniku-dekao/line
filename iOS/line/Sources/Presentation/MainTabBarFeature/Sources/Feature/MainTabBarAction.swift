//
//  MainTabBarAction.swift
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
    @CasePathable
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case homeTopAction(HomeTopFeature.Action)
        case talkTopAction(TalkTopFeature.Action)
        case newsTopAction(NewsTopFeature.Action)
        case walletTopAction(WalletTopFeature.Action)
    }
}
