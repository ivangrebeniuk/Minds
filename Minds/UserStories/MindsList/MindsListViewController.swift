//
//  MindsListViewController.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import SnapKit
import UIKit

final class MindsListViewController: UIViewController {
    
    // Diffable Data Source
    enum Section {
        case main
    }
    
    private typealias Item = MindCell.Model
    private typealias DataSource = UITableViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // Dependencies
    private let presenter: IMindsListPresenter
    
    // UI
    private lazy var addNewMindButton = UIButton()
    private lazy var tableView = UITableView()
    
    private lazy var dataSource = makeDataSource()
    
    // MARK: - Init
    
    init(presenter: IMindsListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        view.backgroundColor = .systemBackground
        presenter.viewDidLoad()
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(
                UIEdgeInsets(
                    top: 0,
                    left: 8,
                    bottom: 0,
                    right: 8
                )
            )
        }
        setUpNavigationBar()
        setupTableView()
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = .navBarTitle
        setUpAddNewMindButton()
        let barButtonItem = UIBarButtonItem(customView: addNewMindButton)
        navigationItem.rightBarButtonItem = barButtonItem
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpAddNewMindButton() {
        let symbolConfig = UIImage.SymbolConfiguration(
            pointSize: 44,
            weight: .regular,
            scale: .large
        )
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: symbolConfig)
        
        addNewMindButton.setImage(image, for: .normal)
        addNewMindButton.tintColor = .systemBlue
        
        addNewMindButton.imageView?.contentMode = .scaleAspectFit
        
        addNewMindButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
        
        addNewMindButton.addAction(
            UIAction { [weak self] _ in
                print("BUTTON TAPPED!")
                self?.presenter.didTapAddNewMind()
            },
            for: .touchUpInside
        )
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.register(MindCell.self, forCellReuseIdentifier: .cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
    }
    
    private func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, item in
            guard
                let mindCell = tableView.dequeueReusableCell(
                    withIdentifier: .cellIdentifier,
                    for: indexPath
                ) as? MindCell
            else {
                return UITableViewCell()
            }
            mindCell.configure(with: item)
            return mindCell
        }
    }
}

// MARK: - UITableViewDelegate

extension MindsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectMind(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive, title: ""
        ) { [weak self] (_, _, completionHandler) in
            self?.presenter.didDeleteMind(at: indexPath.row)
            completionHandler(true)
    
        }
        deleteAction.image = UIImage.init(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - IMindsListView

extension MindsListViewController: IMindsListView {
    
    func updateTableView(with items: [MindCell.Model]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func deleteItem(_ item: MindCell.Model) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([item])
        dataSource.apply(snapshot)
    }
    
    func insertItem(_ item: MindCell.Model) {
        var snapshot = dataSource.snapshot()
        if let first = snapshot.itemIdentifiers.first {
            snapshot.insertItems([item], beforeItem: first)
        } else {
            snapshot.appendItems([item])
        }
        
        dataSource.apply(snapshot)
    }
}

private extension String {
    
    static let navBarTitle = "Minds"
    static let cellIdentifier = "MindsListCellIdentifier"
}
