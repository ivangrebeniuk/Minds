//
//  MindDetailsViewController.swift
//  Minds
//
//  Created by Иван Гребенюк on 11.10.2025.
//

import Foundation
import SnapKit
import UIKit

final class MindDetailsViewController: UIViewController {
    
    private var presenter: IMindDetailsPresenter
    
    init(presenter: IMindDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        view.backgroundColor = .purple
    }
}

extension MindDetailsViewController: IMindDetailsView {
    
    func updateUI() {
        print("Need to update ui")
    }
}
