import Foundation

struct StoryListViewData {
    let stories: [UserAvatarViewData]

    init(users: [User], viewedUserIds: Set<Int>) {
        self.stories = users.map {
            UserAvatarViewData(
                user: $0,
                hasBeenSelected: viewedUserIds.contains($0.id)
            )
        }
    }
}
