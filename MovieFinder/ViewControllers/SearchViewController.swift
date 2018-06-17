//
//  SearchViewController.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/14/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import UIKit
import Toaster

// MARK: - SearchViewController declaration
final class SearchViewController: UIViewController {
    typealias ViewModel = SearchViewModel<APIService, SuggestionStore, MainFlowController>
    // MARK: - Properties
    // MARK: Private properties
    fileprivate let _viewModel: ViewModel

    // MARK: Private outlets
    fileprivate lazy var _searchView: SearchView = self._makeSearchView()
    fileprivate var _searchViewTopAnchorConstraint: NSLayoutConstraint!
    fileprivate var _searchViewCenterYAnchorConstraint: NSLayoutConstraint!
    fileprivate var _searchViewHeightAnchorConstraint: NSLayoutConstraint!

    // MARK: - Object lifecycle
    init(_ viewModel: ViewModel) {
        _viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Use `init(_: ViewModel) instead`")
    }
}

// MARK: - View lifecycle
extension SearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
        _bind()
        _registerForKeyboardNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _searchView.clearText()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _searchView.suggestions = _viewModel.availableSuggestions
        _ = _searchView.becomeFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _searchViewHeightAnchorConstraint.constant = _searchView.height
    }
}

// MARK: - Logic helpers
private extension SearchViewController {
    func _bind() {
        _viewModel.searchStatus.bind { [weak self] status in
            guard let `self` = self else { return }
            self._searchView.isUserInteractionEnabled = true

            switch status {
            case .notStarted: break
            case .completed(let result):
                if let error = result.error,
                    let appError = error as? AppErrorType {

                    self._handleError(appError)
                } else if let value = result.value {
                    self._viewModel.showResult(for: value, keyword: self._searchView.currentKeyword)
                } else {
                    fatalError("[DEV ERROR] No value or valid error was returned")
                }

            case .inProgress:
                self._searchView.isUserInteractionEnabled = false
            }
        }
    }

    func _registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(_keyboardWillDisplay),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(_keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }

    func _startSearch(using keyword: String) {
        _viewModel.search(for: keyword)
    }

    func _handleError(_ error: AppErrorType) {
        Toast(text: error.description).show()
    }
}

// MARK: - UI Helpers
private extension SearchViewController {
    func _setupUI() {
        title = "Movie Finder"
        view.backgroundColor = .white
        _searchView.suggestions = _viewModel.availableSuggestions
    }

    @objc func _keyboardWillDisplay() {
        _searchViewCenterYAnchorConstraint.isActive = false
        _searchViewTopAnchorConstraint.isActive = true
    }

    @objc func _keyboardWillHide() {
        _searchViewTopAnchorConstraint.isActive = false
        _searchViewCenterYAnchorConstraint.isActive = true
    }
}

// MARK: - Builders
private extension SearchViewController {
    func _makeSearchView() -> SearchView {
        let searchView = SearchView(frame: .zero)
        searchView.didSearch = { [weak self] keyword in
            self?._startSearch(using: keyword)
        }

        searchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchView)

        searchView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 20
        ).isActive = true

        searchView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -20
        ).isActive = true

        searchView.centerXAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.centerXAnchor
        ).isActive = true

        _searchViewCenterYAnchorConstraint = searchView.centerYAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.centerYAnchor
        )
        _searchViewCenterYAnchorConstraint.isActive = true

        _searchViewTopAnchorConstraint = searchView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 10
        )

        _searchViewHeightAnchorConstraint = searchView.heightAnchor.constraint(equalToConstant: 100)
        _searchViewHeightAnchorConstraint.isActive = true

        searchView.isUserInteractionEnabled = true

        return searchView
    }
}
