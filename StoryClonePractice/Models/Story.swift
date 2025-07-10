import Foundation

struct Story: Codable {
    let id: String
    let imageUrl: String
    let source: String
    let description: String

    var url: URL? {
        return URL(string: imageUrl)
    }
}
