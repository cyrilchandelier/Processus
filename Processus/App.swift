import SwiftUI

@main
struct Processus: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
