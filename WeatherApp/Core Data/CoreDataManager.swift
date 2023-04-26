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
        setFirstRunSettings()
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
    
    // Добавление данных о погоде

    var currentData: [CurrentData] {
        let fetchRequest = CurrentData.fetchRequest()
        return (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    
    func dataUpload(data: Weather, completion: ((_ success: Bool) -> ())) {
        deleteData()
        persistentContainer.performBackgroundTask { contextBackground in
            let currentData = CurrentData(context: contextBackground)
            let dayData = data.forecast?.forecastday?[0].day
            let dataCurrent = data.current
            let isoDate = data.current?.lastUpdated ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let date = dateFormatter.date(from:isoDate)
            currentData.tempC = dataCurrent?.tempC ?? 0
            currentData.minTempC = dayData?.mintempC ?? 0
            currentData.maxTempC = dayData?.maxtempC ?? 0
            currentData.date = date
            currentData.text = dataCurrent?.condition?.text
            currentData.dailyChanceOfRain = dayData?.dailyChanceOfRain ?? 0
            currentData.uv = dayData?.uv ?? 0
            currentData.windKph = dataCurrent?.windKph ?? 0
            currentData.location = "\(data.location?.name ?? "")"
            currentData.imageURL = dataCurrent?.condition?.icon
            
            do {
                try currentData.managedObjectContext?.save()
            } catch {
                print(error)
            }
        }
        let dataArray = data.forecast?.forecastday
        if let dataArray {
            for index in dataArray {
                persistentContainer.performBackgroundTask { contextBackground in
                    let dataByDay = DataByDay(context: contextBackground)
                    let dayData = index.day
                    let isoDate = index.date ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let date = dateFormatter.date(from:isoDate)
                    dataByDay.maxTempC = dayData?.maxtempC ?? 0
                    dataByDay.minTempC = dayData?.mintempC ?? 0
                    dataByDay.date = date
                    dataByDay.dailyChanceOfRain = dayData?.dailyChanceOfRain ?? 0
                    dataByDay.text = dayData?.condition?.text
                    dataByDay.imageURL = dayData?.condition?.icon
                    do {
                        try dataByDay.managedObjectContext?.save()
                    } catch {
                        print(error)
                    }
                }
            }
            let dataByHourArray = data.forecast?.forecastday?[0].hour
            if let dataByHourArray {
                for i in dataByHourArray {
                    persistentContainer.performBackgroundTask { contextBackground in
                        let dataByHour = DataByHour(context: contextBackground)
                        let isoDate = i.time ?? ""
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        let date = dateFormatter.date(from:isoDate)
                        dataByHour.date = date
                        dataByHour.tempC = i.tempC ?? 0
                        dataByHour.imageURL = i.condition?.icon
                        do {
                            try dataByHour.managedObjectContext?.save()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
        completion(true)
    }
    
    // Установка настроек
    
    var settingsData: [Settings] {
        let fetchRequest = Settings.fetchRequest()
        return (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    func setFirstRunSettings() {
        if settingsData.isEmpty {
            persistentContainer.performBackgroundTask { contextBackground in
                let settings = Settings(context: contextBackground)
                settings.speedFormat = true
                settings.temperatureFormat = true
                settings.timeFormat = true
                do {
                    try settings.managedObjectContext?.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func setSettings(speedFormat: Bool?, temperatureFormat: Bool?, timeFormat: Bool?) {
        if settingsData.isEmpty {
            setFirstRunSettings()
        } else {
            let settings = settingsData[0]
            if let speedFormat {
                settings.speedFormat = speedFormat
            }
            if let temperatureFormat {
                settings.temperatureFormat = temperatureFormat
            }
            if let timeFormat {
                settings.timeFormat = timeFormat
            }
            do {
                try settings.managedObjectContext?.save()
            } catch {
                print(error)
            }
        }
    }
    
    // Удаление данных
    
    func deleteData() {
        let firstDeleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "DataByDay")
        let secondDeleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentData")
        let thirdDeleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "DataByHour")

        let firstDeleteRequest = NSBatchDeleteRequest(fetchRequest: firstDeleteFetch)
        let secondDeleteRequest = NSBatchDeleteRequest(fetchRequest: secondDeleteFetch)
        let thirdDeleteRequest = NSBatchDeleteRequest(fetchRequest: thirdDeleteFetch)

        do {
            try persistentContainer.viewContext.execute(firstDeleteRequest)
            try persistentContainer.viewContext.execute(secondDeleteRequest)
            try persistentContainer.viewContext.execute(thirdDeleteRequest)
            try persistentContainer.viewContext.save()
        } catch {
            print(error)
        }
    }
    
}
