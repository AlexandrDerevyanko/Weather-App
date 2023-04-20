//
//  DaytimeWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 18.04.2023.
//

import UIKit

class DaytimeWeatherTableViewCell: UITableViewCell {
    
    var data: DataByDay?
    
    private let image: UIImageView = {
        let images = UIImageView()
        images.contentMode = .scaleAspectFit
        images.translatesAutoresizingMaskIntoConstraints = false
        return images
    }()
    
    private let dateLabel: UILabel = {
        let authors = UILabel()
        authors.font = UIFont.boldSystemFont(ofSize: 20)
        authors.textColor = .black
        authors.numberOfLines = 2
        authors.translatesAutoresizingMaskIntoConstraints = false
        return authors
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptions = UILabel()
        descriptions.font = UIFont.systemFont(ofSize: 14)
        descriptions.textColor = .systemGray
        descriptions.numberOfLines = 0
        descriptions.translatesAutoresizingMaskIntoConstraints = false
        return descriptions
    }()
    
    private let percentLabel: UILabel = {
        let likes = UILabel()
        likes.font = UIFont.systemFont(ofSize: 16)
        likes.textColor = .black
        likes.translatesAutoresizingMaskIntoConstraints = false
        return likes
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(descriptionLabel)
        addSubview(dateLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
        }
    }
    
    func setup () {
        if data != nil {
            descriptionLabel.text = "\(data!.airTemperature)"
            dateLabel.text = "\(String(describing: data!.date))"
        }
    }
    
}
