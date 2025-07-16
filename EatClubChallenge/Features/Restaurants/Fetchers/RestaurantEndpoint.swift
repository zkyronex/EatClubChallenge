import Foundation

enum RestaurantEndpoint: APIEndpoint {
    case fetchRestaurants
    
    var baseURL: String {
        "https://eccdn.com.au"
    }
    
    var path: String {
        switch self {
        case .fetchRestaurants:
            return "/misc/challengedata.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchRestaurants:
            return .get
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
    
    var parameters: [String: Any]? {
        nil
    }
    
    var body: Data? {
        nil
    }
}