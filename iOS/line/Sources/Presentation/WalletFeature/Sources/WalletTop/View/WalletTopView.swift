//
//  WalletTopView.swift
//  WalletFeature
//
//  Created by 東　秀斗 on 2025/03/02.
//

import SwiftUI
import ComposableArchitecture

public struct WalletTopView: View {
    public init(store: StoreOf<WalletTopFeature>) {
        self.store = store
    }

    let store: StoreOf<WalletTopFeature>
    
    public var body: some View {
        Text("WalletTopView")
    }
}

#Preview {
    WalletTopView(
        store: Store(
            initialState: WalletTopFeature.State()
        ) {
            WalletTopFeature()
        }
    )
}
