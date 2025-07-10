import Foundation

struct UserAvatarViewData: Identifiable {
    let id: Int
    let name: String
    let imageUrl: URL
    let hasBeenSelected: Bool

    init(user: User, hasBeenSelected: Bool = false) {
        self.id = user.id
        self.name = user.name
        self.imageUrl = user.profilePictureUrl
        self.hasBeenSelected = hasBeenSelected
    }
}
