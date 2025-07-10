import Foundation
import SwiftUI
import Combine

protocol HomeViewModelProtocol {
    func loadUsers()
    func getUsersFromPage(_ page: Int)
    func loadNextPage()
    func loadAllUsers()
    func userViewed(id: Int)
}

class HomeViewModel: ObservableObject, HomeViewModelProtocol {
    @Published var users: [User] = []
    @Published var errorMesssage: String?
    @Published var isLoading: Bool = false
    @Published var currentPage: Int = 0
    @Published var hasNextPage: Bool = false
    @Published var viewedUserIds: Set<Int> = []

    private let userService: UserServiceProtocol

    init(userService: UserServiceProtocol) {
        self.userService = userService
    }

    func loadUsers() {
        isLoading = true
        errorMesssage = nil

        do {
            users = try userService.getUsersFromPage(currentPage)
        } catch {
            errorMesssage = error.localizedDescription
        }
        isLoading = false
    }

    func getUsersFromPage(_ page: Int) {
        isLoading = true
        errorMesssage = nil
        do {
            let newUsers = try userService.getUsersFromPage(page)
            users.append(contentsOf: newUsers)
            currentPage = page

            checkIfHasNextPage()
        } catch {
            errorMesssage = error.localizedDescription
        }
        isLoading = false
    }

    func loadNextPage() {
        if !isLoading && hasNextPage {
            getUsersFromPage(currentPage + 1)
        }
    }

    func loadAllUsers() { // Not sure if this will be needed but its here for now, to match the functions in the service
        isLoading = true
        errorMesssage = nil

        do {
            users = try userService.getAllUsers()
        } catch {
            errorMesssage = error.localizedDescription
        }
        isLoading = false
    }

    func userViewed(id: Int) {
        viewedUserIds.insert(id)
    }
}

private extension HomeViewModel {
    func checkIfHasNextPage() {
        do {
            _ = try userService.getUsersFromPage(currentPage + 1)
            hasNextPage = true
        } catch {
            hasNextPage = false
        }
    }
}
