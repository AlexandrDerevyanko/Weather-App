
import UIKit

class LocationsTableViewCell: UITableViewCell {
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
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
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    func setup(cityLabelText: String) {
        cityLabel.text = cityLabelText
    }
    
}
