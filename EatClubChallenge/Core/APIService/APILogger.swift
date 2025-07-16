import Foundation

enum APILogger {
    static func logDecodingError<T>(_ error: Error, targetType: T.Type, data: Data?) {
        print("\n❌ DECODING ERROR")
        print("================")
        print("Target Type: \(String(describing: targetType))")
        print("Error: \(error)")
        
        if let decodingError = error as? DecodingError {
            print("\nDetailed Decoding Error:")
            
            switch decodingError {
            case .dataCorrupted(let context):
                print("  Data Corrupted:")
                print("    Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
                print("    Debug Description: \(context.debugDescription)")
                if let underlyingError = context.underlyingError {
                    print("    Underlying Error: \(underlyingError)")
                }
                
            case .keyNotFound(let key, let context):
                print("  Key Not Found: '\(key.stringValue)'")
                print("    Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
                print("    Debug Description: \(context.debugDescription)")
                
            case .typeMismatch(let type, let context):
                print("  Type Mismatch:")
                print("    Expected Type: \(type)")
                print("    Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
                print("    Debug Description: \(context.debugDescription)")
                
            case .valueNotFound(let type, let context):
                print("  Value Not Found:")
                print("    Expected Type: \(type)")
                print("    Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
                print("    Debug Description: \(context.debugDescription)")
                
            @unknown default:
                print("  Unknown Decoding Error")
            }
        }
        
        if let data = data {
            print("\nRaw Data:")
            if let jsonString = String(data: data, encoding: .utf8) {
                // Try to show a snippet around the error location
                let lines = jsonString.components(separatedBy: .newlines)
                if lines.count <= 20 {
                    print(jsonString)
                } else {
                    // Show first 10 and last 10 lines for large responses
                    print("  First 10 lines:")
                    lines.prefix(10).forEach { print("  \($0)") }
                    print("  ...")
                    print("  Last 10 lines:")
                    lines.suffix(10).forEach { print("  \($0)") }
                }
            } else {
                print("  <Binary data: \(data.count) bytes>")
            }
        }
        
        print("================\n")
    }
    
    static func logRequest(_ request: URLRequest) {
        print("\n📤 API REQUEST")
        print("================")
        
        if let url = request.url {
            print("URL: \(url.absoluteString)")
        }
        
        if let method = request.httpMethod {
            print("Method: \(method)")
        }
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers:")
            headers.forEach { key, value in
                print("  \(key): \(value)")
            }
        }
        
        if let body = request.httpBody {
            print("Body:")
            if let bodyString = String(data: body, encoding: .utf8) {
                print("  \(bodyString)")
            } else {
                print("  <\(body.count) bytes>")
            }
        }
        
        print("================\n")
    }
    
    static func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        print("\n📥 API RESPONSE")
        print("================")
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            
            if let url = httpResponse.url {
                print("URL: \(url.absoluteString)")
            }
            
            if !httpResponse.allHeaderFields.isEmpty {
                print("Headers:")
                httpResponse.allHeaderFields.forEach { key, value in
                    print("  \(key): \(value)")
                }
            }
        }
        
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
        
        if let data = data {
            print("Data:")
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                // Pretty print JSON
                print(prettyString)
            } else if let rawString = String(data: data, encoding: .utf8) {
                // Fallback to raw string
                print(rawString)
            } else {
                // Binary data
                print("<\(data.count) bytes>")
            }
        }
        
        print("================\n")
    }
}