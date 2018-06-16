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
    typealias ViewModel = SearchViewModel<APIService>
    // MARK: - Properties
    // MARK: Private properties
    fileprivate let _viewModel: ViewModel

    // MARK: Private outlets
    fileprivate lazy var _searchTextField: UITextField = self._makeSearchTextField()
    fileprivate lazy var _searchButton: UIButton = self._makeSearchButton()

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
    }
}

// MARK: - Actions from UI
private extension SearchViewController {
    @objc func _didPressSearchButton() {
        _startSearch()
    }
}

// MARK: - Logic helpers
private extension SearchViewController {
    func _bind() {
        _viewModel.searchStatus.bind { [weak self] status in
            self?._searchButton.isEnabled = true
            self?._searchTextField.isEnabled = true

            switch status {
            case .notStarted: break
            case .completed(let result):
                if let error = result.error,
                    let appError = error as? AppErrorType {

                    self?._handleError(appError)
                } else if let value = result.value {
                    self?._viewModel.showResult(for: value)
                } else {
                    fatalError("[DEV ERROR] No value or valid error was returned")
                }

            case .inProgress:
                self?._searchTextField.isEnabled = false
                self?._searchButton.isEnabled = false
            }
        }
    }

    func _startSearch() {
        let keyword = _searchTextField.text ?? ""
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
        _ = _searchTextField
        _ = _searchButton
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _didPressSearchButton()
        return true
    }
}

// MARK: - Builders
private extension SearchViewController {
    func _makeSearchTextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Enter a movie name..."
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .search
        textField.delegate = self

        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 20
        ).isActive = true

        textField.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -20
        ).isActive = true

        textField.centerXAnchor.constraint(
            equalTo: view.centerXAnchor
        ).isActive = true

        textField.centerYAnchor.constraint(
            equalTo: view.centerYAnchor
        ).isActive = true
        return textField
    }

    func _makeSearchButton() -> UIButton {
        let button = UIButton(frame: .zero)
        button.addTarget(
            self,
            action: #selector(_didPressSearchButton),
            for: .touchUpInside
        )

        button.setTitleColor(.black, for: .normal)
        button.setTitle("Search", for: .normal)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: _searchTextField.bottomAnchor, constant: 10).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true

        return button
    }
}
