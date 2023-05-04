//
//  SettingsTableViewCell.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 26.04.2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    var value: String?
    var data: Settings?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 10
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trueButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let falseButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        addtargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(trueButton)
        stackView.addArrangedSubview(falseButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalTo(snp.centerY)
        }
        stackView.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalTo(snp.centerY)
        }
//        trueButton.snp.makeConstraints { make in
//            make.right.equalTo(falseButton.snp.left)
//            make.centerY.equalTo(snp.centerY)
//        }
    }
    
    private func addtargets() {
        trueButton.addTarget(self, action: #selector(trueButtonPressed), for: .touchUpInside)
        falseButton.addTarget(self, action: #selector(falseButtonPressed), for: .touchUpInside)
    }
    
    func setup (text: String, value: [String], boolean: Bool) {
        descriptionLabel.text = text
        trueButton.setTitle(value[0], for: .normal)
        falseButton.setTitle(value[1], for: .normal)
        if boolean {
            trueButton.backgroundColor = .systemBlue
            falseButton.backgroundColor = .systemGray2
        } else {
            falseButton.backgroundColor = .systemBlue
            trueButton.backgroundColor = .systemGray2
        }
    }
    
    @objc
    private func trueButtonPressed() {
        if value == data?.temperatureFormatDescription {
            CoreDataManager.defaultManager.setSettings(speedFormat: nil, temperatureFormat: true, timeFormat: nil)
            trueButton.backgroundColor = .systemOrange
            falseButton.backgroundColor = .gray
        } else if value == data?.speedFormatDescription {
            CoreDataManager.defaultManager.setSettings(speedFormat: true, temperatureFormat: nil, timeFormat: nil)
            trueButton.backgroundColor = .systemOrange
            falseButton.backgroundColor = .gray
        } else if value == data?.timeFormatDescription {
            CoreDataManager.defaultManager.setSettings(speedFormat: nil, temperatureFormat: nil, timeFormat: true)
            trueButton.backgroundColor = .systemOrange
            falseButton.backgroundColor = .gray
        }
    }
    
    @objc
    private func falseButtonPressed() {
        if value == data?.temperatureFormatDescription {
            CoreDataManager.defaultManager.setSettings(speedFormat: nil, temperatureFormat: false, timeFormat: nil)
            falseButton.backgroundColor = .systemOrange
            trueButton.backgroundColor = .gray
        } else if value == data?.speedFormatDescription {
            CoreDataManager.defaultManager.setSettings(speedFormat: false, temperatureFormat: nil, timeFormat: nil)
            falseButton.backgroundColor = .systemOrange
            trueButton.backgroundColor = .gray
        } else if value == data?.timeFormatDescription {
            CoreDataManager.defaultManager.setSettings(speedFormat: nil, temperatureFormat: nil, timeFormat: false)
            falseButton.backgroundColor = .systemOrange
            trueButton.backgroundColor = .gray
        }
    }
    
}
