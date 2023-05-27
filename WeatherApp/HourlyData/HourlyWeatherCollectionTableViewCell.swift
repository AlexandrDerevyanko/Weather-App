//
//  CollectionTableViewCell.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 24.04.2023.
//

import UIKit
import CoreData

class HourlyWeatherCollectionTableViewCell: UITableViewCell, NSFetchedResultsControllerDelegate {
    
    var dataByHour: [HourlyWeather]?
    var dataByDay: DailyWeather?
    var viewController: UIViewController?
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HourlyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.masksToBounds = true
        collectionView.backgroundColor = standardBackgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        collectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: MainViewController.notificationName, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(collectionView)
        setupConstraints()
        collectionView.reloadData()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.top.equalTo(snp.top)
            make.bottom.equalTo(snp.bottom)
        }
    }
    
    @objc private func reloadData() {
        collectionView.reloadData()
    }
    
}

extension HourlyWeatherCollectionTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private enum Constants {
        static var numberOfItemsInLIne: CGFloat {
//            if timeFormat {
//                return 5
//            } else {
//                return 6
//            }
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let interItemSpacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0

        let width = collectionView.frame.width - (Constants.numberOfItemsInLIne - 1) * interItemSpacing - insets.left - insets.right

        let itemWidth = floor(width / Constants.numberOfItemsInLIne)

        return CGSize(width: itemWidth, height: collectionView.frame.height - interItemSpacing)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? HourlyWeatherCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }

        cell.data = dataByHour?[indexPath.row]
        cell.setup()
        cell.layer.cornerRadius = 28
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hourlyDataVC = HourlyWeatherViewController()
        hourlyDataVC.data = dataByHour
        self.viewController?.navigationController?.pushViewController(hourlyDataVC, animated: true)
        
    }
    
}
