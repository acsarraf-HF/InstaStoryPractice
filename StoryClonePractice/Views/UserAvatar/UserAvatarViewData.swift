import Foundation

struct UserAvatarViewData: Identifiable {
    let id: Int
    let name: String
    let imageUrl: URL

    init(user: User) {
        self.id = user.id
        self.name = user.name
        self.imageUrl = user.profilePictureUrl
    }
}
