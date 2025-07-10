import Foundation
protocol StoryServiceProtocol {
    func getStory() throws -> Story
}

class StoryService: StoryServiceProtocol {
    func getStory() throws -> Story {
        guard let url = Bundle.main.url(forResource: "stories", withExtension: "json") else {
            print("Stories File Not Found")
            throw StoryServiceError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let stories = try decoder.decode([Story].self, from: data)
            guard let randomStory = stories.randomElement() else {
                throw StoryServiceError.emptyStories
            }
            return randomStory
        } catch {
            throw StoryServiceError.decodingError
        }
    }
}

enum StoryServiceError: Error {
    case fileNotFound
    case decodingError
    case emptyStories
}
