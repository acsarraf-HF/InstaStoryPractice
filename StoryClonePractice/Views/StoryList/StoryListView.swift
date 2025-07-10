import SwiftUI

struct StoryListView: View {
    let viewData: StoryListViewData
    let onItemTapped: (Int) -> Void
    let elementSize: CGFloat

    init(
        viewData: StoryListViewData,
        onItemTapped: @escaping (Int) -> Void,
        elementSize: CGFloat = 80
    ) {
        self.viewData = viewData
        self.onItemTapped = onItemTapped
        self.elementSize = elementSize
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewData.stories) { storyData in
                    UserAvatarView(
                        viewData: storyData,
                        size: 80,
                        hasBeenSelected: .constant(false) // Update this later
                    )
                    .onTapGesture {
                        onItemTapped(storyData.id)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    // Sample data for preview
    let users = [
        User(id: 1, name: "Test1", profilePictureUrl: URL(string: "https://i.pravatar.cc/300?u=1")!),
        User(id: 2, name: "Test2", profilePictureUrl: URL(string: "https://i.pravatar.cc/300?u=2")!),
        User(id: 3, name: "Test3", profilePictureUrl: URL(string: "https://i.pravatar.cc/300?u=3")!)
    ]

    let viewData = StoryListViewData(users: users, viewedUserIds: [1])

    StoryListView(
        viewData: viewData,
        onItemTapped: { _ in }
    ).contentMargins(20)
}
