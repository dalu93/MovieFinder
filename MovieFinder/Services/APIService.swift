//
//  APIService.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - APIService declaration
/// The application API service used to connect to the API.
struct APIService: APIConnectable {

    /// The API base URL
    let baseAPIURL: String

    /// The API-specific imageUrl provider.
    let imageUrlProvider: TMDBImageUrlProvider

    /// The `URLSessionConfiguration` that the `APIService` will use for the requests.
    let sessionConfiguration: URLSessionConfiguration

    /// Loads a specific resource by connecting to the API.
    ///
    /// - Parameters:
    ///   - resource: The resource to load remotely.
    ///   - completion: Called when the HTTP requests is finished.
    /// - Returns: The `URLSessionDataTask` representation of the current HTTP request.
    func load<Object>(
        resource: Resource<Object>,
        completion: @escaping (Completion<Object>) -> Void
    ) -> URLSessionDataTask {
        let request = _request(from: resource)
        let session = URLSession(configuration: sessionConfiguration)
        log.debug("Starting request to \(request.url?.absoluteString ?? "null")")
        let task = session.dataTask(with: request) { data, urlResponse, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    let connectionError = AppError.Request.invalidConnection
                    log.error("Request failed: \(connectionError)\n\(error!)")
                    completion(.failed(connectionError))
                    return
                }

                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    log.error("Missing HTTPURLResponse")
                    completion(.failed(AppError.Request.invalidConnection))
                    return
                }

                guard (200..<300).contains(httpResponse.statusCode) else {
                    log.error("Invalid status code: \(httpResponse.statusCode)")
                    completion(.failed(AppError.Request.invalidStatusCode(httpResponse.statusCode)))
                    return
                }

                guard let data = data, data.count > 0 else {
                    log.error("Missing data or data.count == 0")
                    completion(.failed(AppError.Request.invalidResponseData))
                    return
                }

                do {
                    log.debug("Parsing the object...")
                    completion(.success(try resource.parse(data)))
                } catch let parseError {
                    log.error("Parsing object failed: \(parseError)")
                    completion(.failed(AppError.Request.invalidResponseData))
                }
            }
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

    func _request<Object>(from resource: Resource<Object>) -> URLRequest {
        var url = _fullURL(
            using: resource.endpoint.path
        )

        if resource.endpoint.method == .get,
            let params = resource.endpoint.parameters {
            let previousUrlString = url.absoluteString
            let queryString = params.reduce("?") { previousResult, args in
                guard let value = args.value as? String else {
                    return previousResult
                }

                let encodedUrlValue = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
                return previousResult + args.key + "=" + encodedUrlValue + "&"
            }

            let fullUrlString = previousUrlString + queryString
            guard let fullUrl = URL(string: fullUrlString) else {
                fatalError("Cannot create URL using the query string: \(queryString)")
            }

            url = fullUrl
        }
        var request = URLRequest(
            url: url
        )

        request.httpMethod = resource.endpoint.method.rawValue
        resource.endpoint.headers?.forEach {
            request.addValue($1, forHTTPHeaderField: $0)
        }

        return request
    }
}
