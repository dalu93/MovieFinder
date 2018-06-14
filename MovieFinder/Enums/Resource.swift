//
//  Resource.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation

/**
 *  The `HTTPHeader` struct contains the needed informations to describe
 *  completely an HTTP header field
 */
struct HTTPHeader {

    /// The name of the HTTP header field
    let name: String

    /// The value of the HTTP header field
    let value: String
}

// MARK: - DictionaryConvertible
extension HTTPHeader: DictionaryConvertible {
    var dictionary: [String: String]? {
        return [
            name: value
        ]
    }
}

// MARK: - Prefilled HTTPHeaders
extension HTTPHeader {
    static func headerWith(contentType: String) -> HTTPHeader {
        return HTTPHeader(
            name: "Content-Type",
            value: contentType
        )
    }

    static var JSONContentType: HTTPHeader {
        return HTTPHeader.headerWith(contentType: "application/json")
    }
}

/**
 *  The `Parameter` struct contains the needed informations to descibe
 *  a request parameter. It can be query parameter or body parameter
 */
struct Parameter {

    /// The parameter name
    let field: String

    /// The parameter value
    let value: Any
}

// MARK: - DictionaryConvertible
extension Parameter: DictionaryConvertible {
    var dictionary: [String: Any]? {
        return [
            field: value
        ]
    }
}

/**
 *  The `Endpoint` struct contains all the info regarding
 *  the endpoint you are trying to reach
 */
struct Endpoint {

    /// The path
    let path: String

    /// The HTTP method
    let method: HTTPMethod

    /// The parameters
    fileprivate let _parameters: [Parameter]?

    /// The headers
    fileprivate let _headers: [HTTPHeader]?

    init(
        path: String,
        method: HTTPMethod,
        parameters: [Parameter]?,
        headers: [HTTPHeader]?
    ) {
        self.path = path
        self.method = method
        self._parameters = parameters
        self._headers = headers
    }
}

// MARK: - Computed properties
extension Endpoint {

    /// The encoded parameters, ready for the use
    var parameters: [String: Any]? {

        guard let parameters = _parameters else { return nil }

        var encParameters: [String: Any] = [:]
        parameters.forEach {
            guard let paramDict = $0.dictionary else { return }
            encParameters += paramDict
        }

        return encParameters
    }

    /// The encoded headers, ready for the use
    var headers: [String: String]? {
        guard let headers = _headers else { return nil }

        var encHeaders: [String: String] = [:]
        headers.forEach {
            guard let headerDict = $0.dictionary else { return }
            encHeaders += headerDict
        }

        return encHeaders
    }
}

/**
 *  The `Resource` struct contains the information about how to retrieve a
 *  specific resource and how to parse it from a Data response
 */
struct Resource<A> {

    /// The endpont to reach
    let endpoint: Endpoint

    /// A closure that indicates how to convert the response in a generic object
    let parse: (Data) throws -> A
}
