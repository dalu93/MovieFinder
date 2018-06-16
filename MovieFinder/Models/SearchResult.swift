//
//  SearchResult.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - SearchResult declaration
struct SearchResult: Codable {

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }

    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Movie]
    fileprivate(set) var keyword: String = ""
}

// MARK: - JSONRepresentable
extension SearchResult: JSONRepresentable {

    init(with jsonData: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(SearchResult.self, from: jsonData)
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

// MARK: - API
extension SearchResult {
    static func get<APIService: APIConnectable>(
        with keyword: String,
        at page: Int,
        using service: APIService,
        completion: @escaping ((Completion<SearchResult>) -> Void)
    ) -> APIService.RequestType {
        let resource = Resource<SearchResult>(
            endpoint: Endpoint.search(using: keyword, at: page),
            parse: { data in
                var result = try SearchResult(with: data)
                result.keyword = keyword
                return result
            }
        )

        return service.load(
            resource: resource,
            completion: completion
        )
    }

    func nextPage<APIService: APIConnectable>(
        using service: APIService,
        completion: @escaping ((Completion<SearchResult>) -> Void)
    ) {
        _ = SearchResult.get(
            with: keyword,
            at: page + 1,
            using: service,
            completion: completion
        )
    }
}
