//
//  CollectionTableViewCell.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 24.04.2023.
//

import UIKit
import CoreData

class CollectionTableViewCell: UITableViewCell, NSFetchedResultsControllerDelegate {
    
    var dataByHour: [DataByHour]?
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 120)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 15
        collectionView.layer.masksToBounds = true
        collectionView.backgroundColor = .systemGray5
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var dataByHourFetchResultsController: NSFetchedResultsController<DataByHour>?
    
    func initFetchResultsController() {
        let secondFetchRequest = DataByHour.fetchRequest()
        secondFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        dataByHourFetchResultsController = NSFetchedResultsController(fetchRequest: secondFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        dataByHourFetchResultsController?.delegate = self
        try? dataByHourFetchResultsController?.performFetch()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        initFetchResultsController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(collectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.top.equalTo(snp.top)
            make.bottom.equalTo(snp.bottom)
        }
    }
    
}

extension CollectionTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        initFetchResultsController()
        cell.data = dataByHourFetchResultsController?.fetchedObjects?[indexPath.row]
        cell.setup()
        cell.layer.cornerRadius = 28
        return cell
    }
    
    private enum Constants {
        static let numberOfItemsInLIne: CGFloat = 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let interItemSpacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0

        let width = collectionView.frame.width - (Constants.numberOfItemsInLIne - 1) * interItemSpacing - insets.left - insets.right

        let itemWidth = floor(width / Constants.numberOfItemsInLIne)

        return CGSize(width: itemWidth, height: collectionView.frame.height - interItemSpacing)
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        return 8
//
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
}
