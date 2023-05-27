//
//  SettingsTableViewCell.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 26.04.2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    var title: String?
    var value: [String]?
    var boolean: Bool?
    
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
        label.textColor = .black.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let falseButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let trueButton: UIButton = {
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
        backgroundColor = .clear
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(falseButton)
        stackView.addArrangedSubview(trueButton)
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
    }
    
    private func addtargets() {
        trueButton.addTarget(self, action: #selector(trueButtonPressed), for: .touchUpInside)
        falseButton.addTarget(self, action: #selector(falseButtonPressed), for: .touchUpInside)
    }
    
    func setup () {
        if let title, let value, let boolean {
            descriptionLabel.text = title
            falseButton.setTitle(value[0], for: .normal)
            trueButton.setTitle(value[1], for: .normal)
            if boolean {
                trueButton.backgroundColor = standardBackgroundColor
                falseButton.backgroundColor = .systemGray2.withAlphaComponent(0.8)
            } else {
                falseButton.backgroundColor = standardBackgroundColor
                trueButton.backgroundColor = .systemGray2.withAlphaComponent(0.8)
            }
        }
    }
    
    @objc
    private func falseButtonPressed() {
        if let title {
            if title == "Temperature" {
                UserDefaults.standard.set(false, forKey: title)
                trueButton.backgroundColor = .systemGray2.withAlphaComponent(0.8)
                falseButton.backgroundColor = standardBackgroundColor
                NotificationCenter.default.post(name: MainViewController.notificationName, object: nil)
            } else if title == "Time format" {
                UserDefaults.standard.set(false, forKey: title)
                UserDefaults.standard.synchronize()
                trueButton.backgroundColor = .systemGray2.withAlphaComponent(0.8)
                falseButton.backgroundColor = standardBackgroundColor
                NotificationCenter.default.post(name: MainViewController.notificationName, object: nil)
            }
        }
    }
    
    @objc
    private func trueButtonPressed() {
        if let title {
            if title == "Temperature" {
                UserDefaults.standard.set(true, forKey: title)
                UserDefaults.standard.synchronize()
                trueButton.backgroundColor = standardBackgroundColor
                falseButton.backgroundColor = .systemGray2.withAlphaComponent(0.8)
                NotificationCenter.default.post(name: MainViewController.notificationName, object: nil)
            } else if title == "Time format" {
                UserDefaults.standard.set(true, forKey: title)
                trueButton.backgroundColor = standardBackgroundColor
                falseButton.backgroundColor = .systemGray2.withAlphaComponent(0.8)
                NotificationCenter.default.post(name: MainViewController.notificationName, object: nil)
            }
        }
    }
    
}
