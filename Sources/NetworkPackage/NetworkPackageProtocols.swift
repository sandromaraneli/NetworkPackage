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
}
