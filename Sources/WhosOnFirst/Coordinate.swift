import Foundation

public struct Coordinate: Codable {
    let lat: Double
    let lng: Double
    
    public init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}

extension Coordinate {
    public func boundingBox(inches: Double) -> (min_x: Double, min_y: Double, max_x: Double, max_y: Double) {
        // Convert inches to kilometers
        let kmPerInch = 0.0000254
        let distanceInKm = inches * kmPerInch
        
        // Calculate degree offsets
        let latOffset = distanceInKm / 111.0 // 1 degree of latitude is ~111 km
        let lngOffset = distanceInKm / (111.0 * Foundation.cos(self.lat * .pi / 180)) // Longitude depends on latitude
        
        // Calculate bounding box coordinates
        let min_x = self.lng - lngOffset
        let min_y = self.lat - latOffset
        let max_x = self.lng + lngOffset
        let max_y = self.lat + latOffset
        
        return (min_x, min_y, max_x, max_y)
    }
}
