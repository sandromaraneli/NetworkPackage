import Foundation
import KeychainSwift

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
    
   public func fetchDataWithToken<T: Decodable>(
    urlString: String,
    modelType: T.Type,
    completion: @escaping @Sendable (Result<T, Error>) -> Void
   ) {
        guard let accessToken = KeychainHelper.getAccessToken() else {
            completion(.failure(NSError(domain: "UserProfileService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "UserProfileService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                    print("Response Body: \(responseBody)")
                }
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 210 {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedObject = try decoder.decode(T.self, from: data)
                        completion(.success(decodedObject))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "UserProfileService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            } else {
                completion(.failure(NSError(domain: "UserProfileService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error or invalid response"])))
            }
        }
        task.resume()
    }
    
   public func postDataWithToken<T: Encodable, U: Decodable>(
        urlString: String,
        modelType: T.Type,
        body: T,
        completion: @escaping @Sendable (Result<U, Error>) -> Void
    ) {
        guard let accessToken = KeychainHelper.getAccessToken() else {
            completion(.failure(NSError(domain: "APIService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "APIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(body)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                    print("Response Body: \(responseBody)")
                }
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 210 {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedObject = try decoder.decode(U.self, from: data)
                        completion(.success(decodedObject))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "APIService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            } else {
                completion(.failure(NSError(domain: "APIService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error or invalid response"])))
            }
        }
        task.resume()
    }
    
    
    
    public func deleteDataWithToken<T: Decodable>(
        urlString: String,
        modelType: T.Type,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    ) {
        guard let accessToken = KeychainHelper.getAccessToken() else {
            completion(.failure(NSError(domain: "APIService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "APIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                    print("Response Body: \(responseBody)")
                }
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 210 {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedObject = try decoder.decode(T.self, from: data)
                        completion(.success(decodedObject))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "APIService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            } else {
                completion(.failure(NSError(domain: "APIService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error or invalid response"])))
            }
        }
        task.resume()
    }

    public func patchDataWithToken<T: Encodable, U: Decodable>(
        urlString: String,
        modelType: T.Type,
        body: T,
        completion: @escaping @Sendable (Result<U, Error>) -> Void
    ) {
        guard let accessToken = KeychainHelper.getAccessToken() else {
            completion(.failure(NSError(domain: "APIService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing"])))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "APIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(body)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                    print("Response Body: \(responseBody)")
                }
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 210 {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedObject = try decoder.decode(U.self, from: data)
                        completion(.success(decodedObject))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "APIService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            } else {
                completion(.failure(NSError(domain: "APIService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error or invalid response"])))
            }
        }
        task.resume()
    }


    
    
    
}
