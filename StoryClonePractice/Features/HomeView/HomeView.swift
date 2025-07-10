import SwiftUI

struct HomeView: View {

    @StateObject var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            VStack {
                StoryListView(
                    viewData: StoryListViewData(
                        users: viewModel.users,
                        viewedUserIds: viewModel.viewedUserIds
                    ),
                    onItemTapped: { userId in
                        print("tapped user \(userId)")
                        viewModel.userViewed(id: userId)
                        viewModel.selectedUserId = userId
                    },
                    elementSize: 80,
                    elementSpacing: 24
                )
                Spacer()
            }
            .onAppear {
                viewModel.loadUsers()
            }
            .navigationDestination(isPresented: $viewModel.navigateToStory) {
                StoryView(
                    viewModel: StoryViewModel(
                        storyService: StoryService()
                    )
                )
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(userService: UserService()))
}
