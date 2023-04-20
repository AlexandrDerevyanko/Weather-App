
import Foundation

// MARK: - Welcome
struct Weather: Codable {
    let type: String?
    let geometry: Geometry?
    let properties: Properties?
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: String?
    let coordinates: [Double]?
}

// MARK: - Properties
struct Properties: Codable {
    let meta: Meta?
    let timeseries: [Timesery]?
}

// MARK: - Meta
struct Meta: Codable {
    let updatedAt: String?
    let units: Units?

    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case units
    }
}

// MARK: - Units
struct Units: Codable {
    let airPressureAtSeaLevel, airTemperature, airTemperatureMax, airTemperatureMin: String?
    let cloudAreaFraction, cloudAreaFractionHigh, cloudAreaFractionLow, cloudAreaFractionMedium: String?
    let dewPointTemperature, fogAreaFraction, precipitationAmount, relativeHumidity: String?
    let ultravioletIndexClearSky, windFromDirection, windSpeed: String?

    enum CodingKeys: String, CodingKey {
        case airPressureAtSeaLevel = "air_pressure_at_sea_level"
        case airTemperature = "air_temperature"
        case airTemperatureMax = "air_temperature_max"
        case airTemperatureMin = "air_temperature_min"
        case cloudAreaFraction = "cloud_area_fraction"
        case cloudAreaFractionHigh = "cloud_area_fraction_high"
        case cloudAreaFractionLow = "cloud_area_fraction_low"
        case cloudAreaFractionMedium = "cloud_area_fraction_medium"
        case dewPointTemperature = "dew_point_temperature"
        case fogAreaFraction = "fog_area_fraction"
        case precipitationAmount = "precipitation_amount"
        case relativeHumidity = "relative_humidity"
        case ultravioletIndexClearSky = "ultraviolet_index_clear_sky"
        case windFromDirection = "wind_from_direction"
        case windSpeed = "wind_speed"
    }
}

// MARK: - Timesery
struct Timesery: Codable {
    let time: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let instant: Instant?
    let next12_Hours: Next12_Hours?
    let next1_Hours: Next1_Hours?
    let next6_Hours: Next6_Hours?

    enum CodingKeys: String, CodingKey {
        case instant
        case next12_Hours = "next_12_hours"
        case next1_Hours = "next_1_hours"
        case next6_Hours = "next_6_hours"
    }
}

// MARK: - Instant
struct Instant: Codable {
    let details: [String: Double]?
}

// MARK: - Next12_Hours
struct Next12_Hours: Codable {
    let summary: Summary?
}

// MARK: - Summary
struct Summary: Codable {
    let symbolCode: SymbolCode?

    enum CodingKeys: String, CodingKey {
        case symbolCode = "symbol_code"
    }
}

enum SymbolCode: String, Codable {
    case clearskyDay = "clearsky_day"
    case clearskyNight = "clearsky_night"
    case cloudy = "cloudy"
    case fairDay = "fair_day"
    case fairNight = "fair_night"
    case lightrain = "lightrain"
    case partlycloudyDay = "partlycloudy_day"
    case partlycloudyNight = "partlycloudy_night"
    case rain = "rain"
}

// MARK: - Next1_Hours
struct Next1_Hours: Codable {
    let summary: Summary?
    let details: Next1_HoursDetails?
}

// MARK: - Next1_HoursDetails
struct Next1_HoursDetails: Codable {
    let precipitationAmount: Int?

    enum CodingKeys: String, CodingKey {
        case precipitationAmount = "precipitation_amount"
    }
}

// MARK: - Next6_Hours
struct Next6_Hours: Codable {
    let summary: Summary?
    let details: Next6_HoursDetails?
}

// MARK: - Next6_HoursDetails
struct Next6_HoursDetails: Codable {
    let airTemperatureMax, airTemperatureMin, precipitationAmount: Double?

    enum CodingKeys: String, CodingKey {
        case airTemperatureMax = "air_temperature_max"
        case airTemperatureMin = "air_temperature_min"
        case precipitationAmount = "precipitation_amount"
    }
}
