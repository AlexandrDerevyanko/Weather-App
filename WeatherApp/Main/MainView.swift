//
//  MainView.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 18.04.2023.
//

import UIKit

class MainView: UIView {
    
    var data: CurrentData?
    
    private let minMaxAirTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let airTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let firstStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let uvIndexImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "uv")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let uvIndexLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let windSpeedImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "wind")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let thirdStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sunriseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sunsetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBlue
        addSubview(minMaxAirTemperatureLabel)
        addSubview(airTemperatureLabel)
        addSubview(textLabel)
        addSubview(weatherImage)
        addSubview(firstStackView)
        firstStackView.addArrangedSubview(uvIndexImage)
        firstStackView.addArrangedSubview(uvIndexLabel)
        addSubview(secondStackView)
        secondStackView.addArrangedSubview(windSpeedImage)
        secondStackView.addArrangedSubview(windSpeedLabel)
        addSubview(thirdStackView)
        thirdStackView.addArrangedSubview(dailyChanceOfRainImage)
        thirdStackView.addArrangedSubview(dailyChanceOfRainLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(firstStackView)
        stackView.addArrangedSubview(secondStackView)
        stackView.addArrangedSubview(thirdStackView)
        addSubview(dateLabel)
        addSubview(sunriseLabel)
        addSubview(sunsetLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        minMaxAirTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(snp.centerX)
        }
        airTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(minMaxAirTemperatureLabel.snp.bottom).offset(20)
            make.centerX.equalTo(snp.centerX)
        }
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(airTemperatureLabel.snp.bottom).offset(20)
            make.centerX.equalTo(snp.centerX)
        }
        weatherImage.snp.makeConstraints { make in
            make.left.equalTo(textLabel.snp.right).offset(10)
            make.centerY.equalTo(textLabel.snp.centerY)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(20)
            make.centerX.equalTo(snp.centerX)
        }
        windSpeedImage.snp.makeConstraints { make in
            make.width.equalTo(26)
            make.height.equalTo(26)
        }
        dailyChanceOfRainImage.snp.makeConstraints { make in
            make.width.equalTo(26)
            make.height.equalTo(26)
        }
        uvIndexImage.snp.makeConstraints { make in
            make.width.equalTo(26)
            make.height.equalTo(26)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(-20)
        }
        sunriseLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.bottom.equalTo(-20)
        }
        sunsetLabel.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.bottom.equalTo(-20)
        }
    }
    
    func setup() {
        if let data {
            let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.locale = .init(identifier: "ru_RU")
                formatter.dateStyle = .full
                formatter.timeStyle = .short
                return formatter
            }()
//            let timeDateFormatter: DateFormatter = {
//                let formatter = DateFormatter()
//                formatter.locale = .init(identifier: "ru_RU")
//                formatter.dateStyle = .none
//                formatter.timeStyle = .short
//                return formatter
//            }()
            minMaxAirTemperatureLabel.text = "\(data.minTempC) / \(data.maxTempC)"
            airTemperatureLabel.text = "\(data.tempC)°"
            textLabel.text = "\(String(describing: data.text ?? ""))"
            DownloadManager.defaultManager.downloadImageData(urlString: data.imageURL) { data in
                guard let data else { return }
                DispatchQueue.main.async {
                    self.weatherImage.image = UIImage(data: data)
                }
            }
            
            
            uvIndexLabel.text = "\(data.uv)"
            windSpeedLabel.text = "\(Int(data.windMps))"
            dailyChanceOfRainLabel.text = "\(data.dailyChanceOfRain)%"
            dateLabel.text = "\(dateFormatter.string(from: data.date ?? Date()))"
            dateFormatter.dateStyle = .none
            sunriseLabel.text = "\(dateFormatter.string(from: data.sunrise ?? Date()))"
            sunsetLabel.text = "\(dateFormatter.string(from: data.sunset ?? Date()))"
        }
    }
    
}
