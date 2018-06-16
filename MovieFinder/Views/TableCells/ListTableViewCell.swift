//
//  ListTableViewCell.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

// MARK: - ListTableViewCell declaration
final class ListTableViewCell: UITableViewCell, ReusableView {

    // MARK: - Properties
    // MARK: Private properties
    @IBOutlet fileprivate weak var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subtitleLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!

    // MARK: - Public methods
    // MARK: Overrides
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.kf.cancelDownloadTask()
        thumbnailImageView.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.kf.indicatorType = .activity
        selectionStyle = .none
    }

    // MARK: Set item
    func set(_ item: ListCellDisplayable) {
        thumbnailImageView.kf.setImage(with: item.thubmnailUrl, options: [.transition(.fade(0.2))])
        titleLabel.text = item.title
        subtitleLabel.text = "Release date: " + item.subtitle
        descriptionLabel.text = item.description
    }
}
