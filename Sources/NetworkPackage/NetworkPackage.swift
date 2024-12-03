import Foundation

public class NetworkPackage: NetworkService {
    
    public init() {}
    
    public func fetchData<T: Codable & Sendable>(
        from urlString: String,
        modelType: T.Type,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "com.example.Test", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "com.example.Test", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw Response Body: \(jsonString)")
                }
            }
            
            if httpResponse.statusCode > 210 {
                completion(.failure(NSError(domain: "com.example.Test", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with status code \(httpResponse.statusCode)"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "com.example.Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(T.self, from: data)
                completion(.success(responseObject))
            } catch {
                print("Decoding error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Failed to decode raw data: \(jsonString)")
                }
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    public func postData<T: Codable & Sendable, U: Codable>(
        to urlString: String,
        modelType: T.Type,
        requestBody: U,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "com.example.Test", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(requestBody)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "com.example.Test", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw Response Body: \(jsonString)")
                }
            }
            
            if httpResponse.statusCode > 210 {
                completion(.failure(NSError(domain: "com.example.Test", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with status code \(httpResponse.statusCode)"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "com.example.Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(T.self, from: data)
                completion(.success(responseObject))
            } catch {
                print("Decoding error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Failed to decode raw data: \(jsonString)")
                }
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    public func deleteData<T: Codable & Sendable>(
        from urlString: String,
        modelType: T.Type,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "com.example.Test", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "com.example.Test", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw Response Body: \(jsonString)")
                }
            }
            
            if httpResponse.statusCode > 210 {
                completion(.failure(NSError(domain: "com.example.Test", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with status code \(httpResponse.statusCode)"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "com.example.Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(T.self, from: data)
                completion(.success(responseObject))
            } catch {
                print("Decoding error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Failed to decode raw data: \(jsonString)")
                }
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
