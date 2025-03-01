//
//  MainTabBarFeature.swift
//  Presentation
//
//  Created by 東　秀斗 on 2025/03/01.
//

import ComposableArchitecture
import HomeFeature
import TalkFeature
import NewsFeature
import WalletFeature

@Reducer
public struct MainTabBarFeature {
    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
        Scope(state: \.homeTopState, action: \.homeTopAction) {
            HomeTopFeature()
        }
        Scope(state: \.talkTopState, action: \.talkTopAction) {
            TalkTopFeature()
        }
        Scope(state: \.newsTopState, action: \.newsTopAction) {
            NewsTopFeature()
        }
        Scope(state: \.walletTopState, action: \.walletTopAction) {
            WalletTopFeature()
        }
    }
}
