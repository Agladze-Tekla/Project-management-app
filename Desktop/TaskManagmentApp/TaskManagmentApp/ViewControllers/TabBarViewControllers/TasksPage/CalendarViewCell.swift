//
//  CalendarViewCell.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/12/24.
//

import UIKit

final class CalendarViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "CalendarViewCell"

        private let weekLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            label.textColor = .white
            return label
        }()

        private let dateLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.textColor = .white
            return label
        }()

        private let monthLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textColor = .white
            return label
        }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.backgroundColor = .systemIndigo
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    //MARK: - ViewLifeCycle
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupUI()
        }

    //MARK: - Methods
        private func setupUI() {
            stackView.addArrangedSubview(weekLabel)
            stackView.addArrangedSubview(dateLabel)
            stackView.addArrangedSubview(monthLabel)
            contentView.addSubview(stackView)
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }

    //MARK: - Configure
        func configure(with calendarDate: Date) {
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE"
                weekLabel.text = dateFormatter.string(from: calendarDate)
                dateFormatter.dateFormat = "dd"
                dateLabel.text = dateFormatter.string(from: calendarDate)
                dateFormatter.dateFormat = "MMM"
                monthLabel.text = dateFormatter.string(from: calendarDate)
        }
}
