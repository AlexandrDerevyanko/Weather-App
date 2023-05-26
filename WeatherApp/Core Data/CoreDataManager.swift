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
    
//    // Получение массива локаций
//    var locationArray: [City] {
//        let fetchRequest = City.fetchRequest()
//        return (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
//    }
    
    // Получение локации по названию
    func getLocation(name: String, context: NSManagedObjectContext) -> City? {
        let fetchRequest = City.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        return (try? context.fetch(fetchRequest))?.first
    }
    
    // Получение сущности DataByDay по дате
    func getDataByDay(dateString: String, context: NSManagedObjectContext) -> DailyWeather? {
        let fetchRequest = DailyWeather.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dateString == %@", dateString)
        return (try? context.fetch(fetchRequest))?.first
    }
    
    func addData(data:Weather, completion: ((_ success: Bool) -> ())?) {
        
        persistentContainer.performBackgroundTask { contextBackground in
            let location = City(context: contextBackground)
            location.name = data.location?.name ?? ""
            location.date = Date()
            
            let currentWeather = CurrentWeather(context: contextBackground)
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
            currentWeather.tempC = dataCurrent?.tempC ?? 0
            currentWeather.tempF = dataCurrent?.tempF ?? 0
            currentWeather.minTempC = dayData?.mintempC ?? 0
            currentWeather.maxTempC = dayData?.maxtempC ?? 0
            currentWeather.minTempF = dayData?.mintempF ?? 0
            currentWeather.maxTempF = dayData?.maxtempF ?? 0
            currentWeather.date = dateFormatter.date(from:lastUpdatedDate)
            currentWeather.sunset = timeDateFormatter.date(from: sunsetTime)
            currentWeather.sunrise = timeDateFormatter.date(from: sunriseTime)
            currentWeather.text = dataCurrent?.condition?.text
            currentWeather.dailyChanceOfRain = dayData?.dailyChanceOfRain ?? 0
            currentWeather.uv = dayData?.uv ?? 0
            currentWeather.windMps = ((dataCurrent?.windKph ?? 0) / 3.6)
            currentWeather.imageURL = dataCurrent?.condition?.icon
            currentWeather.location = location
            let dataArray = data.forecast?.forecastday
            if let dataArray {
                for index in dataArray {
                    
                    let dailyWeather = DailyWeather(context: contextBackground)
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
                    dailyWeather.maxTempC = dayData?.maxtempC ?? 0
                    dailyWeather.minTempC = dayData?.mintempC ?? 0
                    dailyWeather.maxTempF = dayData?.maxtempF ?? 0
                    dailyWeather.minTempF = dayData?.mintempF ?? 0
                    dailyWeather.date = dateFormatter.date(from:isoDate.components(separatedBy: " ").first ?? "")
                    dailyWeather.dateString = isoDate
                    dailyWeather.dailyChanceOfRain = dayData?.dailyChanceOfRain ?? 0
                    dailyWeather.text = dayData?.condition?.text
                    dailyWeather.imageURL = dayData?.condition?.icon
                    dailyWeather.location = location
                    dailyWeather.sunrise = timeDateFormatter.date(from: index.astro?.sunrise ?? "")
                    dailyWeather.sunset = timeDateFormatter.date(from: index.astro?.sunset ?? "")
                    dailyWeather.moonrise = timeDateFormatter.date(from: index.astro?.moonrise ?? "")
                    dailyWeather.moonset = timeDateFormatter.date(from: index.astro?.moonset ?? "")
                    dailyWeather.moonPhase = index.astro?.moonPhase
                }
            }
            
            let hourlyWeatherArray = data.forecast?.forecastday
            if let hourlyWeatherArray {
                for i in hourlyWeatherArray {
                    let date = i.date ?? ""
                    let hourlyData = i.hour
                    if let hourlyData {
                        for index in hourlyData {
                            let hourlyWeather = HourlyWeather(context: contextBackground)
                            hourlyWeather.dataByDay = self.getDataByDay(dateString: date, context: contextBackground)
                            let isoDate = index.time ?? ""
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                            dateFormatter.calendar = Calendar(identifier: .gregorian)
                            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                            let date = dateFormatter.date(from:isoDate)
                            hourlyWeather.date = date
                            hourlyWeather.dateString = isoDate
                            hourlyWeather.tempC = index.tempC ?? 0
                            hourlyWeather.tempF = index.tempF ?? 0
                            hourlyWeather.imageURL = index.condition?.icon
                            hourlyWeather.chanceOfRain = index.chanceOfRain ?? 0
                            hourlyWeather.text = index.condition?.text
                            hourlyWeather.windMph = index.windMph ?? 0
                            hourlyWeather.windMps = index.windKph ?? 0
                            hourlyWeather.uv = index.uv ?? 0
                            hourlyWeather.location = location
                        }
                    }
                }
            }
            do {
                try contextBackground.save()
                completion?(true)
            } catch {
                print(error)
                completion?(false)
            }
        }
        
    }
    
    
    // Удаление данных
    
    func deleteLocation(location: City) {
        persistentContainer.viewContext.delete(location)
        try? persistentContainer.viewContext.save()
    }
    
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
