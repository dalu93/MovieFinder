//
//  ListViewController.swift
//  MovieFinder
//
//  Created by D'Alberti, Luca on 6/16/18.
//  Copyright © 2018 dalu93. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ListViewController declaration
final class ListViewController: UIViewController {
    typealias ViewModel = ListViewModel<APIService>
    // MARK: - Properties
    // MARK: Private properties
    fileprivate let _viewModel: ViewModel

    // MARK: Private outlets
    fileprivate lazy var _tableView: UITableView = self._makeTableView()
    fileprivate lazy var _tableFooterView: ListFooterView = self._makeFooterView()

    // MARK: - Object lifecycle
    init(_ viewModel: ViewModel) {
        _viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View lifecycle
extension ListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = _tableView
        _ = _tableFooterView

        _bind()
    }
}

// MARK: - Logic helpers
private extension ListViewController {
    func _bind() {
        _viewModel.state.bindAndFire { [weak self] state in
            guard let `self` = self else { return }
            self._tableView.reloadData()

            if state.isNextPageAvailable {
                self._tableView.tableFooterView = self._tableFooterView
                self._tableFooterView.set(.loading)
            } else {
                self._tableView.tableFooterView = nil
            }

            switch state.connectionStatus {
            case .completed(let result):
                if result.isFailed {
                    self._tableFooterView.set(
                        .error(AppError.List.loadingNextPageFailed)
                    )
                }

            default: break
            }
        }
    }

    func _loadNextPage() {
        guard _viewModel.state.value.isNextPageAvailable else {
            _tableView.tableFooterView = nil
            return
        }

        _viewModel.loadNextPage()
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rowOffset = 2
        guard indexPath.row + rowOffset >= _viewModel.state.value.items.count else {
            return
        }

        _viewModel.loadNextPage()
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _viewModel.state.value.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListTableViewCell = tableView.dequeueReusableCell()

        guard let item = _viewModel.state.value.items.get(at: indexPath.row) else { return cell }

        cell.set(item)
        return cell
    }
}

// MARK: - Builders
private extension ListViewController {
    func _makeTableView() -> UITableView {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )

        tableView.delegate = self
        tableView.dataSource = self
        tableView.setupAutomaticDimension(to: 200)
        tableView.registerCell(ListTableViewCell.self)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        return tableView
    }

    func _makeFooterView() -> ListFooterView {
        let footerView = ListFooterView(.loading)
        footerView.didTapRetry = { [weak self] in
            self?._loadNextPage()
        }

        _tableView.tableFooterView = footerView
        return footerView
    }
}
