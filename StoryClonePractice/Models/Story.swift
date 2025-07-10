import Foundation

struct Story: Codable {
    let id: String
    let imageUrl: String
    let source: String
    let description: String

    // Computed property to convert the string URL to a URL object
    var url: URL? {
        return URL(string: imageUrl)
    }
}
