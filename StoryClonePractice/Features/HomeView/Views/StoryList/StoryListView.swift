import SwiftUI

struct StoryListView: View {
    let viewData: StoryListViewData
    let onItemTapped: (Int) -> Void
    let elementSize: CGFloat
    let elementSpacing: CGFloat
    let selectedId: Int?

    init(
        viewData: StoryListViewData,
        onItemTapped: @escaping (Int) -> Void,
        elementSize: CGFloat = 80,
        elementSpacing: CGFloat = 32,
        selectedId: Int? = nil
    ) {
        self.viewData = viewData
        self.onItemTapped = onItemTapped
        self.elementSize = elementSize
        self.elementSpacing = elementSpacing
        self.selectedId = selectedId
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: elementSpacing) {
                ForEach(viewData.stories) { storyData in
                    UserAvatarView(
                        viewData: storyData,
                        size: elementSize,
                        hasBeenSelected: .constant(false) // Update this later
                        hasBeenSelected: .constant(storyData.hasBeenSelected)
                    )
                    .onTapGesture {
                        onItemTapped(storyData.id)
                    }
                }
            }
        }
        .padding(.horizontal)
        .contentMargins(.all, 8) // look into removing this
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
