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
    
    // Получение массива данных о погоде
    var currentData: [CurrentData] {
        let fetchRequest = CurrentData.fetchRequest()
        return (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    
    // Добавление локации
    func addLocation(data: Weather) {
        persistentContainer.performBackgroundTask { contextBackground in
            let location = CurrentLocation(context: contextBackground)
            location.name = data.location?.name ?? ""
            
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
    }
    
    // Получение массива локаций
    var locationArray: [CurrentLocation] {
        let fetchRequest = CurrentLocation.fetchRequest()
        return (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    
    // Получение локации по названию
    func getLocation(name: String, context: NSManagedObjectContext) -> CurrentLocation? {
        let fetchRequest = CurrentLocation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        return (try? context.fetch(fetchRequest))?.first
    }
    
    // Получение сущности DataByDay по дате
    func getDataByDay(dateString: String, context: NSManagedObjectContext) -> DataByDay? {
        let fetchRequest = DataByDay.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dateString == %@", dateString)
        return (try? context.fetch(fetchRequest))?.first
    }
    
    func addData(data:Weather, completion: ((_ success: Bool) -> ())) {
        
//        deleteData()
        if locationArray.count != 0 {
            completion(true)
            return
        }
        
        addData2(data: data) { success in
            if success {
                completion(true)
            }
        }
//        persistentContainer.performBackgroundTask { contextBackground in
//            let location = CurrentLocation(context: contextBackground)
//            location.name = data.location?.name ?? ""
//
//            do {
//                try contextBackground.save()
//            } catch {
//                print(error)
//            }
//        }
//        persistentContainer.performBackgroundTask { contextBackground in
//            let currentData = CurrentData(context: contextBackground)
//            let dayData = data.forecast?.forecastday?[0].day
//            let dataCurrent = data.current
//            let lastUpdatedDate = dataCurrent?.lastUpdated ?? ""
//            let sunriseTime = data.forecast?.forecastday?[0].astro?.sunrise ?? ""
//            print(sunriseTime)
//            let sunsetTime = data.forecast?.forecastday?[0].astro?.sunset ?? ""
//            print(sunsetTime)
//            let dateFormatter = DateFormatter()
//            let timeDateFormatter = DateFormatter()
//            timeDateFormatter.dateFormat = "HH:mm a"
//            timeDateFormatter.timeZone = TimeZone(abbreviation: "GMT+00:00")
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//            currentData.tempC = dataCurrent?.tempC ?? 0
//            currentData.minTempC = dayData?.mintempC ?? 0
//            currentData.maxTempC = dayData?.maxtempC ?? 0
//            currentData.date = dateFormatter.date(from:lastUpdatedDate)
//            currentData.sunset = timeDateFormatter.date(from: sunsetTime)
//            currentData.sunrise = timeDateFormatter.date(from: sunriseTime)
//            currentData.text = dataCurrent?.condition?.text
//            currentData.dailyChanceOfRain = dayData?.dailyChanceOfRain ?? 0
//            currentData.uv = dayData?.uv ?? 0
//            currentData.windKph = dataCurrent?.windKph ?? 0
//            currentData.imageURL = dataCurrent?.condition?.icon
//            currentData.location = self.getLocation(name: data.location?.name ?? "", context: contextBackground)
//            let dataArray = data.forecast?.forecastday
//            if let dataArray {
//                for index in dataArray {
//
//                    let dataByDay = DataByDay(context: contextBackground)
//                    let dayData = index.day
//                    let isoDate = index.date ?? ""
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "yyyy-MM-dd"
//                    let timeDateFormatter = DateFormatter()
//                    timeDateFormatter.dateFormat = "HH:mm a"
//                    timeDateFormatter.timeZone = TimeZone(abbreviation: "GMT+00:00")
//                    dataByDay.maxTempC = dayData?.maxtempC ?? 0
//                    dataByDay.minTempC = dayData?.mintempC ?? 0
//                    dataByDay.date = dateFormatter.date(from:isoDate)
//                    dataByDay.dateString = isoDate
//                    dataByDay.dailyChanceOfRain = dayData?.dailyChanceOfRain ?? 0
//                    dataByDay.text = dayData?.condition?.text
//                    dataByDay.imageURL = dayData?.condition?.icon
//                    dataByDay.location = self.getLocation(name: data.location?.name ?? "", context: contextBackground)
//                    dataByDay.sunrise = timeDateFormatter.date(from: index.astro?.sunrise ?? "")
//                    dataByDay.sunset = timeDateFormatter.date(from: index.astro?.sunset ?? "")
//                    dataByDay.moonrise = timeDateFormatter.date(from: index.astro?.moonrise ?? "")
//                    dataByDay.moonset = timeDateFormatter.date(from: index.astro?.moonset ?? "")
//                    dataByDay.moonPhase = index.astro?.moonPhase
//                }
//            }
//
//            let hourlyDataArray = data.forecast?.forecastday
//            if let hourlyDataArray {
//                for i in hourlyDataArray {
//                    let date = i.date ?? ""
//                    let hourlyData = i.hour
//                    if let hourlyData {
//                        for index in hourlyData {
//                            let dataByHour = DataByHour(context: contextBackground)
//                            dataByHour.dataByDay = self.getDataByDay(dateString: date, context: contextBackground)
//                            let isoDate = index.time ?? ""
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//                            let date = dateFormatter.date(from:isoDate)
//                            dataByHour.date = date
//                            dataByHour.tempC = index.tempC ?? 0
//                            dataByHour.imageURL = index.condition?.icon
//                            dataByHour.chanceOfRain = index.chanceOfRain ?? 0
//                            dataByHour.text = index.condition?.text
//                            dataByHour.windMph = index.windMph ?? 0
//                            dataByHour.windKph = index.windKph ?? 0
//                            dataByHour.uv = index.uv ?? 0
//                            dataByHour.location = self.getLocation(name: data.location?.name ?? "", context: contextBackground)
//                        }
//                    }
//                }
//            }
//            do {
//                try contextBackground.save()
//            } catch {
//                print(error)
//            }
//        }
//        completion(true)
    }
    
    func addData2(data:Weather, completion: ((_ success: Bool) -> ())) {
        
        persistentContainer.performBackgroundTask { contextBackground in
            let location = CurrentLocation(context: contextBackground)
            location.name = data.location?.name ?? ""
            location.date = Date()
            
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
        persistentContainer.performBackgroundTask { contextBackground in
            let currentData = CurrentData(context: contextBackground)
            let dayData = data.forecast?.forecastday?[0].day
            let dataCurrent = data.current
            let lastUpdatedDate = dataCurrent?.lastUpdated ?? ""
            let sunriseTime = data.forecast?.forecastday?[0].astro?.sunrise ?? ""
            let sunsetTime = data.forecast?.forecastday?[0].astro?.sunset ?? ""
            let dateFormatter = DateFormatter()
            let timeDateFormatter = DateFormatter()
            timeDateFormatter.dateFormat = "HH:mm a"
            timeDateFormatter.timeZone = TimeZone(abbreviation: "GMT+00:00")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            currentData.tempC = dataCurrent?.tempC ?? 0
            currentData.minTempC = dayData?.mintempC ?? 0
            currentData.maxTempC = dayData?.maxtempC ?? 0
            currentData.date = dateFormatter.date(from:lastUpdatedDate)
            currentData.sunset = timeDateFormatter.date(from: sunsetTime)
            currentData.sunrise = timeDateFormatter.date(from: sunriseTime)
            currentData.text = dataCurrent?.condition?.text
            currentData.dailyChanceOfRain = dayData?.dailyChanceOfRain ?? 0
            currentData.uv = dayData?.uv ?? 0
            currentData.windMps = ((dataCurrent?.windKph ?? 0) / 3.6)
            currentData.imageURL = dataCurrent?.condition?.icon
            currentData.location = self.getLocation(name: data.location?.name ?? "", context: contextBackground)
            let dataArray = data.forecast?.forecastday
            if let dataArray {
                for index in dataArray {
                    
                    let dataByDay = DataByDay(context: contextBackground)
                    let dayData = index.day
                    let isoDate = index.date ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.calendar = Calendar(identifier: .gregorian)
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    let timeDateFormatter = DateFormatter()
                    timeDateFormatter.dateFormat = "HH:mm a"
                    timeDateFormatter.timeZone = TimeZone(abbreviation: "GMT+00:00")
                    dataByDay.maxTempC = dayData?.maxtempC ?? 0
                    dataByDay.minTempC = dayData?.mintempC ?? 0
                    dataByDay.date = dateFormatter.date(from:isoDate.components(separatedBy: " ").first ?? "")
                    dataByDay.dateString = isoDate
                    dataByDay.dailyChanceOfRain = dayData?.dailyChanceOfRain ?? 0
                    dataByDay.text = dayData?.condition?.text
                    dataByDay.imageURL = dayData?.condition?.icon
                    dataByDay.location = self.getLocation(name: data.location?.name ?? "", context: contextBackground)
                    dataByDay.sunrise = timeDateFormatter.date(from: index.astro?.sunrise ?? "")
                    dataByDay.sunset = timeDateFormatter.date(from: index.astro?.sunset ?? "")
                    dataByDay.moonrise = timeDateFormatter.date(from: index.astro?.moonrise ?? "")
                    dataByDay.moonset = timeDateFormatter.date(from: index.astro?.moonset ?? "")
                    dataByDay.moonPhase = index.astro?.moonPhase
                }
            }
            
            let hourlyDataArray = data.forecast?.forecastday
            if let hourlyDataArray {
                for i in hourlyDataArray {
                    let date = i.date ?? ""
                    let hourlyData = i.hour
                    if let hourlyData {
                        for index in hourlyData {
                            let dataByHour = DataByHour(context: contextBackground)
                            dataByHour.dataByDay = self.getDataByDay(dateString: date, context: contextBackground)
                            let isoDate = index.time ?? ""
//                            print(isoDate)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                            dateFormatter.calendar = Calendar(identifier: .gregorian)
                            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                            let date = dateFormatter.date(from:isoDate)
                            print(date)
                            dataByHour.date = date
                            dataByHour.tempC = index.tempC ?? 0
                            dataByHour.imageURL = index.condition?.icon
                            dataByHour.chanceOfRain = index.chanceOfRain ?? 0
                            dataByHour.text = index.condition?.text
                            dataByHour.windMph = index.windMph ?? 0
                            dataByHour.windKph = index.windKph ?? 0
                            dataByHour.uv = index.uv ?? 0
                            dataByHour.location = self.getLocation(name: data.location?.name ?? "", context: contextBackground)
                        }
                    }
                }
            }
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
        completion(true)
    }
    
    // Получение данных настроек
    var settingsData: [Settings] {
        let fetchRequest = Settings.fetchRequest()
        return (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    
    // Установка базовых настроек при первом запуске приложения
    func setFirstRunSettings() {
        if settingsData.isEmpty {
            persistentContainer.performBackgroundTask { contextBackground in
                let settings = Settings(context: contextBackground)
                settings.speedFormatDescription = "Wind speed"
                settings.temperatureFormatDescription = "Temperature"
                settings.timeFormatDescription = "Time format"
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
    
    // Установка новых настроек
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
    func deleteDataByHour() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "DataByHour")

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try persistentContainer.viewContext.execute(deleteRequest)
            try persistentContainer.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func deleteData() {
        let firstDeleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "DataByDay")
        let secondDeleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentData")
        let thirdDeleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "DataByHour")
        let fourthDeleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentLocation")

        let firstDeleteRequest = NSBatchDeleteRequest(fetchRequest: firstDeleteFetch)
        let secondDeleteRequest = NSBatchDeleteRequest(fetchRequest: secondDeleteFetch)
        let thirdDeleteRequest = NSBatchDeleteRequest(fetchRequest: thirdDeleteFetch)
        let fourthDeleteRequest = NSBatchDeleteRequest(fetchRequest: fourthDeleteFetch)

        do {
            try persistentContainer.viewContext.execute(firstDeleteRequest)
            try persistentContainer.viewContext.execute(secondDeleteRequest)
            try persistentContainer.viewContext.execute(thirdDeleteRequest)
            try persistentContainer.viewContext.execute(fourthDeleteRequest)
            try persistentContainer.viewContext.save()
        } catch {
            print(error)
        }
    }
}
