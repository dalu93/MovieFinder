//
//  SuggestionTableViewCell.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import UIKit

// MARK: - SuggestionTableViewCell declaration
final class SuggestionTableViewCell: UITableViewCell, ReusableView {
    static let height: CGFloat = 40
    
    // MARK: - Private outlets
    @IBOutlet private weak var suggestionLabel: UILabel!

    // MARK: - Public methods
    func set(_ suggestion: Suggestion) {
        suggestionLabel.text = suggestion.keyword
    }
}
