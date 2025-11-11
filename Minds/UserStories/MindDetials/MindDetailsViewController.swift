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
    
    // Dependencies
    private var presenter: IMindDetailsPresenter
    
    // UI
    private lazy var saveButton = UIButton(type: .system)
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17)
        textView.backgroundColor = .clear
        textView.delegate = self
        return textView
    }()
    
    // Constraints
    private var textViewBottomConstraint: Constraint?
    
    // MARK: - Init
    
    init(presenter: IMindDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpUI()
        setupKeyboardObservers()
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        setUpNavigationBar()
        view.addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
            $0.horizontalEdges.equalToSuperview().inset(12)
            textViewBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40).constraint
        }
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func saveButtonTapped() {
        presenter.didTapSaveButton(with: textView.text)
    }
    
    // MARK: - Keyboard Handling
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: 0.3) {
            self.textViewBottomConstraint?.update(inset: keyboardHeight + 8)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.textViewBottomConstraint?.update(inset: 40)
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextViewDelegate

extension MindDetailsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text.removeAll()
            textView.textColor = .label
        }
    }
}

// MARK: - IMindDetailsView

extension MindDetailsViewController: IMindDetailsView {
        
    func updateUI(with text: String) {
        navigationItem.title = "Mind"
        textView.textColor = .label
        textView.text = text
    }
    
    func setUpEmptyState() {
        navigationItem.title = "New Mind"
        textView.text = "Enter your mind..."
        textView.textColor = .secondaryLabel
    }
    
    func showErrorAlert(action: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: "Error",
            message: "Something went wrong. Please try again later.",
            preferredStyle: .alert
        )
        
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            action()
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}
