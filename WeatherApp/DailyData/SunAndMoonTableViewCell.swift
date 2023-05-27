//
//  SunAndMoonTableViewCell.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 03.05.2023.
//

import UIKit

class SunAndMoonTableViewCell: UITableViewCell {
    
    var data: DailyWeather?
    
    private let pointView: UIView = {
        let point = UIView()
        point.backgroundColor = .lightGray
        point.translatesAutoresizingMaskIntoConstraints = false
        return point
    }()
    
    private let sunAndMoonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Sun and Moon"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moonPhaseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sunImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "sun")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let sunriseTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black.withAlphaComponent(0.8)
        label.text = "Sunrise"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sunriseValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sunsetTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black.withAlphaComponent(0.8)
        label.text = "Sunset"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sunsetValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moonImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "moon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let moonriseTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black.withAlphaComponent(0.8)
        label.text = "Moonrise"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moonriseValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moonsetTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black.withAlphaComponent(0.8)
        label.text = "Moonset"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moonsetValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black.withAlphaComponent(0.8)
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
    
    override func prepareForReuse() {
        sunAndMoonLabel.text = nil
        moonPhaseLabel.text = nil
        sunriseTextLabel.text = nil
        sunriseValueLabel.text = nil
        sunsetTextLabel.text = nil
        sunsetValueLabel.text = nil
        moonriseTextLabel.text = nil
        moonriseValueLabel.text = nil
        moonsetTextLabel.text = nil
        moonsetValueLabel.text = nil
    }
    
    private func setupUI() {
        backgroundColor = .systemGray5.withAlphaComponent(0.6)
        addSubview(pointView)
        addSubview(sunAndMoonLabel)
        addSubview(moonPhaseLabel)
        addSubview(sunImage)
        addSubview(sunriseTextLabel)
        addSubview(sunriseValueLabel)
        addSubview(sunsetTextLabel)
        addSubview(sunsetValueLabel)
        addSubview(moonImage)
        addSubview(moonriseTextLabel)
        addSubview(moonriseValueLabel)
        addSubview(moonsetTextLabel)
        addSubview(moonsetValueLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        pointView.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(1)
            make.height.equalTo(100)
        }
        sunAndMoonLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(10)
        }
        moonPhaseLabel.snp.makeConstraints { make in
            make.right.equalTo(-6)
            make.centerY.equalTo(sunAndMoonLabel.snp.centerY)
        }
        sunImage.snp.makeConstraints { make in
            make.top.equalTo(sunAndMoonLabel.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.width.equalTo(26)
            make.height.equalTo(26)
        }
        sunriseTextLabel.snp.makeConstraints { make in
            make.top.equalTo(sunImage.snp.bottom).offset(10)
            make.left.equalTo(16)
        }
        sunriseValueLabel.snp.makeConstraints { make in
            make.top.equalTo(sunImage.snp.bottom).offset(10)
            make.right.equalTo(pointView.snp.left).offset(-16)
        }
        sunsetTextLabel.snp.makeConstraints { make in
            make.top.equalTo(sunriseTextLabel.snp.bottom).offset(10)
            make.left.equalTo(16)
        }
        sunsetValueLabel.snp.makeConstraints { make in
            make.top.equalTo(sunriseValueLabel.snp.bottom).offset(10)
            make.right.equalTo(pointView.snp.left).offset(-16)
        }
        moonImage.snp.makeConstraints { make in
            make.top.equalTo(sunAndMoonLabel.snp.bottom).offset(16)
            make.left.equalTo(pointView.snp.right).offset(16)
            make.width.equalTo(26)
            make.height.equalTo(26)
        }
        moonriseTextLabel.snp.makeConstraints { make in
            make.top.equalTo(moonImage.snp.bottom).offset(10)
            make.left.equalTo(pointView.snp.right).offset(16)
        }
        moonriseValueLabel.snp.makeConstraints { make in
            make.top.equalTo(moonImage.snp.bottom).offset(10)
            make.right.equalTo(-16)
        }
        moonsetTextLabel.snp.makeConstraints { make in
            make.top.equalTo(moonriseTextLabel.snp.bottom).offset(10)
            make.left.equalTo(pointView.snp.right).offset(16)
            make.bottom.equalTo(-16)
        }
        moonsetValueLabel.snp.makeConstraints { make in
            make.top.equalTo(moonriseValueLabel.snp.bottom).offset(10)
            make.right.equalTo(-16)
        }
    }
    
    func setup () {
        if let data {
            let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                if timeFormat == false {
                    formatter.locale = .init(identifier: "ru_RU")
                } else {
                    formatter.locale = .init(identifier: "en_US")
                }
                formatter.dateStyle = .none
                formatter.timeStyle = .short
                return formatter
            }()
            moonPhaseLabel.text = "\(String(describing: data.moonPhase ?? ""))"
            sunriseValueLabel.text = "\(dateFormatter.string(from: data.sunrise ?? Date()))"
            sunsetValueLabel.text = "\(dateFormatter.string(from: data.sunset ?? Date()))"
            moonriseValueLabel.text = "\(dateFormatter.string(from: data.moonrise ?? Date()))"
            moonsetValueLabel.text = "\(dateFormatter.string(from: data.moonset ?? Date()))"
        }
    }
    
}
