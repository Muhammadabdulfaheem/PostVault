import Foundation
import RealmSwift

final class RealmProvider {
    private let configuration: Realm.Configuration

    init(configuration: Realm.Configuration = .defaultConfiguration) {
        self.configuration = configuration
    }

    func realm() throws -> Realm {
        try Realm(configuration: configuration)
    }
}

