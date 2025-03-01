//
//  AppDelegate.swift
//  line
//
//  Created by 東　秀斗 on 2025/03/01.
//


import SwiftUI
import ComposableArchitecture
import Presentation

final class AppDelegate: NSObject, UIApplicationDelegate {
    let store = Store(initialState: AppRootFeature.State()) {
        AppRootFeature()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}
