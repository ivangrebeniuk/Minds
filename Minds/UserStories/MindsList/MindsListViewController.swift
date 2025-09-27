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
    
    // Dependencies
    private let presenter: IMindsListPresenter
    
    // UI
    private lazy var newMindButton: UIButton = {
        let button = UIButton(type: .system)
        
        // конфигурация символа — задаём желаемый размер
        let symbolConfig = UIImage.SymbolConfiguration(
            pointSize: 50,
            weight: .regular,
            scale: .large
        )
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: symbolConfig)
        
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        
        button.imageView?.contentMode = .scaleAspectFit
        
        button.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        button.addAction(
            UIAction {_ in 
                print("BUTTON TAPPED!")
            },
            for: .touchUpInside)
        return button
    }()
    
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
        
        setUpNavigationBar()
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Private
    
    private func setUpNavigationBar() {
        navigationItem.title = .navBarTitle
        let barButtonItem = UIBarButtonItem(customView: newMindButton)
        navigationItem.rightBarButtonItem = barButtonItem
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc private func didTapPlus() {
        print("DID TAP PLUS")
    }
}

// MARK: - IMindsListView

extension MindsListViewController: IMindsListView {
    
}

private extension String {
    static let navBarTitle = "Minds"
}
