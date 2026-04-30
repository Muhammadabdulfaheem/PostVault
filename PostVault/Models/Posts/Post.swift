import Foundation

struct Post: Equatable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
    let isFavorite: Bool
}
