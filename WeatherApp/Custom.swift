//
//  Custom.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 12.04.2023.
//

import Foundation
import UIKit
import CoreData

var temperatureFormat: Bool {
    return UserDefaults.standard.bool(forKey: "Temperature")
}
var timeFormat: Bool {
    return UserDefaults.standard.bool(forKey: "Time format")
}

var standardBackgroundColor: UIColor = UIColor(patternImage: UIImage(named: "background") ?? UIImage())

final class CustomButton: UIButton {
    typealias Action = () -> Void
    
    var buttonAction: Action
    var filled = UIButton.Configuration.filled()
    var container = AttributeContainer()
    
    override var isHighlighted: Bool {
        didSet {
            if (isHighlighted) {
                alpha = 0.8
            } else {
                alpha = 1
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if (isSelected) {
                alpha = 0.8
            } else {
                alpha = 1
            }
        }
    }
    
    init(title: String, titleColor: UIColor = .black, bgColor: UIColor, hidden: Bool = false, fontSize: Int = 16, alignment: UIButton.Configuration.TitleAlignment = .center, action: @escaping Action) {
        buttonAction = action
        container.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        container.foregroundColor = titleColor
        filled.attributedTitle = AttributedString("\(title)", attributes: container)
        filled.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
//        filled.title = title
        filled.background.backgroundColor = bgColor
        filled.background.cornerRadius = 12
        filled.titleAlignment = alignment
        super.init(frame: .zero)
        isHidden = hidden
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        configuration = filled
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func buttonTapped() {
        buttonAction()
    }
}

//var dataByDayFetchResultsController: NSFetchedResultsController<DataByDay>?
//var dataByHourFetchResultsController: NSFetchedResultsController<DataByHour>?
//var currentDataFetchResultsController: NSFetchedResultsController<CurrentData>?
//var locationFetchResultsController: NSFetchedResultsController<CurrentLocation>?
//
//func initFetchResultsController() {
//    let firstFetchRequest = DataByDay.fetchRequest()
//    let secondFetchRequest = DataByHour.fetchRequest()
//    let thirdFetchRequest = CurrentData.fetchRequest()
//
//    firstFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
//    secondFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
//    thirdFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
//
////    if location != nil {
////        print(12345)
////        firstFetchRequest.predicate = NSPredicate(format: "location == %@", location!)
////        secondFetchRequest.predicate = NSPredicate(format: "location == %@", location!)
////        thirdFetchRequest.predicate = NSPredicate(format: "location == %@", location!)
////    }
//
//    dataByDayFetchResultsController = NSFetchedResultsController(fetchRequest: firstFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
////    dataByDayFetchResultsController?.delegate = self
//    try? dataByDayFetchResultsController?.performFetch()
//
//    dataByHourFetchResultsController = NSFetchedResultsController(fetchRequest: secondFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
////    dataByHourFetchResultsController?.delegate = self
//    try? dataByHourFetchResultsController?.performFetch()
//
//    currentDataFetchResultsController = NSFetchedResultsController(fetchRequest: thirdFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
////    currentDataFetchResultsController?.delegate = self
//    try? currentDataFetchResultsController?.performFetch()
//}
