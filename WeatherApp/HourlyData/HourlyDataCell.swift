//
//  HourlyDataCell.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 02.05.2023.
//

import UIKit

class HourlyDataTableViewCell: UITableViewCell {
    
    var data: DataByHour?
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let airTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let image: UIImageView = {
        let images = UIImageView()
        images.contentMode = .scaleAspectFit
        images.translatesAutoresizingMaskIntoConstraints = false
        return images
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let windSpeedImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "wind")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let windSpeedTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Wind speed"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let windSpeedValueLabel: UILabel = {
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
    
    private let dailyChanceOfRainTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Daily chance of rain"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dailyChanceOfRainValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let uvImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "uv")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let uvTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "UV index"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let uvValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
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
        addSubview(airTemperatureLabel)
        addSubview(image)
        addSubview(descriptionLabel)
        addSubview(windSpeedImage)
        addSubview(windSpeedTextLabel)
        addSubview(windSpeedValueLabel)
        addSubview(dailyChanceOfRainImage)
        addSubview(dailyChanceOfRainTextLabel)
        addSubview(dailyChanceOfRainValueLabel)
        addSubview(uvImage)
        addSubview(uvTextLabel)
        addSubview(uvValueLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(16)
        }
        airTemperatureLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
        }
        image.snp.makeConstraints { make in
            make.right.equalTo(descriptionLabel.snp.left).offset(-6)
            make.centerY.equalTo(descriptionLabel.snp.centerY)
            make.width.equalTo(26)
            make.height.equalTo(26)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.centerX.equalTo(snp.centerX)
        }
        windSpeedImage.snp.makeConstraints { make in
            make.right.equalTo(windSpeedTextLabel.snp.left).offset(-6)
            make.centerY.equalTo(windSpeedTextLabel.snp.centerY)
            make.width.equalTo(26)
            make.height.equalTo(26)
        }
        windSpeedTextLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.centerX.equalTo(snp.centerX)
        }
        windSpeedValueLabel.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalTo(windSpeedTextLabel.snp.centerY)
        }
        dailyChanceOfRainImage.snp.makeConstraints { make in
            make.right.equalTo(dailyChanceOfRainTextLabel.snp.left).offset(-6)
            make.centerY.equalTo(dailyChanceOfRainTextLabel.snp.centerY)
            make.width.equalTo(26)
            make.height.equalTo(26)
        }
        dailyChanceOfRainTextLabel.snp.makeConstraints { make in
            make.top.equalTo(windSpeedTextLabel.snp.bottom).offset(10)
            make.centerX.equalTo(snp.centerX)
        }
        dailyChanceOfRainValueLabel.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalTo(dailyChanceOfRainTextLabel.snp.centerY)
        }
        uvImage.snp.makeConstraints { make in
            make.right.equalTo(uvTextLabel.snp.left).offset(-6)
            make.centerY.equalTo(uvTextLabel.snp.centerY)
            make.width.equalTo(26)
            make.height.equalTo(26)
        }
        uvTextLabel.snp.makeConstraints { make in
            make.top.equalTo(dailyChanceOfRainTextLabel.snp.bottom).offset(10)
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(snp.bottom).offset(-16)
        }
        uvValueLabel.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalTo(uvTextLabel.snp.centerY)
        }
    }
    
    func setup () {
        if let data {
            let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.locale = .init(identifier: "ru_RU")
                formatter.dateStyle = .none
                formatter.timeStyle = .short
                return formatter
            }()
            dateLabel.text = "\(dateFormatter.string(from: data.date ?? Date()))"
            airTemperatureLabel.text = "\(data.tempC)"
            DownloadManager.defaultManager.downloadImageData(urlString: data.imageURL) { data in
                guard let data else { return }
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data)
                }
            }
            descriptionLabel.text = "\(String(describing: data.text ?? ""))"
            windSpeedValueLabel.text = "\(data.windKph) Kph"
            dailyChanceOfRainValueLabel.text = "\(data.chanceOfRain)%"
            uvValueLabel.text = "\(data.uv)"
        }
    }
    
}
