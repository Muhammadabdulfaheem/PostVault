import Alamofire
import Foundation
import RxSwift


enum APIService {
    private static let session: Session = {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = NetworkConfiguration.requestTimeout
        config.timeoutIntervalForResource = NetworkConfiguration.resourceTimeout
        return Session(configuration: config)
    }()

    static func fetchPosts() -> Single<[PostDTO]> {
        Single.create { single in
            let path = APIPath.posts.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            let url = NetworkConstant.baseURL.appendingPathComponent(path)
            let request = session
                .request(url, method: .get)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [PostDTO].self) { response in
                    switch response.result {
                    case .success(let posts):
                        single(.success(posts))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            return Disposables.create { request.cancel() }
        }
        .retry(NetworkConfiguration.transientFailureRetryCount)
    }
}
