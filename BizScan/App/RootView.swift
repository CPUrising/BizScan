import SwiftUI

struct RootView: View {
    var body: some View {
        HomeView()
            .preferredColorScheme(.dark)
            .tint(Theme.blue)
    }
}
