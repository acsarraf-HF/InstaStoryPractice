import SwiftUI

@main
struct StoryClonePracticeApp: App {
    private let userService = UserService()
    var body: some Scene {
        WindowGroup {
            HomeView(
                viewModel: HomeViewModel(
                    userService: userService
                )
            )
        }
    }
}
