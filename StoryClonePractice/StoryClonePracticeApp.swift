//
//  StoryClonePracticeApp.swift
//  StoryClonePractice
//
//  Created by Alan Sarraf on 10.07.25.
//

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
