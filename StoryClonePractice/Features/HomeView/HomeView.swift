import SwiftUI

struct HomeView: View {

    @StateObject var viewModel: HomeViewModel

    var body: some View {
        VStack {
            StoryListView(
                viewData: StoryListViewData(
                    users: viewModel.users,
                    viewedUserIds: viewModel.viewedUserIds
                ),
                onItemTapped: { userId in
                    print("tapped user \(userId)")
                    viewModel.userViewed(id: userId)
                },
                elementSize: 80,
                elementSpacing: 24
            )
            Spacer()
        }
        .onAppear {
            viewModel.loadUsers()
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(userService: UserService()))
}
