import SwiftUI

struct HomeView: View {

    @StateObject var viewModel: HomeViewModel
    @Namespace private var animation

    var body: some View {
        ZStack {
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
                        viewModel.showStoryView = true
                    },
                    elementSize: 80,
                    elementSpacing: 24,
                    namespace: animation,
                    selectedId: viewModel.selectedUserId
                )
                Spacer()
            }
            .onAppear {
                viewModel.loadUsers()
            }
            
            // Story view with hero animation
            if viewModel.showStoryView, let selectedId = viewModel.selectedUserId {
                StoryView(
                    viewModel: StoryViewModel(
                        storyService: StoryService()
                    ),
                    namespace: animation,
                    userId: selectedId,
                    onDismiss: {
                        viewModel.showStoryView = false
                    }
                )
                .transition(.identity)
                .zIndex(1)
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(userService: UserService()))
}
