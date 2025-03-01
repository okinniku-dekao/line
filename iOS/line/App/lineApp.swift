import SwiftUI
import AppRootFeature

@main
struct lineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppRootView(store: self.appDelegate.store)
        }
    }
}
