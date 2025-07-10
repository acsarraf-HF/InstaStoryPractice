//
//  ContentView.swift
//  StoryClonePractice
//
//  Created by Alan Sarraf on 10.07.25.
//

import SwiftUI

struct HomeView: View {

    @StateObject var viewModel: HomeViewModel

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            viewModel.loadUsers()
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(userService: UserService()))
}
