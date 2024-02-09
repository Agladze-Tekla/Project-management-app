//
//  TaskViewCell.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/9/24.
//

import UIKit

final class TaskViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = "TaskViewCell"
    
    // MARK: - UI Components
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .systemIndigo
        label.numberOfLines = 0
        return label
    }()
    
    private let taskInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.systemIndigo.withAlphaComponent(0.8)
        return label
    }()
    
    private let isDoneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .systemIndigo
        button.addTarget(self, action: #selector(didTapIsDoneButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(labelStackView)
        mainStackView.addArrangedSubview(taskInfoStackView)
        mainStackView.addArrangedSubview(isDoneButton)
        
        taskInfoStackView.addArrangedSubview(titleLabel)
        
        taskInfoStackView.addArrangedSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Public Methods
    
    func configure(with task: TaskModel) {
        titleLabel.text = task.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = "Date: \(dateFormatter.string(from: task.date))"
        
        updateIsDoneButton(isDone: task.isCompleted)
    }
    
    // MARK: - Private Methods
    
    private func updateIsDoneButton(isDone: Bool) {
        isDoneButton.isSelected = isDone
        let imageName = isDone ? "checkmark.circle.fill" : "circle"
        isDoneButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func didTapIsDoneButton() {
        // Handle button tap
    }
}
