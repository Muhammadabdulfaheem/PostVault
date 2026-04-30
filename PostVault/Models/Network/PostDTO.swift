import Foundation


struct PostDTO: Sendable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

extension PostDTO: Decodable {
    nonisolated init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        userId = try c.decode(Int.self, forKey: .userId)
        id = try c.decode(Int.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        body = try c.decode(String.self, forKey: .body)
    }

    private enum CodingKeys: String, CodingKey {
        case userId, id, title, body
    }
}
