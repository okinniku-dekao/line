//
//  HomeTopView.swift
//  Home
//
//  Created by 東　秀斗 on 2025/03/02.
//

import SwiftUI
import ComposableArchitecture

public struct HomeTopView: View {
    public init(store: StoreOf<HomeTopFeature>) {
        self.store = store
    }

    let store: StoreOf<HomeTopFeature>
    
    public var body: some View {
        Text("HomeTopView")
    }
}

#Preview {
    HomeTopView(
        store: Store(
            initialState: HomeTopFeature.State()
        ) {
            HomeTopFeature()
        }
    )
}
