import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, Cursor!")
            .padding()
    }
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
    