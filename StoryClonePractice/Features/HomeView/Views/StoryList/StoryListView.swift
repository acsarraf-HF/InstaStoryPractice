import SwiftUI

struct StoryListView: View {
    let viewData: StoryListViewData
    let onItemTapped: (Int) -> Void
    let elementSize: CGFloat
    let elementSpacing: CGFloat
    let namespace: Namespace.ID
    let selectedId: Int?

    init(
        viewData: StoryListViewData,
        onItemTapped: @escaping (Int) -> Void,
        elementSize: CGFloat = 80,
        elementSpacing: CGFloat = 32,
        namespace: Namespace.ID,
        selectedId: Int? = nil
    ) {
        self.viewData = viewData
        self.onItemTapped = onItemTapped
        self.elementSize = elementSize
        self.elementSpacing = elementSpacing
        self.namespace = namespace
        self.selectedId = selectedId
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: elementSpacing) {
                ForEach(viewData.stories) { storyData in
                    UserAvatarView(
                        viewData: storyData,
                        size: elementSize,
                        hasBeenSelected: .constant(storyData.hasBeenSelected)
                    )
                    .heroAnimation(
                        id: storyData.id,
                        namespace: namespace,
                        isActive: selectedId == storyData.id
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
    struct PreviewWrapper: View {
        @Namespace var previewNamespace
        
        var body: some View {
            let users = [
                User(id: 1, name: "Test1", profilePictureUrl: URL(string: "https://i.pravatar.cc/300?u=1")!),
                User(id: 2, name: "Test2", profilePictureUrl: URL(string: "https://i.pravatar.cc/300?u=2")!),
                User(id: 3, name: "Test3", profilePictureUrl: URL(string: "https://i.pravatar.cc/300?u=3")!)
            ]

            let viewData = StoryListViewData(users: users, viewedUserIds: [1])
            
            return StoryListView(
                viewData: viewData,
                onItemTapped: { _ in },
                namespace: previewNamespace
            ).contentMargins(20)
        }
    }
    
    return PreviewWrapper()
}
