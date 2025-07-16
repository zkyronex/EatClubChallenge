import Foundation
import Combine

protocol APIServicing {
    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, APIError>
    func requestData(_ endpoint: APIEndpoint) -> AnyPublisher<Data, APIError>
}

final class APIService: APIServicing {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let enableLogging: Bool
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder(), enableLogging: Bool = true) {
        self.session = session
        self.decoder = decoder
        self.enableLogging = enableLogging
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, APIError> {
        guard let urlRequest = endpoint.urlRequest else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        if enableLogging {
            APILogger.logRequest(urlRequest)
        }
        
        return session.dataTaskPublisher(for: urlRequest)
            .handleEvents(receiveOutput: { [weak self] data, response in
                if self?.enableLogging == true {
                    APILogger.logResponse(response, data: data, error: nil)
                }
            }, receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion, self?.enableLogging == true {
                    APILogger.logResponse(nil, data: nil, error: error)
                }
            })
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.unknown
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.httpError(statusCode: httpResponse.statusCode)
                }
                
                return data
            }
            .mapError { error in
                if let networkError = error as? APIError {
                    return networkError
                } else {
                    return APIError.networkError(error)
                }
            }
            .flatMap { [weak self] data -> AnyPublisher<T, APIError> in
                return Just(data)
                    .decode(type: T.self, decoder: self?.decoder ?? JSONDecoder())
                    .mapError { error in
                        if self?.enableLogging == true {
                            APILogger.logDecodingError(error, targetType: T.self, data: data)
                        }
                        
                        if error is DecodingError {
                            return APIError.decodingError(error)
                        } else {
                            return APIError.networkError(error)
                        }
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func requestData(_ endpoint: APIEndpoint) -> AnyPublisher<Data, APIError> {
        guard let urlRequest = endpoint.urlRequest else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        if enableLogging {
            APILogger.logRequest(urlRequest)
        }
        
        return session.dataTaskPublisher(for: urlRequest)
            .handleEvents(receiveOutput: { [weak self] data, response in
                if self?.enableLogging == true {
                    APILogger.logResponse(response, data: data, error: nil)
                }
            }, receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion, self?.enableLogging == true {
                    APILogger.logResponse(nil, data: nil, error: error)
                }
            })
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.unknown
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.httpError(statusCode: httpResponse.statusCode)
                }
                
                return data
            }
            .mapError { error in
                if let networkError = error as? APIError {
                    return networkError
                } else {
                    return APIError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
