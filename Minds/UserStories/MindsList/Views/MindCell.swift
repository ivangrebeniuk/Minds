//
//  MindCell.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import SnapKit
import UIKit

final class MindCell: UITableViewCell {
    
    // UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var mindTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(mindTextLabel)
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
    }
}

extension MindCell: ConfigurableView {
    
    struct Model: Hashable, Equatable {
        let id: UUID
        let title: String
        let text: String?
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: Model, rhs: Model) -> Bool {
            lhs.id == rhs.id && lhs.text == rhs.text && lhs.title == rhs.title
        }
    }
    
    func configure(with model: Model) {
        titleLabel.text = model.title
        mindTextLabel.text = model.text ?? .defaultText
    }
}

private extension String {
    static let defaultText = "No additional text"
}
