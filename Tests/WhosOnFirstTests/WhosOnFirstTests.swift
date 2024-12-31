import Testing
import Foundation
@testable import WhosOnFirst

enum TestError: Error {
    case dsnError
    case initError
    case loadFeatureError
    case featurePropertiesError
    case featureWhosOnFirstIdError
    case featureInvalidIdError
    case pipCountError
    case unknown
}

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    
    guard let dsn = Bundle.module.url(forResource: "sfomuseum-maps", withExtension: "db") else {
        throw TestError.dsnError
    }

    var db: Database
    
    do {
        db = try Database(dsn: dsn.absoluteString)
    } catch {
        throw TestError.initError
    }
    
    let id: Int64 = 1477881739
    let feature_rsp = db.loadFeature(id: id)
    
    switch feature_rsp {
    case .success(let f):
        
        guard let props = f.properties else {
            throw TestError.featurePropertiesError
        }
        
        guard let f_id = props.data["wof:id"]?.value else {
            throw TestError.featureWhosOnFirstIdError
        }
        
        if f_id as! Int != id {
            throw TestError.featureInvalidIdError
        }
        
        // print("props \(f_id)")
        
    case .failure(let error):
        throw error
    }
    
    let coord = Coordinate(lat: 37.621131, lng: -122.384292)
    let pip_rsp = db.pointInPolygon(coord: coord)
    
    switch pip_rsp {
    case .success(let matches):
        let count = matches.count

        if count != 40 {
            throw TestError.pipCountError
        }
    case .failure(let error):
        throw error
    }
}
