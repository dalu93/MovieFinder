//
//  SearchView.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import UIKit

// MARK: - SearchView declaration
final class SearchView: UIView, ReusableView {

    // MARK: - Properties
    // MARK: Public properties
    var suggestions: [Suggestion] = [] {
        didSet {
            layoutSubviews()
        }
    }

    var didSearch: ((String) -> Void)?
    var currentKeyword: String {
        return textField.text ?? ""
    }

    var height: CGFloat {
        return tableHeightConstraint.constant + 30
    }

    override var isUserInteractionEnabled: Bool {
        didSet {
            if isUserInteractionEnabled == false {
                textField.resignFirstResponder()
            }
        }
    }

    // MARK: Private properties
    fileprivate let _expandedTableViewHeight: CGFloat = SuggestionTableViewCell.height * 3
    fileprivate var _filteredSuggestions: [Suggestion] {
        return suggestions.filter {
            let typedKeyword = textField.text ?? ""
            return $0.keyword.hasPrefix(typedKeyword) && $0.keyword != typedKeyword
        }
    }

    // MARK: Private outlets
    fileprivate lazy var textField: UITextField = self._makeTextField()
    fileprivate lazy var tableView: UITableView = self._makeTableView()
    fileprivate var tableHeightConstraint: NSLayoutConstraint!

    // MARK: - Public methods
    func clearText() {
        textField.text = ""
    }

    // MARK: - Private methods
    fileprivate func _startSearch(using keyword: String) {
        textField.resignFirstResponder()
        tableHeightConstraint.constant = 0
        didSearch?(keyword)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        _setupUI()
    }

    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    private func _setupUI() {
        _ = textField
        _ = tableView
    }
}

// MARK: - <#UITextFieldDelegate#>
extension SearchView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard suggestions.isEmpty == false else {
            tableHeightConstraint.constant = 0
            return
        }

        // expand suggestions table
        tableHeightConstraint.constant = _expandedTableViewHeight
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _startSearch(using: textField.text ?? "")
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text as NSString?)!.replacingCharacters(in: range, with: string)

        tableView.reloadData()
        if _filteredSuggestions.isEmpty {
            tableHeightConstraint.constant = 0
        } else {
            tableHeightConstraint.constant = _expandedTableViewHeight
        }

        return true
    }
}

// MARK: - <#UITableViewDataSource#>
extension SearchView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if _filteredSuggestions.isEmpty == false {
            return _filteredSuggestions.count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let suggestion = suggestions.get(at: indexPath.row) else {
            return UITableViewCell()
        }

        let cell: SuggestionTableViewCell = tableView.dequeueReusableCell()
        cell.set(suggestion)
        return cell
    }
}

// MARK: - <#UITableViewDelegate#>
extension SearchView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let suggestion = suggestions.get(at: indexPath.row) else { return }
        textField.text = suggestion.keyword
        _startSearch(using: suggestion.keyword)
    }
}

// MARK: - Builders
private extension SearchView {
    func _makeTextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .roundedRect
        textField.delegate = self

        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)

        textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true

        return textField
    }

    func _makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = SuggestionTableViewCell.height
        tableView.registerCell(SuggestionTableViewCell.self)
        tableView.tableFooterView = UIView(frame: .zero)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableHeightConstraint.isActive = true

        return tableView
    }
}
