//
//  MindsListViewController.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import SnapKit
import UIKit

protocol IMindsListView: AnyObject {
    
}

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
    
    // Temporary SOLUTION
    private lazy var dataSource: DataSource = makeDataSource()
    private var items: [Item] = []
    
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
        items.append(.init(title: "Заметка 1", text: nil))
        items.append(.init(title: "Заметка 2", text: "Как делашки, пес?"))
        items.append(.init(title: "Заметка 3", text: "Лупа лупа лупа"))
        applySnapshot(animatingDifferences: false)
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
                self?.addNewNote()
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
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func addNewNote() {
        let newItem = Item(title: "Труляля", text: "Число от 1 до 10: \(Int.random(in: 0...10))")
        items.insert(newItem, at: 0)
        applySnapshot()
    }
}

// MARK: - UITableViewDelegate

extension MindsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive, title: ""
        ) { [weak self] (_, _, completionHandler) in
            self?.items.remove(at: indexPath.row)
            self?.applySnapshot()
            completionHandler(true)
    
        }
        deleteAction.image = UIImage.init(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - IMindsListView

extension MindsListViewController: IMindsListView {
    
}

private extension String {
    static let navBarTitle = "Minds"
    static let cellIdentifier = "MindsListCellIdentifier"
}
