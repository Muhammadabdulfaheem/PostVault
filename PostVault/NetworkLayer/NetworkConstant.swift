import Foundation

enum NetworkConstant {
    static let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
}

enum NetworkConfiguration {
    static let requestTimeout: TimeInterval = 30
    static let resourceTimeout: TimeInterval = 120
    static let transientFailureRetryCount = 2
}

enum APIPath {
    static let posts = "/posts"
}

