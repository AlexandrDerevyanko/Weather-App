//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 11.04.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let defaultManager = CoreDataManager()
    
    init() {
        reloadDataToday()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    
    // Добавление данных о погоде
    
    var dataToday: [DataToday] = []
    func reloadDataToday() {
        let fetchRequest = DataToday.fetchRequest()
        dataToday = (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    var dataByDay: [DataByDay] {
        let fetchRequest = DataByDay.fetchRequest()
        return (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    
    func checkData(data: Weather, completion: ((_ success: Bool) -> ())) {
        print(1234)
        var dataArray: [Timesery] = []
        let totalWeatherData = data.properties!.timeseries!
        for i in totalWeatherData {
            dataArray.append(i)
        }
        if dataByDay.isEmpty {
            for i in dataArray {
                persistentContainer.performBackgroundTask { contextBackground in
                    let dataByDay = DataByDay(context: contextBackground)
                    let weatherData = i.data?.instant?.details
                    dataByDay.airTemperature = weatherData?["air_temperature"] ?? 0
                    dataByDay.windSpeed = weatherData?["wind_speed"] ?? 0
                    dataByDay.relativeHumidity = weatherData?["relative_humidity"] ?? 0
                    dataByDay.dateCreated = Date()
                    
                    let isoDate = i.time!
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date = dateFormatter.date(from:isoDate)!
                    print(date)
                    dataByDay.date = date
                    do {
                        try dataByDay.managedObjectContext?.save()
                    } catch {
                        print(error)
                    }
                }
            }
        } else {
            for (index, element) in dataArray.enumerated() {
                let weatherData = element.data?.instant?.details
                self.dataByDay[index].airTemperature = weatherData?["air_temperature"] ?? 0
                self.dataByDay[index].windSpeed = weatherData?["wind_speed"] ?? 0
                self.dataByDay[index].relativeHumidity = weatherData?["relative_humidity"] ?? 0
                self.dataByDay[index].dateCreated = Date()
                let isoDate = element.time!
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.date(from:isoDate)!
                print(date)
                self.dataByDay[index].date = date
                do {
                    try dataByDay[index].managedObjectContext?.save()
                } catch {
                    print(error)
                }
            }
        }
        completion(true)
    }
    
}
