//
//  MovieSpecs.swift
//  MovieFinderTests
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MovieFinder

final class MovieSpecs: QuickSpec {
    override func spec() {
        describe("[UT] Converting a Movie to ListItem") {
            it("should contain all the correct values after the conversion and thumbnailUrl == nil") {
                // GIVEN
                let movie = Movie(
                    posterPath: nil,
                    name: "Lord of the Rings",
                    release: "01-01-2001",
                    overview: "Overview"
                )

                // WHEN
                let item = movie.listItem

                // THEN
                expect(item.title).to(equal(movie.name))
                expect(item.subtitle).to(equal(movie.release))
                expect(item.thubmnailUrl).to(beNil())
                expect(item.description).to(equal(movie.overview))
            }
        }

        describe("[UT] Loading movies from a valid JSON") {
            it("should return an array of valid Movies") {
                // GIVEN
                let bundle = Bundle(for: type(of: self))
                let url = bundle.url(forResource: "movies", withExtension: "json")!
                let moviesData = try! Data(contentsOf: url)
                let expectedMovie = Movie(
                    posterPath: "some path",
                    name: "Something",
                    release: "some date",
                    overview: "some description"
                )

                // WHEN
                let movies = try! JSONDecoder()
                    .decode([Movie].self, from: moviesData)

                // THEN
                expect(movies.count).to(equal(1))
                expect(movies.first!).to(equal(expectedMovie))
            }
        }
    }
}
