//
//  MainView.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 18.04.2023.
//

import UIKit

class MainView: UIView {
    
    var data: DataByDay?
    
    private let airTemperatureLabel: UILabel = {
        let authors = UILabel()
        authors.font = UIFont.boldSystemFont(ofSize: 20)
        authors.textColor = .black
        authors.numberOfLines = 2
        authors.translatesAutoresizingMaskIntoConstraints = false
        return authors
    }()
    
    private let windSpeedLabel: UILabel = {
        let descriptions = UILabel()
        descriptions.font = UIFont.systemFont(ofSize: 14)
        descriptions.textColor = .systemGray
        descriptions.numberOfLines = 0
        descriptions.translatesAutoresizingMaskIntoConstraints = false
        return descriptions
    }()
    
    private let relativeHumidityLabel: UILabel = {
        let likes = UILabel()
        likes.font = UIFont.systemFont(ofSize: 16)
        likes.textColor = .black
        likes.translatesAutoresizingMaskIntoConstraints = false
        return likes
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setup()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBlue
        addSubview(airTemperatureLabel)
        addSubview(windSpeedLabel)
        addSubview(relativeHumidityLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        airTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(snp.centerX)
        }
        windSpeedLabel.snp.makeConstraints { make in
            make.top.equalTo(airTemperatureLabel.snp.bottom).offset(20)
            make.centerX.equalTo(snp.centerX)
        }
        relativeHumidityLabel.snp.makeConstraints { make in
            make.top.equalTo(windSpeedLabel.snp.bottom).offset(20)
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(-20)
        }
    }
    
    func setup() {
        if let data {
            airTemperatureLabel.text = "\(data.airTemperature)"
            windSpeedLabel.text = "\(data.windSpeed)"
            relativeHumidityLabel.text = "\(data.relativeHumidity)"
        }
    }
    
}
