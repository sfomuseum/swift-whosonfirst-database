import SQLite
import GeoJSON
import Foundation

struct Database {
    
    var dbconn: SQLite.Connection? = nil
    
    public init(dsn: String) throws {
        dbconn = try Connection(dsn)
    }
    
    public func loadFeature(id: Int64) -> Swift.Result<Feature, Error> {
        
        let q = "SELECT body FROM geojson WHERE id = ?"
        
        var load_feature: Statement
        
        do  {
            load_feature = try self.dbconn!.prepare(q)
        } catch {
            print("Failed to prepare query \(error)")
            return .failure(LoadFeatureError.prepareError)
        }
                
        do {
            try load_feature = load_feature.run(id)
        } catch {
            print("Failed to execute query \(error)")
            return .failure(LoadFeatureError.queryError)
        }
        
        do {
            
            guard let body = try load_feature.scalar() as? String else {
                return .failure(LoadFeatureError.notFound)
            }
            
            let data = Data(body.utf8)
            
            let f = try JSONDecoder().decode(Feature.self, from: data)
            return .success(f)
            
        } catch {
            return .failure(LoadFeatureError.unknown)
        }
    }
    
    public func pointInPolygon(coord: Coordinate) -> Swift.Result<[Int64], Error> {
     
        let bbox = coord.boundingBox(inches: 0.5)
        
        let q = "SELECT wof_id, geometry FROM rtree  WHERE min_x <= ? AND max_x >= ?  AND min_y <= ? AND max_y >= ?"
                
        var get_rows: Statement
        
        do  {
            get_rows = try self.dbconn!.prepare(q)
        } catch {
            print("Failed to prepare query \(error)")
            return .failure(PointInPolygonError.prepareError)
        }
                
        do {
            try get_rows = get_rows.run(bbox.min_x, bbox.max_x, bbox.min_y, bbox.max_x)
        } catch {
            print("Failed to execute query \(error)")
            return .failure(PointInPolygonError.queryError)
        }
        
        var matches: [Int64] = []

        for row in get_rows {
            
            guard let str_id = row[0] else {
                continue
            }
            
            let wof_id = str_id as! Int64
            
            guard let geom = row[1] else {
                continue
            }
            
            let contained = isPointInWKT(point: coord, wkt: geom as! String)
            
            if !contained {
                continue
            }
            
            if matches.contains(wof_id){
                continue
            }
            
            matches.append(wof_id)
        }
        
        return .success(matches)
    }
    
}
