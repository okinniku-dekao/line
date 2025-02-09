//
//  ContentView.swift
//  line
//
//  Created by 東　秀斗 on 2025/02/08.
//

import SwiftUI

public struct ContentView: View {
    public init() {}
    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, Swift Package Project")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
