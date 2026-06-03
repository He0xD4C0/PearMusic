import SwiftUI

/// PearMusic — Multiplatform App Entry Point
///
/// Single target builds for macOS 14+ and iOS 17+.
/// MusicKit entitlement auto-derives JWT from code signing.
@main
struct PearMusicApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
            #if os(macOS)
                .frame(minWidth: 800, minHeight: 600)
            #endif
        }
    #if os(macOS)
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unifiedCompact)
        .defaultSize(width: 900, height: 700)
    #endif
    }
}
