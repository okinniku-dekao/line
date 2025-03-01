//
//  NewsTopView.swift
//  NewsFeature
//
//  Created by 東　秀斗 on 2025/03/02.
//

import SwiftUI
import ComposableArchitecture

public struct NewsTopView: View {
    public init(store: StoreOf<NewsTopFeature>) {
        self.store = store
    }

    let store: StoreOf<NewsTopFeature>
    
    public var body: some View {
        Text("NewsTopView")
    }
}

#Preview {
    NewsTopView(
        store: Store(
            initialState: NewsTopFeature.State()
        ) {
            NewsTopFeature()
        }
    )
}
