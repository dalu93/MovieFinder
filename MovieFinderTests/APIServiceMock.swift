//
//  APIServiceMock.swift
//  MovieFinderTests
//
//  Created by D'Alberti, Luca on 6/17/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
@testable import MovieFinder

class APIServiceMock: APIConnectable {
    struct ImageProvider: ImageUrlProviderType {
        func imageUrlUsing(_ path: String) -> URL? {
            return nil
        }
    }

    let baseAPIURL = ""
    let imageUrlProvider = ImageProvider()
    var responseFileName: String = ""
    var responseError: Error?
    func load<Object>(resource: Resource<Object>, completion: @escaping (Completion<Object>) -> Void) -> Any {
        // delaying because otherwise the completion is overwritten by the return of the function - mocks are too fast!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let error = self.responseError {
                completion(.failed(error))
                return
            }

            let bundle = Bundle(for: type(of: self))
            let url = bundle.url(forResource: self.responseFileName, withExtension: "json")!
            let data = try! Data(contentsOf: url)
            let result = try! SearchResult(with: data)
            completion(.success(result as! Object))
        }

        return ()
    }
}
