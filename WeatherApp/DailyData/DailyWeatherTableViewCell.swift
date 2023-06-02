
import UIKit

class DailyWeatherTableViewCell: UITableViewCell {
    
    var data: DailyWeather?
    
    private let image: UIImageView = {
        let images = UIImageView()
        images.contentMode = .scaleAspectFit
        images.translatesAutoresizingMaskIntoConstraints = false
        return images
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black.withAlphaComponent(0.8)
        label.numberOfLines = 2
        label.textAlignment = .center
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
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let minMaxAirTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        backgroundColor = .systemGray5.withAlphaComponent(0.6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        dateLabel.text = nil
        descriptionLabel.text = nil
        dailyChanceOfRainLabel.text = nil
        minMaxAirTemperatureLabel.text = nil
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
            make.width.equalTo(120)
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
                if timeFormat == false {
                    formatter.locale = .init(identifier: "ru_RU")
                } else {
                    formatter.locale = .init(identifier: "en_US")
                }
                formatter.dateStyle = .short
                formatter.timeStyle = .none
                return formatter
            }()
            dateLabel.text = "\(dateFormatter.string(from: data.date ?? Date()))"
            descriptionLabel.text = "\(String(describing: data.text ?? ""))"
            dailyChanceOfRainLabel.text = "\(Int(data.dailyChanceOfRain))%"
            if temperatureFormat {
                minMaxAirTemperatureLabel.text = "\(Int(data.minTempF))°F / \(Int(data.maxTempF))°F"
            } else {
                minMaxAirTemperatureLabel.text = "\(Int(data.minTempC))°C / \(Int(data.maxTempC))°C"
            }
            
        }
    }
    
}
