import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let profilePictureUrl: URL

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePictureUrl = "profile_picture_url"
    }
}

struct UsersPage: Codable {
    let users: [User]
}

struct UserResponse: Codable {
    let pages: [UsersPage]
}
