//
//  TalkTopView.swift
//  TalkFeature
//
//  Created by 東　秀斗 on 2025/03/02.
//

import SwiftUI
import ComposableArchitecture

public struct TalkTopView: View {
    public init(store: StoreOf<TalkTopFeature>) {
        self.store = store
    }

    let store: StoreOf<TalkTopFeature>

    public var body: some View {
        Text("TalkTopView")
    }
}

#Preview {
    TalkTopView(
        store: Store(
            initialState: TalkTopFeature.State()
        ) {
            TalkTopFeature()
        }
    )
}
