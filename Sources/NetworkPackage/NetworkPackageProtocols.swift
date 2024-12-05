//
//  NetworkPackageProtocols.swift
//  NetworkPackage
//
//  Created by Sandro Maraneli on 24.11.24.
//

public protocol NetworkService {
    func fetchData<T: Codable & Sendable>(
        from urlString: String,
        modelType: T.Type,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    )
    
    func postData<T: Codable & Sendable, U: Codable>(
        to urlString: String,
        modelType: T.Type,
        requestBody: U,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    )
    
    func deleteData<T: Codable & Sendable>(
        from urlString: String,
        modelType: T.Type,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    )
    
    func fetchDataWithToken<T: Decodable>(
        urlString: String,
        modelType: T.Type,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    )
    
    func patchDataWithToken<T: Encodable, U: Decodable>(
        urlString: String,
        modelType: T.Type,
        body: T,
        completion: @escaping @Sendable (Result<U, Error>) -> Void
    )
    
    func postDataWithToken<T: Encodable, U: Decodable>(
        urlString: String,
        modelType: T.Type,
        body: T,
        completion: @escaping @Sendable (Result<U, Error>) -> Void
    )
    
    func deleteDataWithToken<T: Decodable>(
        urlString: String,
        modelType: T.Type,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    )
}
