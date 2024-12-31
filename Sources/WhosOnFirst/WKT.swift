import Foundation

// Function to parse a WKT string into a polygon (array of coordinates)
func parseWKT(_ wkt: String) -> [[Coordinate]]? {
    // Extract the coordinate string from the WKT format
    guard wkt.starts(with: "POLYGON(("), wkt.hasSuffix("))") else {
        print("Unsupported WKT format")
        return nil
    }

    let content = wkt
        .replacingOccurrences(of: "POLYGON((", with: "")
        .replacingOccurrences(of: "))", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)

    // Separate rings (exterior and interior)
    let rings = content.split(separator: ")").map { ring in
        ring
            .replacingOccurrences(of: "(", with: "")
            .split(separator: ",")
            .map { point in
                let coordinates = point.split(separator: " ").compactMap { Double($0) }
                return Coordinate(lat: coordinates[1], lng: coordinates[0]) // WKT uses lng, lat order
            }
    }

    return rings
}

// Function to check if a point is inside a polygon (Ray-Casting Algorithm)
func isPointInPolygon(point: Coordinate, polygon: [Coordinate]) -> Bool {
    var isInside = false
    var j = polygon.count - 1
    for i in 0..<polygon.count {
        let xi = polygon[i].lng, yi = polygon[i].lat
        let xj = polygon[j].lng, yj = polygon[j].lat

        if ((yi > point.lat) != (yj > point.lat)) &&
            (point.lng < (xj - xi) * (point.lat - yi) / (yj - yi) + xi) {
            isInside.toggle()
        }
        j = i
    }
    return isInside
}

// Function to check if a point is inside a WKT polygon
func isPointInWKT(point: Coordinate, wkt: String) -> Bool {
    guard let rings = parseWKT(wkt), !rings.isEmpty else {
        print("Failed to parse WKT")
        return false
    }

    let exteriorRing = rings[0]
    let interiorRings = rings.dropFirst()

    // Check if the point is inside the exterior ring
    if !isPointInPolygon(point: point, polygon: exteriorRing) {
        return false
    }

    // Check if the point is inside any interior ring (hole)
    for interiorRing in interiorRings {
        if isPointInPolygon(point: point, polygon: interiorRing) {
            return false
        }
    }

    return true
}
