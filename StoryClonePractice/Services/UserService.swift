import Foundation
protocol UserServiceProtocol {
    func getAllUsers() throws -> [User]
    func getUsersFromPage(_ page: Int) throws -> [User]
}

enum UserServiceError: Error {
    case fileNotFound
    case decodingError
    case invalidPageIndex

    var errorDescription: String {
        switch self {
        case .fileNotFound:
            return "The data file could not be found"
        case .decodingError:
            return "failed to decode user data."
        case .invalidPageIndex:
            return "Page does not exist"
        }
    }
}

class UserService: UserServiceProtocol {
    func getAllUsers() throws -> [User] {
        let response = try loadUsers()
        return response.pages.flatMap { $0.users }
    }

    func getUsersFromPage(_ page: Int) throws -> [User] {
        let response = try loadUsers()
        guard let page = response.pages.safe(at: page) else {
            throw UserServiceError.invalidPageIndex
        }
        return page.users
    }
}

private extension UserService {
    func loadUsers() throws -> UserResponse {
        guard let url = Bundle.main.url(forResource: "users", withExtension: "json") else {
            print("User File Not Found")
            throw UserServiceError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(UserResponse.self, from: data)
        } catch {
            throw UserServiceError.decodingError
        }
    }
}
