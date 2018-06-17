//
//  ListFooterView.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ListFooterView declaration
/// A view displaying either an activity indicator or an error message,
/// to be displayed at the bottom of the list's tableView
/// to mimic the "infinite scroll" behavior.
final class ListFooterView: UIView {

    // MARK: - Mode internal declaration
    /// View mode.
    ///
    /// - loading: The view should display the loading indicator.
    /// - error: The view should display the error.
    enum Mode {
        case loading, error(AppErrorType)
    }

    // MARK: - Properties
    // MARK: Public properties
    /// Called when the error message is tapped by the user.
    var didTapRetry: (() -> Void)?

    // MARK: Private propierties
    private var _currentMode: Mode {
        didSet {
            _refresh()
        }
    }
    fileprivate lazy var _activityIndicator: UIActivityIndicatorView = self._makeIndicatorView()
    fileprivate lazy var _retryButton: UIButton = self._makeRetryButton()

    // MARK: - Object lifecycle
    init(_ mode: Mode) {
        _currentMode = mode
        super.init(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 0,
                height: 50
            )
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    // MARK: Public methods
    /// Change the view's mode.
    ///
    /// - Parameter mode: The new mode.
    func set(_ mode: Mode) {
        _currentMode = mode
    }

    // MARK: Private methods
    private func _refresh() {
        switch _currentMode {
        case .loading:
            _retryButton.isHidden = true
            _activityIndicator.isHidden = false
            _activityIndicator.startAnimating()

        case .error:
            _retryButton.isHidden = false
            _activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Actions
private extension ListFooterView {
    @objc func _retryButtonPressed() {
        didTapRetry?()
    }
}

// MARK: - Builders
private extension ListFooterView {
    func _makeIndicatorView() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(
            activityIndicatorStyle: .gray
        )

        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        indicator.startAnimating()
        indicator.hidesWhenStopped = true

        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        return indicator
    }

    func _makeRetryButton() -> UIButton {
        let button = UIButton(frame: .zero)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.setTitle("An error occurred. Tap to retry", for: .normal)
        button.addTarget(
            self,
            action: #selector(_retryButtonPressed),
            for: .touchUpInside
        )

        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        return button
    }
}
