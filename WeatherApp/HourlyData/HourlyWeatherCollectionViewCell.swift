//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 24.04.2023.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    var data: HourlyWeather?
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let airTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5.withAlphaComponent(0.6)
        layer.cornerRadius = 15
        clipsToBounds = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        dateLabel.text = nil
        weatherImage.image = nil
        airTemperatureLabel.text = nil
    }
    
    private func setupUI() {
        addSubview(dateLabel)
        addSubview(weatherImage)
        addSubview(airTemperatureLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.centerX.equalTo(snp.centerX)
        }
        weatherImage.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(6)
            make.bottom.equalTo(airTemperatureLabel.snp.top).offset(-6)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(32)
            make.height.equalTo(32)
        }
        airTemperatureLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-10)
            make.centerX.equalTo(snp.centerX)
        }
    }
    
    func setup() {
        if let data {
            let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                if timeFormat == false {
                    formatter.locale = .init(identifier: "ru_RU")
                }
                formatter.dateStyle = .none
                formatter.timeStyle = .short
                return formatter
            }()
            dateLabel.text = "\(dateFormatter.string(from: data.date ?? Date()))"
            DownloadManager.defaultManager.downloadImageData(urlString: data.imageURL) { data in
                guard let data else { return }
                DispatchQueue.main.async {
                    self.weatherImage.image = UIImage(data: data)
                }
            }
            if temperatureFormat {
                airTemperatureLabel.text = "\(Int(data.tempF))°F"
            } else {
                airTemperatureLabel.text = "\(Int(data.tempC))°C"
            }
            
        }
        
    }
    
}
