//
//  Endpoint+All.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

// MARK: - Endpoints declaration
extension Endpoint {
    static func search(
        using keyword: String,
        at page: Int,
        and apiKey: String = "2696829a81b1b5827d515ff121700838"
    ) -> Endpoint {
        var parameters: [Parameter] = []
        parameters.append(Parameter(field: "query", value: keyword))
        parameters.append(Parameter(field: "page", value: "\(page)"))
        parameters.append(Parameter(field: "api_key", value: apiKey))

        return Endpoint(
            path: "/search/movie",
            method: .get,
            parameters: parameters,
            headers: nil
        )
    }
}
