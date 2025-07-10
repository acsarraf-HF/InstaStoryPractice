import Combine
import Foundation
import SwiftUI

protocol StoryViewModelProtocol {
    func loadStories()
    func favoriteStory()
    func unfavoriteStory()
    func sendMessage(string: String)
}

class StoryViewModel: ObservableObject, StoryViewModelProtocol {
    private let storyService: StoryServiceProtocol
    @Published var currentStory: Story?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isFavorite: Bool = false


    init(storyService: StoryServiceProtocol) {
        self.storyService = storyService
    }

    func loadStories() {
        isLoading = true
        errorMessage = nil

        do {
            let story = try storyService.getStory()
            DispatchQueue.main.async {
                self.currentStory = story
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to load story: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func favoriteStory() {
        isFavorite = true
    }
    
    func unfavoriteStory() {
        isFavorite = false
    }
    
    func sendMessage(string: String) {
        func sendMessage(string: String) {
            print("Message sent: \(string)")
        }
    }
}
