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
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dailyChanceOfRainImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "rain")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let dailyChanceOfRainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let minMaxAirTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(dateLabel)
        addSubview(descriptionLabel)
        addSubview(dailyChanceOfRainImage)
        addSubview(dailyChanceOfRainLabel)
        addSubview(minMaxAirTemperatureLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(16)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
        }
        dailyChanceOfRainImage.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.bottom.equalTo(-16)
            make.width.equalTo(26)
            make.height.equalTo(26)
        }
        dailyChanceOfRainLabel.snp.makeConstraints { make in
            make.left.equalTo(dailyChanceOfRainImage.snp.right).offset(16)
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.bottom.equalTo(-16)
        }
        minMaxAirTemperatureLabel.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.right.equalTo(-40)
        }
    }
    
    func setup () {
        if let data {
            let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.locale = .init(identifier: "ru_RU")
                formatter.dateStyle = .short
                formatter.timeStyle = .none
                return formatter
            }()
            dateLabel.text = "\(dateFormatter.string(from: data.date ?? Date()))"
            descriptionLabel.text = "\(String(describing: data.text ?? ""))"
            dailyChanceOfRainLabel.text = "\(data.dailyChanceOfRain)%"
            minMaxAirTemperatureLabel.text = "\(data.minTempC) / \(data.maxTempC)"
        }
    }
    
}
