//
//  APIService.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

struct APIService: APIConnectable {
    let baseAPIURL: String
    let sessionConfiguration: URLSessionConfiguration

    func load<Object>(
        resource: Resource<Object>,
        completion: @escaping (Completion<Object>) -> Void
    ) -> URLSessionDataTask {
        let request = URLRequest(
            url: _fullURL(
                using: resource.endpoint.path
            )
        )

        let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: request) { data, urlResponse, error in
            guard error == nil else {
                completion(.failed(AppError.Request.invalidConnection))
                return
            }

            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                completion(.failed(AppError.Request.invalidConnection))
                return
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(.failed(AppError.Request.invalidStatusCode(httpResponse.statusCode)))
                return
            }

            guard let data = data, data.count > 0 else {
                completion(.failed(AppError.Request.invalidResponseData))
                return
            }

            guard let parsedObject = resource.parse(data) else {
                completion(.failed(AppError.Request.invalidResponseData))
                return
            }

            completion(.success(parsedObject))
        }

        task.resume()
        return task
    }
}

// MARK: - Helpers
private extension APIService {
    func _fullURL(using path: String) -> URL {
        guard let url = URL(string: baseAPIURL + path) else {
            fatalError("Cannot generate URL. Developer error.")
        }

        return url
    }
}
